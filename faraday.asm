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
;  File name: faraday.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -o faraday.o faraday.asm
;  Assemble (debug): nasm -f elf64 -o faraday.o faraday.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: extern double _start();
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


;declarations
global _start

extern fputs
extern strlen
extern manager
extern ftoa

segment .data
welcome_msg db "Welcome to Electricity brought to you by Henry Finkelstein.", 10, 0
purpose_msg db "This program will compute the resistance current flow in your direct circuit.", 10, 0


driver_msg_start db "The driver received this number ", 0
driver_msg_end   db ", and will keep it until next semester.", 10, 0
exit_msg         db "A zero will be returned to the Operating System", 10, 0


segment .bss
name_buffer    resb 100
career_buffer  resb 100
res_buf        resq 3      ; stores 3 resistance values as float/double
res_str   resb 100         ; to hold formatted resistance string

segment .text
_start:

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


    ;Print welcome messages
    mov rdi, welcome_msg
    call strlen
    mov rsi, welcome_msg
    mov rdx, rax
    call fputs

    ;Print the purpose of the program
    mov rdi, purpose_msg
    call strlen
    mov rsi, purpose_msg
    mov rdx, rax
    call fputs

    ;Call edison.asm’s manager to handle all user input
    mov rdi, name_buffer
    mov rsi, career_buffer
    mov rdx, res_buf
    call manager

    mov rdi, driver_msg_start
    call strlen
    mov rsi, driver_msg_start
    mov rdx, rax
    call fputs

    ;Convert current in xmm0 to ASCII string
    mov rdi, res_str
    call ftoa

    ;Print converted current value
    mov rdi, res_str
    call strlen
    mov rsi, res_str
    mov rdx, rax
    call fputs

    ;Print closing message
    mov rdi, driver_msg_end
    call strlen
    mov rsi, driver_msg_end
    mov rdx, rax
    call fputs

    ;Final OS return line
    mov rdi, exit_msg
    call strlen
    mov rsi, exit_msg
    mov rdx, rax
    call fputs

    ;Exit for now
    mov rax, 60
    xor rdi, rdi
    syscall


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