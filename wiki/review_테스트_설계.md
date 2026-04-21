---
tags:
  - review
  - java
  - test
  - junit
created: 2026-04-21
sources:
  - "[[summary_PR_로또_1단계]]"
  - "[[summary_PR_블랙잭_1단계]]"
  - "[[summary_PR_장기_1단계]]"
  - https://github.com/woowacourse/java-lotto/pull/521
  - https://github.com/woowacourse/java-blackjack/pull/808
  - https://github.com/woowacourse/java-janggi/pull/80
related:
  - "[[review_상속_vs_합성]]"
  - "[[review_네이밍_행위_드러내기]]"
---

# review: 테스트 설계 — 도메인을 따라 구조, 실패를 같이 검증

## 이 코드가 왜 문제인가

### 패턴 1: 하나의 테스트 클래스에 모든 도메인을 몰아넣음 (장기)

```java
// PieceTest 하나에 Palace, Chariot, Pao, Horse, Elephant, Soldier, Pawn 전부
class PieceTest {
    @Test void palaceMoveTest() { ... }
    @Test void chariotMoveTest() { ... }
    @Test void paoMoveTest() { ... }
    @Test void horseMoveTest() { ... }
    // ... 14개가 한 파일에
}
```

리뷰어 지적 (seovalue): **"Test코드도 각 Piece 객체 하위로 만들어져서 테스트되면 좋을 것 같네요"**
- 도메인 구조: Piece → Palace/Chariot/Pao/... (각 하위 클래스)
- 테스트 구조가 그걸 따라가지 않음 → **어느 도메인에 테스트가 있는지 찾기 어려움**

### 패턴 2: 성공 케이스만 검증, 실패/경계 케이스 누락 (장기·블랙잭)

```java
@Test
@DisplayName("사가 이동 가능한 경로를 모두 표시할 수 있다.")
void possibleRoutesTest_3() {
    Piece soldier = new Soldier(HAN, I0);
    Board board = new Board(HAN, Set.of(soldier));

    Set<Position> positions = soldier.possibleRoutes(board);
    // ... 가능 경로 검증만
}
// 불가능한 경로를 줬을 때 이동하지 않는지는 검증 X
```

리뷰어 지적 (seovalue): **"불가능한 경로일 때 이동하지 않는지에 대한 검증도 해보면 어때요?"**
리뷰어 지적 (ddaaac): **"버스트를 포함해서 다양한 테스트 케이스가 필요하지 않을까요?"** (블랙잭 — 21 초과 경계)

### 패턴 3: given에서 프로덕션과 다른 상태를 직접 세팅 (블랙잭)

```java
@Test
void someLogicTest() {
    // given — 내가 원하는 상태를 직접 만듦 (프로덕션 경로와 다름)
    Players players = Players.from(List.of("a", "b"));
    CardDeck cardDeck = new CardDeck(List.of(...));
    // 프로덕션에선 딜러가 카드를 분배받는 순서가 정해져 있는데
    // 테스트에선 그 순서를 건너뛰고 원하는 상태만 만듦
}
```

내 회고: **"제 머리를 믿고 원래 코드의 진행 과정과 다른 세팅을 해서 로직에 맹점이 생긴 것 같습니다"**
- given의 세팅이 프로덕션 경로를 우회하면, **프로덕션 경로에만 있는 버그를 테스트가 놓침**

### 패턴 4: 테스트 때문에 getter를 만들까 고민 (블랙잭)

```java
// 테스트에서 상태 확인을 위해 getter가 필요
// → "캡슐화 원칙 때문에 getter를 만들면 안 되나?" 고민
public Hand getHand() { return hand; }   // 테스트 전용 getter?
```

리뷰어 답 (ddaaac): **"테스트도 클라이언트 코드입니다. 클라이언트가 필요한 건 객체의 책임일 수 있어요."**

**문제의 공통점**:
- 테스트를 **"코드를 확인하는 보조 수단"**으로만 인식
- 테스트의 **구조·범위·세팅 경로**를 프로덕션과 별개로 둠
- 성공 케이스로 "구현은 됐다"고 만족 → 실패·경계가 비어 있음

## 대안

### 1. 테스트 구조는 도메인 구조를 따른다

```
src/test/java/
├── piece/
│   ├── PalaceTest.java
│   ├── ChariotTest.java
│   ├── PaoTest.java
│   └── ...
```

- 어느 도메인을 수정하면 어느 테스트를 돌려야 하는지 **즉시 매핑**
- 테스트 클래스 단위로 컨텍스트가 묶여 **`@Nested`·given 공유** 용이
- 신규 도메인 추가 시 **새 테스트 파일** — 기존 파일 거대화 방지

### 2. 성공·실패·경계를 세트로 검증

```java
class SoldierTest {
    @Test
    @DisplayName("사가 이동 가능한 경로를 모두 표시한다")
    void possibleRoutes_success() { ... }

    @Test
    @DisplayName("불가능한 경로가 주어지면 이동하지 않는다")
    void possibleRoutes_notAllowedPath() { ... }

    @Test
    @DisplayName("팀이 다른 기물 위치는 이동 후보에서 제외된다")
    void possibleRoutes_differentTeam() { ... }
}
```

기준: **"이 기능의 계약이 깨지면 어떤 증상이 나오는가?"** 를 질문
- 성공: 계약이 맞는지
- 실패: 계약이 깨질 때 제대로 막는지 (예외·반환값)
- 경계: 21 초과(버스트), 0 (빈 컬렉션), null, 최솟값/최댓값

### 3. given은 프로덕션 경로를 따라간다

```java
@Test
void someLogicTest() {
    // given — 프로덕션의 진행 순서 그대로
    Players players = Players.from(List.of("a", "b"));
    Dealer dealer = new Dealer(cardDeck);
    BlackJack blackJack = new BlackJack(players, dealer, cardDeck);
    blackJack.hitCardsToParticipant();  // 프로덕션에서 실제로 일어나는 분배 과정

    // when
    // ...
}
```

- 테스트 세팅이 **프로덕션 코드를 호출해서 상태 만들기** — 세팅 자체가 경로 검증
- 예외: 프로덕션 경로로 만들기 어려운 세팅(무작위성, 외부 의존)만 **Mock·직접 주입** 허용
- 판단 기준: "이 세팅을 프로덕션에서 어떻게 만드는가?" → 답이 있으면 그 경로로 세팅

### 4. 테스트도 클라이언트 — getter/가시성을 테스트 관점에서 재고

```java
// X — 테스트 전용 getter를 뒤늦게 끼워넣기
// public Hand getHand() { return hand; }   // "테스트 때문에" 추가

// O — 테스트가 필요로 하는 건 객체의 진짜 책임일 수도
public boolean isBurst() { return hand.sum() > 21; }   // 도메인 행위로 노출
```

- "테스트가 필요로 하는 것"이 **객체의 책임 신호**일 수 있음
- **getter를 써서 값을 꺼내 테스트에서 로직 구성** = 나쁜 냄새
- 테스트가 호출할 **행위 메서드(도메인 언어)** 를 추가하는 게 더 자연스러움

### 5. 테스트 네이밍·파라미터도 유지보수 대상

```java
@ParameterizedTest
@DisplayName("다양한 카드 조합에서 승자를 결정한다")
@MethodSource("provideSumForCalculateWinner")
void calculateWinnerTest(int dealerSum, int playerSum, MatchResult expected) { ... }
```

- `@DisplayName` 한국어로 **의도 설명** (`void test1()` 금지)
- `@ParameterizedTest`로 **다양한 입력을 세트로** — 경계·예외 케이스 자연스럽게 포함
- 네이밍이 구리면 6개월 뒤의 내가 못 알아봄 → 유지보수 대상

## 적용 기준

### 테스트 작성 체크리스트
1. **구조**: 도메인 하위 타입마다 테스트 클래스가 있는가?
2. **성공**: 기본 성공 케이스가 있는가?
3. **실패**: 계약이 깨지는 입력 1개 이상 있는가?
4. **경계**: 경계값(최소·최대·비어있음·임계) 있는가?
5. **given**: 프로덕션 경로로 세팅되는가, 아니면 직접 상태를 주입했는가?
6. **네이밍**: `@DisplayName`으로 **뭘 검증하는지**가 읽히는가?
7. **getter 냄새**: 테스트에서 getter로 꺼내 로직을 구성하고 있지 않은가?

### 지양할 패턴
- 하나의 `XxxTest`에 전체 도메인 몰아넣기
- 성공 케이스만 있는 테스트 파일
- given에서 "원하는 상태 바로 만들기" (세터·리플렉션 과용)
- 테스트를 위해서만 존재하는 getter — 도메인 행위로 치환 가능한지 확인
- `void test1()` / `void 테스트()` — 의도 전달 실패

## 흔한 반론과 답

| 반론 | 답 |
|---|---|
| "실패 케이스는 귀찮고 명백하다" | 귀찮음이 **버그 방지 이유를 이긴 것**. 명백한 케이스일수록 **회귀 방지**에 가치 있음. 블랙잭 버스트처럼 경계는 리팩토링에서 가장 먼저 깨짐 |
| "given을 프로덕션 경로로 만들면 세팅이 길어진다" | 길이보다 **맹점이 없어진다**는 이득이 큼. 길이가 진짜 문제면 `Fixture` 헬퍼 추출 |
| "테스트 전용 getter는 어쩔 수 없다" | 먼저 **도메인 행위로 치환 가능한지** 확인. `isBurst()`, `canMoveTo(pos)` 같은 행위가 대안 |
| "테스트 파일 분리하면 공통 세팅이 중복된다" | `@Nested`·`@BeforeEach`·헬퍼로 해결. 파일을 합치는 건 **도메인 경계를 흐릴 위험** |

## 3개 PR에서의 반복 신호

| PR | 지적 | 원칙 |
|---|---|---|
| **로또** | `@DisplayName` 누락 / 다양 입력 미흡 / 테스트 네이밍 유지보수 | 네이밍·입력 다양성 |
| **블랙잭** | 버스트(경계) 누락 / given이 프로덕션과 다름 / 테스트용 getter 고민 | 경계 케이스·given 경로·테스트=클라이언트 |
| **장기** | `PieceTest` 단일 파일 / 부정 케이스 미검증 | 구조 분리·실패 케이스 |

**핵심 메시지**: 3PR 모두 **"성공 케이스 작성에 만족하고 실패·경계·구조를 놓침"** — 개인 고질 영역

## 학습 노트 (왜 놓쳤나)

- **내 패턴 1: "구현이 되면 테스트 끝"**
  - 성공 케이스 한두 개로 만족 → 회귀 방지 장치가 빈약
  - 실패·경계는 "당연히 되겠지"로 넘김 → 리뷰어가 계속 지적
- **내 패턴 2: 테스트를 "별개의 코드"로 인식**
  - given에서 프로덕션 경로 대신 직접 상태 세팅 (편하니까)
  - 테스트 네이밍을 대충 처리 (`test1`, 영문 자동 생성 그대로)
- **내 패턴 3: 캡슐화 vs 테스트를 이분법으로 접근**
  - "테스트 때문에 getter 만드는 게 맞나?" 고민에 갇힘
  - ddaaac의 전환: **테스트도 클라이언트. 필요한 건 도메인 행위일 수 있음**
- 추출 원칙:
  - **"이 기능의 계약이 깨지면 어떤 증상이 나오는가?"** — 실패·경계를 뽑는 질문
  - **"이 given을 프로덕션에서 어떻게 만드는가?"** — 경로 세팅의 질문
  - **"테스트가 원하는 이 값이 도메인 행위로 표현될 수 있는가?"** — getter 고민의 탈출구

## 연결

- [[review_상속_vs_합성]] — 도메인 구조를 따르는 테스트는 상속/합성 판단의 결과가 드러남
- [[review_네이밍_행위_드러내기]] — 테스트 네이밍도 동일 원칙 (`test1` 금지, `@DisplayName`으로 의도)
- 3PR 모두 반복 → **상속 vs 합성과 함께 개인 고질 영역 투톱**
