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

          org $0580
introfile .byte c'INTRO   XEX' ; 11 characters ATASCII (8.3 without the dot, space padded)
gamefile .byte c'STARV   XEX'
xBiosIOresult .byte
xBiosIOerror .byte

;          icl 'printf.asm'

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

main
;          mva	#1c	$2c4
          jsr printf
	        dta c'Loading...',$9b,0
          mva <introfile adr1+1
          mva >introfile adr2+1
          jsr loadfile
game      mva <gamefile adr1+1
          mva >gamefile adr2+1
          jsr loadfile

          run main
          .link 'd:\Atari\Mad_Asm\examples\LIBRARIES\stdio\lib\printf.obx'

.print "game address: ", game, "..", *
