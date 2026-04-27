.include "m16def.inc"

.def temp  = r16
.def input = r17
.def res   = r18
.def t1    = r19
.def t2    = r20

; Initialize stack pointer
ldi temp, low(RAMEND)
out SPL, temp
ldi temp, high(RAMEND)
out SPH, temp

; Configure I/O: PORTA as input, PORTB as output
clr temp
out DDRA, temp
ser temp
out DDRB, temp

main_loop:
    in input, PINA   ; Read PORTA pins
    clr res          ; Clear result register

    ; --- Parallel OR: (A0|A4, A1|A5, A2|A6, A3|A7) ---
    mov t1, input
    swap t1          ; Swap high/low results
    or t1, input     ; Combine results using OR
    mov t2, t1

    ; X0 = (A0 OR A4)
    andi t1, 0x01
    or res, t1

    ; X1: = (A1 OR A5) AND (A0 OR A4)
    andi t2, 0x02
    lsl t1           ; Shift X0 to align with bit 1
    and t2, t1       ; Perform AND
    or res, t2

    ; --- Parallel AND: (A0&A4, A1&A5, A2&A6, A3&A7) ---
    mov t1, input
    swap t1          ; Swap high/low results again
    and t1, input    ; Combine results using AND
    mov t2, t1

    ; Logic for X2: Result bit 2 = (A2 AND A6)
    andi t1, 0x04
    or res, t1

    ; Logic for X3: Result bit 3 = (A3 AND A7) XOR (A2 AND A6)
    andi t2, 0x08
    lsl t1           ; Shift X2 to align with bit 3
    eor t2, t1       ; Perform XOR
    or res, t2
    
    out PORTB, res   ; Output final 4-bit result to PORTB
    rjmp main_loop   ; Repeat indefinitely
