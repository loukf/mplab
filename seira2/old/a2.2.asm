/*
 * a2.1.asm
 *
 *  Created on: May 26, 2026
 *      Author: loukf
 */


.syntax unified
.thumb
.text
.global run_led_logic

@ Διευθύνσεις καταχωρητών για την ανάγνωση/εγγραφή των Pins
.equ GPIOA_ODR,     0x40020014  @ Output Data Register για τα LED (PA)
.equ GPIOD_IDR,     0x40020C10  @ Input Data Register για τους διακόπτες (PD)

run_led_logic:
    @ Αρχική θέση του αναμμένου LED: Το LSB (Bit 0)
    MOV R4, #1                  @ Ο R4 κρατάει το μοτίβο των LED (0x0001)

loop:
    @ 1. Ανάγνωση της κατάστασης των εισόδων από το GPIOD
    LDR R0, =GPIOD_IDR
    LDR R1, [R0]                @ Φόρτωση των pins του GPIOD στον R1

    @ 2. Έλεγχος του LSB (Bit 0) του GPIOD -> Αν είναι OFF (0), το LED παγώνει
    TST R1, #1                  @ Έλεγχος αν το LSB είναι 1 (ON)
    BEQ loop                    @ Αν είναι 0 (OFF), κάνε loop χωρίς να αλλάξεις θέση ή ODR

    @ 3. Ενημέρωση των LED στην έξοδο (GPIOA)
    LDR R2, =GPIOA_ODR
    STR R4, [R2]                @ Άναμμα του LED στο αντίστοιχο bit του PA

    @ 4. Χρονική καθυστέρηση (Delay) για να είναι ορατή η κίνηση στο Renode GUI
    LDR R3, =500000
delay_loop:
    SUBS R3, #1
    BNE delay_loop

    @ 5. Έλεγχος κατεύθυνσης βάσει του MSB (Bit 15) του GPIOD
    TST R1, #0x8000             @ Έλεγχος αν το MSB (Bit 15) είναι 1 (ON)
    BNE move_right              @ Αν είναι 1 (ON), άλλαξε φορά προς τα δεξιά

move_left:
    @ Κυκλική κίνηση αριστερά στο GPIOA (Bit 0 -> Bit 15)
    LSLS R4, R4, #1             @ Ολίσθηση αριστερά κατά 1 θέση
    TST R4, #0x00010000         @ Έλεγχος αν ξεπεράσαμε το 16ο bit (overflow από τα 16 LED)
    BEQ loop                    @ Αν όχι, συνέχισε
    MOV R4, #1                  @ Αν ναι, επανέφερε στο LSB (Bit 0) κυκλικά
    B loop

move_right:
    @ Κυκλική κίνηση δεξιά στο GPIOA (Bit 15 -> Bit 0)
    LSRS R4, R4, #1             @ Ολίσθηση δεξιά κατά 1 θέση
    CMP R4, #0
