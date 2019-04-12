////////////////////////////////////////////////////////////////////////////////
// TITLE DLI

procedure dli_title1;assembler;interrupt;

    asm {
        pha
        sta ATARI.WSYNC

        mva adr.gfxcolors ATARI.colpf0
        mva adr.gfxcolors+1 ATARI.colpf1
        mva adr.gfxcolors+2 ATARI.colpf2
        mva adr.gfxcolors+3 ATARI.colbk

;        mwa #DLI_TITLE2 __dlivec
        pla
        };
end;

procedure dli_title2;assembler;interrupt;
    asm {
        pha
        sta ATARI.WSYNC
        ;mva #$00 ATARI.colbk
;       mva #$00 ATARI.colpf0
;        mva adr.txtcolors ATARI.colpf0
        sta ATARI.colpf2
        ;mva #$00 ATARI.colpf3
        sta ATARI.colbk
;        mva #$0c ATARI.colpf1
;        mva adr.txtcolors+1 ATARI.colpf1
;        mwa #DLI_TITLE3 __dlivec
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
begin
  asm {
        phr ; store registers
  };

  // msx.play;
  asm {
      mwa #DLI_TITLE1 ATARI.VDSLST
      plr ; restore registers
  };
end;
