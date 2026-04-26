.include "m16def.inc"

start:
    ldi r16, high(RAMEND)
    out SPH, r16
    ldi r16, low(RAMEND)
    out SPL, r16

; ==== ASKISI 1a ====
    ldi XL, low(0x0200)
    ldi XH, high(0x0200)
    ldi r20, 0xFF

loop_a:
    st X+, r20
    subi r20, 1
    brcc loop_a

; ==== ASKISI 1b ====
    ldi XL, low(0x0200)
    ldi XH, high(0x0200)
    clr r14
    clr r15
    ldi r20, 0xFF

loop_b:
    ld r18, X+           
    ldi r19, 0x8
check_bits:
    lsr r18
    brcs skip_inc_b
    
    inc r14
    brne skip_inc_b
    inc r15
    
skip_inc_b:
    subi r19, 1
    brne check_bits
    
    subi r20, 1
    brcc loop_b

; ==== ASKISI 1c ====
    ldi XL, low(0x0200)
    ldi XH, high(0x0200)
    clr r16
    ldi r20, 0xFF

loop_c:
    ld r18, X+
    
    cpi r18, 0x10
    brlo skip_inc_c

    cpi r18, 0x81
    brsh skip_inc_c

    inc r16

skip_inc_c:
    subi r20, 1
    brcc loop_c

end:
    rjmp end