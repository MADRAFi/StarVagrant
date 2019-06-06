////////////////////////////////////////////////////////////////////////////////
// TITLE DLI

procedure dli_pic1_f1;assembler;interrupt;

    asm {
        pha ; store registers
        ;sta ATARI.WSYNC
        mva adr.gfxcolors ATARI.colpf0
        mva adr.gfxcolors+1 ATARI.colpf1
        mva adr.gfxcolors+2 ATARI.colpf2
        mva adr.gfxcolors+3 ATARI.colbk
        
        ;sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC1_F1) ATARI.chbase

        mwa #dli_pic1_f2 __dlivec
        pla ; restore registers
        };
end;

procedure dli_pic1_f2;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC1_F2) ATARI.chbase

        mwa #dli_pic1_f3 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic1_f3;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC1_F3) ATARI.chbase

        mwa #dli_pic1_f4 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic1_f4;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC1_F4) ATARI.chbase

        mwa #dli_pic1_f5 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic1_f5;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC1_F5) ATARI.chbase

        mwa #dli_pic1_f6 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic1_f6;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC1_F6) ATARI.chbase

        mwa #dli_pic1_f7 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic1_f7;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC1_F7) ATARI.chbase

        mwa #dli_pic1_f8 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic1_f8;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC1_F8) ATARI.chbase

        mwa #dli_pic1_f9 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic1_f9;assembler;interrupt;
    asm {
        pha ; store registers
        ;sta ATARI.WSYNC
        mva adr.txtcolors ATARI.colpf0
        mva #00 ATARI.colpf2
        mva #00 ATARI.colbk
        mva adr.txtcolors+1 ATARI.colpf1
        
        ;sta ATARI.WSYNC
        mva #.hi(CHARSET_ADDRESS) ATARI.chbase
;        sta ATARI.WSYNC
        
        mwa #dli_pic1_f1 __dlivec

        pla ; restore registers
        };
end;


procedure dli_pic2_f1;assembler;interrupt;

    asm {
        pha ; store registers
        ;sta ATARI.WSYNC
        mva adr.gfxcolors ATARI.colpf0
        mva adr.gfxcolors+1 ATARI.colpf1
        mva adr.gfxcolors+2 ATARI.colpf2
        mva adr.gfxcolors+3 ATARI.colbk
        
        ;sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC2_F1) ATARI.chbase

        mwa #dli_pic2_f2 __dlivec
        pla ; restore registers
        };
end;

procedure dli_pic2_f2;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC2_F2) ATARI.chbase

        mwa #dli_pic2_f3 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic2_f3;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC2_F3) ATARI.chbase

        mwa #dli_pic2_f4 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic2_f4;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC2_F4) ATARI.chbase

        mwa #dli_pic2_f5 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic2_f5;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC2_F5) ATARI.chbase

        mwa #dli_pic2_f6 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic2_f6;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC2_F6) ATARI.chbase

        mwa #dli_pic2_f7 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic2_f7;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC2_F7) ATARI.chbase

        mwa #dli_pic2_f8 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic2_f8;assembler;interrupt;
    asm {
        pha ; store registers
        ;sta ATARI.WSYNC
        mva adr.txtcolors ATARI.colpf0
        mva #00 ATARI.colpf2
        mva #00 ATARI.colbk
        mva adr.txtcolors+1 ATARI.colpf1
        
        ;sta ATARI.WSYNC
        mva #.hi(CHARSET_ADDRESS) ATARI.chbase
;        sta ATARI.WSYNC
        
        mwa #dli_pic2_f1 __dlivec

        pla ; restore registers
        };
end;


procedure vbl_pic;interrupt;
begin
  asm {
        phr ; store registers
  };
  if music then msx.play;

  asm {
      ;mwa #dli_pic1_f1 __dlivec
      plr ; restore registers
  };
end;

procedure dli_title;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva adr.txtcolors ATARI.colpf0
        mva #00 ATARI.colpf2
        mva #00 ATARI.colbk
        mva adr.txtcolors+1 ATARI.colpf1
        
        ;sta ATARI.WSYNC
        mva #.hi(CHARSET_ADDRESS) ATARI.chbase
;        sta ATARI.WSYNC

        pla ; restore registers
        };
end;
