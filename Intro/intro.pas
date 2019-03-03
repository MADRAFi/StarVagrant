{$librarypath '../../Libs/lib/';'../../Libs/blibs/';'../../Libs/base/'}
uses atari, crt, sysutils, rmt, xbios;

const
{$i const.inc}

{$r resources.rc}

var
  old_dli, old_vbl: pointer;
  gfxcolors: array [0..3] of Byte = (
    $1a,$14,$10,$00
  );
  main: TString;


{$i interrupts.inc}

procedure fadeoff;
begin
    repeat
      Delay(50);
      If (color2 and %00001111 <> 0) then Dec(color2) else color2:=0;
      If (color1 and %00001111 <> 0) then Dec(color1) else color1:=0;
    until (color1 or color2) = 0;
end;


begin
  CursorOff;
  clrscr;
  GetIntVec(iDLI, old_dli);
  GetIntVec(iVBL, old_vbl);
  //writeln('Loading...');
  fadeoff;
//  repeat until keypressed;


  //savmsc:= GFX_ADDRESS;


  SetIntVec(iDLI, @dli_title1);
  SetIntVec(iVBL, @vbl_title);

  SDLSTL:= DISPLAY_LIST_ADDRESS_TITLE;

  nmien:=$c0;


  repeat
    pause;
  until keypressed;

  SetIntVec(iDLI, old_dli);
  SetIntVec(iVBL, old_vbl);
  nmien := $40;

  // main:= 'STARV   XEX';
  // xbiosloadfile(main);

end.
