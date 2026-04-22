---
description: 위키 작업 이력. 시간순 append-only.
updated: 2026-04-22
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
