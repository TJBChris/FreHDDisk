;FREHD BOOT W/OUT MODIFIED C ROM
;TJBCHRIS WROTE THIS - 11/16/2020
;BASED ON BASIC PROGRAM ON GITHUB: APUDER/TRS-IO ISSUE #23
;PROGRAM EQUATES
MODEL	EQU	4	;COMPUTER MODEL
FREHD	EQU	196	;REHD PORT
MEMLOC	EQU	5000H	;WHERE TO STORE CODE FROM FREHD
NBYTES	EQU	255 	;NUM OF BYTES TO READ FROM FREHD

	ORG	4300H

;THE FIRST THREE SECTORS OF A DISK
;INDICATE THE LOCATION OF THE DIRECTORY TRACK.
;FOR MY DISKS...LDOS 5 (MODELS III/4/4P): TRACK 20
;               TRSDOS 2.1 (MODEL I): TRACK 17
START    NOP
         CP    14H
;DISPLAY STARTUP MESSAGE
	LD	HL,INTRO
	LD	BC,3C00H	; START AT BEGINNING OF DISP
	CALL	DISP
INIT	LD	A,56
	LD	(16912),A
;READ FROM FREHD PORT
	OUT	(236),A
	LD	A,MODEL
	OUT	(197),A	;SET MODEL (1, 3, 4, 5 FOR 4P)
	IN	A,(FREHD)	;READ BYTE FROM FREHD PORT
;CHECK FOR EXPECTED BYTE
	CP	254
	JR	NZ,ERROR
;GOOD, READ NBYTES BYTES FROM FREHD AND JUMP TO IT
	LD	HL,MEMLOC	;STARTING ADDR FOR FREHD CODE
	LD	B,NBYTES
	LD	C,FREHD
	INIR
	JP	MEMLOC
ERROR	LD	HL,ERRST	;SHOW ERROR TEXT, LOOP FOREVER
	LD	BC,3C40H	;START ON SECOND LINE OF DISP
	CALL	DISP
LOOP	JR	LOOP
; DISPLAY ROUTINE
; TAKEN FROM MORE TRS-80 ASSEMBLY LANGUAGE PROGRAMMING
; BY WILLIAM BARDEN PP. 149
DISP	PUSH	AF
	PUSH	BC
	PUSH	HL
DSP001	LD	A,(HL)
	OR	A
	JR	Z,DSPEND
	LD	(BC),A
	INC	BC
	INC	HL
	LD	(CURPOS),BC
	JR	DSP001
DSPEND	POP	HL
	POP	BC
	POP	AF
	RET
;STRING CONSTANTS
ERRST	DB	'ERROR LOADING FREHD ROM.  CHECK CABLE CONNECTIONS AND ENSURE    FREHD.ROM IS PRESENT ON SD CARD/NETWORK SHARE.',00H
INTRO	DB	'LOADING FREHD ROM.  LOVE, -TJBCHRIS...',00H
CURPOS	DW	0000H
	END	START
