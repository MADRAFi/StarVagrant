////////////////////////////////////////////////////////////////////////////////
// TITLE DLI

procedure dli_title1;assembler;interrupt;
// $10
// $14
// $1A
// $00 -
    asm {
        pha
        sta ATARI.WSYNC

    ;    mva #$1A ATARI.colpf0
    ;    mva #$14 ATARI.colpf1
    ;    mva #$10 ATARI.colpf2
    ;    mva #$00 ATARI.colpf3
    ;    sta ATARI.colbk
            mva adr.gfxcolors ATARI.colpf0
            mva adr.gfxcolors+1 ATARI.colpf1
            mva adr.gfxcolors+2 ATARI.colpf2
            mva adr.gfxcolors+3 ATARI.colbk

;        lda #60
;@       cmp vcount
;        bpl @-
;        mva #$00 ATARI.colpf2
        mwa #DLI_TITLE2 __dlivec
        pla
        };
end;

procedure dli_title2;assembler;interrupt;
    asm {
        pha
        sta ATARI.WSYNC
        ;mva #$00 ATARI.colbk
;       mva #$00 ATARI.colpf0
        mva adr.txtcolors ATARI.colpf0
        sta ATARI.colpf2
        ;mva #$00 ATARI.colpf3
        sta ATARI.colbk
;        mva #$0c ATARI.colpf1
        mva adr.txtcolors+1 ATARI.colpf1
        mwa #DLI_TITLE3 __dlivec
        pla
        };
end;

procedure dli_title3;assembler;interrupt;
    asm {
        pha
        mva #$06 ATARI.colpf1
        :3 sta ATARI.WSYNC
        mva #$08 ATARI.colpf1
        sta ATARI.WSYNC
        mva #$0a ATARI.colpf1
        sta ATARI.WSYNC
        mva #$0c ATARI.colpf1
        sta ATARI.WSYNC
        mva #$0a ATARI.colpf1
        sta ATARI.WSYNC
        mva #$08 ATARI.colpf1
        pla
        };
end;


procedure vbl_title;interrupt;
var
  count: byte = 3;
  offset: byte = 0;

begin
  asm {
        phr ; store registers
  };
    if count = $ff then begin // $ff is one below zero
        count := 3;
        Inc(offset);
        if offset=140 then offset:= 0;  // 140 = 2x string size
        dpoke(DISPLAY_LIST_ADDRESS_TITLE + 114, SCROLL_ADDRESS + offset); // 114 bytes for DLI lines
    end;

    hscrol := count; // set hscroll
    dec(count);

  //msx.play;

  asm {

    ;   *** example test routine
    ;    mva 20 atari.colbk // blink background

    ;   *** RMT play routine
    ;    lda MSX
    ;    ldy MSX+1
    ;    jsr RMT.TRMT.PLAY

      mwa #DLI_TITLE1 __dlivec
      plr ; restore registers
  };
end;


////////////////////////////////////////////////////////////////////////////////
// Main DLI



procedure dli1;assembler;interrupt;
  asm {
        pha
        sta ATARI.WSYNC

        mva adr.gfxcolors ATARI.colpf0
        mva adr.gfxcolors+1 ATARI.colpf1
        mva adr.gfxcolors+2 ATARI.colpf2
        mva adr.gfxcolors+3 ATARI.colbk

        mwa #DLI2 __dlivec
        pla
  };

end;

procedure dli2;assembler;interrupt;
    asm {
        pha
        sta ATARI.WSYNC
        mva #$00 ATARI.colbk
        sta ATARI.colpf0
        sta ATARI.colpf2
        sta ATARI.colpf3
        mva #$0c ATARI.colpf1
        pla
        };
end;

procedure vbl;interrupt;
begin
  asm {
        pha ; store registers
  };

  //msx.play;

  asm {
    ;   *** example test routine
    ;    mva 20 atari.colbk // blink background

    ;   *** RMT play routine
    ;    lda MSX
    ;    ldy MSX+1
    ;    jsr RMT.TRMT.PLAY

      ;mwa #dli1 ATARI.VDSLST
      mwa #DLI1 __dlivec

      pla ; restore registers
  };
end;



////////////////////////////////////////////////////////////////////////////////
// Console DLI

procedure dli_console;assembler;interrupt;
    asm {
        pha
        sta ATARI.WSYNC
        mva #$06 ATARI.colbk
        sta ATARI.colpf2
        mva #$02 ATARI.colpf1
        pla
        };
end;

procedure vbl_console;interrupt;
begin
  asm {
      pha ; store registers
  };
  //msx.play;
  asm {
      mwa #dli_console __dlivec
      pla ; restore registers
  };
end;
