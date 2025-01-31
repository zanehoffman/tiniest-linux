.intel_syntax noprefix

.set file_load_va, 4096 * 40

.byte 0x7F
.ascii "ELF"
.byte 2
.byte 1
.byte 1
.byte 0
loop_start:
  xor eax, eax
  inc eax
  inc edx
  jmp write
.byte 0x02, 0
.byte 0x3e, 0
.byte 1, 0, 0, 0
# Entrypoint
.quad file_load_va + 8
# Program Offset
.quad 0x40 
# Section offset
write:
  push 0x23
  mov rsi, rsp
  syscall
  jmp read
.byte 0
.word 0
.word 64
.word 0x38
.word 1
.word 0
.word 0
.word 0

program_headers_start:
.word 1
.word 0

.word 5
.word 0

.quad 0
.quad file_load_va
.quad 0
.quad 200
.quad 200 

execve:
  mov al, 59
  syscall

read:
  dec al
  xor edi, edi
  mov rsi, rsp
  # dl == 1 from write, so yolo
  sub dl, 2
  # mov dl, 255
  syscall
  # dec al 
  
  movb [rsp + rax - 1], 0
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

  jmp loop_start 
