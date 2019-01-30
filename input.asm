section .data

entermsg db 'enter a number '
lenentermsg equ $-entermsg
even_num db 'even number'
odd_num db 'odd number'
len_even_num equ $-even_num
len_odd_num equ $-odd_num

section .bss
num resb 5

section .text
global _start

_start:
	mov edx,lenentermsg
	mov ecx,entermsg
	mov ebx, 1
	mov eax,4
	int 80h

mov edx,lenentermsg
	mov eax,3
	mov ebx,2
	mov ecx,num
	int 80h

and edx,1
jz @even

even:
	mov eax,4
	mov ebx,1
	mov ecx, even_num
	mov edx len_even_num

	; Exit code
   mov eax, 1; sys_exit
   mov ebx, 0; no errors
   int 80h