section .multiboot_header
header_start:
	;align 4
	dd 0xe85250d6 ; magic number multiboot2
	dd 0x00 ; flag
	dd header_end - header_start ; header length
	dd 0x100000000 - (0xe85250d6 + 0x00 + (header_end - header_start))
	dw 0    ; type
	dw 0    ; flags
	dd 8    ; size
header_end:

section .text
	bits 32

global start
extern kmain ; from our sources


start:
	cli ; block interupt
	mov esp, stack_space ; set stack ptr
	call kmain 
	hlt ; halt the cpu

section .bss
resb 8192 ; 8KB for stack
stack_space:
