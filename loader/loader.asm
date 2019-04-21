xBIOS                      equ $800
xBIOS_VERSION              equ xBIOS+$02
xBIOS_RENAME_ENTRY         equ xBIOS+$03
xBIOS_LOAD_FILE            equ xBIOS+$06
xBIOS_OPEN_FILE            equ xBIOS+$09
xBIOS_LOAD_DATA            equ xBIOS+$0c
xBIOS_WRITE_DATA           equ xBIOS+$0f
xBIOS_OPEN_CURRENT_DIR     equ xBIOS+$12
xBIOS_GET_BYTE             equ xBIOS+$15
xBIOS_PUT_BYTE             equ xBIOS+$18
xBIOS_FLUSH_BUFFER         equ xBIOS+$1b
xBIOS_SET_LENGTH           equ xBIOS+$1e
xBIOS_SET_INIAD            equ xBIOS+$21
xBIOS_SET_FILE_OFFSET      equ xBIOS+$24
xBIOS_SET_RUNAD            equ xBIOS+$27
xBIOS_SET_DEFAULT_DEVICE   equ xBIOS+$2a
xBIOS_OPEN_DIR             equ xBIOS+$2d
xBIOS_LOAD_BINARY_FILE     equ xBIOS+$30
xBIOS_OPEN_DEFAULT_DIR     equ xBIOS+$33
xBIOS_SET_DEVICE           equ xBIOS+$36
xBIOS_RELOCATE_BUFFER      equ xBIOS+$39
xBIOS_GET_ENTRY            equ xBIOS+$3c
xBIOS_OPEN_DEFAULT_FILE    equ xBIOS+$3f
xBIOS_READ_SECTOR          equ xBIOS+$42
xBIOS_FIND_ENTRY           equ xBIOS+$45
xBIOS_SET_BUFFER_SIZE      equ xBIOS+$48

xDIRSIZE        equ xBIOS+$3e5 ; current directory size in sectors (1 byte)
xSPEED          equ xBIOS+$3e6 ; STANDARD SPEED (1 byte)
xHSPEED         equ xBIOS+$3e7 ; ULTRA SPEED (1 byte)
xIRQEN          equ xBIOS+$3e8 ; User IRQ (1 byte)
xAUDCTL         equ xBIOS+$3e9 ; AUDCTL
xFILE           equ xBIOS+$3ea ; File handle (2 bytes)
xDIR            equ xBIOS+$3ec ; Root directory handle (2 bytes)
xIOV            equ xBIOS+$3ee ; I/O module entry (2 bytes)
xBUFFERH        equ xBIOS+$3f0 ; Buffer adr hi byte (1 byte)
xBUFSIZE        equ xBIOS+$3f1 ; Buffer size lo byte $100-SIZE (1 byte)
xDAUX3          equ xBIOS+$3f2 ; Buffer offset (1 byte)
xSEGMENT        equ xBIOS+$3f3 ; Bytes to go in binary file segment (2 bytes)
xNOTE           equ xBIOS+$3f5 ; File pointer (3 bytes)
xDEVICE         equ xBIOS+$3fc ; Device ID
xDCMD           equ xBIOS+$3fd ; CMD (1 byte)
xDAUX1          equ xBIOS+$3fe ; Sector lo byte (1 byte)
xDAUX2          equ xBIOS+$3ff ; Sector hi byte (1 byte)

DL_BLANK1 equ 0; // 1 blank line
DL_BLANK2 equ %00010000; // 2 blank lines
DL_BLANK3 equ %00100000; // 3 blank lines
DL_BLANK4 equ %00110000; // 4 blank lines
DL_BLANK5 equ %01000000; // 5 blank lines
DL_BLANK6 equ %01010000; // 6 blank lines
DL_BLANK7 equ %01100000; // 7 blank lines
DL_BLANK8 equ %01110000; // 8 blank lines

DL_DLI equ %10000000; // Order to run DLI
DL_LMS equ %01000000; // Order to set new memory address
DL_VSCROLL equ %00100000; // Turn on vertical scroll on this line
DL_HSCROLL equ %00010000; // Turn on horizontal scroll on this line

DL_MODE_40x24T2 equ 2; // Antic Modes
DL_MODE_40x24T5 equ 4;
DL_MODE_40x12T5 equ 5;
DL_MODE_20x24T5 equ 6;
DL_MODE_20x12T5 equ 7;
DL_MODE_40x24G4 equ 8;
DL_MODE_80x48G2 equ 9;
DL_MODE_80x48G4 equ $A;
DL_MODE_160x96G2 equ $B;
DL_MODE_160x192G2 equ $C;
DL_MODE_160x96G4 equ $D;
DL_MODE_160x192G4 equ $E;
DL_MODE_320x192G2 equ $F;

DL_JMP equ %00000001; // Order to jump
DL_JVB equ %01000001; // Jump to begining

;PORTB_SELFTEST_OFF equ %10000000; // portb bit value to turn Self-Test off
;PORTB_BASIC_OFF equ %00000010;	// portb bit value to turn Basic off
;PORTB_SYSTEM_ON equ %00000001;	// portb bit value to turn System on

ANTIC_MODE_NARROW equ %00100001;
ANTIC_MODE_NORMAL equ %00100010;
ANTIC_MODE_WIDE equ %00100011;

;myport_b equ PORTB_BASIC_OFF + PORTB_SELFTEST_OFF + %01111100;



          icl 'atari.hea'

        ;   org $d301
        ;   .byte $fe

CHARSET_ADDRESS equ $9C00; // same as in intro and game
          org CHARSET_ADDRESS
          ins '../assets/Nvdi8.fnt'
          org $0580

introfile .byte c'INTRO   XEX' ; 11 characters ATASCII (8.3 without the dot, space padded)
gamefile .byte c'STARV   XEX'
xBiosIOresult .byte
xBiosIOerror .byte


loadfile
          mva #0 xBiosIOresult
          sta xBiosIOerror
adr1      ldy #0
adr2      ldx #0
          jsr xBIOS_LOAD_FILE
          bcc @+
          stx xBiosIOerror
          mva #1 xBiosIOresult
@         rts

.proc	systemoff

	lda:rne vcount

	sei
	inc nmien
	mva #$fe portb

	rts
.endp

.proc	systemon

	lda:rne vcount

	mva #$ff portb
	dec nmien
	cli

	rts
.endp

;-------------------------------------------------------------------------------
dlist
          .byte DL_BLANK8, DL_BLANK8, DL_BLANK8
          .byte DL_MODE_40x24T2 + DL_LMS, a(vmem)
          .byte DL_JVB, a(dlist)

vmem
	        .byte "    LOADING... Star Vagrant.            "

;initialize  clc
;            cld
;            lda PORTB
;            ora #$02
;            sta PORTB
;            rts

main

          ;jsr systemoff


sync     lda VCOUNT
         bne sync

         mva #.hi(CHARSET_ADDRESS) chbase
         mva #28 colpf1
         mva #0 colpf0
         mva #0 colpf2
         mva #0 colpf3
         mva #0 colbak
         mwa #dlist dlistl
         mva #ANTIC_MODE_NARROW DMACTL

intro    mva <introfile adr1+1
         mva >introfile adr2+1
         jsr loadfile


         mva #.hi(CHARSET_ADDRESS) chbase
         mva #28 colpf1
         mva #0 colpf0
         mva #0 colpf2
         mva #0 colpf3
         mva #0 colbak
         mwa #dlist dlistl
         mva #ANTIC_MODE_NARROW DMACTL

game     mva <gamefile adr1+1
         mva >gamefile adr2+1
         jmp loadfile

          ;jmp systemon

;          ini initialize
          run main

.print "Loader:", main, "..", *
