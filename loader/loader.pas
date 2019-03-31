{$librarypath '../../Libs/lib/';'../../Libs/blibs/';'../../Libs/base/'}
uses atari, b_crt, b_system, xbios;

const
  CHARSET_ADDRESS = $D800;
  GFX_ADDRESS = $8010;

var
  filename: TString;

begin
  // repeat
  //   pause;pause;
  //   If (color2 and %00001111 <> 0) then Dec(color2) else color2:=0;
  //   If (color1 and %00001111 <> 0) then Dec(color1) else color1:=0;
  // until (color1 or color2) = 0;


  CRT_Init(GFX_ADDRESS);
  if xBiosCheck = 0 then
  begin
  //   CRT_Init(GFX_ADDRESS);
  //   colpf1:=$1c;
  //   colpf2:=$00;
  //   // CRT_GotoXY(5,1);
  //   CRT_WriteXY(5,1,' No xBios found. Cannot load '*);
  //
  //   repeat
  //     Waitframe;
  //   until CRT_Keypressed;
  //
  end
  else begin
    SystemOff;
    filename:= 'INTRO   XEX';
    xbiosloadfile(filename);
    if xBiosIOresult <> 0 then
    begin
      CRT_GotoXY(0,2);
      CRT_WriteXY(0,2,'IOerror: '~);CRT_Write(xBiosIOerror);
    end;
    SystemReset;
  end;

end.
