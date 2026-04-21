---
tags:
  - review
  - java
  - oop
  - inheritance
  - composition
created: 2026-04-21
sources:
  - "[[summary_PR_로또_1단계]]"
  - "[[summary_PR_블랙잭_1단계]]"
  - "[[summary_PR_장기_1단계]]"
  - https://github.com/woowacourse/java-lotto/pull/521
  - https://github.com/woowacourse/java-blackjack/pull/808
  - https://github.com/woowacourse/java-janggi/pull/80
related:
  - "[[review_네이밍_행위_드러내기]]"
  - "[[review_추상화의_목적]]"
---

# review: 상속 vs 합성 — 기본은 합성, 상속은 타입 계층일 때만

## 이 코드가 왜 문제인가

### 패턴 1: 재사용을 위한 일반 클래스 상속 (블랙잭)

```java
// 단순히 Hand 필드가 공통이라 Participant에 몰아넣음
public abstract class Participant {
    protected final Hand hand;
    // ... 공통 메서드들
}

public class Dealer extends Participant { ... }
public class Player extends Participant { ... }
```

리뷰어 지적 (ddaaac): **"일반 클래스의 상속은 지양해주세요. 단순 재사용 목적이라면 조합이 훨씬 안전한 방법이죠."**

### 패턴 2: 상속으로 인한 캡슐화 붕괴 (장기)

```java
public abstract class Piece {
    protected final Team team;
    protected final Position position;
    protected final Routes routes;   // protected로 하위에서 접근
}

public class JumpingPiece extends Piece { ... }
public class NormalPiece extends Piece { ... }
```

자체 재고 후 발견한 문제:
- `protected`는 **캡슐화를 침해**함 (하위 클래스는 클라이언트의 일부)
- "필드가 같다"는 이유만으로 상위로 뽑으니 **응집도 저하**
- 상속을 쓰지만 **확장성은 활용하지 못함** — 그냥 상위 필드의 공유 저장소로 전락

### 패턴 3: "조금 다른 상위"로 중간 계층 남발 (장기)

```java
// Piece <- NormalPiece <- Chariot, Horse, Elephant, Soldier
// Piece <- JumpingPiece <- Pao
// Piece <- StraightPiece <- ...
```

리뷰어 재질문 (seovalue): **"'일반적으로 정의된 경로' / '다른 기물을 건너뛸 수 있는' 이라는 것은 Piece에 담겨야 할 속성일까요?"**
- 중간 타입 계층이 **진짜 필요한 분기**인지, 아니면 구현 중복 제거 장치인지 구분

**문제의 공통점**:
- 상속을 **"공통 필드/메서드 중복 제거"** 목적으로 사용
- 상속이 표현하는 **is-a 관계·다형성**이 실제로 필요한지 검증 X
- `protected`로 하위 접근을 열어주며 캡슐화 침해

## 대안

### 1. 단순 재사용이면 — 합성(Composition)

```java
// WinningLotto가 Lotto의 역할을 상속받지 않고, 필드로 보유
public class WinningLotto {
    private final Lotto lotto;           // has-a
    private final int bonusNumber;

    public boolean contains(int number) {
        return lotto.contains(number);   // 필요한 메시지만 위임
    }
}
```

장점:
- 내부 구조 변경에 유연 (`Lotto`가 바뀌어도 `WinningLotto` 외부 API 유지 가능)
- 필요한 메시지만 노출 (캡슐화 유지)
- `protected`를 쓸 이유가 사라짐

### 2. 진짜 다형성이 필요하면 — 추상 클래스/인터페이스

[[review_추상화의_목적]]에서 설명한 기준: **요구사항이 메시지 흐름으로 표현되는가**

```java
// "첫 공개할 카드를 알려줘" 메시지가 딜러·플레이어에 다르게 응답
public abstract class Participant {
    public abstract List<Card> getFirstCards();   // 타입별 다른 응답
}
```

이 경우엔 상속(추상 클래스)이 정당함 — **중복 제거가 아니라 타입 계층이 요구사항을 표현**

### 3. 중간 타입 계층은 신중히 — 그 속성이 타입인가?

```java
// 재고 후: "점프 여부"가 Piece의 속성인가?
// - 점프 여부가 외부에 메시지로 드러나는가? (e.g. Piece#canJumpOver)
// - 아니면 단순히 이동 계산 알고리즘 차이일 뿐인가?
//   → 후자라면 전략 패턴(합성)이 더 맞음
public class Piece {
    private final MoveStrategy strategy;   // 합성으로 다양성 표현
}
```

## 적용 기준

### 상속을 쓸 수 있는 경우 (좁음)
- **is-a 관계가 실제로 성립** — Dealer는 Participant**다**, Player는 Participant**다**
- **외부에서 하나의 타입으로 다루고 싶음** — `List<Participant>`로 다형성 활용
- **추상 클래스/인터페이스** 형태 — 재사용 목적이 아닌 **계약** 목적

### 합성을 써야 하는 경우 (기본값)
- 단순히 공통 필드/메서드 재사용이 목적일 때
- 내부 구현 변경에 유연해야 할 때
- "has-a"가 더 자연스러운 관계 (`WinningLotto`는 `Lotto`를 **갖는** 것)

### 판단 절차
1. **"X is-a Y"를 말로 해봤을 때 어색한가?** 어색하면 합성
2. **클라이언트가 부모 타입으로 다루는가?** 아니면 상속 대신 위임
3. **`protected` 필드가 필요한가?** 필요하다면 캡슐화 신호등 — 합성 재검토
4. **중간 계층의 구분이 메시지로 드러나는가?** 아니면 전략 패턴 고려

## 흔한 반론과 답

| 반론 | 답 |
|---|---|
| "코드가 중복되는데 합성하면 위임 메서드가 늘어난다" | 맞음. 하지만 **결합도·캡슐화 유지 비용이 중복 비용보다 큼**. 위임이 많으면 애초에 그 필드의 책임을 재검토 |
| "추상 클래스도 지양인가?" | 아님. 추상 클래스/인터페이스는 **계약을 위한 것**. 문제가 되는 건 **일반 클래스 상속** (특히 재사용 목적) |
| "확장을 대비하려면 상속이 편하다" | 확장 지점이 **is-a가 아니라면** 전략 패턴(합성)이 더 유연. 확장을 상속으로만 해석하는 게 함정 |
| "중간 타입 계층 없이 어떻게 이동 로직을 분리?" | `MoveStrategy` 인터페이스로 합성 주입 → 같은 분리 효과 + Piece 내부 구조 유지 |

## 3개 PR에서의 반복 신호

| PR | 상황 | 리뷰어 지적 |
|---|---|---|
| **로또** | `WinningLotto`가 `Lotto`를 extends? (필드로 보유한 구조이지만 논의됨) | 합성이 더 유연 |
| **블랙잭** | `Participant` 추상 클래스에 Dealer/Player extends | "일반 클래스 상속은 지양, 단순 재사용이면 조합이 안전" |
| **장기** | `Piece <- NormalPiece/JumpingPiece` 중간 타입 계층 | "그 속성이 Piece에 담겨야 할 속성인가?" — 중간 계층 재고 |

**핵심 메시지**: 리뷰어가 매번 달랐는데 **같은 원칙이 반복됨** → 내 기본값이 "상속 우선"으로 설정되어 있다는 신호

## 학습 노트 (왜 놓쳤나)

- **내 패턴 1: "중복이 보이면 상속으로 위로"**
  - 공통 필드를 발견하면 반사적으로 상위 클래스 생성
  - `protected`를 쉽게 사용 → 캡슐화 침해를 인지 못 함
- **내 패턴 2: 상속 = 확장의 기본 도구라는 오해**
  - 장기에서 "타입 계층을 나누어 기능을 확장시키기 위한 용도"로 JumpingPiece 도입
  - 하지만 **확장이 실제로 발생할 지**, **그 구분이 타입이어야 하는지** 검증 안 함
- **내 패턴 3: 합성의 위임 코드를 비용으로 인식**
  - `piece.routes.x()` 대신 `piece.x()`를 쓰려고 상속 선택
  - 위임 메서드 작성이 싫어서 설계가 꼬이는 케이스
- 추출 원칙:
  - **"is-a를 말로 해봤을 때 어색하면 상속 금지"**
  - **`protected`가 쓰이면 설계 재검토 신호**
  - 일반 클래스 상속은 **사실상 최후 수단**. 추상 클래스/인터페이스 또는 합성이 기본

## 연결

- [[review_추상화의_목적]] — 추상 클래스를 쓸 때 그 목적이 "타입 계약"인지 "중복 제거"인지 구분
- [[review_네이밍_행위_드러내기]] — 상속 관계도 이름에 드러남 (`JumpingPiece`가 진짜 타입 이름인지, 구현 분류 이름인지)
- 3개 PR 모두 반복 → **개인 고질 영역 중 가장 강한 신호**
