#include <avr/io.h>

int main(void) {
    // Configure I/O: PORTA as input, PORTC as output
    DDRA = 0x00;
    DDRC = 0xFF;

    unsigned char input, tens, ones;

    while (1) {
        input = PINA; // Read 8-bit binary value

        if (input >= 100) {
            PORTC = 0xFF; // Light up all LEDs on error
        }
        else {
            tens = input / 10;  // Get the tens digit
            ones = input % 10;  // Get the remainder (ones digit)
            
            // Format: [Tens High bits | Ones Low bits]
            PORTC = (tens << 4) | ones;
        }
    }
    
    return 0;
}
