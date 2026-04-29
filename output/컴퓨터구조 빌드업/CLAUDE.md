# output/컴퓨터구조 빌드업/ — 빌드업형 인포그래픽

컴퓨터구조 학습용 빌드업형 HTML 인포그래픽 모음.
일반 시각화 가이드라인은 부모 `output/CLAUDE.md` 참조.

## 본질

학습 프레임워크 3질문(왜 이 이름 → 기존 문제 → 해결 방법)에 사용자가 직접 답하면 시각이 한 단계씩 진화하고, 부품이 누적되어 마지막에 조감도가 빌드된 결과로 출현한다.

**왜 빌드업인가**
- 답을 입력하지 않으면 시각이 변하지 않음 → **능동 회상 강제** (그냥 보기는 학습이 아님)
- 매 학습이 "내가 빌드한 한 조각"으로 무대에 누적 → 소유감 + 장기기억 전이 효율 ↑
- 페이즈 전환 질문이 부품 간 인과 사슬을 만듦

## 작업 전 필수: 빌드업.html을 reference로 함께 읽기

이 가이드는 **개념·원칙·절차**를 담는다. **세부 코드 패턴(SVG 그룹 ID 명명, CSS 클래스 조합, JS 상태 모델 등)은 같은 폴더의 `빌드업.html`을 reference로 그대로 확장**하라.

- 새 페이즈 추가 시 처음부터 작성하지 말고 **기존 패턴을 확장**한다
- 일관된 컨벤션이 깨지면 능동 회상 강제 원칙도 함께 무너질 위험이 있다
- 가이드와 reference 파일 둘 다 읽으면 이 인포그래픽을 단독으로 재현할 수 있다

## 3단 레이아웃

```
[ 페이즈 인디케이터 ]      ← 클릭으로 점프. 점프 시 직전 부품은 자동 completed 처리
[ 누적 조감도 (PCB) ]      ← 어두운 메인보드 + 부품 슬롯들. 학습 완료 시 부품이 슬롯에 꽂힘
[ 메인 진화 무대 ]         ← 현재 학습 중인 부품의 큼지막한 진화 시각 (step별 통째 교체)
[ 질문답변 패널 ]          ← textarea 입력 → 내 답 vs 실제 답 + 학습 노트 메타
[ ↻ 처음부터 다시 빌드 ]
```

## 학습 프레임워크 ↔ 시각 변화 매핑

| 질문 | 시각 변화 강도 | 예시 |
|---|---|---|
| 왜 이 이름? | 작음 | 키워드 강조 ("CENTRAL", "RANDOM ACCESS") |
| 기존 문제? | 큼 | 병목·부재·통증 시각화 (분리된 회로 3개, 1,000만 배 갭) |
| 해결 방법? | 가장 큼 | 새 요소 등장·재배선 (CPU 박스 + 3요소, 시스템 흐름) |

## 구현 모델

### 상태 (state)

```js
const state = {
  phase: 'p1',     // 'p1' | 'transition' | 'p2' | 'p3' | ... | 'complete'
  step: 0,         // 0..2 (각 phase 안의 Q1·Q2·Q3). transition은 step 무시
  revealed: false  // 현재 step의 답이 제출되어 시각이 진화했는가
};
```

### 질문/답 데이터 (data)

```js
const data = {
  p1: {
    phaseLabel: 'P1 · CPU',
    steps: [
      // 정확히 3개 (학습 프레임워크 3질문에 대응)
      { q: '왜 이름이 ...?',  a: '... <b>키워드</b> ...', meta: '내 답 X → 실제 Y → 깨달음 Z' },
      { q: '기존 문제는?',    a: '...',                    meta: '...' },
      { q: '어떻게 해결했나?', a: '...',                    meta: '...' }
    ],
    completeMsg: '...'
  },
  transition: {  // P1 → P2 사이 전환 질문 (별도 객체, steps 배열 아님)
    q: '지금 ...의 한계는?',
    a: '<b>...</b>'
    // meta 없음 (학습 노트 메타는 페이즈 안의 답에만 동반)
  },
  p2: { /* 같은 구조 */ }
  // P3+ 추가 시: data.p3, data.transition2 (P2 → P3) 등 추가
};
```

### 미니맵 글로우 트래커 (prevMinimapState)

```js
let prevMinimapState = { cpu: null, ram: null /* P3+ 추가 시 키 추가 */ };
// 'completed' 상태가 처음으로 등장할 때만 pcbGlow 키프레임 1회 발동
// jumpToPhase로 직전 부품 자동 completed 처리할 땐 미리 'completed'로 세팅 → 글로우 X
```

### 함수 호출 흐름

```
[사용자 입력: 답 제출 / 다음 / 페이즈 점프]
   ↓ (state 변경)
render()
   ├─ updatePhasePills()        // 페이즈 인디케이터 색상 갱신
   ├─ 입력 영역 리셋             // textarea 활성화·비우기·포커스
   └─ renderStage()
        ├─ const v = computeView()   // state → 부품 상태 매핑
        ├─ renderMainStage(v.main)   // MAIN_STAGE_IDS 중 한 그룹만 visible
        └─ renderMinimap(v)
             ├─ setMiniBox('cpu', v.cpu)   // 부품별 슬롯+미니어처 토글
             ├─ setMiniBox('ram', v.ram)
             └─ trace 그룹 활성화 (v.connection)
```

### computeView 반환 형태

```js
{
  main: 'p1-step1',                    // 메인 무대에 보일 step 그룹 ID
  cpu:  { state: 'active', step: 0 },  // state: 'placeholder'|'transition'|'active'|'completed'
  ram:  { state: 'placeholder' },      // step은 active 상태에서만 의미 있음
  connection: false                    // PCB 트레이스 활성 여부
}
```

## 새 페이즈 추가 절차 (P3 System Bus, P4 Storage, ...)

1. **위키 소스 준비** — 위키 개념 페이지 + learning 노트 (막혔던 지점 메타용)

2. **데이터 추가** — JS `data` 객체에 phase 추가
   ```js
   data.p3 = {
     phaseLabel: 'P3 · System Bus',
     steps: [
       { q: '왜 ...?', a: '...', meta: '내 답 ... → 깨달음 ...' },
       ...3개
     ],
     completeMsg: '...'
   };
   ```
   페이즈 전환 질문은 별도 단계로 (현재 `data.transition` 패턴 참조).

3. **메인 무대 SVG** — step별 그룹 추가 (`p3-step1`, `p3-step2`, `p3-step3`)
   - 자리 박스 X, 화면 가득 큼지막한 시각
   - 학습 프레임워크 강도 매핑 적용 (위 표)

4. **미니맵 PCB 슬롯 추가** — 새 부품의 슬롯 그래픽 + 부품 미니어처 (디자인 패턴은 아래 섹션)

5. **computeView 분기 추가** — phase별 main, 미니맵 부품들의 상태 매핑

6. **페이즈 인디케이터** — pill 하나 추가 (`data-phase="3"`)

7. **MAIN_STAGE_IDS 갱신** — 새 step 그룹 ID 추가

8. **페이즈 점프 처리** — `jumpToPhase('3')` 시 P1·P2 부품을 모두 'completed'로 처리, 글로우 발동 X. `prevMinimapState`에 새 부품 키 추가

## PCB 미니맵 디자인 패턴

**배경**: 어두운 녹색 PCB (`#0a1a0f`) + 도트 격자 패턴 (회로 트레이스 느낌). 4모서리 나사 구멍.

**부품 슬롯**: 항상 표시. 부품마다 형태가 달라야 시각 인식이 빠름:
- **CPU** → LGA 소켓 (정사각 + 핀 격자 `<pattern>`)
- **RAM** → DIMM 슬롯 (가로 직사각 + 양 끝 잠금 클립)
- **Storage** → SATA 커넥터 또는 M.2 슬롯 (가로 짧은 슬롯)
- **System Bus** → 슬롯이 아닌 **PCB 트레이스 자체** (다른 부품 사이 회로 라인)
- **IO Device** → I/O 패널 (가로 긴 영역, USB·이더넷 포트들)

**부품 미니어처** (학습 완료 시 슬롯 위에 등장):
- CPU 다이 → 어두운 실리콘 패키지 + IHS 표면 + 라벨
- RAM 스틱 → 녹색 PCB + 검은 칩 5개 + 골드 핑거
- Storage SSD → 검은 PCB + 메모리 칩 + 라벨

**상태별 슬롯 박스 색**:
| 상태 | stroke | 효과 |
|---|---|---|
| placeholder | 회색 (`#444`) | 점선/실선 |
| transition | 보라 (`#c792ea`) | 보라 글로우 |
| active | 노랑 (`#ffcc66`) | 노랑 글로우 |
| completed | 녹색 (`#34d399`) | (첫 완료 시) `pcbGlow` 키프레임 1.8s |

## CSS 명명 규칙

### 미니맵 부품 박스
패턴: `{part}-{socket|slot}-bg + 상태 클래스 조합`

```css
.cpu-socket-bg              /* 기본 (placeholder 상태) */
.cpu-socket-bg.transition   /* 보라 강조 (페이즈 전환 직후) */
.cpu-socket-bg.active       /* 노랑 강조 (학습 중) */
.cpu-socket-bg.completed    /* 녹색 정착 (학습 완료) */
.cpu-socket-bg.justCompleted-pcb  /* 첫 완료 시 1.8s 글로우 키프레임 */
```

DIMM·SATA·M.2 등 새 부품도 같은 패턴: `dimm-slot-bg`, `sata-slot-bg` 등.

### 메인 무대 step 그룹 ID
패턴: `{phaseId}-step{n}` 또는 특수(`empty-state`, `transition-state`)

```
empty-state, p1-step1, p1-step2, p1-step3,
transition-state, p2-step0, p2-step1, p2-step2, p2-step3,
[P3+ 추가] transition2-state, p3-step0, p3-step1, p3-step2, p3-step3, ...
```

`MAIN_STAGE_IDS` 배열에 모두 등록해야 `renderMainStage`가 토글한다.

### 미니맵 부품 미니어처 그룹 ID
패턴: `mini-{part}-{die|stick|module|...}`

```
mini-cpu-die         (CPU 다이)
mini-ram-stick       (RAM 스틱)
mini-storage-module  (SSD)
```

### 가시성 토글 방식
- 메인 무대 step 그룹: `fade-hidden` 클래스 (opacity 0 + transition)
- 미니맵 ?: `style.display = 'none'` 직접 설정 (opacity 잔상 방지를 위해 직접 제거)
- 미니맵 부품 미니어처: `fade-hidden` 클래스

## 능동 회상 강제 원칙 (절대 양보 X)

- 답 입력 전엔 메인 무대 시각이 변하지 않음 (직전 step 유지)
- 답 제출 시점에 비로소 시각 진화 + 답 비교 + 학습 노트 메타 동반
- 빈칸 제출 = 스킵 (CLAUDE.md 학습 모드 "탈출구" 규칙과 동일)
- 제출 후 textarea 잠금 (자기 답 박제, 수정 불가)
- "답 즉시 노출" 패턴은 학습 효과를 무력화 — 절대 추가 X

## 페이즈 점프 처리

- 페이즈 pill 클릭 시 그 페이즈 step=0부터 시작
- 직전 부품들은 자동 'completed' 상태로 미니맵에 표시 (학습 안 했어도)
- `prevMinimapState`를 'completed'로 미리 세팅 → **글로우 발동 X** (학습 안 했는데 축하 효과는 어색)
- 미구현 페이즈(P3+ locked)는 `cursor: not-allowed`, 클릭 핸들러 안 붙음

## 메타 노트 (학습 노트 동반)

답 공개 시 함께 표시되는 "📘 학습 노트 — 막혔던 지점" 영역.
출처: `output/learning_<주제>_<날짜>.md`의 "막혔던 지점" 섹션.
형식: "내 답 ... / 실제 ... → 깨달음 ..."

이 영역은 자기 회고를 일으켜 "왜 틀렸는지"가 함께 박힘 → 정착도 ↑

## 검증 시뮬레이션 (새 페이즈 추가 후 동작 점검)

새 페이즈 추가 후 다음 표대로 동작하는지 한 번 돌려보고 검증한다:

| state.phase | step | revealed | main | minimap.cpu | minimap.ram | connection |
|---|---|---|---|---|---|---|
| p1 | 0 | false | empty-state | active(Q1) | placeholder | - |
| p1 | 0 | true | p1-step1 | active(Q1) | placeholder | - |
| p1 | 1 | false | p1-step1 | active(Q2) | placeholder | - |
| p1 | 1 | true | p1-step2 | active(Q2) | placeholder | - |
| p1 | 2 | false | p1-step2 | active(Q3) | placeholder | - |
| p1 | 2 | true | p1-step3 | **completed (글로우 ⚡)** | placeholder | - |
| transition | - | false | p1-step3 | completed | placeholder | - |
| transition | - | true | transition-state | completed | transition | - |
| p2 | 0 | false | p2-step0 | completed | active(Q1) | - |
| p2 | 0 | true | p2-step1 | completed | active(Q1) | - |
| p2 | 2 | true | p2-step3 | completed | **completed (글로우 ⚡)** | **active** |
| complete | - | - | p2-step3 | completed | completed | active |

P3+ 추가 시 같은 패턴으로 표 확장. 글로우는 각 부품의 첫 'completed' 진입 시점에만 1회.

**페이즈 점프 시뮬레이션**:
| 클릭 | state.phase | 결과 |
|---|---|---|
| P1 pill | 'p1' | step=0, revealed=false, prevMinimapState 리셋 |
| P2 pill | 'p2' | step=0, revealed=false, prevMinimapState.cpu='completed' (글로우 X) |
| P3+ pill | (locked) | 클릭 핸들러 안 붙음 (cursor: not-allowed) |

## 작업 시 체크리스트

- [ ] 학습 프레임워크 3질문 순서 (왜 이름 → 문제 → 해결)
- [ ] 페이즈 전환 질문은 "지금 상태의 한계는?" 형태
- [ ] 메타 노트는 학습 노트의 "막혔던 지점"에서 가져옴
- [ ] 미니맵 부품 슬롯 형태가 부품마다 다름 (LGA / DIMM / SATA / 트레이스 / I/O 패널 등)
- [ ] 답 입력 전엔 시각 변화 X (능동 회상 강제 검증)
- [ ] 페이즈 점프 시 글로우 발동 X (직전 부품 자동 completed 처리)

## 확장 시 결정 사항

### P4 추가에서 답이 정해진 것 (N=2)

- **슬롯형 setMiniBox 추상화**: 새 슬롯형 부품(M.2/SSD)을 추가하면서 매핑 객체로 일반화 — `FILLED_ID`, `BG_BASE_CLASS` 객체에 키만 추가하면 됨
  ```js
  const FILLED_ID = { cpu: 'mini-cpu-die', ram: 'mini-ram-stick', storage: 'mini-storage-module' };
  const BG_BASE_CLASS = { cpu: 'cpu-socket-bg', ram: 'dimm-slot-bg', storage: 'm2-slot-bg' };
  ```
- **새 부품 슬롯 디자인 (M.2 SSD)**: 가로로 짧은 슬롯(폭 ~170, 높이 ~22) + 우측 마운트 볼트(원형) + 위에 SSD 모듈(검은 PCB + NAND 칩 3개 + "SSD" 라벨). 슬롯 자체가 얇고 위에 모듈이 솟아오르는 형태가 실제 M.2 사실성에 가까움
- **메인 무대 시각 흐름 화살표 방향**: 박스 외곽 모서리에서 출발해 다음 박스 외곽 모서리로 도착. 박스 내부에서 시작/끝나면 화살표가 박스 안으로 들어가는 시각 오류. 시스템 흐름 박스들은 가운데 정렬(viewBox 880 기준 여백 균등)
- **transition 명명 패턴 검증**: `transition3`도 `transition2`와 동일 패턴 — 단순 incremental이 N=2에서도 일관 유지
- **페이즈 인디케이터**: 4단(P1·P2·P3·P4)까지는 한 줄 충분. P5+ 잠김 라벨만 우측에. P5 추가 시 5단 한 줄 가능 여부 재판단

### P5+에서 도달 시 답을 정할 것 (남은 항목)

- **패널형 setMiniBox** (IO Device): 슬롯형·트레이스형과 다른 패턴. I/O 패널 + 포트 미니어처들. 어떻게 매핑 객체에 흡수할지 또는 별도 함수가 필요할지
- **미니맵 viewBox 공간 부족**: P5 슬롯 자리가 미니맵 우측 끝(x=830~880)밖에 없음. 부품 5개 들어가면 viewBox 확장 vs 부품 크기 축소 vs 2층 배치 결정 필요

---

### P3 추가에서 답이 정해진 것 (N=1)

- **transition 명명**: `transition` → `transition2` → `transition3` ... (단순 incremental, P→P+1마다 하나씩)
- **트레이스형 setMiniBus**: 슬롯형과 별도 함수. bg rect 대신 **path들의 `pcb-trace.bus-{state}` 클래스 토글**. status 텍스트는 트레이스 영역 위쪽, 라벨은 아래쪽
- **connection 구조 진화**: 단일 boolean 제거. `view.bus = { state, step }`로 부품과 동일하게 4-state(placeholder/transition/active/completed) 처리. 트레이스가 부품 그 자체라는 의미가 명확해짐
- **jumpToPhase 직전 부품 처리**: `prevMinimapState = { cpu: 'completed', ram: 'completed', bus: null }` 형태로 **명시적 키별 처리**. 자동 루프 미사용 — 새 부품 추가 시 키가 명시적이어야 누락 방지
- **미니맵 공간**: 트레이스형은 슬롯 자리 안 차지. 기존 트레이스 영역(CPU 소켓~DIMM 슬롯 사이)을 그대로 활용. P3+ → P4+ 라벨만 갱신

### 메인 무대 라벨 컨벤션 (P3에서 정해짐)

부품 채널·서브 개념 라벨은 **한국어 메인 + 영문 약어 보조** 형식:
```html
<text>주소 버스 <tspan style="font-size:11px;font-weight:500;fill:#9c87d4;">(ADDR)</tspan></text>
```
이유: 위키 페이지가 한국어 정식 표기. 한국어가 먼저 인지되고 영문 약어는 함께 익힘. 학습 도구 정합성.

원칙: 추측하지 말고, 실제 추가 과정에서 마주친 진짜 제약·실수가 가장 신뢰할 수 있는 가이드 소스.

## 현재 파일

- `빌드업.html` — P1 CPU + P2 RAM + P3 System Bus + P4 Storage (P5+ 미구현)
