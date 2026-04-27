.include "m16def.inc"

start:
    ; Initialize Stack Pointer
    ldi r16, high(RAMEND)
    out SPH, r16
    ldi r16, low(RAMEND)
    out SPL, r16

; ==== ASKISI 1a ====
    ldi XL, low(0x0200)   ; Set X pointer to 0x0200
    ldi XH, high(0x0200)
    ldi r20, 0xFF         ; Start value (255)

loop_a:
    st X+, r20            ; Store value and post-increment pointer
    subi r20, 1           ; Decrement value
    brcc loop_a           ; Continue until r20 rolls over (Carry Clear)

; ==== ASKISI 1b: ====
    ldi XL, low(0x0200)   ; Reset X pointer
    ldi XH, high(0x0200)
    clr r14               ; Clear 16-bit counter (r15:r14)
    clr r15
    ldi r20, 0xFF         ; Loop counter for 256 bytes

loop_b:
    ld r18, X+            ; Load byte from memory
    ldi r19, 0x8          ; Bit counter (8 bits per byte)
check_bits:
    lsr r18               ; Shift right (bit moves to Carry)
    brcs skip_inc_b       ; If Carry set (bit was 1), skip increment
    
    inc r14               ; Increment low byte of '0' counter
    brne skip_inc_b
    inc r15               ; Increment high byte on overflow
    
skip_inc_b:
    subi r19, 1           ; Next bit
    brne check_bits
    
    subi r20, 1           ; Next byte
    brcc loop_b

; ==== ASKISI 1c: ====
    ldi XL, low(0x0200)   ; Reset X pointer
    ldi XH, high(0x0200)
    clr r16               ; Clear result counter
    ldi r20, 0xFF         ; Loop counter

loop_c:
    ld r18, X+            ; Load byte
    
    cpi r18, 0x10         ; Check if value < 0x10
    brlo skip_inc_c

    cpi r18, 0x81         ; Check if value >= 0x81
    brsh skip_inc_c

    inc r16               ; Increment if 0x10 <= value <= 0x80

skip_inc_c:
    subi r20, 1           ; Next byte
    brcc loop_c

end:
    rjmp end              ; Infinite loop
