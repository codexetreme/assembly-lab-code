section .bss
  num: resw 1 ;For storing a number, to be read of printed....
  nod: resb 1 ;For storing the number of digits....
  temp: resb 2
  array1: resw 50
  size1: resw 1
  
section .text
  msg1: db "Enter the number of elements in the array : "
  siz1: equ $-msg1
  msg2:  db "Enter the elements one by one"
  size2: equ $-msg2
  space: db  " "
  
section .text
  global _start

_start:
  mov eax, 4
  mov ebx, 1
  mov ecx, msg1
  mov edx, siz1
  int 80h
  
  mov ecx, 0
  call read_num  
  mov cx, word[num]
  mov word[size1], cx
  
  push ecx
  
  mov eax, 4
  mov ebx, 1
  mov ecx, msg2
  mov edx, size2
  int 80h
  
  pop ecx ;Array length in ecx, so we can loop to read elements
  ;Reading the array elements....
  mov eax, 0
  mov ebx, array1
  
  read_element:
    call read_num
    mov dx , word[num]
    ;eax will contain the array index and each element is 2 bytes(1 word) long
    mov  word[ebx + 2 * eax], dx
    inc eax    ;Incrementing array index by one....
  loop read_element
  
  
  ;Printing the elements.....
  movzx  ecx, word[size1]
  mov eax, 0
  mov ebx, array1
  
  print_element:
  ;eax will contain the array index and each element is 2 bytes(1 word) long
    mov  dx, word[ebx + 2 * eax]   ;
    mov word[num] , dx
    call print_num
    
    ;Printing a space after each element.....
    pusha
      mov eax, 4
      mov ebx, 1
      mov ecx, space
      mov edx, 1
      int 80h    
    popa
    
    inc eax  
  loop print_element
  
  

  
;Exit System Call.....
exit:
  mov eax, 1
  mov ebx, 0
  int 80h

  
  
;Function to read a number from console and to store that in num 
read_num:

  pusha
  mov word[num], 0
  
  loop_read:
    mov eax, 3
    mov ebx, 0
    mov ecx, temp
    mov edx, 1
    int 80h
    
    cmp byte[temp], 10
      je end_read
    
    mov ax, word[num]
    mov bx, 10
    mul bx
    mov bl, byte[temp]
    sub bl, 30h
    mov bh, 0
    add ax, bx
    mov word[num], ax
    jmp loop_read 
  end_read:
  popa
  
ret


;Function to print any number stored in num...
print_num:
  pusha
  extract_no:
    cmp word[num], 0
    je print_no
    inc byte[nod]
    mov dx, 0
    mov ax, word[num]
    mov bx, 10
    div bx
    push dx
    mov word[num], ax
  jmp extract_no

  print_no:
    cmp byte[nod], 0
    je end_print
    dec byte[nod]
    pop dx
    mov byte[temp], dl
    add byte[temp], 30h


    mov eax, 4
    mov ebx, 1
    mov ecx, temp
    mov edx, 1
    int 80h
    
    jmp print_no
    
  end_print:   
  popa
ret 