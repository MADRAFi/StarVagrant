DL_BLANK1 = 0; // 1 blank line
DL_BLANK2 = %00010000; // 2 blank lines
DL_BLANK3 = %00100000; // 3 blank lines
DL_BLANK4 = %00110000; // 4 blank lines
DL_BLANK5 = %01000000; // 5 blank lines
DL_BLANK6 = %01010000; // 6 blank lines
DL_BLANK7 = %01100000; // 7 blank lines
DL_BLANK8 = %01110000; // 8 blank lines

DL_DLI = %10000000; // Order to run DLI
DL_LMS = %01000000; // Order to set new memory address
DL_VSCROLL = %00100000; // Turn on vertical scroll on this line
DL_HSCROLL = %00010000; // Turn on horizontal scroll on this line

DL_MODE_40x24T2 = 2; // Antic Modes
DL_MODE_40x24T5 = 4;
DL_MODE_40x12T5 = 5;
DL_MODE_20x24T5 = 6;
DL_MODE_20x12T5 = 7;
DL_MODE_40x24G4 = 8;
DL_MODE_80x48G2 = 9;
DL_MODE_80x48G4 = $A;
DL_MODE_160x96G2 = $B;
DL_MODE_160x192G2 = $C;
DL_MODE_160x96G4 = $D;
DL_MODE_160x192G4 = $E;
DL_MODE_320x192G2 = $F;

DL_JMP = %00000001; // Order to jump
DL_JVB = %01000001; // Jump to begining

; It's always useful to include you program global constants here
    icl 'const.inc'

; and declare display list itself

;(*** DISPLAY LIST DEFINITION ***)
;{
;DL_Init(DISPLAY_LIST_ADDRESS);
;DL_Push(DL_BLANK8);                                   // 8 blank line
;DL_Push(DL_MODE_160x192G4 + DL_LMS, GFX_ADDRESS);       // gfx line + graphics memory start
;DL_Push(DL_MODE_160x192G4,99);                          // x graphics line
;DL_Push(DL_BLANK8);                                     // 8 blank lines
;DL_Push(DL_MODE_40x24T2 + DL_LMS, VIDEO_RAM_ADDRESS);   // mode 0 line + text memory start
;DL_Push(DL_MODE_40x24T2,5);                               // 5x mode 0 line
;DL_Push(DL_BLANK8);                                   // 2x 8 blank lines
;DL_Push(DL_MODE_40x24T2 + DL_HSCROLL);                  //  mode 0 line
;DL_Push(DL_BLANK8);                                     // 8 blank lines
;DL_PUSH(DL_JVB,DISPLAY_LIST_ADDRESS);                   // jump to beginning
;DL_Start;                                               // Set & Start custom Display List
;}

dl_start
    dta DL_BLANK8                            ; // 8 blank line
    dta DL_MODE_160x192G4 + DL_LMS, a(GFX_ADDRESS)      ; // gfx line + graphics memory start
    :99 dta DL_MODE_160x192G4                           ; // x graphics line
    dta DL_BLANK8                                       ; // 8 blank lines
    dta DL_MODE_40x24T2 + DL_LMS, a(VIDEO_RAM_ADDRESS)  ; // mode 0 line + text memory start
    :5 dta DL_MODE_40x24T2                              ; // 5x mode 0 line
    dta DL_DLI + DL_BLANK8                                       ; // 8 blank line
    dta DL_MODE_40x24T2 + DL_HSCROLL                    ; //  mode 0 line
    dta DL_JVB, a(dl_start)                             ; // jump to beginning
