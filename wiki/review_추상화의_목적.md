---
tags:
  - review
  - java
  - oop
  - abstraction
  - design
created: 2026-04-21
sources:
  - "[[summary_PR_블랙잭_1단계]]"
  - https://github.com/woowacourse/java-blackjack/pull/808
related:
  - "[[summary_PR_블랙잭_1단계]]"
  - "[[review_네이밍_행위_드러내기]]"
---

# review: 추상화의 목적 — 요구사항을 메시지 흐름으로 녹이기

## 이 코드가 왜 문제인가

```java
// 딜러와 플레이어 각각이 "첫 공개 카드"를 뷰에 직접 꺼내줌
public class Dealer {
    public Card getFirstCard() { return hand.getFirst(); }
}
public class Player {
    public List<Card> getFirstCards() { return hand.asList(); }
}

// 뷰가 타입별로 분기
if (participant instanceof Dealer) {
    printDealerFirstCard(((Dealer) participant).getFirstCard());
} else {
    printPlayerFirstCards(((Player) participant).getFirstCards());
}
```

**문제**: 도메인 요구사항("딜러는 1장, 플레이어는 2장을 공개")이 **코드 어디에도 드러나지 않는다**.
- 클래스 이름, 메서드 이름, 시그니처 어디를 봐도 "서로 다른 규칙이 존재한다"는 사실을 읽을 수 없음
- 규칙의 근거를 알려면 뷰의 분기문을 역추적해야 함 → 도메인 지식이 뷰에 숨음

## 대안 — 공통 메시지로 묶어 요구사항을 드러내기

```java
public abstract class Participant {
    // "첫 공개할 카드를 알려줘"라는 메시지 자체가 요구사항을 담음
    public abstract List<Card> getFirstCards();
}

public class Dealer extends Participant {
    @Override
    public List<Card> getFirstCards() {
        return List.of(hand.getFirst());   // 한 장
    }
}

public class Player extends Participant {
    @Override
    public List<Card> getFirstCards() {
        return hand.asList();              // 두 장 전부
    }
}
```

**이제 읽히는 것**:
- `Participant#getFirstCards` 시그니처만 봐도 **"딜러와 플레이어가 첫 공개 카드가 다르다"**는 요구사항이 드러남
- 구체적인 "몇 장인지"가 궁금하면 구현체를 열면 됨 — 도메인 지식이 도메인에 있음

## 적용 기준

### 추상화의 올바른 목적 (리뷰어 ddaaac)

| 흔히 말하는 이유 | 실제 본질 |
|---|---|
| 중복 제거 | X — 결과적으로 따라올 뿐 |
| 변경 가능성 대비 | X — 확장 필요 없는 도메인에도 추상화는 유효 |
| **요구사항을 메시지 흐름으로 표현** | O |

### 추상화 도입 판단 절차
1. **외부에서 어떤 메시지를 던지는가?** 공통 메시지가 있다면 묶을 후보
2. **메시지의 응답 방식이 객체마다 다른가?** 그렇다면 인터페이스/추상 메서드로 추출
3. **추상 메서드 이름만 보고 요구사항이 읽히는가?** YES면 성공. NO면 네이밍 재검토

### 지양할 패턴
- **상태로 먼저 설계하기** — `Card`의 일급 컬렉션이라는 상태부터 생각 → 책임이 상태 주변으로 뭉침
- **중복만 보고 추상화** — 우연히 닮은 코드를 묶으면 캡슐화가 깨지고 결합도만 올라감
- **타입 체크로 분기** (`instanceof`) — 추상화가 필요하다는 강한 신호

## 흔한 반론과 답

| 반론 | 답 |
|---|---|
| "변경 가능성이 없는데 추상화가 필요한가" | 목적이 **변경 대비**가 아니라 **요구사항 표현**이라면 변경 가능성과 무관하게 가치 있음 |
| "중복 제거하면 결합도가 올라간다" | 맞음. 그래서 추상화 이유가 **중복 제거뿐**이라면 하지 않는 것도 선택. 하지만 요구사항 표현이 목적이면 결합도 상승을 감수할 만함 |
| "상속은 지양해야 하지 않나" | 일반 클래스 상속은 지양. 단순 재사용이면 합성. **추상 클래스/인터페이스는 다름** — 메시지 계약을 위한 것 ([[review_네이밍_행위_드러내기]] 참고) |

## 학습 노트 (왜 놓쳤나)

- **내 설계 순서의 문제**: 상태 → 클래스 → 메시지 순으로 생각함
  - `Card` 일급 컬렉션 → `CardDeck`에 Deck/Hand를 몰아넣음
  - "오브젝트" 책에서 **"메시지가 객체를 선택하기"** → **"공통 상태·행동을 클래스로"** 순서로 설계해야 한다는 걸 읽었지만, 실전에선 역순으로 감
- **추상화 목적을 "중복/변경"으로만 학습**: 흔한 설명 프레임이 반사적으로 작동
  - 리뷰어의 관점 전환: 추상화는 **요구사항을 코드에 녹이는 도구**
- 추출 원칙:
  - 설계 시작 시 **"외부가 이 객체에 어떤 메시지를 던지는가"**를 먼저 묻기
  - 추상 메서드 이름은 **요구사항 문장이 그대로 읽히도록** (e.g. "첫 공개할 카드를 알려줘" → `getFirstCards`)

## 연결

- [[review_네이밍_행위_드러내기]] — 추상 메서드 이름은 "행위·의도를 드러낸다"의 극단적 적용
- [[summary_PR_블랙잭_1단계]] — 리뷰 맥락과 답변 흐름
