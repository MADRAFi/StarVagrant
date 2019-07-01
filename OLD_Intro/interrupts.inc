////////////////////////////////////////////////////////////////////////////////
// TITLE DLI

procedure dli_title1;assembler;interrupt;

  asm {
        phr
        sta ATARI.WSYNC

        mva adr.gfxcolors ATARI.colpf0
        mva adr.gfxcolors+1 ATARI.colpf1
        mva adr.gfxcolors+2 ATARI.colpf2
        mva adr.gfxcolors+3 ATARI.colbk

        plr
  };
end;


procedure vbl_title;interrupt;
begin
  asm {
        phr ; store registers
        ;inc 20
  };
  if music then msx.play;

  asm {
      ; mwa #DLI_TITLE1 ATARI.VDSLST
      plr ; restore registers
  };
end;
