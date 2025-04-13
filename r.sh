#!/bin/bash

# Program Name: An Assembly-Based Circuit Diagnostics Calculator
# Author: Carlos Secas
# Author Email: carlosJsecas@gmail.com
# CWID: 886088269
# Class: 240-09 Section 09
# This file is the script file that accompanies the "An Assembly-Based Circuit Diagnostics Calculator" program.
# Prepare for execution in normal mode (not gdb mode).

nasm -f elf64 -o ftoa.o ftoa.asm

nasm -f elf64 -o strlen.o strlen.asm

nasm -f elf64 -o fputs.o fputs.asm

nasm -f elf64 -o fgets.o fgets.asm

nasm -f elf64 -o faraday.o faraday.asm

nasm -f elf64 -o tesla.o tesla.asm

nasm -f elf64 -o edison.o edison.asm

nasm -f elf64 -o atof.o atof.asm

nasm -f elf64 -o itoa.o itoa.asm

echo "Link the X86 assembled code"
ld -o pure-assembly.out ftoa.o itoa.o strlen.o fputs.o fgets.o faraday.o edison.o tesla.o atof.o -g


echo "Run the executable file"
./pure-assembly.out

rm *.o
rm *.out