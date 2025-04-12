;Information: This include file was first created to accompany the program An Assembly-Based Circuit Diagnostics Calculator.
;This program collects a user's name, career path, and resistance values for three sub-circuits,
;then calculates and displays the total resistance and current in the circuit.



;This is an include file for the program edison.asm.   File name: acdc.inc

%macro get_res_line 2
    ; %1 = destination buffer 
    ; %2 = input buffer 

    mov rdi, %2
    call fgets

    mov rsi, %2      ; pointer into input buffer
    mov rcx, 0       ; counter

.parse_next:
.skip_ws:
    mov rax, [rsi]
    and rax, 0xFF
    cmp rax, ' '
    je .skip_advance
    cmp rax, 9
    je .skip_advance
    cmp rax, 10
    je .done_parsing
    cmp rax, 0
    je .done_parsing
    jmp .token_start

.skip_advance:
    inc rsi
    jmp .skip_ws

.token_start:
    mov rdi, rsi
    call atof        ; xmm0 = float

    ; store into [%1 + rcx * 8]
    mov rax, rcx
    imul rax, 8
    add rax, %1
    movsd [rax], xmm0

.find_end:
    mov rax, [rsi]
    and rax, 0xFF
    cmp rax, ' '
    je .found_end
    cmp rax, 9
    je .found_end
    cmp rax, 10
    je .done_parsing
    cmp rax, 0
    je .done_parsing
    inc rsi
    jmp .find_end

.found_end:
    inc rsi
    inc rcx
    cmp rcx, 3
    jl .parse_next

.done_parsing:
%endmacro
