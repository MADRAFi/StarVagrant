{$librarypath '../../Libs/lib/';'../../Libs/blibs/';'../../Libs/base/'}
uses atari, crt, xbios;

var
  filename: TString;

begin
  repeat
    pause;pause;
    If (color2 and %00001111 <> 0) then Dec(color2) else color2:=0;
    If (color1 and %00001111 <> 0) then Dec(color1) else color1:=0;
  until (color1 or color2) = 0;



  if xBiosCheck = 0 then
  begin
    color1:=$1c;
    color2:=$00;
    GotoXY(5,1);
    Write(' No xBios found. Cannot load '*);

    repeat
      pause;
    until Keypressed;

  end
  else begin
    filename:= 'intro   XEX';
    xbiosloadfile(filename);
    if xBiosIOresult <> 0 then
    begin
      Write('IOerror: '~);Write(xBiosIOerror);
    end;
  end;
end.
