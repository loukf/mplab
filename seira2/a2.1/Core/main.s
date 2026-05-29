/*
 * main.s
 *
 *  Created on: May 26, 2026
 *      Author: loukf
 */


.syntax unified
.thumb

.global main

main:
    MOVS R0, #10
    MOVS R1, #3
    LSLS R2, R0, #2
    ADDS R2, R2, R1
    MOVS R1, #5
    SUBS R2, R2, R1
    LDR  R3, =0x20001000
    STR  R2, [R3, #0]
loop:
    B    loop
