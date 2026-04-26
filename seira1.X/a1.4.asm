.include "m16def.inc"

.def temp  = r16
.def input = r17
.def tens  = r18
.def ones = r19

ldi temp, low(RAMEND)
out SPL, temp
ldi temp, high(RAMEND)
out SPH, temp

clr temp
out DDRA, temp
ser temp
out DDRC, temp

main_loop:
    in input, PINA
    
    cpi input, 0x64
    brsh error

    clr tens
    mov ones, input

div_loop:
    cpi ones, 0xA
    brlo end
    subi ones, 0xA
    inc tens
    rjmp div_loop

end:
    ; BCD form (Tens: MSB, Ones: LSB)
    swap tens
    or tens, ones
    out PORTC, tens
    rjmp main_loop

error:
    ser temp         ; temp = 0xFF (1111 1111)
    out PORTC, temp
    rjmp main_loop