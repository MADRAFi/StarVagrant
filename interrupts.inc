


//col0=$00
//col1=$02
//col3=$06
//col4=$0C


//procedure dli;assembler;interrupt;
//asm {
//    phr ; store registers
//
//;   *** example test routine
//;    lda #64 ; wait this number of lines
//;@   cmp vcount
//;    bpl @-
//;    mva #$0f atari.colbk ; change backgroung color to white
//
//    plr ; restore registers
//};
//end;



procedure dli1;assembler;interrupt;
    asm {
        pha
        lda $d20a
        sta $d01a
        sta ATARI.WSYNC
//        mva #$01 ATARI.COLOR0
//        mva #$02 ATARI.COLOR1
//        mva #$03 ATARI.COLOR2
//        mva #$04 ATARI.COLOR3
//        mva #$05 ATARI.COLOR4
//        mwa #DLI2 ATARI.VDSLST
        pla
        };
end;

procedure dli2;assembler;interrupt;
    asm {
        pha
        sta ATARI.WSYNC
      //  mva #$00 ATARI.COLOR0
        mva #$0c ATARI.COLOR1
        mva #$00 ATARI.COLOR2
        mva #$00 ATARI.COLOR4
        mwa #DLI3 ATARI.VDSLST
        pla
        };
end;

procedure dli3;assembler;interrupt;
    asm {
        pha
        mva #$06 ATARI.COLOR4
        :3 sta ATARI.WSYNC
        mva #$08 ATARI.COLOR4
        sta ATARI.WSYNC
        mva #$0a ATARI.COLOR4
        sta ATARI.WSYNC
        mva #$0c ATARI.COLOR4
        sta ATARI.WSYNC
        mva #$0a ATARI.COLOR4
        sta ATARI.WSYNC
        mva #$08 ATARI.COLOR4

      //  mwa #DLI1 ATARI.VDSLST
        pla
        };
end;

procedure vbl;assembler;interrupt;
asm {
    phr ; store registers

;   *** example test routine
;    mva 20 atari.colbk // blink background

;   *** RMT play routine
;    lda MSX
;    ldy MSX+1
;    jsr RMT.TRMT.PLAY
;    mwa #dli1 ATARI.VDSLST

    plr ; restore registers
    jmp $E462 ; jump to system VBL handler
};
end;
