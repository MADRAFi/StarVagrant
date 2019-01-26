program typtest;
{$librarypath '../Libs/lib/';'../Libs/blibs/';'../Libs/base/'}
uses atari, crt, sysutils;

const
  MAXCARGOSLOTS = 10;

type
  TShip = record
    name: string;
    size: Word;
    cargoquantity: array [0..MAXCARGOSLOTS-1] of Word;
  end;


var
  ship: TShip;
  klon: TShip;
  l: byte;

begin
  ship.name:='nazwa1';
  ship.size:=1;
  ship.cargoquantity[0]:=10;

  klon:=ship;

  for l:=0 to MAXCARGOSLOTS-1 do
  begin
    //  currentship.cargoindex[l]:= ship.cargoindex[l];
    //  currentship.cargoquantity[l]:= ship.cargoquantity[l];
    Writeln(IntToStr(klon.cargoquantity[l]));
  end;
  repeat
  until KeyPressed;

end.
