
procedure dli1;assembler;interrupt;
    asm {
        pha
        sta ATARI.WSYNC
        mva #$0c ATARI.colpf0
        mva #$06 ATARI.colpf1
        mva #$02 ATARI.colpf2
        mva #$0c ATARI.colpf3
        mva #$00 ATARI.colbk
        lda #60
@       cmp vcount
        bpl @-
        mva #$00 ATARI.colpf2
        ;mwa #DLI2 ATARI.VDSLST
        mwa #DLI2 __dlivec
        pla
        };
end;

procedure dli2;assembler;interrupt;
    asm {
        pha
        sta ATARI.WSYNC
        ;mva #$00 ATARI.colbk
        mva #$00 ATARI.colpf0
        mva #$0c ATARI.colpf1
        mva #$00 ATARI.colpf2
        mva #$00 ATARI.colpf3
        ;mwa #DLI3 ATARI.VDSLST
        mwa #DLI3 __dlivec
        pla
        };
end;

procedure dli3;assembler;interrupt;
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

procedure vbl;interrupt;
var
  count: byte = 3;
  offset: byte = 0;

begin
  asm {
        phr ; store registers
  };
    if count = $ff then begin // $ff is one below zero
        count := 3;
        offset := (offset + 1) mod 140;  // 140 = 2x string size
        dpoke(DISPLAY_LIST_ADDRESS_MENU + 114, SCROLL_ADDRESS + offset); // 114 bytes for DLI lines
    end;

    hscrol := count; // set hscroll
    dec(count);

  //msx.play;
  //Waitframe;
  asm {
    ;   *** example test routine
    ;    mva 20 atari.colbk // blink background

    ;   *** RMT play routine
    ;    lda MSX
    ;    ldy MSX+1
    ;    jsr RMT.TRMT.PLAY

      ;mwa #dli1 ATARI.VDSLST
      mwa #DLI1 __dlivec

      plr ; restore registers
  };
end;

////////////////////////////////////////////////////////////////////////////////
// Console DLI

procedure dlic;assembler;interrupt;
    asm {
        pha
        sta ATARI.WSYNC
        mva #$06 ATARI.colbk
        ;mva #$00 ATARI.colpf0
        mva #$02 ATARI.colpf1
        ;;mva #$c8 ATARI.colpf1
        mva #$06 ATARI.colpf2
        ;;mva #$f4 ATARI.colpf2
        ;mva #$00 ATARI.colpf3
        pla
        };
end;

procedure vblc;interrupt;
begin
  asm {
      phr ; store registers
      mwa #dlic ATARI.VDSLST
      ;mwa #dlic __dlivec
      plr ; restore registers
  };
end;
