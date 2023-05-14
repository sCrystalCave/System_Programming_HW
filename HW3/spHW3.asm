INCLUDE C:\Irvine32\Irvine32.inc	;사용할 라이브러리 추가

.386	; this as a 32-bit program
.model flat, stdcall	; program’s memory model (flat), calling convention (named stdcall) for procedures
.stack 4096		; 4096 bytes of storage for the runtime stack

.data
MyInfo BYTE "20101432 조윤지", 0	; 학번과 이름을 저장한 null-terminated string
PrintInt BYTE "32개 unsigned 5byte integer 난수 생성", 0
hexa BYTE "0x",0
PrintSum BYTE "32개 unsigned 5byte integer 합: ", 0
PrintQuotient BYTE "평균: ", 0
val BYTE 160 DUP(?) ; 32개의 5byte 정수, 즉 160 byte 난수를 저장하는 배열
sum BYTE 6 DUP(0) ; sum
Quotient BYTE 6 DUP(0) ; sum을 32로 나눈 몫이면서 평균 값

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

mov eax, DWORD PTR sum  ; 하위 32비트
mov edx, DWORD PTR sum+4 ; 상위 32비트
shrd eax, edx, 5

shr edx, 5

mov WORD PTR Quotient+4, dx
mov DWORD PTR Quotient, eax
ret
Divide ENDP

main PROC	; 메인 프로시저 시작

call Clrscr	; 라이브러리에서 지원하는 프로시저. 콘솔창을 clear

mov edx, OFFSET MyInfo
call WriteString	; "20101432 조윤지"를 출력

; val 초기화 부분
call Randomize
mov ecx, 40
mov esi, 0
mov ebx, OFFSET val ; val 배열의 시작 주소를 ebx 레지스터에 복사합니다.
L1 : call Random32
     mov BYTE PTR [ebx], al ; eax의 하위 1바이트 값을 val[0]에 저장합니다.
     shr eax, 8            ; eax를 8비트만큼 오른쪽으로 이동합니다.
     mov BYTE PTR [ebx+1], al ; eax의 하위 1바이트 값을 val[1]에 저장합니다.
     shr eax, 8            ; eax를 8비트만큼 오른쪽으로 이동합니다.
     mov BYTE PTR [ebx+2], al ; eax의 하위 1바이트 값을 val[2]에 저장합니다.
     shr eax, 8            ; eax를 8비트만큼 오른쪽으로 이동합니다.
     mov BYTE PTR [ebx+3], al ; eax의 하위 1바이트 값을 val[3]에 저장합니다.
	 inc esi
     add ebx, 4
     
	 loop L1

;32개 출력
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

;32개 합
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

exit	; 라이브러리에서 지원하는 프로시저. invoke ExitProcess, 0 대신 사용
main ENDP	; 메인 프로시저 종료
END main	; 프로그램 종료