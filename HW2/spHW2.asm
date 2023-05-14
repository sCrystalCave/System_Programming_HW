INCLUDE C:\Irvine32\Irvine32.inc	;����� ���̺귯�� �߰�

.386	; this as a 32-bit program
.model flat, stdcall	; program��s memory model (flat), calling convention (named stdcall) for procedures
.stack 4096		; 4096 bytes of storage for the runtime stack
	
.data
MyInfo BYTE "20101432 ������", 0	; �й��� �̸��� ������ null-terminated string, 
									; byte���̹Ƿ� �޸� 1����Ʈ�� �����ϰ� label�� prompt
InputScore SBYTE "������ �Է��ϼ���(0~100 ������ ����) : ", 0
Maxscore SBYTE 100;
scoreLimitArray SBYTE 90, 80, 70, 60
scoreLimitArraySize = ($-scoreLimitArray)/TYPE scoreLimitArray;
gradeArray BYTE "A", "B", "C", "D", "F"
grade BYTE ?

PrintGrade BYTE "���� : ", 0
PrintErrorMsg BYTE "������ ������ϴ�.", 0

.code

main PROC	; ���� ���ν��� ����

call Clrscr	; ���̺귯������ �����ϴ� ���ν���. �ܼ�â�� clear

mov edx, OFFSET MyInfo	; prompt�� offset�� edx�� ����
call WriteString	; ���̺귯������ �����ϴ� ���ν���. edx�� �ִ� string�� offset�� ���ڷ� �Ͽ� �ش� string�� ���


beginwhile:

call Crlf
call Crlf

mov edx, OFFSET InputScore
call WriteString

call ReadInt
test al, 80h
jnz @NegativeInput

cmp al, Maxscore
jle @VaildInput
mov edx, OFFSET PrintErrorMsg 
call WriteString
jmp beginwhile

@VaildInput:
mov esi,0;
mov ecx, scoreLimitArraySize
jmp L1

L1:
cmp esi, ecx
jl @Compare
jmp @Grade

@Compare:
cmp al, scoreLimitArray[esi]
jge @Grade
inc esi
jmp L1

@Grade:
mov edx, OFFSET PrintGrade
call WriteString
mov al, gradeArray[esi]
call WriteChar	
jmp beginwhile

@NegativeInput: 

exit	; ���̺귯������ �����ϴ� ���ν���. invoke ExitProcess, 0 ��� ���
main ENDP	; ���� ���ν��� ����
END main	; ���α׷� ����