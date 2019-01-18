uses crt, atari;

var x,y: byte;

begin

for x:=1 to 30 do
  begin
    for y:=1 to 30 do
      write('#');
    writeln;
  end;

 repeat
 case vcount of
  10: COLCRS:=$26;
  20: COLCRS:=$36;
  30: COLCRS:=$46;
 end;

 until keypressed;

end.
