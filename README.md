# LLM WIKI

[Karpathy의 LLM Wiki 패턴](https://github.com/karpathy/LLM-Wiki)을 기반으로 한 **AI를 위한 세컨드 브레인**.

세상에 있는 유용한 정보와 지식을 체계적으로 모으고, 나의 맥락에 맞게 정리·연결해서, AI가 이를 읽고 활용할 수 있게 만드는 개인 지식 베이스입니다.

## 핵심 아이디어

RAG처럼 매번 원본에서 지식을 재발견하는 것이 아니라, AI가 **점진적으로 위키를 구축하고 유지**합니다. 소스를 추가할 때마다 AI가 읽고, 핵심을 추출하고, 기존 위키와 연결합니다. 지식은 한 번 컴파일되고 계속 최신화됩니다.

- **사람**: 소스를 수집하고, 질문하고, 방향을 잡는다
- **AI**: 요약, 교차 참조, 정리, 유지보수 — 모든 부기 작업을 담당한다

## 구조

```
LLM WIKI/
├── raw/            # 불변 원본 (AI는 읽기만)
│   ├── notes/      # 과거 학습 정리본
│   ├── docs/       # 공식 문서, 아티클, 블로그
│   ├── media/      # 유튜브 등 영상 자료
│   └── assets/     # 이미지, 다이어그램
├── wiki/           # AI가 관리하는 위키
│   ├── index.md    # 전체 목차
│   └── log.md      # 작업 이력
└── output/         # 시각화, 학습 계획 등 결과물
```

## 운영 방식

| 작업 | 설명 |
|------|------|
| **Ingest** | raw/에 소스 추가 → AI가 읽고 wiki/ 페이지 생성 |
| **Query** | wiki/ 문서를 근거로 질문에 답변 |
| **Lint** | 깨진 링크, 모순, 누락 등 위키 전체 점검 |
| **Improve** | 학습 패턴 분석 → 개선 방안 제안 |

## 스킬

이 위키를 운영하기 위한 Claude Code 스킬은 별도 레포에서 관리합니다:

[sonjh919/LLM-Wiki-Skills](https://github.com/sonjh919/LLM-Wiki-Skills) — `/ingest`, `/query`, `/lint`, `/improve`

## 라이선스

[CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) — 자유롭게 사용·수정 가능, 상업적 사용 불가
