.intel_syntax noprefix

.section .text
.global _start

_start:
loop_start:

write:
  xor eax, eax 
  inc al
  inc dl
  push 0x23
  mov rsi, rsp
  syscall

read:
  dec al
  xor edi, edi

  mov rsi, rsp
  xor edx, edx
  dec dl
  #mov dl, 255
  syscall
  dec al 
  
  movb [rsp + rax], 0

  mov rdi, rsp

fork: 
  xor eax, eax
  xor edx, edx 
  xor esi, esi
  mov al, 57
  syscall

  cmp al, 0
  je execve

waitid:
  xor eax, eax
  mov al, 247
  xor edi, edi


  mov r10b, 10 
  syscall
  jmp _start
  
execve: 
  mov al, 59
  syscall
