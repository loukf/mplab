.include "m16def.inc"

start:
    ; Initialize Stack Pointer
    ldi r16, high(RAMEND)
    out SPH, r16
    ldi r16, low(RAMEND)
    out SPL, r16

    ; Configure I/O: PORTB as input, PORTD as output
    ldi r16, 0x00
    out DDRB, r16
    ldi r16, 0xFF
    out DDRD, r16

main_loop:
    in r20, PINB          ; Read input from PINB
    clr r17               ; Counter for bit high-low transitions
    ldi r19, 0x7          ; Loop 7 times

count:
    mov r21, r20          ; Copy current state
    lsr r20               ; Shift right to align with adjacent
    eor r21, r20          ; XOR adjacent
    
    sbrc r21, 0           ; If LSB of XOR is 1, a transition occurred
    inc r17               ; Increment counter 

    dec r19
    brne count            ; Repeat

    clr r18               ; Clear output register
    tst r17               ; Check if any transitions were found
    breq display          ; If zero transitions, output nothing

format_output:
    sec                   ; Set Carry flag
    ror r18               ; Rotate Carry into r18 (fills with 1s from left)
    dec r17
    brne format_output

display:
    out PORTD, r18        ; Display result on PORTD LEDs
    rjmp main_loop        ; Repeat indefinitely
