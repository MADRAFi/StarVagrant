
procedure dli_f1;assembler;interrupt;
    asm {
        pha ; store registers

        mva adr.gfxcolors ATARI.colpf0
        mva adr.gfxcolors+1 ATARI.colpf1
        mva adr.gfxcolors+2 ATARI.colpf2
        mva adr.gfxcolors+3 ATARI.colbk
        
        mva #.hi(CHARSET_ADDRESS1) ATARI.chbase

        mwa #DLI_F2 __dlivec
        pla ; restore registers
        };
end;

procedure dli_f2;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHARSET_ADDRESS2) ATARI.chbase

        mwa #DLI_F3 __dlivec

        pla ; restore registers
        };
end;

procedure dli_f3;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHARSET_ADDRESS1) ATARI.chbase

        mwa #DLI_F4 __dlivec

        pla ; restore registers
        };
end;

procedure dli_f4;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHARSET_ADDRESS2) ATARI.chbase

        mwa #DLI_F5 __dlivec

        pla ; restore registers
        };
end;

procedure dli_f5;interrupt;
begin
    asm {
        phr ; store registers

        mva adr.txtcolors ATARI.colpf0
        mva #00 ATARI.colpf2
        mva #00 ATARI.colbk
        mva adr.txtcolors+1 ATARI.colpf1
        
        mva #.hi(CHARSET_ADDRESS3) ATARI.chbase

    };
    // msx.play;
    asm {

        plr ; restore registers
        };
end;


procedure vbl:interrupt;
begin
  asm {
      phr ; store registers
  };
  if music then msx.play;
//   msx.play;
  asm {
      mwa firstDLI __dlivec
      plr ; restore registers
  };
end;


