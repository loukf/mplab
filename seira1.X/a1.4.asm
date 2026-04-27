.include "m16def.inc"

.def temp  = r16
.def input = r17
.def tens  = r18
.def ones = r19

; Initialize stack pointer
ldi temp, low(RAMEND)
out SPL, temp
ldi temp, high(RAMEND)
out SPH, temp

; Configure I/O: PORTA as input, PORTC as output
clr temp
out DDRA, temp
ser temp
out DDRC, temp

main_loop:
    in input, PINA   ; Read binary value from PORTA
    
    ; Check if input >= 100 (0x64)
    cpi input, 0x64
    brsh error       ; If 100 or greater, go to error

    clr tens         ; Reset tens counter
    mov ones, input  ; Copy input to ones

div_loop:
    ; Integer division by 10 using repeated subtraction
    cpi ones, 0xA    ; Compare remaining value with 10
    brlo end         ; If less than 10, division is finished
    subi ones, 0xA   ; Subtract 10
    inc tens         ; Increment tens
    rjmp div_loop

end:
    ; Combine tens and ones
    swap tens        ; Move tens to the upper 4 bits
    or tens, ones    ; Merge ones into the lower 4 bits
    out PORTC, tens  ; Display result on PORTC
    rjmp main_loop

error:
    ser temp         ; Set temp to 0xFF
    out PORTC, temp  ; Output means input was >= 100
    rjmp main_loop
