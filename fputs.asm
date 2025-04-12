;declarations
global fputs

extern strlen

segment .data

segment .bss

segment .text

fputs:

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


    mov rsi, rdi       ; move pointer to string to rsi
    call strlen        ; get string length in rax

    mov rdx, rax       ; rdx = length
    mov rax, 1         ; syscall number for write
    mov rdi, 1         ; file descriptor (stdout)
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