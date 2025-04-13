;****************************************************************************************************************************
;Program name: "An Assembly-Based Circuit Diagnostics Calculator".  ;This program collects a user's name, career path, and resistance values for three sub-circuits,
;then calculates and displays the total resistance and current in the circuit.
; Copyright (C) 2025  Carlos Secas .          *
;                                                                                                                           *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
;but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
;the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
;<https://www.gnu.org/licenses/>.                                                                                           *
;****************************************************************************************************************************




;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;Author information
;  Author name: Carlos Secas
;  Author email: carlosJsecas@csu.fullerton.edu
;  CWID: 886088269
;  Class: 240-09 Section 09
;
;Program information
;  Program name: An Assembly-Based Circuit Diagnostics Calculator
;  Programming languages: nine in x86, and one in bash
;  Date program began: 2025-Apr-7
;  Date of last update: 2025-Apr-12
;  Files in this program: edison.asm, faraday.asm, tesla.asm, strlen.asm, itoa.asm, fputs.asm, fgets.asm, atof.asm, ftoa.asm, acdc.inc, r.sh.
;  Testing: Alpha testing completed.  All functions are correct.
;  Status: Ready for release to customers
;
;Purpose
;This program collects a user's name, career path, and resistance values for three sub-circuits,
;then calculates and displays the total resistance and current in the circuit.
;
;Devlopment
;  This assembly code was developed using NASM in a Linux-based enviorment within Github Codespaces,
;  accessed remotely from a Windows 10 system.  
;
;This file:
;  File name: tesla.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -o tesla.o tesla.asm
;  Assemble (debug): nasm -f elf64 -o tesla.o tesla.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: extern double compute_resist();
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

;declarations

global compute_resist


segment .data
one dq 1.0
one_ptr dq one

segment .bss

segment .text


compute_resist:

    ;backup GPRs
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    pushf


    ; rdi = pointer to resistance array [R1, R2, R3]

    ; Load R1 into xmm0
    movsd xmm0, [rdi]           ; xmm0 = R1
    movsd xmm1, [rdi + 8]       ; xmm1 = R2
    movsd xmm2, [rdi + 16]      ; xmm2 = R3

    ; Compute 1/R1 → xmm0 = 1.0 / xmm0
    mov rax, one_ptr
    movsd xmm3, [rax]
    divsd xmm3, xmm0            ; xmm3 = 1/R1

    ; Compute 1/R2 → xmm1 = 1.0 / xmm1
    mov rax, one_ptr
    movsd xmm4, [rax]
    divsd xmm4, xmm1            ; xmm4 = 1/R2

    ; Compute 1/R3 → xmm2 = 1.0 / xmm2
    mov rax, one_ptr
    movsd xmm5, [rax]
    divsd xmm5, xmm2            ; xmm5 = 1/R3

    ; Add them up: xmm3 + xmm4 + xmm5
    addsd xmm3, xmm4
    addsd xmm3, xmm5            ; xmm3 = (1/R1 + 1/R2 + 1/R3)

    ; Compute total resistance: 1 / (sum)
    mov rax, one_ptr
    movsd xmm0, [rax]           ; xmm0 = 1.0
    divsd xmm0, xmm3            ; xmm0 = R_total

    ;Restore the GPRs
    popf
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    pop rbp   ;Restore rbp to the base of the activation record of the caller program
    ret