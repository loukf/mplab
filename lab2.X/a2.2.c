#define F_CPU 16000000UL
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

int counter = 0;
int interruption = 0;

ISR(INT0_vect) {
    counter = 0;
    EIFR = (1<<INTF0);
    if(interruption) {
        PORTB = 0x0E;
        _delay_ms(1000);
    }
    interruption = 1;
    PORTB = 0x04;
}


int main(void) {    
    EICRA = (1<<ISC01) | (1<<ISC00);
    EIMSK = (1<<INT0);
    sei();
    DDRB = 0xFF;
    DDRD = 0x00;
    while (1) {
        while(counter < 4000) {
            _delay_ms(1);
            counter++;
        }
        interruption = 0;
        PORTB = 0x00;
    }
}
