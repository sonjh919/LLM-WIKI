#컴퓨터구조

### CPU의 역할

CPU(Central Processing Unit)는 컴퓨터의 두뇌로, 프로그램의 명령어를 해석하고 실행하는 핵심 장치입니다.

### 주요 구성 요소

```mermaid
graph LR
    Control[제어장치] --> ALU[연산장치]
    ALU --> Register[레지스터]
    Register --> Control
```

### 동작 원리

**제어장치**: 메모리에서 명령어를 가져와(Fetch) 해석(Decode)하고, 다른 부품들에게 제어 신호를 보냅니다.

**ALU**: 산술 연산(덧셈, 뺄셈)과 논리 연산(AND, OR)을 수행합니다.

**레지스터**: CPU 내부의 초고속 임시 저장 공간으로, 연산에 필요한 데이터를 즉시 사용할 수 있게 합니다.