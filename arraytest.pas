program arraytest;
{$librarypath '../Libs/lib/';'../Libs/blibs/';'../Libs/base/'}

uses crt, sysutils;

const
  MAXCARGOSLOTS = 10;

type
  TShip = record
    sname: string;//Byte;
    scu_max: Word;
    scu: Word;
    cargoindex: array [0..MAXCARGOSLOTS-1] of Word;
    cargoquantity: array [0..MAXCARGOSLOTS-1] of Word;
  end;

var
  ship: TShip;
  x,l: byte;
  tmp : Word;

begin
  Writeln('Start.');

  ship.cargoindex[0]:=10;
  ship.cargoindex[1]:=20;
  ship.cargoindex[2]:=0;
  ship.cargoindex[3]:=40;
  ship.cargoindex[4]:=50;
  ship.cargoindex[5]:=0;
  ship.cargoindex[6]:=70;
  ship.cargoindex[7]:=80;
  ship.cargoindex[8]:=0;
  ship.cargoindex[9]:=100;

  ship.cargoquantity[0]:=10;
  ship.cargoquantity[1]:=10;
  ship.cargoquantity[2]:=0;
  ship.cargoquantity[3]:=10;
  ship.cargoquantity[4]:=10;
  ship.cargoquantity[5]:=0;
  ship.cargoquantity[6]:=10;
  ship.cargoquantity[7]:=10;
  ship.cargoquantity[8]:=0;
  ship.cargoquantity[9]:=10;

  for x:=0 to High(ship.cargoindex) do
  begin
    writeln('cargoindex[',x,']=',ship.cargoindex[x],'          ','cargoquantity[',x,']=',ship.cargoquantity[x]);
  end;

  Writeln('');
  Writeln('Przesuniecie.');

  for x:=0 to High(ship.cargoindex) do
  begin
    if ship.cargoquantity[x] = 0 then
    begin
      for l:=x to High(ship.cargoindex) do
      begin
        if (l < High(ship.cargoindex)) then
        begin
          ship.cargoindex[l]:=ship.cargoindex[l+1];
          ship.cargoquantity[l]:=ship.cargoquantity[l+1];
        end
        ELSE
        BEGIN
          ship.cargoindex[l]:=0;
          ship.cargoquantity[l]:=0;
        END;


      end;
    end;
  end;

  for x:=0 to High(ship.cargoindex) do
  begin
    writeln('cargoindex[',x,']=',ship.cargoindex[x],'          ','cargoquantity[',x,']=',ship.cargoquantity[x]);
  end;


  repeat

  until keypressed;
end.
