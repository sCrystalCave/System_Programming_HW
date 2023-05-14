INCLUDE C:\Irvine32\Irvine32.inc	;����� ���̺귯�� �߰�

.386	; this as a 32-bit program
.model flat, stdcall	; program��s memory model (flat), calling convention (named stdcall) for procedures
.stack 4096		; 4096 bytes of storage for the runtime stack

.data
MyInfo BYTE "20101432 ������", 0	; �й��� �̸��� ������ null-terminated string
PrintInt BYTE "32�� unsigned 5byte integer ���� ����", 0
hexa BYTE "0x",0
PrintSum BYTE "32�� unsigned 5byte integer ��: ", 0
PrintQuotient BYTE "���: ", 0
val BYTE 160 DUP(?) ; 32���� 5byte ����, �� 160 byte ������ �����ϴ� �迭
sum BYTE 6 DUP(0) ; sum
Quotient BYTE 6 DUP(0) ; sum�� 32�� ���� ���̸鼭 ��� ��

.code
Extended_Add PROC
    clc

L1: mov al, [edi]
    adc [ebx], al
    inc edi
    inc ebx
    loop L1

    adc byte ptr [ebx], 0
    ret
Extended_Add ENDP

Display PROC
    add esi, ecx
    mov ebx, TYPE BYTE

L1: sub esi, TYPE BYTE
    mov al, [esi]
    call WriteHexB
    loop L1

    ret
Display ENDP

Divide PROC

mov eax, DWORD PTR sum  ; ���� 32��Ʈ
mov edx, DWORD PTR sum+4 ; ���� 32��Ʈ
shrd eax, edx, 5

shr edx, 5

mov WORD PTR Quotient+4, dx
mov DWORD PTR Quotient, eax
ret
Divide ENDP

main PROC	; ���� ���ν��� ����

call Clrscr	; ���̺귯������ �����ϴ� ���ν���. �ܼ�â�� clear

mov edx, OFFSET MyInfo
call WriteString	; "20101432 ������"�� ���

; val �ʱ�ȭ �κ�
call Randomize
mov ecx, 40
mov esi, 0
mov ebx, OFFSET val ; val �迭�� ���� �ּҸ� ebx �������Ϳ� �����մϴ�.
L1 : call Random32
     mov BYTE PTR [ebx], al ; eax�� ���� 1����Ʈ ���� val[0]�� �����մϴ�.
     shr eax, 8            ; eax�� 8��Ʈ��ŭ ���������� �̵��մϴ�.
     mov BYTE PTR [ebx+1], al ; eax�� ���� 1����Ʈ ���� val[1]�� �����մϴ�.
     shr eax, 8            ; eax�� 8��Ʈ��ŭ ���������� �̵��մϴ�.
     mov BYTE PTR [ebx+2], al ; eax�� ���� 1����Ʈ ���� val[2]�� �����մϴ�.
     shr eax, 8            ; eax�� 8��Ʈ��ŭ ���������� �̵��մϴ�.
     mov BYTE PTR [ebx+3], al ; eax�� ���� 1����Ʈ ���� val[3]�� �����մϴ�.
	 inc esi
     add ebx, 4
     
	 loop L1

;32�� ���
call Crlf
mov edx, OFFSET PrintInt
call WriteString
call Crlf

mov esi, OFFSET val
mov ecx, 32
L5: push ecx
    mov ecx, 5
    mov edx, OFFSET hexa
call WriteString
    call Display
    call Crlf
    add esi, 5
    pop ecx
loop L5

;32�� ��
mov ecx, 32
mov edi, OFFSET val
L2:
push ecx
mov ebx, OFFSET sum
mov ecx, 5
call Extended_Add
pop ecx
loop L2


call Crlf
mov edx, OFFSET PrintSum
call WriteString
mov esi, OFFSET sum
mov ecx, LENGTHOF sum
call Display
call Crlf

call Divide


mov esi, OFFSET Quotient
mov ecx, LENGTHOF Quotient
call Crlf
mov edx, OFFSET PrintQuotient
call WriteString
call Display
call Crlf

exit	; ���̺귯������ �����ϴ� ���ν���. invoke ExitProcess, 0 ��� ���
main ENDP	; ���� ���ν��� ����
END main	; ���α׷� ����