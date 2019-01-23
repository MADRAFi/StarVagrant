program SystemOff_test;
{$librarypath '../Libs/lib/';'../Libs/blibs/';'../Libs/base/'}
uses atari, b_utils, b_system, b_crt, sysutils;


const
FREE_TOP = $4000;
CHARSET_ADDRESS = FREE_TOP;
DISPLAY_LIST_ADDRESS_MENU = CHARSET_ADDRESS + $400;
DISPLAY_LIST_ADDRESS_CONSOLE = DISPLAY_LIST_ADDRESS_MENU + $100;
TXT_ADDRESS = $5000;
SCROLL_ADDRESS = TXT_ADDRESS + $400; //$F0;
GFX_ADDRESS = $8000;


type
{$i 'types.inc'}
{$r 'systemoff_res.rc'}

var
    oldvbl, olddli: pointer;


{$i 'interrupts.inc'}

{
--------------------------------------------------------------------------------
MAIN LOOP
--------------------------------------------------------------------------------
}

begin
  SystemOff;
  SetCharset (Hi(CHARSET_ADDRESS)); // when system is off
  // savmsc:= TXT_ADDRESS;
  // Waitframe;
  // SDLSTL := DISPLAY_LIST_ADDRESS_MENU;
  //
  // GetIntVec(iVBL, oldvbl);
  // GetIntVec(iDLI, olddli);
  // nmien:= $c0;
  // //
  //  SetIntVec(iDLI, @dli1);
  //  SetIntVec(iVBL, @vbl);
  //

  //

  lmargin:= 0;
  rmargin:= 0;


  CRT_Init;
  CRT_WriteCentered('Loading...'~);

  repeat
  until CRT_Keypressed;

  // restore system
  // SetIntVec(iVBL, oldvbl);
  // SetIntVec(iDLI, olddli);
  // nmien:= $40;
end.
