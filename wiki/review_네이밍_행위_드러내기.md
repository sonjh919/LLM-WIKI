---
tags:
  - review
  - java
  - naming
  - code-quality
created: 2026-04-21
sources:
  - "[[summary_PR_로또_1단계]]"
  - "[[summary_PR_블랙잭_1단계]]"
  - https://github.com/woowacourse/java-lotto/pull/521
  - https://github.com/woowacourse/java-blackjack/pull/808
related:
  - "[[summary_PR_로또_1단계]]"
  - "[[summary_PR_블랙잭_1단계]]"
---

# review: 네이밍 — 행위(의도)를 드러내기

## 이 코드가 왜 문제인가

```java
public class Main { ... }

public class LottoFactory {
    public Lotto from() { ... }
}

public class CardDeck {
    public int sum() {   // 실제로는 단순 합 아님 (Ace 보너스 계산 포함)
        int sum = cards.stream().mapToInt(Card::getScore).sum();
        if (sum <= BONUS_THRESHOLD && hasA()) sum += ACE_BONUS;
        return sum;
    }
}

public class Amount { ... }   // 무엇의 amount인지 모름

private GetLottoDto ...       // Get prefix
private int bonus;            // 보너스 뭐?
```

**문제의 공통점**:
- **구조적·기계적 이름**이 붙음 (`Main`, `get`, `sum`, `from`) — 클래스/메서드가 "있다"는 사실만 말해줌
- **의도/행위**가 드러나지 않음 — 읽는 사람이 구현을 봐야 뭘 하는지 앎
- **범용 이름**이 도메인 맥락을 숨김 (`Amount`가 금액인지 개수인지)

## 대안 — 행위·의도가 드러나는 이름

```java
public class LottoApplication { ... }       // 무엇의 application인가

public class LottoFactory {
    public Lotto create() { ... }           // 생성한다 (from은 변환 느낌)
}

public class CardDeck {
    public int sumWithAce() { ... }         // 로직을 반영
}

public class PurchaseAmount { ... }         // 금액임이 드러남

public record LottoDto(...) { }             // Get prefix 제거

private int bonusNumber;                    // 구체적
```

## 적용 기준

### 행위를 드러내는 네이밍
- **메서드**: `buyLottos`, `calculateProfit`, `createLottosFromRandomNumber` — 동사 중심
- **변환/생성**: 일반 생성이면 `create`/`generate`, 외부 타입에서 변환이면 `from`, `of`
- **도메인 이름**: 도메인 맥락을 담음 (`PurchaseAmount`, `WinningResult`, `InputMessage`)

### 지양할 패턴
- `getXXX` / `setXXX` — 단, 실제로 단순 접근자라면 OK. **로직이 있는데 getter 이름** = 냄새
- `Main` / `Util` / `Helper` / `Manager` / `Handler` — 무엇의 책임인지 드러나지 않음
- 너무 범용적인 도메인 이름 (`Amount`, `Data`, `Info`)
- 결과 타입에 어울리지 않는 prefix (`GetLottoDto` — Get은 행위)

### 애매할 때의 판단
질문: **"이 이름만 보고 뭘 하는지/무엇인지 알 수 있는가?"**
- YES → OK
- NO → 구현을 보고 나서야 이해된다면 네이밍 재검토

## 흔한 반론과 답

| 반론 | 답 |
|---|---|
| "이름이 길어진다" | 길이보다 **즉각적 이해**가 더 중요. 에디터 자동완성으로 입력 비용은 무시 가능 |
| "관례상 `get`을 쓴다" | JavaBean 규약이 필요한 곳(프레임워크 자동 바인딩 등)에선 OK. 그 외엔 행위로 |
| "`from`이 더 세련돼 보인다" | 세련됨보다 **의도 전달**이 우선. 실제로 생성한다면 `create` |

## 학습 노트 (왜 놓쳤나)

- 내 패턴 1: **프리코스 시절 습관의 관성**
  - Spring에서 HTTP 메서드 prefix(`get`, `post`)를 DTO에 쓴 경험 → `GetLottoDto` 재현
  - 정적 팩토리 메서드 `from()`을 한 번 좋게 쓴 기억 → 맥락 없이 반복 사용
- 내 패턴 2: **단축키·자동 생성 기능의 흔적**
  - IDE가 생성한 `getXXX/setXXX`를 검토 없이 그대로 둠
  - 테스트 메서드 자동 생성이 영문으로 만든 걸 한글로 교체하지 않음
- 추출 원칙:
  - **"왜 이 이름인가"를 한 번 더 묻기** — 관성·자동 생성의 흔적을 붙잡는 질문
  - 네이밍은 **첫 독자(미래의 나·팀원)에게 보내는 설명**

## 연결

- [[review_final_키워드_언어단_안전장치]] — 둘 다 "의도를 코드에 명시"하는 관점 공유
- 두 PR 공통으로 강하게 반복됨 → 개인 고질 영역 신호
