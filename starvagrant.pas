program StarVagrant;
{$librarypath '../Libs/lib/';'../Libs/blibs/';'../Libs/base/'}
//{$librarypath 'Libs/lib/';'Libs/blibs/';'Libs/base/'}
// {$librarypath '../blibs/'}
uses atari, b_utils, b_system, b_crt, sysutils, xbios; //, mad_xbios;

const
{$i 'const.inc'}

  CURRENCY = ' UEC';
  CARGOUNIT = ' SCU';
  DISTANCE = ' DU';
  COMMISSION = 0.03;

type
{$i 'types.inc'}
{$r 'resources.rc'}

var
  //commission: shortreal = 0.05;
  keyval : Byte = 0;
  player: TPlayer; // player
  ship: TShip; // player's ship
  currentship:TShip; // temp ship for operations
  newLoc: Byte; // new Location (destination)
  tstr : TString; // string used in various routines.
  strnum: TString; // string used in various routines to display numbers
  txt: String; // Some strings
  offset: Word; // offset counted to get items from arrays
  y: Byte; // index for loops
  count: Byte; // count in item iterations
  //msx: TRMT;
  current_menu: Byte;

//number of ship variables equals NUMBEROFSHIPS
//  tshp : ^TShip;

  ship0: TShip;
  ship1: TShip;
  ship2: TShip;
  ship3: TShip;
  ship4: TShip;
  ship5: TShip;
  ship6: TShip;
  ship7: TShip;
  ship8: TShip;
  ship9: TShip;
  ship10: TShip;
  ship11: TShip;

  shipmatrix: array [0..NUMBEROFSHIPS-1] of pointer = (@ship0, @ship1, @ship2, @ship3, @ship4, @ship5, @ship6, @ship7, @ship8, @ship9, @ship10, @ship11);

{$i 'ships.inc'}

  (*
  * 0 - colpf0
  * 1 - colpf1
  * 2 - colpf2
  * 3 - colbk
  *)
  piccolors: array [0..(4*NUMBEROFLOCATIONS)-1] of Byte = (
    $1a,$14,$10,$00,    // 0
    $10,$14,$1c,$00,    // 1
    $1a,$14,$10,$00,    // 2
    $90,$96,$9c,$00,    // 3
    $1a,$14,$10,$00,    // 4
    $1a,$14,$10,$00,    // 5
    $1a,$14,$10,$00,    // 6
    $1a,$14,$10,$00,    // 7
    $d0,$d4,$dc,$00,    // 8
    $1a,$14,$10,$00,    // 9
    $1a,$14,$10,$00,    // 10
    $1a,$14,$10,$00,    // 11
    $1a,$14,$10,$00,    // 12
    $1a,$14,$10,$00,    // 13
    $1a,$14,$10,$00,    // 14
    $1a,$14,$10,$00,    // 15
    $1a,$14,$10,$00     // 16
  );

// current gfx colors
  gfxcolors: array [0..3] of Byte = (
    $1a,$14,$10,$00
  );

  strings: array [0..0] of Word absolute STRINGS_ADDRESS;
  locations: array [0..0] of Word absolute LOCATIONS_ADDRESS;
  items: array [0..0] of Word absolute ITEMS_ADDRESS;
  //ships: array [0..0] of Word absolute SHIPS_ADDRESS;

  itemprice: array [0..(NUMBEROFLOCATIONS * NUMBEROFITEMS)-1] of Word = (
  0,0,0,0,83,43,0,25,69,30,0,61,0,0,281,170,0,0,0,34,83,39,1,0,
  256,0,116,0,83,43,0,0,69,30,0,61,0,0,0,180,0,0,10,0,0,39,1,150,
  0,0,118,0,0,0,15,0,0,30,16,0,13,15,0,178,14,0,0,34,0,0,0,160,
  0,12,97,0,0,0,17,0,0,30,0,0,11,0,0,180,14,0,0,34,0,0,1,146,
  245,0,118,0,0,42,0,0,0,30,0,57,0,0,0,178,14,13,0,34,0,37,1,240,
  243,0,118,0,0,31,0,24,0,30,0,0,0,0,0,178,14,12,0,34,0,35,0,240,
  0,35,0,0,0,0,17,0,0,20,0,0,15,0,0,0,10,0,0,22,0,0,3,0,
  0,31,0,22,0,42,0,0,0,0,0,68,0,0,0,176,0,0,8,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,34,15,0,8,13,0,0,10,0,0,24,0,0,3,0,
  225,0,0,0,0,0,0,22,39,0,0,0,0,16,0,0,14,21,18,0,0,0,2,0,
  225,26,0,0,0,0,0,27,0,27,18,0,14,10,0,0,0,21,20,0,0,0,1,249,
  205,0,125,0,78,49,0,0,46,38,0,61,0,0,291,195,0,0,0,0,78,47,0,280,
  0,0,0,22,73,38,0,0,44,36,0,61,0,0,291,181,0,0,20,0,89,47,0,249,
  0,0,118,12,0,42,10,0,39,37,0,0,0,0,0,181,14,0,0,0,0,0,1,249,
  0,26,118,12,0,0,0,0,0,37,0,56,0,0,0,181,14,0,0,0,0,0,1,249,
  0,26,0,0,0,0,10,23,0,0,22,61,11,10,271,0,14,33,0,0,89,0,0,240,
  0,0,0,22,0,0,11,25,0,40,24,0,12,16,281,185,16,0,0,36,99,0,0,0

  );  // price matrix for items
  itemquantity: array [0..(NUMBEROFLOCATIONS * NUMBEROFITEMS)-1] of Word = (
  0,0,0,0,5000,5000,0,5000,0,1000,0,0,0,0,0,5000,0,0,0,5000,2000,0,10000,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000,0,
  0,0,0,0,0,0,5000,0,0,0,5000,0,2500,2500,0,0,0,0,0,0,0,0,10000,0,
  0,2500,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000,1000,
  5000,0,0,0,0,2500,0,0,0,0,0,5000,0,0,0,0,0,2500,0,0,0,5000,10000,0,
  2500,0,0,0,0,2500,0,2500,0,0,0,0,0,0,0,0,0,5000,0,0,0,2500,10000,0,
  0,0,0,0,0,0,0,0,0,5000,0,0,2500,0,0,0,5000,0,0,2500,0,0,0,0,
  0,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,2500,0,0,5000,0,0,0,10000,0,
  0,0,0,0,0,0,0,0,0,2500,500,0,2500,2500,0,0,5000,0,0,2500,0,0,10000,0,
  5000,0,0,0,0,0,0,1500,0,0,0,0,0,1000,0,0,0,0,5000,0,0,0,10000,0,
  0,2500,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2500,0,0,0,10000,0,
  5000,0,0,0,5000,5000,0,0,5000,100,0,500,0,0,5000,1000,0,0,0,0,5000,2000,0,0,
  1000,0,0,0,1000,1000,0,0,1000,1000,0,1000,0,0,1000,1000,0,0,0,0,1000,1000,0,0,
  0,0,0,5000,0,0,0,0,2500,0,0,0,0,0,0,0,0,0,0,0,0,0,10000,0,
  0,500,0,5000,0,0,0,0,0,0,0,5000,0,0,0,0,0,0,0,0,0,0,10000,0,
  0,5000,0,0,0,0,5000,5000,0,0,5000,0,5000,5000,2500,0,2500,5000,0,0,0,0,0,0,
  0,0,0,500,0,0,500,500,0,500,500,0,500,500,500,500,500,0,0,500,500,0,0,0

  ); // quantities of items

  locationdistance: array[0..(NUMBEROFLOCATIONS * NUMBEROFLOCATIONS)-1] of Word =
  (
  0,50,0,0,0,0,0,0,60,0,0,365,120,0,0,50,50,
  50,0,20,30,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,20,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,
  0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,30,0,0,0,0,0,0,0,0,
  60,0,0,0,0,0,0,30,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,50,0,60,0,0,0,0,
  0,0,0,0,0,0,0,0,0,50,0,0,0,0,0,0,0,
  365,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  120,0,0,0,0,0,0,0,0,60,0,0,0,10,70,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,70,0,0,0,0,
  50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  50,0,0,0,20,30,0,0,0,0,0,0,0,0,0,0,0

  );

  availableitems: array [0..(MAXAVAILABLEITEMS-1)] of Word; // only 12 avaiable items
  availabledestinations: array [0..(MAXAVAILABLEDESTINATIONS-1)] of Word; // only 6 available destinations



{$i 'interrupts.inc'}


procedure sfx_play(channel: Word; freq: Byte; vol: Byte );

begin
  poke(channel,freq);
  poke(channel+1,vol);
  waitframes(5);
  poke(channel+1,0);
end;

procedure sfx_init;
begin
  // sound init at pokey
  poke($d20f,3);
  poke($d208,0);
end;

procedure writeRuler;
begin
    CRT_Write('--------------------+-------------------'~);
    sfx_play(voice4,77,200); // vol8
end;

procedure WriteSpaces(len:byte);
begin
  CRT_Write(Atascii2Antic(Space(len)));
end;

procedure WriteFF(var ptr:word);
begin
    CRT_Write(FFTermToString(ptr));
end;

procedure CRT_ClearRows(start: Byte;num: Byte);
begin
  for y:=start to num do
    CRT_ClearRow(y);
end;


procedure eraseArray(min: Byte; max: Byte; arrptr: Pointer); //forward does not work
//procedure eraseArray(min: Byte; max: Byte; a: array [0..0] of Word);
var
  a: array [0..0] of Word;

begin
  if (min < max) then
  begin
    a:=arrptr;
    fillbyte(a[min],(max-min) shl 2,0); // x2 becasue Word type (2 bytes)
  end;
end;

procedure piclocation_openfile;

begin
  if (newLoc < 10) then tstr:=concat('LOC0',IntToStr(newLoc))
  else tstr:=concat('LOC',inttostr(newLoc));
  tstr:=concat(tstr,'   DAT');

  if xBiosCheck = 0 then
  begin
    CRT_GotoXY(0,5);
    //CRT_Write('xBios not found at address: $'~); CRT_Write(HexStr(xBIOS_ADDRESS,4));
    WriteFF(strings[25]); // no xBios
  end
  else begin
    xBiosOpenFile(tstr);
  end;

end;

procedure piclocation_load;

begin
  newLoc:=player.loc;
  piclocation_openfile;

  //if (xBiosCheck = 1) and (xBiosIOresult = 0) then
  if (xBiosCheck <> 0) and (xBiosIOresult = 0) then
  begin
    xBiosLoadData(Pointer(GFX2_ADDRESS));
    xBiosFlushBuffer;
  end

end;


procedure generateWorld;

begin
    // for y:=0 to NUMBEROFSHIPS-1 do
    // begin
    //   txt:=FFTermToString(ships[y]);
    //   tshp:=shipmatrix[y];
    //   tshp^.sname:=txt;
    // end;

    ship0.manufacture:=prodmatrix[ARGO];
    ship0.sname:=ships[0];
    //move(@txt, @ship0.sname, byte(txt[0])+1);
    ship0.scu_max:=10;

    ship1.manufacture:=prodmatrix[DRAK];
    ship1.sname:=ships[1];
    ship1.scu_max:=46;

    ship2.manufacture:=prodmatrix[RSI];
    ship2.sname:=ships[2];
    ship2.scu_max:=96;

    ship3.manufacture:=prodmatrix[MISC];
    ship3.sname:=ships[3];
    ship3.scu_max:=122;

    ship4.manufacture:=prodmatrix[AEGIS];
    ship4.sname:=ships[4];
    ship4.scu_max:=180;

    ship5.manufacture:=prodmatrix[MISC];
    ship5.sname:=ships[5];
    ship5.scu_max:=384;

    ship6.manufacture:=prodmatrix[DRAK];
    ship6.sname:=ships[6];
    ship6.scu_max:=577;

    ship7.manufacture:=prodmatrix[CRSD];
    ship7.sname:=ships[7];
    ship7.scu_max:=624;

    ship8.manufacture:=prodmatrix[AEGIS];
    ship8.sname:=ships[8];
    ship8.scu_max:=995;

    ship9.manufacture:=prodmatrix[ANVL];
    ship9.sname:=ships[9];
    ship9.scu_max:=1000;

    ship10.manufacture:=prodmatrix[BANU];
    ship10.sname:=ships[10];
    ship10.scu_max:=3584;

    ship11.manufacture:=prodmatrix[MISC];
    ship11.sname:=ships[11];
    ship11.scu_max:=4608;

end;


procedure start;

begin
  player.uec:= STARTUEC;
  if player.loc <> 0  then
  begin
    player.loc:= STARTLOCATION;
    newLoc:=0;
    piclocation_load;
  end;

  //mocap starting ship
  // ship.sname:= 'Cuttlas Black';
  // ship.scu_max:=46;
  // ship.scu:=0;
  //
  ship:= ship0;

  eraseArray(0,MAXCARGOSLOTS-1, @ship.cargoindex);
  eraseArray(0,MAXCARGOSLOTS-1, @ship.cargoquantity);


  // test cargo
  // ship.cargoindex[0]:=8;
  // ship.cargoquantity[0]:=10;
  // ship.cargoindex[1]:=11;
  // ship.cargoquantity[1]:=20;
  // ship.scu:= 30;


end;


procedure ListCargo(mode : Boolean);
const
  LISTWIDTH = 20;
  LISTSTART = 0;
  TOPCARGOMARGIN = 8;

begin
  count:=1;
  for y:=0 to MAXCARGOSLOTS-1 do // max available items
  begin
    offset:=currentship.cargoindex[y];
    if offset > 0 then
    begin
      CRT_GotoXY(LISTSTART,7+count); //min count:=1 so we start at 8th row
      tstr:= FFTermToString(items[offset]);
      CRT_Write(tstr);
      strnum:=IntToStr(currentship.cargoquantity[y]);
      WriteSpaces(LISTWIDTH-Length(tstr)-Length(strnum));
      CRT_Write(Atascii2Antic(strnum));
      if (count = 1) and mode then CRT_Invert(LISTSTART,8,LISTWIDTH);
      Inc(count);
    end;
  end;
  for y:=count to MAXCARGOSLOTS-1 do
  begin
    CRT_GotoXY(LISTSTART,TOPCARGOMARGIN+y-1);
    WriteSpaces(LISTWIDTH); // -1 to clear from the end of list
  end;

end;


procedure ListItems(mode: boolean);
const
  LISTSTART = 21;
  LISTWIDTH = 19;


var
  countstr: Tstring;
  finalprice: word;


  visible: Boolean;

begin

//load items
  count:=0;
  for y:=0 to NUMBEROFITEMS-1 do
    begin
      visible:= false;
      offset:=(NUMBEROFITEMS * player.loc) + y;

      if mode then
      begin
        if (itemprice[offset] > 0) then // show item even if quantity is 0
          visible:=true;
      end
      else
      //begin
        if (itemprice[offset] > 0) and (itemquantity[offset] > 0) then // show item if quantity > 0
          visible:=true;
      //end;

      if visible then
      begin
        if count <= MAXAVAILABLEITEMS-1 then // max avaiable items
        begin
          availableitems[count]:=offset;
          inc(count);
        end;
      end;
    end;
  eraseArray(count,MAXAVAILABLEITEMS-1, @availableitems);

  // list items
  count:=1;
  for y:=0 to MAXAVAILABLEITEMS-1 do // max available items
    begin
      // offset:=availableitems[x];
      if (availableitems[y] > 0) then
      begin

        offset:=availableitems[y];
        CRT_GotoXY(LISTSTART,4+count); //min count:=1 so we start at 4th row

        CRT_Write(count);CRT_Write(' '~);
        tstr:= FFTermToString(items[availableitems[y]-(player.loc * NUMBEROFITEMS)]);
        CRT_Write(tstr);
        //if mode then finalprice:=Trunc(itemprice[offset] * (1-COMMISSION))
        if mode then finalprice:=Round(itemprice[offset] * (1-COMMISSION))
        else finalprice:=itemprice[offset];
        countstr:=IntToStr(count);
        strnum:=IntToStr(finalprice);
        WriteSpaces(LISTWIDTH-(Length(countstr)+1+Length(tstr))-Length(strnum)); // (count, space and string)-price
        CRT_Write(Atascii2Antic(strnum));
        //CRT_WriteRightAligned(Atascii2Antic(IntToStr(finalprice)));
        if (count = 1) and (mode = false) then CRT_Invert(LISTSTART,5,LISTWIDTH);
        inc(count);
      end
      else
      begin
        CRT_GotoXY(LISTSTART,4+y+1);
        WriteSpaces(LISTWIDTH);
      end;

    end;
  sfx_play(voice4,185,200); // vol8
end;


procedure LoadDestinations;
const
  LISTSTART = 20;

begin

  // Load destinations
  count:=0;
  for y:=0 to NUMBEROFLOCATIONS-1 do
  begin
    offset:=(NUMBEROFLOCATIONS * player.loc) + y;
    if locationdistance[offset] > 0 then
    begin
      availabledestinations[count]:=offset;
      inc(count);
    end;
  end;

  Waitframe;

  // clear avaiable destinations array when less destinations are present
  eraseArray(count,MAXAVAILABLEDESTINATIONS-1, @availabledestinations);



  // list destinations
  count:=0;

  for y:=0 to MAXAVAILABLEDESTINATIONS-1 do
  begin
    if (availabledestinations[y] > 0) then
    begin
      offset:=availabledestinations[y]-(player.loc * NUMBEROFLOCATIONS); // calculate base location index
      CRT_GotoXY(LISTSTART,count);
      CRT_Write(count+1);CRT_Write(' '~);
      WriteFF(locations[offset]);
      //CRT_Write('offset='~); CRT_Write(offset);
      Inc(count);
    end;

  // debug
  //   CRT_GotoXY(LISTSTART,count);
  //   CRT_Write('avdes='~);
  //   CRT_Write(availabledestinations[x]);
  //   Inc(count);
  end;
  sfx_play(voice4,185,200); // vol8

end;


function CheckItemPosition(newindex : Byte) : Boolean;
begin
  result:=(newindex < MAXAVAILABLEITEMS); // and (newindex >= 0);
end;

function CheckCargoPosition(newindex : Byte) : Boolean;
begin
  result:=(newindex < MAXCARGOSLOTS); // and (newindex >= 0);
end;

function GetItemPrice(itemindex : Byte; mode : Boolean): Word;
// Get item price based on itemindex of available items mode is false for BUY and tru for SELL

begin
  offset:=availableitems[itemindex];
  if mode then
  begin
    //finalprice:=Trunc(price * (1-commission))
    Result:=Round(itemprice[offset] * (1-commission))
  end
  else
  begin
    Result:=itemprice[offset];
  end;

end;


function GetCargoPrice(itemindex: Byte): Word;
// Get item price based on itemindex of available items

begin
  // translate cargo item index into offset to read price in location.
  offset:=(NUMBEROFITEMS * player.loc) + currentship.cargoindex[itemindex];
  Result:=Round(itemprice[offset] * (1-commission));
end;

function CheckCargoPresence(itemindex: Byte): Boolean;

// var
//   item: Word;

begin
  Result:= false;
  //for item in availableitems do
  // for item:=0 to MAXAVAILABLEITEMS-1 do
  //   begin
  //     if currentShip.cargoindex[itemindex] = availableitems[item] then exit(true);
  //   end
  if currentship.cargoindex[itemindex] > 0 then exit(true);

end;

procedure navi_destinationUpdate(locationindex: Word);

begin
  CRT_GotoXY(0,1);
  WriteSpaces(19); // max location lenght
  CRT_GotoXY(0,1);
  WriteFF(strings[21]);
  WriteFF(locations[locationindex-(player.loc * NUMBEROFLOCATIONS)]);
end;

procedure navi_distanceUpdate(mydistance: Word);

begin
  CRT_GotoXY(0,2);
  WriteSpaces(19); // max distance lenght
  CRT_GotoXY(0,2);
  WriteFF(strings[22]);
  CRT_Write(mydistance); CRT_Write(Atascii2Antic(DISTANCE));
end;




procedure calculateprices(loc: Byte);
begin
  for y:=0 to NUMBEROFITEMS-1 do
    begin
      offset:= (NUMBEROFITEMS * loc)+y;

      // Produce new items on certain LOCATIONS
      if (itemquantity[offset] > 0) and (itemquantity[offset] <= 10) then
      begin
        case loc of
          2..9,13,14:   begin
                          itemquantity[offset]:= itemquantity[offset] + Random(200);
                        end;
        end;
      end;

      // Increase price if less then 1000
      if (itemquantity[offset] > 0) and (itemquantity[offset] < 1000) and (itemprice[offset] > 0) then
      begin
        itemprice[offset]:=itemprice[offset] * (1 + COMMISSION);
      end;

      // Decrease price if more then 5000
      if (itemquantity[offset] > 5000) and (itemquantity[offset] < 10000) and (itemprice[offset] > 0) then
      begin
        itemprice[offset]:=itemprice[offset] * (1 - COMMISSION);
      end;

      // Simulate item sell
      if (itemquantity[offset] > 10000) and (itemprice[offset] > 0) then
      begin
        itemquantity[offset]:=itemquantity[offset] * (1 - COMMISSION);
      end;

    end;
end;

procedure encounterMessage;
begin
  sfx_play(voice1,230,200); //vol 8
  sfx_play(voice2,230,200); //vol 8

  CRT_ClearRows(0,6);

  CRT_GotoXY(0,0);
  for y:=1 to Length(txt) do
  begin
    CRT_Write(txt[y]);
    if (y mod 4) = 0 then sfx_play(voice1,200,200); //vol 8
    //waitframes(2);
    waitframe;
  end;

  CRT_GotoXY(12,6);
  WriteFF(strings[26]); // press any key

  repeat
    Waitframe;
  until CRT_Keypressed;

end;

procedure randomEncounter;
begin
  y:=Random(24);
   // CRT_GotoXY(0,4);
   // CRT_Write(y);

  txt:='#';
  case y of

    1:   begin
            if player.uec > 0 then
            begin
              txt:=FFTermToString(strings[34]);
              player.uec:=player.uec - 2500;
            end;
          end;
    5:   begin
            y:=Random(5);
            if ship.cargoindex[y] > 0 then
            begin
              txt:=FFTermToString(strings[33]);
              ship.cargoquantity[y]:=ship.cargoquantity[y]-(1 * Random);
            end;
          end;
    10:   begin
            txt:=FFTermToString(strings[32]);
            offset:= Round(Random * 10000);
            player.uec:=player.uec + offset;
          end;
    20:   begin
            if player.uec > 0 then
            begin
              txt:=FFTermToString(strings[31]);
              player.uec:=0;
            end;
          end;
    22:   begin
            txt:=FFTermToString(strings[30]);
          end;
    24:   begin
            if ship.cargoindex[0] > 0 then
            begin
              txt:=FFTermToString(strings[29]);
              eraseArray(0,MAXCARGOSLOTS-1, @ship.cargoindex);
              eraseArray(0,MAXCARGOSLOTS-1, @ship.cargoquantity);
            end;
          end;
  end;
  If (txt <> '#') then encounterMessage;
end;

procedure navi_ftljump(distance: Word);
const
    CHUNKSIZE = 800;

var
  fileoffset: Cardinal;

begin
  CRT_ClearRow(6);
  for y:=0 to MAXAVAILABLEDESTINATIONS-1 do
  begin
    CRT_GotoXY(20,0+y); // liststart
    WriteSpaces(18); // clear rows
  end;

  sfx_play(voice1,230,200); //vol 8
  sfx_play(voice2,230,200); //vol 8
  sfx_play(voice3,236,200); //vol 8
  sfx_play(voice4, 236,200); // vol 8

  // fade out
  repeat
    Waitframes(2);
    If (gfxcolors[0] and %00001111 <> 0) then Dec(gfxcolors[0]) else gfxcolors[0]:=0;
    If (gfxcolors[1] and %00001111 <> 0) then Dec(gfxcolors[1]) else gfxcolors[1]:=0;
    If (gfxcolors[2] and %00001111 <> 0) then Dec(gfxcolors[2]) else gfxcolors[2]:=0;
    If (gfxcolors[3] and %00001111 <> 0) then Dec(gfxcolors[3]) else gfxcolors[3]:=0;
  until (gfxcolors[0] or gfxcolors[1] or gfxcolors[2] or gfxcolors[3]) = 0;

  piclocation_openfile;
  fileoffset:=0;
  If (xBiosCheck <> 0) then xBiosSetLength(CHUNKSIZE); //size of chunk to read

  // simulate travel
  repeat
    If (xBiosCheck <> 0) then
    begin
      xBiosLoadData(Pointer(GFX2_ADDRESS+fileoffset));
      fileoffset:=fileoffset+CHUNKSIZE;
    end;
    //If distance > 0 then
    //begin
       Dec(distance);
       navi_distanceUpdate(distance);
       waitframes(5);
       //waitframe;
    //end;

  until ((distance = 0) and (xBiosIOresult <> 0)) or ((distance = 0) and (xBiosCheck = 0));

  If (xBiosCheck <> 0) then xBiosFlushBuffer; // close file
  sfx_init; // reinitialize pokey
  randomEncounter;
  calculateprices(player.loc);
  player.loc:=newLoc;
  //calculateprices(player.loc);
end;

procedure console_navigation;
var
  //y: byte;
  destinationindex: Word;
  distance: Word;

begin
  CRT_ClearRows(0,6);

  CRT_GotoXY(0,0);
  WriteFF(strings[20]); // Loc:
  WriteFF(locations[player.loc]);
  //CRT_GotoXY(20,0);
  //CRT_Write(FFTermToString(strings[23])); // Navigation:

  CRT_GotoXY(0,1);
  WriteFF(strings[21]); // Nav:
  CRT_GotoXY(0,2);
  WriteFF(strings[22]); //CRT_Write(' 2356 SDU'~); // Dis:

  // Help Keys
  CRT_GotoXY(0,6);
  WriteFF(strings[23]); // Navigation options
  CRT_Write(' '~);
  WriteFF(strings[24]);  // FTL Jump
  CRT_Write(' '~);
  WriteFF(strings[7]); // Back

  LoadDestinations;

  destinationindex:=0;
  keyval:= 0;
  repeat

    If (CRT_Keypressed) then
    begin

        //keyval := char(CRT_Keycode[kbcode]);
        keyval := kbcode;
        case keyval of
          KEY_BACK:     begin
                          sfx_play(voice4,255,168); // vol8
                          current_menu := MENU_MAIN;
                        end;
          KEY_OPTION1:  begin
                          destinationindex:=availabledestinations[0];
                         end;
          KEY_OPTION2:  begin
                          destinationindex:=availabledestinations[1];
                        end;
          KEY_OPTION3:  begin
                          destinationindex:=availabledestinations[2];
                        end;
          KEY_OPTION4:  begin
                          destinationindex:=availabledestinations[3];
                        end;
          KEY_OPTION5:  begin
                          destinationindex:=availabledestinations[4];
                        end;
          KEY_OPTION6:  begin
                          destinationindex:=availabledestinations[5];
                        end;
          KEY_JUMP:     begin
                          if (destinationindex > 0) then
                          begin
                            newLoc:=destinationindex-(player.loc * NUMBEROFLOCATIONS);
                            navi_ftljump(distance);
                            current_menu:=MENU_MAIN;
                          end;
                        end;
        end;
        if (current_menu=MENU_NAV) and (destinationindex > 0) then
        begin
          distance:=locationdistance[destinationindex];
          navi_destinationUpdate(destinationindex);
          navi_distanceUpdate(distance);
        end;
    end;
    Waitframe;

  until (keyval = KEY_BACK) OR (keyval = KEY_JUMP);
end;

procedure UpdateSelectedItem(selecteditemquantity:Word;selecteditemtotal:Longword);

begin
  txt:=IntToStr(selecteditemquantity);
  txt:= concat(txt,CARGOUNIT);
  txt:= concat(txt,FFTermToString(strings[18]));
  txt:= concat(txt,IntToStr(selecteditemtotal));
  txt:= concat(txt,CURRENCY);
  CRT_ClearRow(19);
  CRT_WriteRightAligned(19,Atascii2Antic(txt));
end;


procedure trade_UpdateUEC(uec: Longword);

const
  LISTSTART = 21;
  LISTWIDTH = 19;

begin
//    liststart:=(CRT_screenWidth shr 1)+1;
//    listwidth:=CRT_screenWidth-liststart;

  // update player UEC (current session)
  CRT_GotoXY(LISTSTART+7,0); // +7 for Sell string
  strnum:=IntToStr(uec);
  WriteSpaces(LISTWIDTH-Length(strnum)-Length(CURRENCY)-7);
  CRT_Write(uec);
  CRT_Write(Atascii2Antic(CURRENCY));
end;

procedure trade_UpdateCargo;

const
  LISTSTART = 21;

begin
  //liststart:=(CRT_screenWidth shr 1)+1;
  // update cargo Total
  tstr:=IntToStr(currentship.scu_max-currentship.scu);
  CRT_GotoXY(LISTSTART-(Length(tstr)+5)-4,6);
  CRT_Write('    '~); // fixed 4 chars for cargo size
  CRT_GotoXY(LISTSTART-(Length(tstr)+5),6);
  CRT_Write(Atascii2Antic(tstr)); CRT_Write(Atascii2Antic(CARGOUNIT));CRT_Write('|'~);
end;

procedure console_trade;

const
  LISTTOPMARGIN = 5;
  CARGOTOPMARGIN = 8;
  LISTSTART = 21;
  LISTWIDTH = 19;

var
  d: shortInt;
  mode: Boolean = false;

  optionPressed: Boolean = false;
  selectPressed: Boolean = false;
  cargoPresent: Boolean = false;
  selectitem: Boolean = false;

  l: Byte;
  itemindex: Byte = 0;
  //listwidth: Byte = 19;
  //liststart: Byte = 21;


  currentitemindex: Word;
  currentitemquantity: Word;
  currentitemprice: Word;

  currentuec: Longword;


  selecteditemtotal: Longword;
  selecteditemquantity: Word;




begin
  currentuec:= player.uec;
  currentShip:= ship;
  selecteditemtotal:= 0;
  selecteditemquantity:= 0; // reset choosen quantity at start;
  mode:= false;
  optionPressed:= false;
  selectPressed:= false;
  cargoPresent:= false;
  keyval:= 0;

  //currentcargo:= ship.cargoindex;
  //currentcargoquantity:= ship.cargoquantity;

  //cargoindex:= 0;


  // liststart:=(CRT_screenWidth shr 1)+1;
  // listwidth:=CRT_screenWidth-liststart;

  EnableVBLI(@vbl_console);
  EnableDLI(@dli_console);
  Waitframe;
  DLISTL:= DISPLAY_LIST_ADDRESS_CONSOLE;

  // for y:=0 to CRT_screenHeight do
  //   CRT_ClearRow(y);
  CRT_ClearRows(0,CRT_screenHeight);

  tstr:=FFTermToString(locations[player.loc]);
  CRT_GotoXY(0,0);
  CRT_Write(tstr);
  l:=Length(tstr);

  CRT_GotoXY(LISTWIDTH-1,0);
  CRT_Write(' '~);
  WriteFF(strings[8]); // Buy
  CRT_Write(' '~);
  // invert at start
  CRT_Invert(LISTWIDTH-1,0,5);

  CRT_WriteRightAligned(Atascii2Antic(concat(IntToStr(currentuec), CURRENCY)));
  CRT_GotoXY(0,1);
  writeRuler;
  CRT_GotoXY(0,2);
  WriteFF(strings[10]);CRT_Write('  |'~); // Delivery
  WriteFF(strings[11]); // Available items
  CRT_GotoXY(0,3);
  CRT_Write('[ '~); CRT_Write(Atascii2Antic(currentship.sname)); CRT_Write(' ]'~);
  CRT_GotoXY(LISTSTART-2,3);
  CRT_Write(' |'~);
  WriteFF(strings[12]);CRT_WriteRightAligned(FFTermToString(strings[13])); // commodity price
  CRT_GotoXY(0,4);
  writeRuler;
  CRT_GotoXY(0,5);
  WriteFF(strings[14]); CRT_Write(' '~);
  CRT_GotoXY(LISTWIDTH-5,5);
  CRT_Write(Atascii2Antic(IntToStr(currentship.scu_max))); CRT_Write(Atascii2Antic(CARGOUNIT));CRT_Write('|'~);
  CRT_GotoXY(0,6);
  WriteFF(strings[15]); CRT_Write(' '~);
  tstr:=IntToStr(currentship.scu_max-currentship.scu);
  CRT_GotoXY(LISTSTART-(Length(tstr)+5),6);
  CRT_Write(Atascii2Antic(tstr)); CRT_Write(Atascii2Antic(CARGOUNIT));CRT_Write('|'~);
  CRT_GotoXY(0,7);
  CRT_Write('--------------------+'~);
  sfx_play(voice4,77,200); // vol8

  for y:=8 to 17 do
  begin
      CRT_GotoXY(LISTSTART-1,y);
      CRT_Write('|'~);
  end;

  CRT_GotoXY(0,18);
  writeRuler;


  // CRT_Write(StringOfChar('-'~,20));
  // CRT_Write('+'~);
  // CRT_Write(StringOfChar('-'~,19));


  CRT_GotoXY(27,22);
  WriteFF(strings[16]); CRT_Write(' '~);
  WriteFF(strings[17]);
  // CRT_WriteRightAligned('[Cancel] [OK]'~);

  // help
  CRT_GotoXY(0,23);
  CRT_Write('OPTION'*~);
  CRT_Write('-'~);
  WriteFF(strings[8]);
  CRT_Write('/'~);
  WriteFF(strings[9]);
  CRT_Write(' '~);
  CRT_Write('SELECT'*~);
  CRT_Write('-'~);
  WriteFF(strings[19]);
  CRT_Write(' '~);
  WriteFF(strings[7]);


  ListItems(false);
  ListCargo(false);
  itemindex:=0;

  // assign 1st item on the avaiable items
  currentitemquantity:=itemquantity[availableitems[itemindex]];
  currentitemprice:=GetItemPrice(itemindex,mode);
  currentitemindex:=availableitems[itemindex];


  repeat
    Waitframe;
    //msx.play;
    If (CRT_Keypressed) then
    begin
      keyval := kbcode;

      case keyval of
        KEY_CANCEL: begin
                      currentuec:= player.uec;
                      currentShip:= ship;

                      ListItems(false);
                      ListCargo(false);
                      selecteditemquantity:=0;
                      selecteditemtotal:=0;
                      itemindex:=0;
                      // assign 1st item on the avaiable items
                      currentitemindex:=availableitems[itemindex];
                      currentitemquantity:=itemquantity[availableitems[itemindex]];
                      currentitemprice:=GetItemPrice(itemindex,mode);


                      // update player UEC (current session)
                      trade_UpdateUEC(currentuec);

                      // update cargo Total
                      currentShip.scu:=currentShip.scu-selecteditemquantity;
                      trade_UpdateCargo;
                      sfx_play(voice4,255,168); // vol8
                    end;
        KEY_OK:     begin
                      player.uec:= currentuec;
                      ship:= currentShip;
                      itemquantity[currentitemindex]:=itemquantity[currentitemindex]-selecteditemquantity;
                      current_menu:= MENU_MAIN;
                      sfx_play(voice4,52,200); // vol8
                    end;
        KEY_BACK:   begin
                      sfx_play(voice4,255,168); // vol8
                      current_menu := MENU_MAIN;
                    end;
        KEY_UP, KEY_DOWN:
                    begin
                      d:=1;
                      if keyval = KEY_UP then d:=-1;
                      if (mode = false) then
                      begin
                        if CheckItemPosition(itemindex+d) and (availableitems[itemindex+d] > 0) then
                        begin
                          CRT_Invert(LISTSTART,itemindex + LISTTOPMARGIN,LISTWIDTH);
                          itemindex:=itemindex+d;
                          CRT_Invert(LISTSTART,itemindex + LISTTOPMARGIN,LISTWIDTH); // selecting the whole row with item
                          currentitemquantity:=itemquantity[availableitems[itemindex]];
                          currentitemprice:=GetItemPrice(itemindex,false);
//                          currentitemindex:=availableitems[itemindex];
                          currentitemindex:=availableitems[itemindex]-(NUMBEROFITEMS * player.loc);
                          CRT_ClearRow(19);
                        end;

                        // CRT_GotoXY(0,12);
                        // CRT_Write('cur_itemprice='~);CRT_Write(currentitemprice);CRT_Write('      '~);
                        // CRT_GotoXY(0,13);
                        // CRT_Write('itemindex='~);CRT_Write(itemindex);CRT_Write('      '~);
                        // CRT_GotoXY(0,14);
                        // CRT_Write('cur_itemindex='~);CRT_Write(currentitemindex);CRT_Write('      '~);
                        //CRT_GotoXY(0,15);
                        //CRT_Write('cargoPresent='~);CRT_Write(cargoPresent);CRT_Write('           '~);

                      end
                      else begin // when selling
                        if CheckCargoPosition(itemindex+d) and (currentShip.cargoindex[itemindex+d] > 0)  then
                        begin
                          CRT_Invert(0,itemindex + CARGOTOPMARGIN,LISTWIDTH+1);
                          itemindex:=itemindex+d;
                          currentitemquantity:=currentShip.cargoquantity[itemindex];
                          currentitemprice:=GetCargoPrice(itemindex);
                          currentitemindex:=currentShip.cargoindex[itemindex];
                          CRT_Invert(0,itemindex + CARGOTOPMARGIN,LISTWIDTH+1); // selecting the whole row with item
                          cargoPresent:=CheckCargoPresence(itemindex);

                          // CRT_GotoXY(19,12);
                          // CRT_Write('cur_itemprice='~);CRT_Write(currentitemprice);CRT_Write('      '~);
                          // CRT_GotoXY(19,13);
                          // CRT_Write('itemindex='~);CRT_Write(itemindex);CRT_Write('      '~);
                          // CRT_GotoXY(19,14);
                          // CRT_Write('cur_itemindex='~);CRT_Write(currentitemindex);CRT_Write('      '~);
                          // CRT_GotoXY(0,15);
                          // CRT_Write('cargoindex[0]='~);CRT_Write(currentship.cargoindex[0]);CRT_Write('           '~);
                          //
                          //

                        end;
                      end;
                      selecteditemtotal:=0;
                      selecteditemquantity:=0;
                      Waitframes(2);
                    end;
        KEY_LEFT:   begin
                      if (selecteditemquantity > 0) then
                      begin
                        Dec(selecteditemquantity);
                        selecteditemtotal:=selecteditemquantity * currentitemprice;

                      end;
                    end;
        KEY_RIGHT:  begin
                      selectitem:= false;
                      if (selecteditemquantity < currentitemquantity) then
                          if (mode = false) then begin
                              if (selecteditemquantity < currentShip.scu_max-currentShip.scu)
                                and (selecteditemtotal + currentitemprice <= currentuec ) then selectitem := true;
                          end else // when selling
                              if cargoPresent then selectitem:= true;

                      if selectitem then
                      begin
                        Inc(selecteditemquantity);
                        selecteditemtotal:=selecteditemquantity * currentitemprice;

                      end;
//                      else
//                       CRT_WriteRightAligned(19,FFTermToString(strings[??]));

                      //
                      // CRT_GotoXY(0,12);
                      // CRT_Write('selectitem='~);CRT_Write(selectitem);CRT_Write('           '~);
                      // CRT_GotoXY(0,13);
                      // CRT_Write('selecteditemquantity='~);CRT_Write(selecteditemquantity);CRT_Write('           '~);
                      // CRT_GotoXY(0,14);
                      // CRT_Write('currentitemquantity='~);CRT_Write(currentitemquantity);CRT_Write('           '~);
                      // CRT_GotoXY(0,15);
                      // CRT_Write('cargoPresent='~);CRT_Write(cargoPresent);CRT_Write('           '~);
                    end;
      end;
      If (keyval = KEY_LEFT) or (keyval = KEY_RIGHT) then UpdateSelectedItem(selecteditemquantity,selecteditemtotal);
    end;

    if (CRT_OptionPressed) and (optionPressed=false) then
    begin
      mode:= not mode;
      CRT_ClearRow(19);
      if (mode = false) then
      begin
        CRT_GotoXY(LISTSTART-3,0);
        CRT_Write(' '~);
        WriteFF(strings[8]); // Buy
        CRT_Write('  '~);
        CRT_Invert(LISTSTART-3,0,5);

        // // debug
        // for y:=0 to MAXAVAILABLEITEMS-1 do
        // begin
        //  str:=concat('availableitems[',IntToStr(y));
        //  str:=concat(str,']=');
        //  str:=concat(str,IntToStr(availableitems[y]));
        //  CRT_WriteXY(0,8+y,Atascii2Antic(str));
        // end;
        // //


        ListItems(false);
        ListCargo(false);
        itemindex:=0;
      end
      else begin // selling mode
        CRT_GotoXY(LISTSTART-3,0);
        CRT_Write(' '~);
        WriteFF(strings[9]); // Buy
        CRT_Write(' '~);
        CRT_Invert(LISTSTART-3,0,6);

        //  // debug
        //  for y:=0 to MAXAVAILABLEITEMS-1 do
        //  begin
        //   str:=concat('available[',IntToStr(y));
        //   str:=concat(str,']=');
        //   str:=concat(str,IntToStr(availableitems[y]));
        //   CRT_WriteXY(0,8+y,Atascii2Antic(str));
        // end;
        //  //


        ListItems(true);
        ListCargo(true);
        itemindex:=0;
        currentitemquantity:=currentShip.cargoquantity[itemindex];
        currentitemprice:=GetCargoPrice(itemindex);
        currentitemindex:=currentShip.cargoindex[itemindex];
        cargoPresent:=CheckCargoPresence(itemindex);
        selecteditemquantity:=0;

      end;
      optionPressed:=true;
    end
    else
      if not CRT_OptionPressed then optionPressed:=false;

    if (CRT_SelectPressed) then
    begin
      if (selectPressed = false) then
      begin
          if (mode = false) then // buying mode
          begin
            if (selecteditemquantity > 0) then
            begin
              for y:=0 to MAXCARGOSLOTS-1 do
              begin
                if currentShip.cargoindex[y] = 0 then
                begin
                  currentShip.cargoindex[y]:=currentitemindex;
                  currentShip.cargoquantity[y]:=selecteditemquantity;
                  // CRT_GotoXY(0,19);
                  // CRT_Write('cur_itemprice='~);CRT_Write(currentitemprice);CRT_Write('           '~);
                  // CRT_GotoXY(0,20);
                  // CRT_Write('itemindex='~);CRT_Write(itemindex);CRT_Write('           '~);
                  // CRT_GotoXY(0,21);
                  // CRT_Write('cur_itemindex='~);CRT_Write(currentitemindex);CRT_Write('           '~);

                  break;
                end
                else begin
                  // some item exists
                  if currentship.cargoindex[y] = currentitemindex then
                  begin
                    // found same cargo
                    currentShip.cargoquantity[y]:=currentShip.cargoquantity[y] + selecteditemquantity;
                    break;
                  end;
                end;
              end;

              // update UEC on screen not on player
              currentuec:=currentuec - selecteditemtotal;

              // update player UEC (current session)
              trade_UpdateUEC(currentuec);

              // update cargo Total
              currentShip.scu:=currentShip.scu + selecteditemquantity;
              trade_UpdateCargo;

              // remove selection
              currentitemprice:=GetCargoPrice(itemindex);
              currentitemindex:=currentShip.cargoindex[itemindex];
              selecteditemquantity:= 0;
              selecteditemtotal:= 0;
//              itemindex:=0;

            end;
          end
          else begin // Selling mode
            if (selecteditemquantity > 0) then
            begin
              currentShip.cargoquantity[itemindex]:=currentShip.cargoquantity[itemindex]-selecteditemquantity;
              If currentShip.cargoquantity[itemindex] = 0 then currentShip.cargoindex[itemindex]:= 0; // erasing item form cargoindex

              // update UEC on screen not on player
              currentuec:=currentuec + selecteditemtotal;

              for y:=0 to MAXCARGOSLOTS-1 do
              begin
                if currentShip.cargoquantity[y] = 0 then
                begin
                  for l:=y to MAXCARGOSLOTS-1 do
                  begin
                    if (l < MAXCARGOSLOTS-1) then
                    begin
                      currentShip.cargoindex[l]:=currentShip.cargoindex[l+1];
                      currentShip.cargoquantity[l]:=currentShip.cargoquantity[l+1];
                    end
                    else
                    begin
                      currentShip.cargoindex[l]:=0;
                      currentShip.cargoquantity[l]:=0;
                    end;
                  end;
                  //move (currentShip.cargoindex[y],currentShip.cargoindex[y+1],1);
                  //move (currentShip.cargoquantity[y],currentShip.cargoquantity[y+1],1);
                end;
              end;


              // update player UEC (current session)
              trade_UpdateUEC(currentuec);

              // update cargo Total
              currentShip.scu:=currentShip.scu-selecteditemquantity;
              trade_UpdateCargo;


              // // set selection to 1st item on the list
              itemindex:=0;
              currentitemprice:=GetCargoPrice(itemindex);
              currentitemquantity:=currentShip.cargoquantity[itemindex];
              currentitemindex:=currentShip.cargoindex[itemindex];
              selecteditemquantity:= 0;
              selecteditemtotal:=0;

              // remove selection

              // for y:=0 to MAXCARGOSLOTS-1 do
              // begin
              //  str:=concat('cargoindex[',IntToStr(y));
              //  str:=concat(str,']=');
              //  str:=concat(str,IntToStr(currentShip.cargoindex[y]));
              //  str:=concat(str,'          2');
              //  CRT_WriteXY(20,11+y,Atascii2Antic(str));
              // end;

              // remove selected
              CRT_ClearRow(19);

            end;
          end;
        ListCargo(mode);
      end;
      selectPressed:=true;
    end
    else
      selectPressed:=false;
    Waitframe;

  until (keyval = KEY_BACK) or (keyval = KEY_OK);
end;

procedure menu;

begin
  // offset for player location colors
  y:= player.loc shl 2;
  gfxcolors[0]:=piccolors[y];
  gfxcolors[1]:=piccolors[y+1];
  gfxcolors[2]:=piccolors[y+2];
  gfxcolors[3]:=piccolors[y+3];


  EnableVBLI(@vbl);
  EnableDLI(@dli1);
  Waitframe;
  DLISTL := DISPLAY_LIST_ADDRESS_MENU;

  CRT_ClearRows(0,6);

  CRT_GotoXY(14,0);
  WriteFF(strings[3]); // Navigation
  CRT_GotoXY(14,1);
  WriteFF(strings[4]); // Trade Console
  CRT_GotoXY(14,2);
  WriteFF(strings[7]); // Back

  // CRT_GotoXY(0,3);
  // CRT_Write('sname='~);CRT_Write(ship.sname);CRT_Write('|'~);
  // CRT_GotoXY(0,4);
  // CRT_Write('scu_max='~);CRT_Write(ship.scu_max);
  //CRT_GotoXY(0,6);
  //Write_CRT(ship.sname);



  keyval:=0;

  repeat
  //  pause;
  //  msx.play;
    if CRT_Keypressed then
    begin
      keyval := kbcode;
      case keyval of
        KEY_OPTION1: current_menu := MENU_NAV;
        KEY_OPTION2: current_menu := MENU_TRADE;
        KEY_BACK: begin
                    sfx_play(voice4,255,168); // vol8
                    current_menu := MENU_TITLE;
                  end;
      end;
    end;
    Waitframe;

  until (keyval = KEY_BACK) or (keyval = KEY_OPTION1) or (keyval = KEY_OPTION2);
end;



procedure title;

begin
  EnableVBLI(@vbl_title);
  EnableDLI(@dli_title1);
  Waitframe;
  DLISTL := DISPLAY_LIST_ADDRESS_TITLE;


  CRT_ClearRows(0,5);

  CRT_GotoXY(14,0);
  WriteFF(strings[1]); // New game;
  CRT_GotoXY(14,1);
  WriteFF(strings[2]); // Quit;

  txt:= FFTermToString(strings[0]); // read scroll text
  move(txt[1],pointer(SCROLL_ADDRESS+42),sizeOf(txt)); // copy text to vram

  //keyval:=chr(0);
  keyval:=0;
  repeat
    //msx.play;
    if CRT_Keypressed then
    begin
      //keyval := char(CRT_Keycode[kbcode]);
      keyval := kbcode;
      case keyval of
          KEY_NEW:  begin
                      sfx_play(voice1,80,200); // vol8
                      sfx_play(voice2,84,200); // vol8
                      sfx_play(voice3,86,200); // vol8
                      sfx_play(voice4,88,200); // vol8
                      start;
                      current_menu := MENU_MAIN;
                    end;
      // else
      // begin
      //   CRT_GotoXY(0,5);
      //   CRT_Write('Klawisz='~);
      //   CRT_Write(asc(keyval));
      //   CRT_Write('   Kod='~);
      //   CRT_Write(keyval);
      //   CRT_Write('  '~);
      // end;
(*
          KEY_OPTION1: sfx_play(185,16*12+4);
          KEY_OPTION2: sfx_play(110,16*12+4);
          KEY_OPTION3: sfx_play(60,16*12+4);
          KEY_OPTION4: sfx_play(20,16*12+4);
          KEY_OPTION5: sfx_play(10,16*12+4);
          KEY_OPTION6: sfx_play(5,16*12+4);
*)
      end;
    end;
    Waitframe;

  until (keyval = KEY_QUIT) or (keyval = KEY_NEW);
end;



{
--------------------------------------------------------------------------------
MAIN LOOP
--------------------------------------------------------------------------------
}

begin
  SystemOff;
  Randomize;
  SetCharset (Hi(CHARSET_ADDRESS)); // when system is off
  CRT_Init(TXT_ADDRESS);
  player.loc:=0; //start location Port Olisar
  piclocation_load;
  sfx_init;

  // Initialize RMT player
  //msx.player:=pointer(RMT_PLAYER_ADDRESS);
  //msx.modul:=pointer(RMT_MODULE_ADDRESS);
  //msx.init(0);

  generateWorld;


  current_menu := MENU_TITLE;
  //current_menu := MENU_MAIN;
  repeat
    case current_menu of
      MENU_TITLE: title;
      MENU_MAIN:  menu;
      MENU_NAV:   console_navigation;
      MENU_TRADE: console_trade;
      //MENU_MAINT: console_maint;
    end;
    repeat Waitframe until not CRT_Keypressed;

  until keyval = KEY_QUIT;

  // restore system
  SystemReset;
end.
