.include "m328PBdef.inc"

.def TEMP = r16
.def A    = r17
.def B    = r18
.def C    = r19
.def D    = r20
.def F0   = r21
.def F1   = r22

start:
    clr TEMP
    out DDRB, TEMP      ; PORTB as input
    ser TEMP
    out PORTB, TEMP     ; enable pull-ups
    ldi TEMP, 0xFF
    out DDRC, TEMP      ; PORTC as output

loop:
    in TEMP, PINB       ; read PORTB inputs
    mov A, TEMP
    lsr TEMP
    mov B, TEMP
    lsr TEMP
    mov C, TEMP
    lsr TEMP
    mov D, TEMP

    ; F0 = A'.B' + B.D' = ((A+B).(B'+D))'
    mov F1, A
    or A, B
    mov F0, A
    mov TEMP, B
    com TEMP
    or TEMP, D
    and F0, TEMP
    com F0
    andi F0, 1

    ; F1 = (A' + D).(B' + C)
    mov A, F1
    com A
    com B
    or A, D
    or B, C
    and A, B
    mov F1, A
    andi F1, 1

    ; Output: PC0 = F0, PC1 = F1
    mov TEMP, F1
    lsl TEMP
    or TEMP, F0
    out PORTC, TEMP

    rjmp loop
