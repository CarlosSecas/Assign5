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