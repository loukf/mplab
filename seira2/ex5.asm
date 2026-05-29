; find CPSR, SP, PC
; PC = 0x00008000
; SP = 0x00010000
; r0 = 0x00000000
; r1 = 0x00000000
; r2 = 0x00000000
; r3 = 0x00000000
; r4 = 0x00000000
; r5 = 0x00000000
; r9 = 0x00000000
; CPSR = 0x00000013

.syntax unified
.arch armv7-a
.text
.global _start
.arm ; Entering aarch32 mode

_start:
    MOV r0, #0x80000000
    ADDS r1, r0, r0

CHK1:
    STMDB sp!, {r0, r1}

CHK2:
    MOV r2, #0
    CMP r2, #1

    BLT to_thumb
    MOV r9, #9

to_thumb:
    ADR r3, thumb_part + 1
    BX r3

    .thumb ; Entering Thumb2 mode
    .thumb_func
thumb_part:
CHK3:
    CMP r2, #0
    POP {r4, r5}
    ADR r3, arm_back
    BX r3

    .align 2
    .arm ; Entering aarch32 mode
arm_back:
CHK4:
    B CHK4
