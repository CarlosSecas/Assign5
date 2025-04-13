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
;  File name: ftoa.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -o ftoa.o ftoa.asm
;  Assemble (debug): nasm -f elf64 -o ftoa.o ftoa.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: extern ftoa();
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


;declarations

global ftoa
extern itoa
extern strlen

segment .data
multiplier dq 10000000.0     ; 7 digits

segment .bss

segment .text

ftoa:

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


    ; Save original float
    movapd xmm6, xmm0

    ; === Integer part ===
    cvttsd2si rax, xmm0         ; rax = int(xmm0)
    mov rsi, rdi                ; rsi = output buffer
    call itoa                   ; write integer

    ; Move rdi to end of integer string
    mov rdi, rsi
    call strlen
    add rdi, rax

    ; Add dot
    mov byte [rdi], '.'
    inc rdi

    ; === Fractional part ===
    cvtsi2sd xmm1, rax
    movapd xmm0, xmm6
    subsd xmm0, xmm1            ; xmm0 = fraction

    ; Multiply by 10^7
    movsd xmm1, [multiplier]
    mulsd xmm0, xmm1

    roundsd xmm0, xmm0, 0
    cvttsd2si rax, xmm0         ; rax = int(fraction * 10^7)

    ; Convert fraction to string
    mov rsi, rdi
    call itoa

    ; Null terminate
    call strlen
    add rdi, rax
    mov byte [rdi], 0

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