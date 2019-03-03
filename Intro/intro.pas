{$librarypath '../../Libs/lib/';'../../Libs/blibs/';'../../Libs/base/'}
uses atari, crt, sysutils, rmt, xbios;

const
{$i const.inc}

{$r resources.rc}

var
  old_dli, old_vbl: pointer;
  gfxcolors: array [0..3] of Byte = (
    $10,$14,$1a,$00
  );

  main: TString;


{$i interrupts.inc}

procedure fadeoff;
begin
    repeat
  //    Delay(50);
      pause;pause;
      If (color2 and %00001111 <> 0) then Dec(color2) else color2:=0;
      If (color1 and %00001111 <> 0) then Dec(color1) else color1:=0;
    until (color1 or color2) = 0;
     //  If (colpf2 and %00001111 <> 0) then Dec(colpf2) else colpf2:=0;
     //  If (colpf1 and %00001111 <> 0) then Dec(colpf1) else colpf1:=0;
     // until (colpf1 or colpf2) = 0;
end;

// procedure putNumber2(x,y:byte;num:TString);
// var dest:word;
// begin
//     dest:=GFX_ADDRESS+(y*40)+x;
//     for i:=1 to byte(num[0]) do begin
//         Dpoke(dest,txt_numbers[byte(num[i])-48]);
//         Inc(dest,2);
//     end
// end;


begin
  CursorOff;
  // old_dli:=pointer(0);
  // old_vbl:=pointer(0);

  clrscr;
  fadeoff;
  GetIntVec(iDLI, old_dli);
  GetIntVec(iVBL, old_vbl);
//  repeat until keypressed;

  SetIntVec(iDLI, @dli_title1);
  SetIntVec(iVBL, @vbl_title);
  nmien:=$c0;

  SDLSTL:= DISPLAY_LIST_ADDRESS_TITLE;


  repeat
    pause;
  until keypressed;

  // if xBiosCheck = 0 then
  // begin
  //   // SetIntVec(iDLI, old_dli);
  //   // SetIntVec(iVBL, old_vbl);
  //   // nmien := $40;
  //   // color1:=White;
  //   // color2:=black;
  //   // GotoXY(5,1);
  //   // Writeln(' No xBios found. Cannot load '*);
  //   // repeat
  //   //   pause;
  //   // until keypressed;
  //
  // end
  // else begin
  //   // main:= 'STARV   XEX';
  //   // xbiosloadfile(main);
  // end;
  SetIntVec(iDLI, old_dli);
  SetIntVec(iVBL, old_vbl);
  nmien := $40;
end.
