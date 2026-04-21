#!/usr/bin/env bash
# GitHub PR을 raw/reviews/에 마크다운으로 저장.
# Usage: ./scripts/fetch-pr-review.sh <PR-URL>

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <PR-URL>" >&2
    exit 1
fi

PR_URL="$1"

if [[ ! "$PR_URL" =~ ^https://github\.com/([^/]+)/([^/]+)/pull/([0-9]+) ]]; then
    echo "Invalid PR URL: $PR_URL" >&2
    exit 1
fi
OWNER="${BASH_REMATCH[1]}"
REPO="${BASH_REMATCH[2]}"
NUMBER="${BASH_REMATCH[3]}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="$SCRIPT_DIR/../raw/reviews"
mkdir -p "$OUT_DIR"

DATE="$(date +%Y-%m-%d)"

echo "→ Fetching PR metadata..."
PR_JSON="$(gh pr view "$PR_URL" --json title,body,author,state,mergedAt,createdAt,reviews,comments,url)"

TITLE="$(echo "$PR_JSON" | jq -r '.title')"
BODY="$(echo "$PR_JSON" | jq -r '.body // ""')"
AUTHOR="$(echo "$PR_JSON" | jq -r '.author.login // ""')"
MERGED_AT="$(echo "$PR_JSON" | jq -r '.mergedAt // empty')"
MERGED="false"
[ -n "$MERGED_AT" ] && MERGED="true"

# 파일명 안전화
SAFE_TITLE="$(echo "$TITLE" | tr '/\\:*?"<>|' '_' | tr -s ' ' '_')"
OUT_FILE="$OUT_DIR/${DATE}_${SAFE_TITLE}.md"

echo "→ Fetching inline review comments..."
INLINE_COMMENTS="$(gh api "/repos/$OWNER/$REPO/pulls/$NUMBER/comments" --paginate 2>/dev/null || echo "[]")"

echo "→ Fetching diff..."
DIFF="$(gh pr diff "$PR_URL")"

echo "→ Writing $OUT_FILE..."

# YAML 이스케이프용 (제목의 " 문자만 처리)
YAML_TITLE="$(echo "$TITLE" | sed 's/"/\\"/g')"

{
    echo "---"
    echo "source_type: github-pr"
    echo "title: \"$YAML_TITLE\""
    echo "source: $PR_URL"
    echo "author: $AUTHOR"
    echo "reviewer:"
    echo "$PR_JSON" | jq -r '[.reviews[].author.login] | unique | .[] | "  - \(.)"'
    echo "repo: $OWNER/$REPO"
    echo "merged: $MERGED"
    echo "topic:"
    echo "created: $DATE"
    echo "tags:"
    echo "  - raw/reviews"
    echo "ingested: false"
    echo "---"
    echo ""
    echo "## PR 본문"
    echo ""
    echo "$BODY"
    echo ""
    echo "## 리뷰 코멘트"
    echo ""
    echo "$PR_JSON" | jq -r '
        .reviews[]
        | select(.body != null and .body != "")
        | "### [\(.author.login)] \(.submittedAt // "") — \(.state)\n\n\(.body)\n"
    '
    echo "## 인라인 코멘트"
    echo ""
    DIFF="$DIFF" INLINE_COMMENTS="$INLINE_COMMENTS" python3 - <<'PYEOF'
import os, json, re

diff = os.environ.get('DIFF', '')
try:
    comments = json.loads(os.environ.get('INLINE_COMMENTS', '[]'))
except json.JSONDecodeError:
    comments = []

BEFORE = 8   # 코멘트 라인 위로 N줄
AFTER = 2    # 코멘트 라인 아래로 N줄

def get_window(diff_text, target_path, target_line):
    """전체 diff에서 target_path 파일의 target_line 주변 라인을 diff 형식으로 추출."""
    if target_line is None:
        return None
    sections = re.split(r'(?m)^diff --git ', diff_text)
    for section in sections:
        if not section.strip():
            continue
        lines = section.split('\n')
        m = re.search(r' b/(.+)$', lines[0])
        if not m or m.group(1) != target_path:
            continue
        # 헝크를 순회하며 new-file 라인 번호 추적
        collected = []  # (new_line_or_None, raw_line)
        new_line = None
        for raw in lines:
            hm = re.match(r'^@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@', raw)
            if hm:
                new_line = int(hm.group(1))
                collected.append((None, raw))
                continue
            if new_line is None:
                continue
            if raw.startswith('+++') or raw.startswith('---'):
                continue
            if raw.startswith('+'):
                collected.append((new_line, raw)); new_line += 1
            elif raw.startswith('-'):
                collected.append((None, raw))   # 삭제 라인은 new-line 증가 없음
            elif raw.startswith(' ') or raw == '':
                collected.append((new_line, raw)); new_line += 1
            elif raw.startswith('\\'):
                collected.append((None, raw))
            else:
                break
        # 타겟 라인 찾기
        idx = next((i for i, (ln, _) in enumerate(collected) if ln == target_line), None)
        if idx is None:
            return None
        start = max(0, idx - BEFORE)
        end = min(len(collected), idx + AFTER + 1)
        return '\n'.join(raw for _, raw in collected[start:end])
    return None

for c in comments:
    path = c.get('path', '')
    line = c.get('line') or c.get('original_line')
    user = (c.get('user') or {}).get('login', '')
    body = c.get('body', '')
    window = get_window(diff, path, line)
    if window is None:
        window = c.get('diff_hunk', '(코드 맥락을 찾지 못함)')
    print(f"### {path}:{line} — [{user}]\n")
    print("**코드 맥락:**\n")
    print("```diff")
    print(window)
    print("```\n")
    print("**코멘트:**\n")
    print(body)
    print()
PYEOF
    echo "## Diff"
    echo ""
    echo '```diff'
    echo "$DIFF"
    echo '```'
} > "$OUT_FILE"

echo "✓ Saved: $OUT_FILE"
