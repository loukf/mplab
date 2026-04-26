#include <avr/io.h>

int main(void) {
    DDRA = 0x00;
    DDRC = 0xFF;

    unsigned char input, tens, ones;

    while (1) {
        input = PINA;

        if (input >= 100) {
            PORTC = 0xFF;
        }
        else {
            tens = input / 10; 
            ones = input % 10;
            PORTC = (tens << 4) | ones;
        }
    }
    
    return 0;
}
