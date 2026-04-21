include "m328PBdef.inc"
.def number=r16
.org 0x0
rjmp reset
.org 0x2
rjmp isr0
reset:
ldi r24, LOW(RAMEND)
    out SPL, r24
ldi r24, HIGH(RAMEND)
    out SPH, r24
    ser r24
    out DDRB,r24 ; Init PORTB as output
    clr r24
    out DDRD,r24 ; Init PORTD as input
    ;Interrupt on rising edge of INT0 pin
ldi r24, (1<<ISC01) | (1<<ISC00)
    sts EICRA, r24
    ;Enable the INT0 interrupt
ldi r24, (1<<INT0)
    out EIMSK, r24
    sei ; Enable general flag of interrupts
    clr r24
    out PORTB, r24 ; Clear all pins of PORTB
    main0:
    rjmp main0 ; main0 loop code do nothing
    ;External interrupt 0 service routine
    isr0:
    push r23
    push r24
    push r25
    in r25, SREG
    push r25 ; save r23, r24, 25, SREG to stack
    ldi r23, 0xFF ; Set all pins of PORTB
    out PORTB, r23
    ;Delay 500 mS
    ldi r24, low(16*500) ; Init r25, r24 for delay 500 mS
    ldi r25, high(16*500) ; CPU frequency = 16 MHz
    delay1:
    ldi r23, 249 ; (1 cycle)
    delay2:
    dec r23 ; 1 cycle
    nop ; 1 cycle
    brne delay2 ; 1 or 2 cycles
    sbiw r24, 1 ; 2 cycles
    brne delay1 ; 1 or 2 cycles
    clr r23
    out PORTB, r23 ; Clear all pins of PORTB
ldi r24, (1 << INTF0)
    out EIFR, r24 ; Clear external interrupt 0 flag
    pop r25
    out SREG, r25
    pop r25
    pop r24
    pop r23 ; Retrieve r23, r24, 25, SREG from stack
    reti ; Return from interrupt