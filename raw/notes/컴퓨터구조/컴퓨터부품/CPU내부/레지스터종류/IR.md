#컴퓨터구조

### IR이란

IR(Instruction Register)은 현재 실행 중인 명령어를 저장하는 레지스터입니다. [[Fetch]] 단계에서 메모리로부터 가져온 명령어를 임시 보관합니다.

### 동작 과정

[[PC]]가 가리키는 주소에서 명령어를 읽어오면 IR에 저장됩니다. [[Decode]] 단계에서 [[제어장치]]가 IR의 내용을 해석하여 어떤 연산을 수행할지 결정합니다.

### IR의 구조

IR은 보통 명령어 코드(Opcode)와 피연산자(Operand)로 구성됩니다. 예를 들어 "ADD R1, R2" 명령어라면 ADD가 opcode, R1과 R2가 operand입니다.

```mermaid
flowchart LR
    MEM[메모리] -->|Fetch| IR[IR]
    IR -->|Decode| CU[제어장치]
    CU --> EX[Execute]
    
    style IR fill:#ffe6cc
```

### 백엔드 개발과의 연관성

JVM이 바이트코드를 실행할 때도 현재 실행 중인 명령어를 내부 레지스터에 저장합니다. invoke, aload 같은 바이트코드 명령어가 IR에 해당합니다.
