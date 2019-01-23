program SystemOff_test;
{$librarypath '../LIBS/lib/';'../LIBS/blibs/';'../LIBS/base/'}
uses atari, b_utils, b_system, b_crt, sysutils;


const
CHARSET_ADDRESS = $4000;
DISPLAY_LIST_ADDRESS_MENU = CHARSET_ADDRESS + $400;
DISPLAY_LIST_ADDRESS_CONSOLE = DISPLAY_LIST_ADDRESS_MENU + $100;
TXT_ADDRESS = $5000;
SCROLL_ADDRESS = TXT_ADDRESS + $400; //$F0;
GFX_ADDRESS = $8000;


{$r 'systemoff_res.rc'}

var
    oldvbl, olddli: pointer;


procedure dlic;assembler;interrupt;
    asm {
        pha
        sta ATARI.WSYNC
        mva #$06 ATARI.colbk
        ;mva #$00 ATARI.colpf0
        mva #$02 ATARI.colpf1
        mva #$06 ATARI.colpf2
        ;mva #$00 ATARI.colpf3
        pla
        };
end;

procedure vblc;interrupt;
begin
  asm {
      phr ; store registers
      mwa #dlic ATARI.VDSLST
      plr ; restore registers
  };
end;

{
--------------------------------------------------------------------------------
MAIN LOOP
--------------------------------------------------------------------------------
}

begin
  SystemOff;
  SetCharset (Hi(CHARSET_ADDRESS)); // when system is off
  CRT_Init(TXT_ADDRESS);
  DLISTL:= DISPLAY_LIST_ADDRESS_CONSOLE;

  EnableVBLI(@vblc);
  EnableDLI(@dlic);


  CRT_WriteCentered('Loading...'~);

  repeat
  until CRT_Keypressed;

  // restore system
    DisableDLI;
    DisableVBLI;
    SystemReset;
end.
