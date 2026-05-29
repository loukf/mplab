/*
 * main.s
 *
 *  Created on: May 26, 2026
 *      Author: loukf
 */


.syntax unified
.thumb
.text
.global run_led_logic

@ Διευθύνσεις καταχωρητών
.equ GPIOA_ODR,     0x40020014  @ Output (LEDs)
.equ GPIOD_IDR,     0x40020C10  @ Input (Διακόπτες)

run_led_logic:
    @ Αρχική θέση: Το αναμμένο LED ξεκινάει από το LSB (Bit 0)
    MOV R4, #1                  @ Ο R4 κρατάει το τρέχον μοτίβο των LED (0x0001)

loop:
    @ 1. Ενημέρωσε αμέσως την έξοδο (GPIOA) με την τρέχουσα θέση
    LDR R2, =GPIOA_ODR
    STR R4, [R2]

wait_for_enable:
    @ 2. Διάβασε τους διακόπτες από το GPIOD
    LDR R0, =GPIOD_IDR
    LDR R1, [R0]

    @ 3. ΕΛΕΓΧΟΣ LSB (Bit 0): Αν είναι OFF (0), πάγωσε εδώ (μην πας στο delay, μην αλλάξεις bit)
    TST R1, #1
    BEQ wait_for_enable         @ Αν PD0 == 0, ξαναδιάβασε τις εισόδους χωρίς να κουνηθείς

    @ 4. Μικρό Delay για το Renode GUI (για να προλαβαίνεις να δεις την κίνηση)
    MOV R3, #60
delay_loop:
    SUBS R3, #1
    BNE delay_loop

    @ Ξαναδιάβασε το GPIOD μετά το delay για να δούμε αν άλλαξε κάτι ενδιάμεσα
    LDR R1, [R0]

    @ Ξανατσέκαρε το LSB μήπως έκλεισε κατά τη διάρκεια του delay
    TST R1, #1
    BEQ wait_for_enable

    @ 5. ΕΛΕΓΧΟΣ MSB (Bit 15): Κατεύθυνση κίνησης
    TST R1, #0x8000             @ Έλεγχος αν το MSB του GPIOD είναι 1
    BNE move_right              @ Αν PD15 == 1 -> Πήγαινε Δεξιά (MSB to LSB)

move_left:
    @ Κίνηση Αριστερά: LSB -> MSB (Όταν PD15 == 0)
    LSLS R4, R4, #1             @ Ολίσθηση αριστερά κατά 1 bit
    TST R4, #0x00010000         @ Ελέγχουμε αν ξεπεράσαμε το 15ο bit (Bit 16 == 1)
    BEQ loop                    @ Αν όχι, επιστροφή στο loop
    MOV R4, #1                  @ Αν ναι, γύρνα κυκλικά στο Bit 0 (LSB)
    B loop

move_right:
    @ Κίνηση Δεξιά: MSB -> LSB (Όταν PD15 == 1)
    LSRS R4, R4, #1             @ Ολίσθηση δεξιά κατά 1 bit
    CMP R4, #0                  @ Ελέγχουμε αν μηδενίστηκε (βγήκε κάτω από το Bit 0)
    BNE loop                    @ Αν όχι, επιστροφή στο loop
    LDR R4, =0x8000             @ Αν ναι, γύρνα κυκλικά στο Bit 15 (MSB)
    B loop
