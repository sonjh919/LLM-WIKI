---
tags:
  - 개념
  - 컴퓨터구조
  - IO
created: 2026-04-23
sources:
  - "session: 2026-04-23 System Bus 복습"
related:
  - "[[System Bus]]"
  - "[[CPU]]"
  - "[[RAM]]"
  - "[[IO Device]]"
  - "[[JVM 메모리 구조]]"
---

## 왜 이 이름인가

**DMA = Direct Memory Access** (직접 메모리 접근). I/O 장치가 **RAM에 직접 접근**한다는 뜻. 여기서 "Direct"의 반대말은 "CPU를 거치는(Indirect)" — 즉 CPU를 중계자로 쓰지 않고 직접.

## 기존 문제

옛날 방식(**PIO, Programmed I/O**)에선 CPU가 데이터 파이프 역할을 했음:

```
NIC → CPU 레지스터 → RAM  (한 바이트씩)
NIC → CPU 레지스터 → RAM
NIC → CPU 레지스터 → RAM
...
```

1GB 파일이 들어오면 CPU가 **바이트 단위로 읽고 쓰기**를 반복. 문제:

- **단순 복사**인데 CPU 시간이 통째로 묶임
- 그동안 CPU는 연산 같은 "진짜 일"을 못 함
- CPU는 빠른데 IO 장치는 느리니 **CPU가 대부분 기다림**

"복사만 하는 CPU를 빼내서, 버스를 활용해 IO ↔ RAM이 직접 소통하게 하면?"

## 어떻게 해결하는가

**DMA 컨트롤러**라는 전용 하드웨어가 [[System Bus]]를 잠깐 빌려 IO 장치와 RAM 사이를 직접 연결.

```
기존:  NIC → CPU → RAM   (CPU가 중계자)
DMA:   NIC ↔ RAM         (CPU는 감독만, 실제 전송은 버스 직행)
```

### 흐름

1. CPU가 DMA 컨트롤러에 "NIC에서 RAM 0x1000 주소로 1MB 옮겨"라고 **명령**만 내림
2. DMA 컨트롤러가 버스를 써서 IO↔RAM 전송 수행
3. 전송 끝나면 **인터럽트**로 CPU에 "끝났어" 알림
4. 그동안 CPU는 다른 연산 수행

### 왜 가능한가 — 버스의 공유 특성

[[System Bus]]는 모든 부품이 공유하는 통로. 꼭 "CPU가 주도"해야 하는 게 아니라, **버스에 접근 권한(마스터 권한)** 을 잠깐 가진 장치가 쓸 수 있음. DMA 컨트롤러가 이 권한을 얻어 작동.

## 백엔드 개발에서의 활용

### zero-copy / sendfile()

파일을 네트워크로 전송할 때, 전통적 방식은 복사 4번:

```
디스크 → 커널 버퍼 → user 버퍼 → 커널 소켓 버퍼 → NIC
```

`sendfile()` 같은 시스템 콜은 **user 공간 경유를 건너뛰고** 커널 내부에서 DMA로 직결:

```
디스크 → 커널 버퍼 → NIC  (DMA 활용)
```

**Kafka, Nginx** 같은 고성능 서버가 이 방식으로 처리량을 끌어올림. 대용량 파일 전송 시 CPU 사용률과 RAM 복사 부담이 크게 감소.

### Java NIO / Netty

`FileChannel.transferTo()` 같은 API는 내부적으로 OS의 sendfile/DMA를 활용. [[JVM 메모리 구조]]의 Heap을 거치지 않는 **Direct Buffer** (`ByteBuffer.allocateDirect()`)도 DMA·zero-copy와 맞물려 설계됨 — 커널이 직접 접근 가능한 영역이라 복사 없이 IO 가능.

### 개발자 관점

DMA는 대부분 **OS와 라이브러리가 알아서** 활용. 백엔드 개발자가 직접 제어할 일은 드물지만:

- "왜 Netty가 빠른가", "왜 sendfile이 빠른가"의 **근거** 개념
- I/O 바운드 최적화를 이해하는 하드웨어 기반
- Direct Buffer 사용·튜닝 시 왜 Heap 외부를 쓰는지 설명

## 관련 개념

- [[System Bus]] — DMA는 버스의 공유·마스터 권한 구조가 있기에 가능
- [[CPU]] — I/O 바운드 상황에서 CPU를 복사 노동에서 해방
- [[JVM 메모리 구조]] — Direct Buffer가 Heap 밖에 있는 이유와 연결
