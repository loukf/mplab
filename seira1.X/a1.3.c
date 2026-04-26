#include <avr/io.h>

int main(void) {
    DDRA = 0x00;
    DDRB = 0xFF;

    unsigned char input, a, b, x;

    while (1) {
        input = PINA;
        a = input & 0x0F;
        b = (input >> 4) & 0x0F;

        x = 0;
        
        // X0 = (A0 OR A4)
        if ((a & 0x01) | (b & 0x01)) x |= (1 << 0);
        
        // X1 = (A1 OR A5) AND (A0 OR A4)
        if (((a & 0x02) | (b & 0x02)) && ((a & 0x01) | (b & 0x01))) x |= (1 << 1);

        // X2 = (A2 AND A6)
        if ((a & 0x04) & (b & 0x04)) x |= (1 << 2);

        // X3 = (A3 AND A7) XOR (A2 AND A6)
        if (((a & 0x08) & (b & 0x08)) ^ ((a & 0x04) & (b & 0x04))) x |= (1 << 3);

        PORTB = x;
    }
}