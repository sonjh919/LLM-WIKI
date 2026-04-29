---
description: 위키 작업 이력. 시간순 append-only.
updated: 2026-04-29 (deprecated 결과물 3건 정리)
---

# Log

## [2026-04-17] init | 위키 초기화
- LLM Wiki 폴더 구조 생성 (raw/, wiki/, output/)
- CLAUDE.md 및 하위 CLAUDE.md 작성
- index.md, log.md 초기화

## [2026-04-17] ingest | 하네스 공식문서 100번 읽은 것처럼 만들어드림
- 소스: raw/media/_하네스 공식문서 100번 읽은 것처럼 만들어드림.md (유튜브, 캐슬 AI)
- 생성: summary_하네스 엔지니어링 영상.md, 하네스 엔지니어링.md, 컨텍스트 부패.md
- index.md 업데이트

## [2026-04-17] ingest | 컴퓨터구조 — CPU
- 소스: raw/notes/컴퓨터구조/컴퓨터부품/CPU.md
- 생성: wiki/CPU.md
- index.md 업데이트

## [2026-04-17] ingest | 컴퓨터구조 — System Bus
- 소스: raw/notes/컴퓨터구조/컴퓨터부품/System Bus.md
- 생성: wiki/System Bus.md
- index.md 업데이트

## [2026-04-17] ingest | 컴퓨터구조 — IO Device
- 소스: raw/notes/컴퓨터구조/컴퓨터부품/IO Device.md
- 생성: wiki/IO Device.md
- index.md 업데이트

## [2026-04-17] ingest | 컴퓨터구조 — Storage
- 소스: raw/notes/컴퓨터구조/컴퓨터부품/Storage.md
- 생성: wiki/Storage.md
- index.md 업데이트

## [2026-04-17] update | CPU 페이지 섹션명 변경
- "개발에서 왜 중요한가" → "백엔드 개발에서의 활용"

## [2026-04-17] ingest | 컴퓨터구조 — RAM
- 소스: raw/notes/컴퓨터구조/컴퓨터부품/RAM.md
- 생성: wiki/RAM.md
- index.md 업데이트

## [2026-04-20] improve | 위키 개선 점검
- 분석: 전체 8개 페이지, 2개 영역 (컴퓨터구조, AI/하네스)
- 제안: 6건 (Stage 2 진행, query 활용, 학습 밸런스, 복습, 구조 보강, 결과물)
- 실행: 없음 (현황 확인 목적)

## [2026-04-21] infra | PR 리뷰 인풋 파이프라인 구축
- raw/reviews/ 폴더 신설, raw/CLAUDE.md 및 wiki/CLAUDE.md 업데이트 (리뷰 페이지 유형 추가)
- clipper/clipper-PR리뷰.json 작성 (트리거 미동작 이슈 — 코드 lazy-load 미캡처)
- scripts/fetch-pr-review.sh 작성 — gh CLI 기반, diff ±N줄 맥락 포함

## [2026-04-21] ingest | PR 리뷰 요약 — 로또 1단계
- 소스: raw/reviews/2026-04-21_[1단계_-_로또_구현]_링크(손준형)_미션_제출합니다..md (woowacourse/java-lotto PR #521)
- 생성: wiki/summary_PR_로또_1단계.md (12개 학습 카테고리 + 6개 review_ 승격 후보)
- index.md 업데이트

## [2026-04-21] ingest | review 첫 페이지 — final 키워드
- 소스: summary_PR_로또_1단계.md의 승격 후보 중 "final 키워드" 선정
- 생성: wiki/review_final_키워드_언어단_안전장치.md
- 프레임워크: "이 코드가 왜 문제인가 → 대안 → 적용 기준 → 반론 → 학습 노트"
- index.md에 "리뷰" 섹션 신설

## [2026-04-21] ingest | PR 리뷰 요약 — 블랙잭 1단계
- 소스: raw/reviews/2026-04-21_[1단계_-_블랙잭]_링크(손준형)_미션_제출합니다..md (woowacourse/java-blackjack PR #808)
- 생성: wiki/summary_PR_블랙잭_1단계.md
- 관찰: 리뷰어 스타일 대비 (Rok93 vs ddaaac), 2개 PR 공통 원칙 식별, 블랙잭 고유 신규 원칙 5건
- 공통 원칙 (네이밍·상속vs합성·매직넘버)은 review_ 승격 우선순위
- 메모리 기록: 패턴이 굳기 전에 스킬화하지 않기 (N=2 달성, N=2~3 목표)

## [2026-04-21] ingest | review 승격 — 네이밍 (2개 PR 공통)
- 소스: summary_PR_로또_1단계.md + summary_PR_블랙잭_1단계.md 공통 원칙
- 생성: wiki/review_네이밍_행위_드러내기.md
- 근거: 두 PR에서 반복 — 로또(`Main`, `getXXX`, `GetLottoDto`), 블랙잭(`CardDeck.sum`, `Amount`, `bonus`)
- 프레임워크 동일: "이 코드가 왜 문제인가 → 대안 → 적용 기준 → 반론 → 학습 노트"

## [2026-04-21] ingest | review 승격 — 추상화의 목적 (블랙잭 고유)
- 소스: summary_PR_블랙잭_1단계.md의 ddaaac 리뷰 (Participant#getFirstCards 논의)
- 생성: wiki/review_추상화의_목적.md
- 핵심: 추상화는 중복 제거·변경 대비가 아닌 "요구사항을 메시지 흐름으로 표현"
- index.md "리뷰" 섹션에 3개 페이지로 확장

## [2026-04-21] ingest | PR 리뷰 요약 — 장기 1단계 (N=3)
- 소스: raw/reviews/2026-04-21_[1단계_-_장기]_링크(손준형)_미션_제출합니다..md (woowacourse/java-janggi PR #80)
- 생성: wiki/summary_PR_장기_1단계.md
- 리뷰어: seovalue (조앤), 2라운드 + APPROVED 후 질문
- 관찰: 질문형 스타일 (ddaaac와 유사), "Owner는 링크" — 최종 판단 위임
- 3개 PR 공통 원칙: 상속vs합성·테스트 설계 (다음 승격 우선순위)
- 장기 고유: 원칙의 맥락 의존성 (콘솔 vs 웹), Parameter Object 분리 신호, 상태없는 객체 재사용, 행동 없는 개념은 독립 객체 X
- N=3 달성 → 파이프라인 스킬화 판단 가능 시점

## [2026-04-21] ingest | review 승격 — 상속 vs 합성 (3PR 공통, 최강 신호)
- 소스: summary_PR_로또/블랙잭/장기 1단계 3개 PR 공통 원칙
- 생성: wiki/review_상속_vs_합성.md
- 근거: 로또(WinningLotto 합성), 블랙잭(Participant 추상 클래스 + ddaaac의 "일반 클래스 상속 지양"), 장기(NormalPiece/JumpingPiece 중간 계층 재고 + seovalue "그 속성이 Piece에 담겨야?")
- 핵심: 기본값은 합성. 상속은 is-a·타입 계약일 때만. protected는 캡슐화 신호등
- 구성: 3PR 반복 신호 표 + 중간 타입 계층 판단 기준 + 전략 패턴 대안
- index.md "리뷰" 섹션 4개 페이지로 확장

## [2026-04-21] ingest | review 승격 — 테스트 설계 (3PR 공통, 두번째 투톱)
- 소스: summary_PR_로또/블랙잭/장기 1단계 테스트 관련 피드백 통합
- 생성: wiki/review_테스트_설계.md
- 근거: 로또(@DisplayName·다양 입력), 블랙잭(버스트 경계·given 프로덕션 경로·테스트=클라이언트), 장기(PieceTest 클래스 분리·부정 케이스)
- 핵심: 도메인 구조 따라 분리, 성공·실패·경계를 세트로, given은 프로덕션 경로대로, 테스트도 클라이언트 코드
- 체크리스트: 구조/성공/실패/경계/given/네이밍/getter-냄새 7항목
- index.md "리뷰" 섹션 5개 페이지로 확장

## [2026-04-21] ingest | review 승격 — 리뷰 답변의 태도 (메타, 3PR 답변 진화)
- 소스: 3개 PR에서 관찰된 답변 태도 변화
- 생성: wiki/review_리뷰_답변의_태도.md
- 성장 궤적: 로또(수긍+역질문+관성 인정) → 블랙잭(근거 있는 반론) → 장기(단락 근거+미해결 인정+공동 고민)
- 전환점: ddaaac 질문형 리뷰(1→2단계), seovalue "Owner는 링크"(2→3단계)
- 4가지 안티패턴 + 답변 작성 전 4가지 질문 + AI 대화에도 적용 가능
- 기술 원칙 5개와 축이 달라 중복 없이 상호 보완
- index.md "리뷰" 섹션 6개 페이지로 확장

## [2026-04-21] output | review 원칙 관계도 Canvas (생성 후 삭제)
- 생성: output/canvas_review_원칙_관계도.canvas
- 삭제 이유: 리뷰 원칙은 개념적 연관 — Obsidian graph view가 wikilink로 이미 자동 그래프를 그려줌. 수동 canvas는 중복·보여주기용
- 학습: 시각화는 **물리적·공간적 관계**가 본질인 주제(컴퓨터부품·아키텍처)에 적합. 개념 원칙은 각 페이지의 "적용 기준"이 실전 가치 더 큼
- index.md "결과물" 섹션은 유지 (컴퓨터부품 조감도·인포그래픽만 남김)

## [2026-04-21] infra | CLAUDE.md 5건 업데이트 (review 파이프라인 반영)
- 메인 CLAUDE.md: 위키 운영 규칙에 **Promote** 프로세스 추가 (summary → review_ 승격, N=2~3 반복 신호 기준)
- wiki/CLAUDE.md: **PR 요약 페이지** 유형 신설 (프레임워크: PR 개요 → 리뷰어 스타일 → 라운드 흐름 → 학습 포인트 → 답변 패턴 → 승격 후보)
- wiki/CLAUDE.md: 리뷰 페이지 프레임워크 확장 ("반론과 답 → 학습 노트" 섹션 공식화)
- raw/CLAUDE.md: `ingested: true/false` 플래그 규칙 명시
- output/CLAUDE.md: **시각화 적용 기준** 신설 (공간적·물리적 관계 주제에만, 개념 연관은 graph view로 충분)

## [2026-04-22] infra | 소크라테스식 문답 학습 모드 명문화
- CLAUDE.md "학습자" 역할에 선호 학습 방식 한 줄 추가
- CLAUDE.md "AI에게 기대하는 것"에 3단계 스캐폴딩·탈출구 규칙 추가
- CLAUDE.md "Query" 섹션에 학습 모드 분기 추가 (기존 페이지 복습 = 질문-only, 서브 질문은 세션 내 소비)
- "나의 핵심 맥락.md"의 AI 역할에 선호 문구 반영

## [2026-04-22] query | CPU 소크라테스식 복습
- 기존 wiki/CPU.md를 질문-only 모드로 복습
- 드러난 빈틈: **레지스터 vs 캐시 혼동**, **코어 개념** 명시적 부재, **컨텍스트 스위칭** 명시적 부재
- wiki/CPU.md 보강: "코어와 멀티코어" 섹션 신설, 백엔드 섹션을 CPU/I/O 바운드 표로 재구성
- 신규: output/learning_CPU_2026-04-22.md (학습 여정 노트 — 새 output 유형 N=1 실험)
- 소크라테스식 문답 효과 검증: 수동 읽기로는 드러나지 않았을 빈틈이 질문으로 드러남

## [2026-04-22] ingest | 컨텍스트 스위칭 페이지 분리
- CPU.md에 섹션으로 넣었던 컨텍스트 스위칭을 독립 페이지(wiki/컨텍스트 스위칭.md)로 분리
- 판단 근거: CPU와 OS의 교차점 개념이라 향후 스레드·프로세스·OS 스케줄링 페이지에서도 참조 예상. 코어 개념은 CPU의 확장 축이라 CPU.md 섹션 유지
- index.md 새 서브섹션 "컴퓨터구조 — 실행 모델" 신설 (향후 스레드·프로세스 등 확장 지점)
- CPU.md는 "관련 개념" 섹션에 wikilink로 역참조

## [2026-04-21] infra | CLAUDE.md Reflect 프로세스 신설
- 메인 CLAUDE.md 위키 운영 규칙에 **Reflect** 추가 (Ingest/Query/Lint/Promote와 동급)
- 목적: 대화 후 반복·규칙성 신호를 CLAUDE.md/메모리/페이지 중 적절한 레이어로 반영
- 스킬화 대신 프로세스 명문화 선택 (N=1 시점, 자체 규칙 "N=2~3 수동 후 스킬화" 준수)
- 중복 제거 명시: CLAUDE.md와 메모리 중복 시 CLAUDE.md를 단일 소스로

## [2026-04-22] query | RAM 소크라테스식 복습 (N=2)
- 기존 wiki/RAM.md를 질문-only 모드로 복습
- 드러난 빈틈: **Storage vs RAM 속도 차이 감**, **System Bus 3종 제어 버스 누락**(이미 복습했던 개념), **JVM 메모리 영역 중 메서드 영역·공유/비공유 구분**, **OOM 시나리오 3종(코드·DB·캐시)**, **스레드-Stack 관계**
- 돌파: 사용자 본인이 먼저 메타 질문 — "JVM이 RAM에 올라가?", "Java Thread = OS Thread?" 두 질문이 복습을 깊게 만든 지점. CPU↔RAM 복습이 "같은 스레드"라는 사실로 연결됨
- wiki/RAM.md 대폭 보강: 속도 계층 표, JVM 3개 영역 표, OOM 시나리오 3종 + 에러 메시지 매핑, 스레드-Stack-컨텍스트 스위칭 연결, Java Thread vs OS 스레드 구분
- 신규: output/learning_RAM_2026-04-22.md (학습 여정 노트 N=2 — "막혔던 지점→돌파→깨달음" 3단 포맷 유지, "본인 메타 질문" 섹션 추가)
- index.md 업데이트 (RAM 설명 확장 + output 항목 추가)
- 관찰: **복습한 개념(System Bus)도 흐릿해진다** — 복습도 감가상각되는 신호. 추후 System Bus 자체 복습 필요

## [2026-04-22] ingest | JVM 메모리 구조 페이지 분리
- RAM.md의 백엔드 섹션에 들어있던 JVM 3영역·OOM 3종·JVM 옵션·스레드-Stack 내용을 wiki/JVM 메모리 구조.md로 분리
- 판단 근거(CPU-컨텍스트 스위칭 분리 때와 같은 기준): **다른 맥락에서 참조 가능성**. JVM 메모리 구조는 GC·성능 튜닝·Spring 시작 과정 등에서 계속 참조될 독립 개념. RAM은 하드웨어, JVM은 언어 런타임으로 결이 다름
- RAM.md 백엔드 섹션은 "RAM 위에서 돌아가는 애플리케이션" / "동시 요청 처리와 RAM 소비"(간소화) / "인메모리 캐시"로 축소. [[JVM 메모리 구조]] wikilink로 연결
- index.md 신규 서브섹션 "Java / JVM" 신설 (향후 GC·Spring Boot 런타임 등 확장 지점)
- 패턴 반복: CPU(코어 섹션 유지 + 컨텍스트 스위칭 분리), RAM(속도 계층·인메모리 캐시 섹션 유지 + JVM 메모리 구조 분리) — 같은 판단 기준 2회 적용 (N=2)

## [2026-04-23] query | System Bus 소크라테스식 복습 (N=3)
- 기존 wiki/System Bus.md를 질문-only 모드로 복습
- **복습 감가상각 회복 신호**: 지난 세션(2026-04-22)에 "플래그 버스"라고 틀렸던 제어 버스를 이번엔 바로 기억해냄. 하루 단위 복습·learning 노트 재각인 효과로 추정
- 드러난 빈틈: **"기존 문제" 스케일 혼동**(ALU·레지스터 내부 vs 부품 간), **제어 버스 필요성 구체 장면**(주소만으로 읽기/쓰기 구분 불가), **I/O 바운드 원인 오해**("버스 폭이 좁아서"로 잘못 연결 → 실제는 IO 장치 자체 속도)
- 본인 메타 질문 2개(RAM 복습과 같은 빈도):
  1. "제어 버스를 굳이 왜 분리했냐?" → 정보 성격·폭 차이·해석 오버헤드 개념 도달
  2. "다른 장치끼리 이어지는 버스 있냐?" → **DMA 개념 자연 유도**
- wiki/System Bus.md 보강: 3종 버스 방향성 표(단방향/양방향/혼합), N(N-1)/2 공식, "왜 3개로 분리" 설명, 백엔드 섹션 재구성(병목 구분·다층 버스·비동기 연결)
- 신규: output/learning_System Bus_2026-04-23.md (학습 여정 노트 N=3 — 4단 포맷+메타질문 섹션 연속 3회 유효, 포맷 정식화 신호)

## [2026-04-23] ingest | DMA 페이지 분리
- System Bus.md에 한 줄이었던 DMA를 wiki/DMA.md 독립 페이지로 분리
- 판단 근거: **"다른 맥락에서 참조 가능성"** — zero-copy·sendfile()·Netty·Direct Buffer 등 백엔드 여러 맥락에서 독립 참조됨. "CPU↔IO 직접 통신" 자체로 탄탄한 개념
- DMA.md 구성: PIO 방식의 문제 → DMA 컨트롤러·버스 마스터 권한 → zero-copy/sendfile()·Netty NIO 활용 → Direct Buffer 연결
- System Bus.md의 DMA 언급은 한 단락으로 축약하고 [[DMA]] 링크로 이관
- **패턴 반복 N=3**: CPU→컨텍스트 스위칭, RAM→JVM 메모리 구조, System Bus→DMA. 같은 분리 기준("다른 맥락 참조 가능성") 3회 적용 — **CLAUDE.md 규칙 승격 후보**

## [2026-04-23] query | Storage 복습
- 기존 wiki/Storage.md를 질문-only 모드로 복습
- 매끄럽게: 휘발성·용량·비용 대비 관점 완벽, HDD 임의 접근 느린 이유 정확 설명
- 빈틈: SSD 내부 원리(비휘발성 유지 메커니즘의 속도 비용), DB 버퍼 풀 개념 미정착, 로그 I/O·IOPS 개념 미학습
- 본인 메타 질문: "SSD가 전자식이면 RAM과 같은 알고리즘이라 빠른가?", "DB쪽을 더 파보고 싶은데 지금 하긴 결이 다르지?" → **DB 학습 후보 발의로 이어짐**
- 학습 노트 별도 생성 X (IO Device와 같은 날 연속 세션, 컴퓨터부품 마무리 맥락에서 IO Device 노트에 통합적 회고)

## [2026-04-23] query | IO Device 복습 — 컴퓨터부품 5종 마무리
- 기존 wiki/IO Device.md를 질문-only 모드로 복습
- 매끄럽게: 3분류·NIC 중심성 즉시 답, **Thread-per-Connection 한계에 JVM 메모리·컨텍스트 스위칭·스레드 풀 동시 소환** — 이전 4개 세션 개념이 한 질문에 전부 엮임
- 빈틈: I/O 멀티플렉싱 명칭("이벤트 루프?"로 방향만), 소켓 개념 자기 인식으로 후보 분리, 5대 부품 조감도 시작점 못 잡음
- 본인 메타 제안: **"학습 후보 백로그"** 인프라 발의 — 개별 개념 학습을 넘어 학습 시스템 자체 진화 신호
- wiki/IO Device.md 대폭 보강: Thread-per-Connection vs I/O 멀티플렉싱 대조, 5대 부품 HTTP 요청 흐름 조감도, DMA·컨텍스트 스위칭·JVM 메모리 wikilink 강화
- 신규: output/learning_IO Device_2026-04-23.md (N=4, 4단 포맷 연속 4회 유효 — **스킬화 판단 가능 시점**)

## [2026-04-23] infra | 학습 후보 백로그 + Branch 프로세스 신설
- 신규: output/학습_후보.md — IO Device 세션에서 사용자 본인이 발의한 메타 인프라
- 구조: 카테고리(DB·네트워크·JVM·성능·인프라·학습법)별 분류, 신호 강도(반복 등장 횟수), 상태(후보/진행중/완료)
- Backfill: 5개 학습 세션(CPU·RAM·System Bus·Storage·IO Device) + 요약·리뷰 페이지에서 후보 17건 수집
- CLAUDE.md에 **Branch (학습 후보 관리)** 프로세스 추가 — Ingest/Query/Lint/Promote/Reflect와 동급 (Query 바로 뒤 배치)
- 완료 섹션에 승격 역사 기록: 컨텍스트 스위칭·JVM 메모리 구조·DMA
- 활용 계획: 시각화에서 파생 맥락 표현, 다음 학습 대상 우선순위 결정, 반복 등장 주제 식별

## [2026-04-23] output | 컴퓨터구조 학습 여정 canvas
- 신규: output/컴퓨터구조 학습 여정.canvas
- 구조: 상단 "객관 구조"(5대 부품 + 요청 흐름) × 하단 "학습 궤적"(N=1~N=4 + Storage 세션) + 외곽 "학습 후보"
- 앵커: 승격된 개념 3개(컨텍스트 스위칭·JVM 메모리·DMA)가 구조 레이어와 궤적 레이어를 잇는 중간 다리
- 시각화 장치: 세션→앵커(노란색), 부품→앵커(초록색), N=4 개념 소환(빨간색), N=4→후보 발의(보라색), 세션 시간 체인(회색)
- 기존 "컴퓨터부품 전체 조감도.canvas"(정적 구조)와 상보 관계
- updated: index.md 결과물 섹션

## [2026-04-27] reflect | 시각화 목적·형태 가이드라인 명문화
- 메인 CLAUDE.md: "나의 비전과 목표"에 핵심 목적 추가 (학습 → 효율 복습 → 장기기억 전이). 시각화 = "필수 도구"로 격상
- output/CLAUDE.md: "시각화의 목적" + "시각화 형태 (능동 회상 강제)" 두 섹션 신설. 두 종류(개념 진화형/빌드업형) + 학습 프레임워크↔시각 변화 매핑 + 안티 패턴 명시
- 나의 핵심 맥락.md: 시각화 한 줄을 "복습 효율 → 장기기억 전이 필수 도구"로 강화
- 인포그래픽 실험 기록.md: N=2 미스매치 발견(클릭 즉시 답 노출 → 능동 회상 무력) + 빌드업형 방향 결정 기록
- 메모리: 새 방향 반영 (project_infographic_output.md)

## [2026-04-29] cleanup | deprecated 결과물 3건 삭제
- 삭제: output/인포그래픽 실험 기록.md (결정 history는 log.md에 충분히 기록되어 중복)
- 삭제: output/컴퓨터구조 학습 여정.canvas (정적 시각화, 빌드업.html이 발전 형태로 대체)
- 삭제: output/컴퓨터부품 인포그래픽.html (N=1 종합 조감형, 능동 회상 미강제 — 빌드업.html이 대체)
- 보존: 컴퓨터부품 전체 조감도.canvas (정적 부품 연결 구조 — 다른 형태 결과물)
- 보존: 컴퓨터구조 학습 여정.html (N=2 종합 조감형 — 추후 모드 토글 또는 빌드업 흡수 검토 후보)
- references 갱신: wiki/index.md, output/CLAUDE.md (안티 패턴 예시 문구)
- git history 보존 — 필요 시 복구 가능

## [2026-04-28] output | 빌드업 폴더 분리 + 가이드 CLAUDE.md
- 신규: output/컴퓨터구조 빌드업/ 폴더 (도메인 + 형태별 결과물 묶음)
- 이동: output/컴퓨터구조 빌드업.html → output/컴퓨터구조 빌드업/빌드업.html (git mv)
- 신규: output/컴퓨터구조 빌드업/CLAUDE.md — 빌드업형 만드는 구체 가이드
  - 본질·3단 레이아웃·학습 프레임워크↔시각 변화 매핑·새 페이즈 추가 절차·PCB 미니맵 디자인 패턴·능동 회상 강제 원칙·페이즈 점프 처리·메타 노트
- output/CLAUDE.md: "특정 형태 반복 생산 시 하위 폴더 CLAUDE.md로 분리" 규칙 한 줄 추가
- index.md: 결과물 섹션 폴더 구조 반영

## [2026-04-28] output | 빌드업 N=1 → N=2 — PCB 메인보드 + 답 입력 + 페이즈 점프
- output/컴퓨터구조 빌드업/빌드업.html 대폭 진화
- 능동 회상 강화: 텍스트 답 직접 입력 → 내 답 vs 실제 답 2열 비교 (학습 노트의 "막혔던 지점" 4단 포맷 라이브 재현)
- 누적 시각 분리: 누적 조감도(위, 작음 PCB) + 메인 진화 무대(아래, 큼) — 두 영역 분리 → 시선 집중 + 누적감 동시 확보
- PCB 메인보드 미니맵: 어두운 녹색 PCB + LGA CPU 소켓(핀 격자) + DIMM 슬롯(잠금 클립) + PCB 트레이스 3가닥 + P3+ 빈 슬롯
- 학습 완료 시 부품 미니어처 등장: CPU 다이 안착, RAM 스틱(녹색 PCB + 검은 칩 5개 + 골드핑거) 삽입
- 글로우 키프레임(pcbGlow 1.8s) — 학습 완료 시점에만 1회 발동, 페이즈 점프 시 발동 X
- 페이즈 인디케이터 클릭 → 점프. P2 직접 시작 가능(CPU는 자동 completed로 미니맵에 박힘)

## [2026-04-27] output | 빌드업형 인포그래픽 N=1 프로토타입
- 신규: output/컴퓨터구조 빌드업.html
- 형태: 빈 캔버스에서 시작 → 학습 프레임워크 3질문에 답하면 시각이 한 단계씩 진화 → 페이즈 전환 질문 후 다음 부품 등장 → 마지막에 조감도가 빌드된 결과로 출현
- 범위: P1(CPU 진화) + 전환(CPU만의 한계) + P2(RAM 진화)까지. P3~ 확장은 형태 검증 후
- 핵심 장치: (1) "답 떠올렸다 → 보기" 버튼이 시각 변화를 게이트 (능동 회상 강제), (2) 답 공개 시 학습 노트의 "막혔던 지점"을 메타 노트로 동반 (자기 회고), (3) 페이즈 인디케이터로 P1 → P2 → P3+ 진행감
- 위키 소스: wiki/CPU.md, wiki/RAM.md, output/learning_CPU_2026-04-22.md, output/learning_RAM_2026-04-22.md
- 검증 포인트: 능동 회상 작동? 페이즈 전환 인과 자연스러움? 소유감 발생? → 사용자 피드백 후 P3~ 확장 또는 형태 수정 결정

## [2026-04-23] promote | 컴퓨터부품 요청 흐름 페이지 분리 (종합 페이지, prefix 생략)
- IO Device.md에 들어있던 "5대 부품 요청 흐름 조감도" 섹션을 wiki/컴퓨터부품 요청 흐름.md로 분리
- 판단 근거(Promote 패턴 확장): 기존은 "하위 개념 분리"만 있었음. 이번은 **여러 부품을 엮는 상위 종합 지도**라 IO Device 스코프에서 벗어남 → 종합 페이지(overview) 유형으로 승격
- 5대 부품 전 페이지(CPU·RAM·Storage·System Bus·IO Device)의 frontmatter `related:`에 역링크 추가. CPU·IO Device의 "관련 개념" 섹션에도 불릿 추가
- **파일명 prefix 정책 변경**: wiki/CLAUDE.md에 "제목으로 유형이 명확하면 prefix 생략 가능" 규칙 신설. `overview_` 강제 붙이지 않고 `컴퓨터부품 요청 흐름.md`로 명명 (한글 제목 자연스러움 우선)
- index.md의 컴퓨터부품 서브섹션 최상단에 종합 지도로 배치
