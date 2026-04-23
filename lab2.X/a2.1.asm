.include "m328PBdef.inc"
.def number = r16

.org 0x0
rjmp reset

.org 0x4
rjmp isr1

reset:
    ldi r24, LOW(RAMEND)
    out SPL, r24
    ldi r24, HIGH(RAMEND)
    out SPH, r24

    ser r24
    out DDRC, r24        ; Init PORTC as output
    clr r24
    out DDRD, r24        ; Init PORTD as input

    ; Interrupt on rising edge of INT1 pin
    ldi r24, (1<<ISC11) | (1<<ISC10)
    sts EICRA, r24
    
    ; Enable the INT1 interrupt
    ldi r24, (1<<INT1)
    out EIMSK, r24

    clr number           ; Initialize counter to 0
    sei

    clr r24
    out PORTC, r24       ; Clear PORTC

    main0:
    mov r24, number
    lsl r24
    andi r24, 0x1E
    out PORTC, r24
    rjmp main0

isr1:
    push r25             ; Save SREG and working registers
    in r25, SREG
    push r25
    push r24
    push r23

    sbis PIND, 0
    rjmp exit_isr        ; Skip delay if PD0 is 0

    inc number
    andi number, 0x0F

    ldi r23, 0xFF 
    out PORTC, r23

    ldi r24, low(16*600) 
    ldi r25, high(16*600) 

delay1:
    ldi r23, 249 
delay2:
    dec r23 
    nop 
    brne delay2 
    sbiw r24, 1 
    brne delay1 

    clr r23
    out PORTC, r23       ; Clear PORTC after delay

exit_isr:
    ldi r24, (1 << INTF1)
    out EIFR, r24 

    pop r23 
    pop r24
    pop r25
    out SREG, r25
    pop r25

    reti
