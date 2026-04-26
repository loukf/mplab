.include "m16def.inc"

.def temp  = r16
.def input = r17
.def res   = r18
.def t1    = r19
.def t2    = r20

ldi temp, low(RAMEND)
out SPL, temp
ldi temp, high(RAMEND)
out SPH, temp

clr temp
out DDRA, temp
ser temp
out DDRB, temp

main_loop:
    in input, PINA ; INPUT IS A
    clr res

    ; COMPUTE (A0 OR A4), (A1 OR A5), (A2 OR A6), (A3 OR A7)
    mov t1, input
    swap t1
    or t1, input
    mov t2, t1

    ; --- X0 = (A0 OR A4) ---
    andi t1, 0x01
    or res, t1

    ; --- X1 = (A1 OR A5) AND (A0 OR A4) ---
    andi t2, 0x02
    lsl t1
    and t2, t1
    or res, t2

    ; COMPUTE (A0 AND A4), (A1 AND A5), (A2 AND A6), (A3 AND A7)
    mov t1, input
    swap t1
    and t1, input
    mov t2, t1

    ; --- X2 = (A2 AND A6) ---
    andi t1, 0x04
    or res, t1

    ; --- X3 = (A3 AND A7) XOR (A2 AND A7) ---
    andi t2, 0x08
    lsl t1
    eor t2, t1
    or res, t2
    
    out PORTB, res   ; SHOW OUTPUT IN B
    rjmp main_loop