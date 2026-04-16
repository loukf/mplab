.include "m16def.inc"

start:
    ldi r16, high(RAMEND)
    out SPH, r16
    ldi r16, low(RAMEND)
    out SPL, r16
    ldi XL, low(0x0200)
    ldi XH, high(0x0200)

    ldi r16, 255

loop:
    st X+, r16
    subi r16, 1
    brcc loop

end:
    rjmp end