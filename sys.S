.intel_syntax noprefix

.set file_load_va, 4096 * 40

.byte 0x7F
.ascii "ELF"
.byte 2 # 32 or 64 bit
.byte 1 # Endianness
.byte 1 # Version
.byte 0x23 # ABI
# ABIVersion && PAD
loop_start:
  xor eax, eax
  inc eax
  inc edx
  jmp write
.byte 0x02, 0 # Type
.byte 0x3e, 0 # Processor ID
.byte 1, 0, 0, 0 # ELF Version
# Entrypoint
.quad file_load_va + 8
# Program Offset
.quad 0x40 

# Section offset
write:
  mov esi, 0x28007
  syscall
  dec al
  jmp read
.byte 0

.word 64
.word 0x38
.word 1
.word 0
.word 0
.word 0

program_headers_start:
.word 1
.word 0

.word 7
.word 0

.quad 0
.quad file_load_va
execve:
  cmp al, 0
  jne waitid
  mov al, 59
  syscall
.quad 200
.quad 200 

read:
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
  jmp execve

waitid:
  xor eax, eax
  mov al, 247
  xor edi, edi
  mov r10b, 10 
  syscall

  jmp loop_start 

