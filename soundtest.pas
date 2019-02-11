{$librarypath '../Libs/lib/';'../Libs/blibs/';'../Libs/base/'}
uses atari, crt;

var
  keyval: char;
  vol: Byte = 10;
  note: Byte = 100;
  dist: Byte = 12;




  procedure playsfx(freq: Byte; vol: Byte);

  begin
    poke($D206,freq);
    poke($D207,vol);
    Delay(100);
    poke($D207,0);        
  end;



begin
  poke($d20f,3);
  poke($d208,0);

  writeln('Sound test');
  writeln('W/S - +/- volume');
  writeln('A/D - +/- note');
  writeln('Q/E - +/- Distorion');

  gotoxy(0,6);
  writeln('Volume = ',vol);
  writeln('Note = ',note);
  writeln('Distortion = ',dist);

  repeat
    pause;
    if keypressed then
    begin
      keyval:= ReadKey;
      case keyval of
        'a' : if note > 0 then Dec(note);
        'd' : if note < 255 then Inc(note);
        'w' : if vol < 15 then Inc(vol);
        's' : if vol > 0 then Dec(vol);
        'q' : if dist > 0 then Dec(dist);
        'e' : if dist < 15 then Inc(dist);
      end;
      gotoxy(0,6);
      writeln('Volume = ', vol, ' ');
      writeln('Note = ', note, ' ');
      writeln('Distortion = ', dist, ' ');
    end
    else begin
      playsfx(note,(16*dist)+vol);
      delay(500);
    end;
  until keyval = chr(27);

end.
