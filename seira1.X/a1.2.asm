.include "m16def.inc"

start:
    ldi r16, high(RAMEND)
    out SPH, r16
    ldi r16, low(RAMEND)
    out SPL, r16

    ldi r16, 0x00
    out DDRB, r16
    ldi r16, 0xFF
    out DDRD, r16

main_loop:
    in r20, PINB
    clr r17
    ldi r19, 0x7

count:
    mov r21, r20
    lsr r20
    eor r21, r20
    
    sbrc r21, 0
    inc r17 

    dec r19
    brne count

    clr r18
    tst r17
    breq display

format_output:
    sec
    ror r18
    dec r17
    brne format_output

display:
    out PORTD, r18
    rjmp main_loop