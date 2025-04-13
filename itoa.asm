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
;  File name: itoa.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -o itoa.o itoa.asm
;  Assemble (debug): nasm -f elf64 -o itoa.o itoa.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: extern itoa();
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


;declarations

global itoa

segment .data

segment .bss
temp_char resb 1

segment .text
itoa:

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


    mov rcx, 0              ; digit counter
    mov rbx, 10             ; divisor

    cmp rax, 0
    jne itoa_convert
    mov byte [rsi], '0'
    mov byte [rsi + 1], 0
    jmp itoa_done

itoa_convert:
itoa_loop:
    xor rdx, rdx
    div rbx                 ; rax / 10 → quotient in rax, remainder in rdx

    add rdx, 48             ; convert digit to ASCII (rdx = ASCII char)
    mov r8, rdx             ; move to r8 (64-bit only)
    mov [temp_char], r8     ; store full r8 (only lowest byte matters)
    push qword [temp_char]  ; push 8 bytes (only low byte meaningful)

    inc rcx
    cmp rax, 0
    jne itoa_loop

itoa_write:
    pop r8
    mov [temp_char], r8     ; write popped value back to temp buffer
    mov r10, rsi            ; backup rsi
    lea r9, [temp_char]
    mov r8, [r9]            ; load full 64-bit (only low byte is char)
    mov rsi, r10            ; restore rsi
    mov [rsi], r8           ; store 1 byte (NASM accepts this form)
    inc rsi
    loop itoa_write

    mov byte [rsi], 0       ; null terminator

itoa_done:

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