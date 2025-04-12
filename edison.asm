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
;  Files in this program: edison.asm, faraday.asm, tesla.asm, strlen.asm, itoa.asm, fputs.asm, fgets.asm, atof.asm, ftoa.asm, r.sh.
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
;  File name: edison.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -o edison.o edison.asm
;  Assemble (debug): nasm -f elf64 -o edison.o edison.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: extern double manager();
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


;declarations
global manager

extern fputs
extern strlen
extern fgets
extern atof
extern compute_resist
extern ftoa

%include "acdc.inc"

segment .data

name_prompt    db "Please enter your full name: ", 0
career_prompt  db "Please enter the career path you are following: ", 0
thanks_msg     db "Thank you. We appreciate all ", 0
newline_msg    db 10, 0
all_res_prompt db "Your circuit has 3 sub-circuits.", 10, \
                   "Please enter the resistance in ohms on each of the three sub-circuits separated by ws: ", 0
res_thanks_msg db "Thank you.", 10, 0
res_msg     db "The total resistance of the full circuit is computed to be ", 0
ohms_msg    db " ohms.", 10, 0
emf_msg     db "EMF is constant on every branch of any circuit.", 10, 0
emf_prompt  db "Please enter the EMF of this circuit in volts: ", 0
current_msg db "The current flowing in this circuit has been computed: ", 0
amps_msg    db " amps", 10, 0
final_thanks_1 db "Thank you ", 0
final_thanks_2 db " for using the program Electricity.", 10, 0

segment .bss

float_buffer resb 128
emf_buffer  resb 100
res_buf     resq 3
res_str     resb 100     ; for ftoa output

segment .text

manager:

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

    ; Inputs from faraday.asm
    ; rdi = name_buffer
    ; rsi = career_buffer

    mov r8, rdi     ; r8 = name_buffer
    mov r9, rsi     ; r9 = career_buffer

    ; === Full Name ===
    mov rdi, name_prompt
    call strlen
    mov rsi, name_prompt
    mov rdx, rax
    call fputs

    mov rdi, r8
    call fgets

    ;Career Path
    mov rdi, career_prompt
    call strlen
    mov rsi, career_prompt
    mov rdx, rax
    call fputs

    mov rdi, r9
    call fgets

    ;Append 's' to career path
    mov rdi, r9
    call strlen
    dec rax
    mov byte [r9 + rax], 's'
    inc rax
    mov byte [r9 + rax], 0

    ;Print Appreciation
    mov rdi, thanks_msg
    call strlen
    mov rsi, thanks_msg
    mov rdx, rax
    call fputs

    mov rdi, r9
    call strlen
    mov rsi, r9
    mov rdx, rax
    call fputs

    mov rdi, newline_msg
    call strlen
    mov rsi, newline_msg
    mov rdx, rax
    call fputs

    ;Prompt for all 3 values at once
    mov rdi, all_res_prompt
    call strlen
    mov rsi, all_res_prompt
    mov rdx, rax
    call fputs

    ;Get resistances using macro
    get_res_line res_buf, float_buffer

    ;Print thank you
    mov rdi, res_thanks_msg
    call strlen
    mov rsi, res_thanks_msg
    mov rdx, rax
    call fputs

    ;Compute total resistance
    mov rdi, res_buf
    call compute_resist
    movapd xmm6, xmm0

    ;Convert resistance to ASCII
    mov rdi, res_str
    call ftoa

    ;Print total resistance
    mov rdi, res_msg
    call strlen
    mov rsi, res_msg
    mov rdx, rax
    call fputs
    mov rdi, res_str
    call strlen
    mov rsi, res_str
    mov rdx, rax
    call fputs
    mov rdi, ohms_msg
    call strlen
    mov rsi, ohms_msg
    mov rdx, rax
    call fputs

    ;EMF input
    mov rdi, emf_msg
    call strlen
    mov rsi, emf_msg
    mov rdx, rax
    call fputs
    mov rdi, emf_prompt
    call strlen
    mov rsi, emf_prompt
    mov rdx, rax
    call fputs
    mov rdi, emf_buffer
    call fgets
    mov rdi, emf_buffer
    call atof
    movapd xmm7, xmm0

    mov rdi, res_thanks_msg
    call strlen
    mov rsi, res_thanks_msg
    mov rdx, rax
    call fputs

    ;Compute current
    movapd xmm0, xmm7
    divsd xmm0, xmm6

    movapd xmm8, xmm0       ; save current for faraday.asm

    mov rdi, res_str
    call ftoa

    mov rdi, current_msg
    call strlen
    mov rsi, current_msg
    mov rdx, rax
    call fputs
    mov rdi, res_str
    call strlen
    mov rsi, res_str
    mov rdx, rax
    call fputs
    mov rdi, amps_msg
    call strlen
    mov rsi, amps_msg
    mov rdx, rax
    call fputs

    ;Final message
    mov rdi, final_thanks_1
    call strlen
    mov rsi, final_thanks_1
    mov rdx, rax
    call fputs
    mov rdi, r8
    call strlen
    dec rax
    mov byte [r8 + rax], 0
    mov rdi, r8
    call strlen
    mov rsi, r8
    mov rdx, rax
    call fputs
    mov rdi, final_thanks_2
    call strlen
    mov rsi, final_thanks_2
    mov rdx, rax
    call fputs

    ; return current in xmm0
    movapd xmm0, xmm8       ; restore current to return to faraday.asm

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