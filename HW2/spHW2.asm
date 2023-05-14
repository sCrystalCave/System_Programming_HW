INCLUDE C:\Irvine32\Irvine32.inc	;사용할 라이브러리 추가

.386	; this as a 32-bit program
.model flat, stdcall	; program’s memory model (flat), calling convention (named stdcall) for procedures
.stack 4096		; 4096 bytes of storage for the runtime stack
	
.data
MyInfo BYTE "20101432 조윤지", 0	; 학번과 이름을 저장한 null-terminated string, 
									; byte형이므로 메모리 1바이트를 차지하고 label이 prompt
InputScore SBYTE "성적을 입력하세요(0~100 사이의 정수) : ", 0
Maxscore SBYTE 100;
scoreLimitArray SBYTE 90, 80, 70, 60
scoreLimitArraySize = ($-scoreLimitArray)/TYPE scoreLimitArray;
gradeArray BYTE "A", "B", "C", "D", "F"
grade BYTE ?

PrintGrade BYTE "학점 : ", 0
PrintErrorMsg BYTE "범위를 벗어났습니다.", 0

.code

main PROC	; 메인 프로시저 시작

call Clrscr	; 라이브러리에서 지원하는 프로시저. 콘솔창을 clear

mov edx, OFFSET MyInfo	; prompt의 offset을 edx에 저장
call WriteString	; 라이브러리에서 지원하는 프로시저. edx에 있는 string의 offset을 인자로 하여 해당 string을 출력


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

exit	; 라이브러리에서 지원하는 프로시저. invoke ExitProcess, 0 대신 사용
main ENDP	; 메인 프로시저 종료
END main	; 프로그램 종료