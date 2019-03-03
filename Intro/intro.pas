{$librarypath '../../Libs/lib/';'../../Libs/blibs/';'../../Libs/base/'}
uses atari, b_utils, b_system, b_crt, sysutils, rmt, xbios;

const
{$i const.inc}

{$r resources.rc}

var
  old_dli, old_vbl: pointer;
  gfxcolors: array [0..3] of Byte = (
    $10,$14,$1a,$00
  );
  piccolors: array [0..3] of Byte = (
    $10,$14,$1a,$00
  );
  msx: TRMT;
  filename: TString;


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

procedure gfx_fadein;

begin
  gfxcolors[0]:=0;
  gfxcolors[1]:=0;
  gfxcolors[2]:=0;
  gfxcolors[3]:=0;

  repeat
    Waitframes(2);
    If (gfxcolors[0] and %00001111 < piccolors[0] and %00001111 ) then Inc(gfxcolors[0]) else gfxcolors[0]:=piccolors[0];
    If (gfxcolors[1] and %00001111 < piccolors[1] and %00001111) then Inc(gfxcolors[1]) else gfxcolors[1]:=piccolors[1];
    If (gfxcolors[2] and %00001111 < piccolors[2] and %00001111) then Inc(gfxcolors[2]) else gfxcolors[2]:=piccolors[2];
    If (gfxcolors[3] and %00001111 < piccolors[3] and %00001111) then Inc(gfxcolors[3]) else gfxcolors[3]:=piccolors[3];

      // If (txtcolors[0] and %00001111 < 0 and %00001111) then inc(txtcolors[0]) else txtcolors[0]:=0;
      // If (txtcolors[1] and %00001111 < $1c and %00001111) then inc(txtcolors[1]) else txtcolors[1]:=$1c;

  until (gfxcolors[0]=piccolors[0]) and (gfxcolors[1]=piccolors[1]) and (gfxcolors[2]=piccolors[2]) and (gfxcolors[3]=piccolors[3]);
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
  //CursorOff;
  //clrscr;

  // old_dli:=pointer(0);
  // old_vbl:=pointer(0);


  //fadeoff;
//  GetIntVec(iDLI, old_dli);
//  GetIntVec(iVBL, old_vbl);
//  repeat until keypressed;

//  SetIntVec(iDLI, @dli_title1);
//  SetIntVec(iVBL, @vbl_title);
//  nmien:=$c0;

  //SDLSTL:= DISPLAY_LIST_ADDRESS_TITLE;
  fadeoff;
  SystemOff;
  SetCharset (Hi(CHARSET_ADDRESS)); // when system is off
  CRT_Init(GFX_ADDRESS);

  EnableVBLI(@vbl_title);
  EnableDLI(@dli_title1);
  Waitframe;
  DLISTL := DISPLAY_LIST_ADDRESS_TITLE;

  gfx_fadein;

  // Initialize RMT player
  msx.player:=pointer(RMT_PLAYER_ADDRESS);
  msx.modul:=pointer(RMT_MODULE_ADDRESS);
  msx.init(0);

  repeat
    waitframe;
    msx.play;
  until CRT_keypressed;
  msx.stop;

  if xBiosCheck = 0 then
  begin
  //   // SetIntVec(iDLI, old_dli);
  //   // SetIntVec(iVBL, old_vbl);
  //   // nmien := $40;
    // colpf1:=$1c;
    // colpf2:=$00;
    // CRT_GotoXY(5,1);
    // CRT_Write(' No xBios found. Cannot load '*~);

    // TODO new DLI  for text mode or write on GFX screen to  display no xbios
    repeat
      waitframe;
    until CRT_keypressed;
  //
  end
  else begin
    filename:= 'STARV   XEX';
    xbiosloadfile(filename);
  end;
  // SetIntVec(iDLI, old_dli);
  // SetIntVec(iVBL, old_vbl);
  // nmien := $40;
  //SystemReset;
end.
