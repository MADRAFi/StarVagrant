
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

procedure dli_pic1_f9;interrupt;
begin
    asm {
        phr ; store registers
        ;sta ATARI.WSYNC
        mva adr.txtcolors ATARI.colpf0
        mva #00 ATARI.colpf2
        mva #00 ATARI.colbk
        mva adr.txtcolors+1 ATARI.colpf1
        
        ;sta ATARI.WSYNC
        mva #.hi(CHARSET_ADDRESS) ATARI.chbase
;        sta ATARI.WSYNC
        
        ;mwa #dli_pic1_f1 __dlivec
    };
    // msx.play;
    asm {
        plr ; restore registers
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

procedure dli_pic2_f8;interrupt;
begin
    asm {
        phr ; store registers
        ;sta ATARI.WSYNC
        mva adr.txtcolors ATARI.colpf0
        mva #00 ATARI.colpf2
        mva #00 ATARI.colbk
        mva adr.txtcolors+1 ATARI.colpf1
        
        ;sta ATARI.WSYNC
        mva #.hi(CHARSET_ADDRESS) ATARI.chbase
;        sta ATARI.WSYNC
        
    };
    // msx.play;
    asm {

        plr ; restore registers
        };
end;


procedure dli_pic3_f1;assembler;interrupt;
    asm {
        pha ; store registers

        mva adr.gfxcolors ATARI.colpf0
        mva adr.gfxcolors+1 ATARI.colpf1
        mva adr.gfxcolors+2 ATARI.colpf2
        mva adr.gfxcolors+3 ATARI.colbk
        
        mva #.hi(CHAR_ADDRESS_PIC3_F1) ATARI.chbase

        mwa #DLI_PIC3_F2 __dlivec
        pla ; restore registers
        };
end;

procedure dli_pic3_f2;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC3_F2) ATARI.chbase

        mwa #DLI_PIC3_F3 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic3_f3;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC3_F3) ATARI.chbase

        mwa #DLI_PIC3_F4 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic3_f4;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC3_F4) ATARI.chbase

        mwa #DLI_PIC3_F5 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic3_f5;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC3_F2) ATARI.chbase

        mwa #DLI_PIC3_F6 __dlivec

        pla ; restore registers
        };
end;
procedure dli_pic3_f6;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC3_F4) ATARI.chbase

        mwa #DLI_PIC3_F7 __dlivec

        pla ; restore registers
        };
end;
procedure dli_pic3_f7;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC3_F5) ATARI.chbase

        mwa #DLI_PIC3_F8 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic3_f8;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC3_F4) ATARI.chbase

        mwa #DLI_PIC3_F9 __dlivec

        pla ; restore registers
        };
end;


procedure dli_pic3_f9;interrupt;
begin
    asm {
        phr ; store registers

        mva adr.txtcolors ATARI.colpf0
        mva #00 ATARI.colpf2
        mva #00 ATARI.colbk
        mva adr.txtcolors+1 ATARI.colpf1
        
        mva #.hi(CHARSET_ADDRESS) ATARI.chbase

    };
    // msx.play;
    asm {

        plr ; restore registers
     };
end;




procedure dli_pic4_f1;assembler;interrupt;
    asm {
        pha ; store registers

        mva adr.gfxcolors ATARI.colpf0
        mva adr.gfxcolors+1 ATARI.colpf1
        mva adr.gfxcolors+2 ATARI.colpf2
        mva adr.gfxcolors+3 ATARI.colbk
        
        mva #.hi(CHAR_ADDRESS_PIC4_F1) ATARI.chbase

        mwa #DLI_PIC4_F2 __dlivec
        pla ; restore registers
        };
end;

procedure dli_pic4_f2;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC4_F2) ATARI.chbase

        mwa #DLI_PIC4_F3 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic4_f3;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC4_F1) ATARI.chbase

        mwa #DLI_PIC4_F4 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic4_f4;assembler;interrupt;
    asm {
        pha ; store registers
        sta ATARI.WSYNC
        mva #.hi(CHAR_ADDRESS_PIC4_F2) ATARI.chbase

        mwa #DLI_PIC4_F5 __dlivec

        pla ; restore registers
        };
end;

procedure dli_pic4_f5;interrupt;
begin
    asm {
        phr ; store registers

        mva adr.txtcolors ATARI.colpf0
        mva #00 ATARI.colpf2
        mva #00 ATARI.colbk
        mva adr.txtcolors+1 ATARI.colpf1
        
        mva #.hi(CHARSET_ADDRESS) ATARI.chbase

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
  asm {
      mwa firstDLI __dlivec
      plr ; restore registers
  };
end;



////////////////////////////////////////////////////////////////////////////////
// TITLE DLI

procedure dli_title;interrupt;
begin
    asm {
        phr ; store registers
        sta ATARI.WSYNC
        mva adr.txtcolors ATARI.colpf0
        mva #00 ATARI.colpf2
        mva #00 ATARI.colbk
        mva adr.txtcolors+1 ATARI.colpf1
    };
    // msx.play;
  asm {
        plr ; restore registers
        };
end;

