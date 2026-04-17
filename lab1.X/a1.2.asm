.include "m328PBdef.inc"

.DEF wagon = r18            ; Wagon state (bit shifting)
.DEF temp = r19             ; Temporary variable
.DEF leds = r20             ; LED control variable
.DEF i = r21                ; inner loop counter
.DEF j = r22                ; middle loop counter
.DEF k = r23                ; outer loop counter

reset:
    ldi temp, LOW(RAMEND)
    out SPL, temp
    ldi temp, HIGH(RAMEND)
    out SPH, temp

    ser temp
    out DDRD, temp          ; PORTD as output

    ldi wagon, 0x01         ; Set wagon to LSB
    ldi leds, 6             ; Set LED counter to 6

LSB:
    rcall loop_ON
    rcall delay
    rcall delay
    rcall delay
    rcall loop_OFF
    lsl wagon

move_left:
    rcall loop_ON
    rcall delay
    rcall delay
    rcall loop_OFF
    lsl wagon
    dec leds
    brne move_left

MSB:
    rcall loop_ON
    rcall delay
    rcall delay
    rcall delay
    rcall loop_OFF
    lsr wagon
    ldi leds, 6

move_right:
    rcall loop_ON           ; Turn on LED
    rcall delay
    rcall delay
    rcall loop_OFF
    lsr wagon
    dec leds
    brne move_right         ; Loop until all LEDs have been shifted
    rjmp reset              ; Return to LSB

; ********* LOOP CONTROL *********
loop_ON:
    ser temp
    and temp, wagon
    out PORTD, temp         ; Output to PORTD
    ret

loop_OFF:
    clr temp
    out PORTD, temp         ; Clear PORTD
    ret

delay:                      ; Delay 0.5 seconds
    ldi k, 30
outer:
    ldi j, 255
middle:
    ldi i, 255
inner:
    nop
    dec i
    brne inner
    dec j
    brne middle
    dec k
    brne outer
    ret
