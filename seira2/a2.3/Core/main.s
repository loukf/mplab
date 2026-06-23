/*
 * main.s
 *
 *  Created on: May 26, 2026
 *      Author: loukf
 */


.syntax unified
.thumb

.section .data
    .equ START_ADDR, 0x20000900

.section .text
.global reset

reset:
    // --- (a) Store 255-0 descending in words (4 bytes each) ---
    ldr r0, =START_ADDR     // Base address
    mov r1, #255            // Current value
    mov r2, #0              // End value
loop_a:
    str r1, [r0], #4        // Store r1 at address, increment pointer by 4
    subs r1, r1, #1         // r1--
    cmp r1, #-1             // Stop when r1 < 0
    bne loop_a

    // --- (b) Count total zeros in 256 words ---
    ldr r0, =START_ADDR
    mov r1, #0              // Total zero counter
    mov r2, #0              // Loop index
loop_b:
    ldr r3, [r0, r2, lsl #2] // Load word at base + (index * 4)
    mov r4, #32             // 32 bits per word
bit_loop_b:
    lsrs r3, r3, #1         // Shift right into Carry
    bcs skip_zero_b         // If C=1, it was a 1
    adds r1, r1, #1         // If C=0, increment zero counter
skip_zero_b:
    subs r4, r4, #1
    bne bit_loop_b
    adds r2, r2, #1
    cmp r2, #256
    bne loop_b

    // Output result to GPIOD (Assuming ODR register at 0x40020C14)
    ldr r5, =0x40020C14
    str r1, [r5]

    // --- (c) Count numbers between 0x10 and 0x80 ---
    mov r1, #0              // Result counter
    mov r2, #0              // Loop index
loop_c:
    ldr r3, [r0, r2, lsl #2] // Load word
    cmp r3, #0x10
    blt skip_inc_c
    cmp r3, #0x80
    bgt skip_inc_c
    adds r1, r1, #1
skip_inc_c:
    adds r2, r2, #1
    cmp r2, #256
    bne loop_c

    str r1, [r5]            // Update GPIOD with new result

end:
    b end
