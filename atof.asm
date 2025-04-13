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
;  File name: atof.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -o atof.o atof.asm
;  Assemble (debug): nasm -f elf64 -o atof.o atof.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: extern atof();
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**




; declarations
global atof

section .data
    neg_mask dq 0x8000000000000000   ; Mask to flip the sign bit for negative numbers

section .bss
    align 64
    storedata resb 832               ; Buffer to store the FPU state using xsave/xrstor

section .text
atof:
    ; === Save all general-purpose and SIMD registers ===
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    rcx
    push    rdx
    push    rsi
    push    rdi
    push    r8 
    push    r9 
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14
    push    r15
    pushf

    ; Save x87/FPU state
    mov     rax, 7
    mov     rdx, 0
    xsave   [storedata]    

    ; === rdi points to the null-terminated ASCII float string ===
    mov     r15, rdi                ; Copy input string pointer to r15

    ; === Find the position of the decimal point ('.') ===
    xor     r14, r14                ; r14 will store index of the radix point
find_radix_loop:
    cmp     byte[r15 + r14], '.'
    je      found_radix_point
    inc     r14
    jmp     find_radix_loop

found_radix_point:
    ; === Set up integer part parsing ===
    xor     r13, r13                ; r13 = accumulated integer value
    mov     r12, 1                  ; r12 = digit multiplier (1, 10, 100, ...)
    mov     r11, r14                ; r11 = index before radix
    dec     r11
    xor     r10, r10                ; r10 = 1 if negative, 0 if positive

parse_integer:
    mov     al, byte[r15 + r11]
    cmp     al, '+'
    je      finish_parse_integer
    cmp     al, '-'
    je      parse_integer_negative

    ; === Convert digit and accumulate total ===
    sub     al, '0'                 ; Convert ASCII to integer (0-9)
    imul    rax, r12
    add     r13, rax
    imul    r12, 10                 ; Update multiplier
    dec     r11
    cmp     r11, 0
    jge     parse_integer
    jmp     finish_parse_integer

parse_integer_negative:
    mov     r10, 1                  ; Set flag for negative number

finish_parse_integer:
    ; === Parse the decimal part after the '.' ===
    mov     rax, 10
    cvtsi2sd xmm11, rax            ; xmm11 = 10.0
    xorpd   xmm13, xmm13           ; xmm13 = decimal total
    movsd   xmm12, xmm11           ; xmm12 = divisor (10, 100, 1000, ...)
    inc     r14                    ; Move past '.'

parse_decimal:
    mov     al, byte [r15 + r14]
    sub     al, '0'                ; Convert ASCII to integer

    cvtsi2sd xmm0, rax
    divsd   xmm0, xmm12
    addsd   xmm13, xmm0
    mulsd   xmm12, xmm11           ; Increase divisor (x10)

    inc     r14
    cmp     byte[r15 + r14], 0     ; Check for null terminator
    jne     parse_decimal

    ; === Combine integer and decimal parts ===
    cvtsi2sd xmm0, r13             ; xmm0 = float(integer part)
    addsd   xmm0, xmm13            ; xmm0 = integer + decimal

    ; === Apply negation if needed ===
    cmp     r10, 0
    je      return
    movsd   xmm1, [neg_mask]
    xorpd   xmm0, xmm1             ; Flip sign bit

return:
    ; === Move result to stack temporarily ===
    push    qword 0
    movsd   [rsp], xmm0

    ; Restore x87/FPU state
    mov     rax, 7
    mov     rdx, 0
    xrstor  [storedata]

    movsd   xmm0, [rsp]
    pop     rax

    ; === Restore all saved registers ===
    popf          
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     r11
    pop     r10
    pop     r9 
    pop     r8 
    pop     rdi
    pop     rsi
    pop     rdx
    pop     rcx
    pop     rbx
    pop     rbp
    ret
