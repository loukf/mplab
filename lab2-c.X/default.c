#define F_CPU 16000000UL
#include<avr/io.h>
#include<avr/interrupt.h>
#include<util/delay.h>
ISR(INT0_vect) // External INT0 ISR
{
    PORTC=0XFF; // Turn on all LEDs of PORTC
    _delay_ms(2000); // for 2000ms
    PORTC=0x00;
    EIFR = (1 << INTF0); // Clear the flag of interrupt INTF0
}

ISR(INT1_vect) // External INT1 ISR
{
    PORTC=0XFF; // Turn on all LEDs of PORTC
    _delay_ms(3000); // for 3000ms
    PORTC=0x00;
    EIFR = (1 << INTF1); // Clear the flag of interrupt INTF1
}

int main(){
    // Interrupt on rising edge of INT0 and INT1 pin
    EICRA=(1<<ISC11) | (1<<ISC10) | (1<<ISC01) | (1<<ISC00);
    // Enable the INT0 interrupt (PD2), INT1 interrupt (PD3))
    EIMSK=(1<<INT0) | (1<<INT1);
    sei(); // Enable global interrupts
    DDRB=0xFF; // Set PORTB as output
    DDRC=0xFF; // Set PORTC as output
    PORTC=0x00; // Turn off all LEDs of PORTC
    while(1)
    {
        PORTB=0x00; // Turn off all LEDs of PORTC
        _delay_ms(500); // Delay 500 mS
        PORTB=0xFF; // Turn on all LEDs of PORTC
        _delay_ms(500); // Delay 500 mS
    }
}
