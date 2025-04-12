;declarations

global itoa

segment .data

segment .bss

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

    mov rcx, 0              ; digit count
    mov rbx, 10             ; divisor

    cmp rax, 0
    jne .convert
    mov byte [rsi], '0'
    mov byte [rsi + 1], 0
    jmp .done

.convert:
    ; Convert digits into stack (reversed)
.convert_loop:
    xor rdx, rdx            ; clear remainder
    div rbx                 ; rax = rax / 10, rdx = rax % 10
    add dl, '0'             ; convert digit to ASCII
    push rdx                ; push ASCII digit onto stack
    inc rcx                 ; increment digit count
    test rax, rax
    jnz .convert_loop

    ; Pop digits into buffer
.write_loop:
    pop rdx
    mov [rsi], dl
    inc rsi
    loop .write_loop

    mov byte [rsi], 0       ; null terminator

.done:

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