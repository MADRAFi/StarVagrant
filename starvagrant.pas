program StarVagrant;
{$librarypath '../Libs/lib/';'../Libs/blibs/';'../Libs/base/'}
//{$librarypath 'Libs/lib/';'Libs/blibs/';'Libs/base/'}
// {$librarypath '../blibs/'}
uses atari, b_utils, b_system, b_crt, sysutils, xbios, rmt;

const
{$i 'const.inc'}

  CURRENCY = ' UEC';
  CARGOUNIT = ' SCU';
  DISTANCEUNIT = ' DU';
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
  msx: TRMT;
  current_menu: Byte;
  gamestate: TGameState;

  {$i 'ships.inc'}
  {$i 'locations.inc'}
  {$i 'items.inc'}



//number of ship variables equals NUMBEROFSHIPS
  tshp : ^TShip;

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
txtcolors : array [0..1] of Byte = (
    $00,$1c
);


  strings: array [0..0] of Word absolute STRINGS_ADDRESS;

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

  locationdistance: array[0..(NUMBEROFLOCATIONS * NUMBEROFLOCATIONS)-1] of Word = (
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

  ); // distance between locations

 shipprices: array [0..(NUMBEROFLOCATIONS * NUMBEROFSHIPS)-1] of longword = (
 1000,0,0,0,0,0,0,0,0,0,0,0,
 0,9000,12990,22700,32000,0,75000,62000,0,0,330000,0,
 0,0,0,0,0,0,0,0,0,0,0,0,
 0,0,0,0,0,0,0,0,0,0,0,0,
 0,0,0,0,0,0,0,0,0,0,0,0,
 0,0,0,0,0,0,0,0,0,0,0,0,
 0,0,0,0,0,0,0,0,0,0,0,0,
 0,0,0,0,0,0,0,59500,0,130000,0,0,
 0,0,0,0,0,0,0,0,0,0,0,0,
 0,0,0,0,0,0,0,0,0,0,0,0,
 0,0,0,0,0,45000,0,0,0,0,0,400000,
 0,5000,0,18000,29999,0,50000,0,0,0,0,0,
 0,9000,0,20100,0,0,0,0,124900,0,300000,0,
 0,0,0,0,0,0,0,0,0,0,0,0,
 0,0,0,0,0,0,75000,0,0,0,0,0,
 0,0,0,0,31500,0,75000,62000,124900,0,300000,0,
 0,8000,11999,22700,32000,0,0,0,124900,166000,330000,0
 ); // ship prices

  availableitems: array [0..(MAXAVAILABLEITEMS-1)] of Word; // only 12 avaiable items
  availabledestinations: array [0..(MAXAVAILABLEDESTINATIONS-1)] of Word; // only 6 available destinations
  availableships: array [0..(NUMBEROFSHIPS-1)] of Word; // only available ships


{$i 'interrupts.inc'}


// procedure sfx_play(channel: Word; freq: Byte; vol: Byte );
//
// begin
  // poke(channel,freq);
  // poke(channel+1,vol);
  // waitframes(5);
  // poke(channel+1,0);
//
//
// end;

// procedure sfx_init;
// begin
//   // sound init at pokey
//   poke($d20f,3);
//   poke($d208,0);
// end;

procedure writeRuler;
begin
    CRT_Write('--------------------+-------------------'~);
    // sfx_play(voice4,77,200); // vol8
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

procedure gfx_fadeout(hidetext: Boolean);
begin

  repeat
    Waitframes(2);
    If (gfxcolors[0] and %00001111 <> 0) then Dec(gfxcolors[0]) else gfxcolors[0]:=0;
    If (gfxcolors[1] and %00001111 <> 0) then Dec(gfxcolors[1]) else gfxcolors[1]:=0;
    If (gfxcolors[2] and %00001111 <> 0) then Dec(gfxcolors[2]) else gfxcolors[2]:=0;
    If (gfxcolors[3] and %00001111 <> 0) then Dec(gfxcolors[3]) else gfxcolors[3]:=0;
    If hidetext then
    begin
      If (txtcolors[0] and %00001111 <> 0) then Dec(txtcolors[0]) else txtcolors[0]:=0;
      If (txtcolors[1] and %00001111 <> 0) then Dec(txtcolors[1]) else txtcolors[1]:=0;
    end;
  //until (gfxcolors[0] or gfxcolors[1] or gfxcolors[2] or gfxcolors[3] or txtcolors[0] or txtcolors[1]) = 0;
  until (gfxcolors[0] or gfxcolors[1] or gfxcolors[2] or gfxcolors[3]) = 0;
  waitframes(10);
end;

procedure gfx_fadein;

begin
  // gfxcolors[0]:=0;
  // gfxcolors[1]:=0;
  // gfxcolors[2]:=0;
  // gfxcolors[3]:=0;
  y:= newLoc shl 2; // x 4 for number of colors
  repeat
    Waitframes(2);
    If (gfxcolors[0] and %00001111 < piccolors[y] and %00001111 ) then Inc(gfxcolors[0]) else gfxcolors[0]:=piccolors[y];
    If (gfxcolors[1] and %00001111 < piccolors[y+1] and %00001111) then Inc(gfxcolors[1]) else gfxcolors[1]:=piccolors[y+1];
    If (gfxcolors[2] and %00001111 < piccolors[y+2] and %00001111) then Inc(gfxcolors[2]) else gfxcolors[2]:=piccolors[y+2];
    If (gfxcolors[3] and %00001111 < piccolors[y+3] and %00001111) then Inc(gfxcolors[3]) else gfxcolors[3]:=piccolors[y+3];

      If (txtcolors[0] and %00001111 < 0 and %00001111) then inc(txtcolors[0]) else txtcolors[0]:=0;
      If (txtcolors[1] and %00001111 < $1c and %00001111) then inc(txtcolors[1]) else txtcolors[1]:=$1c;

  until (gfxcolors[0]=piccolors[y]) and (gfxcolors[1]=piccolors[y+1]) and (gfxcolors[2]=piccolors[y+2]) and (gfxcolors[3]=piccolors[y+3]);
end;


procedure pic_openfile(myname: TString; mynum: Byte);

begin
  tstr:='';
  if (mynum < 10) then tstr:=concat(myname,'0')
  else tstr:=myname;

  tstr:=concat(tstr,inttostr(mynum));
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

procedure pic_load(mytype: Byte; num: Byte);

begin
  If mytype = LOC then pic_openfile('LOC',num)
  else pic_openfile('GFX',num);
  //if (xBiosCheck = 1) and (xBiosIOresult = 0) then
  if (xBiosCheck <> 0) and (xBiosIOresult = 0) then
  begin
    xBiosLoadData(Pointer(GFX_ADDRESS));
    xBiosFlushBuffer;
  end

end;


procedure start;

begin
  // sfx_play(voice1,80,200); // vol8
  // sfx_play(voice2,84,200); // vol8
  // sfx_play(voice3,86,200); // vol8
  // sfx_play(voice4,88,200); // vol8

  gamestate:=GAMEINPROGRESS;
  player.uec:= STARTUEC;
  //if player.loc <> 0  then
  //begin
  player.loc:= STARTLOCATION;
  newLoc:= STARTLOCATION; //0;
  //end;
  gfx_fadeout(true);
  pic_load(LOC,player.loc);
  // sfx_init;
  gfx_fadein;

  tshp:=shipmatrix[0];
  ship:= tshp^;

  eraseArray(0,MAXCARGOSLOTS-1, @ship.cargoindex);
  eraseArray(0,MAXCARGOSLOTS-1, @ship.cargoquantity);


  // test cargo
  // ship.cargoindex[0]:=8;
  // ship.cargoquantity[0]:=10;
  // ship.cargoindex[1]:=11;
  // ship.cargoquantity[1]:=20;
  // ship.scu:= 30;

  current_menu := MENU_MAIN;

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
      tstr:= items[offset];
      CRT_Write(Atascii2Antic(tstr));
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

        CRT_Write(count);WriteSpaces(1);
        tstr:= items[availableitems[y]-(player.loc * NUMBEROFITEMS)];
        CRT_Write(Atascii2Antic(tstr));
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
  // sfx_play(voice4,185,200); // vol8
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
      CRT_Write(count+1);WriteSpaces(1);
      CRT_Write(Atascii2Antic(locations[offset]));
      //CRT_Write('offset='~); CRT_Write(offset);
      Inc(count);
    end;

  // debug
  //   CRT_GotoXY(LISTSTART,count);
  //   CRT_Write('avdes='~);
  //   CRT_Write(availabledestinations[x]);
  //   Inc(count);
  end;
  // sfx_play(voice4,185,200); // vol8

end;


procedure LoadShips;

begin

  // Load ships
  count:=0;
  for y:=0 to NUMBEROFSHIPS-1 do
  begin
    offset:=(NUMBEROFSHIPS * player.loc) + y;
    if shipprices[offset] > 0 then
    begin
      availableships[count]:=y; //offset;
      inc(count);
    end;
  end;

  Waitframe;

  // clear avaiable destinations array when less destinations are present
  eraseArray(count,NUMBEROFSHIPS-1, @availableships);
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
  CRT_Write(Atascii2Antic(locations[locationindex-(player.loc * NUMBEROFLOCATIONS)]));
end;

procedure navi_distanceUpdate(mydistance: Word);

begin
  CRT_GotoXY(9,2);
  WriteSpaces(6); // max distance lenght + distance symbol
  CRT_GotoXY(9,2);
  //WriteFF(strings[22]);
  CRT_Write(mydistance); CRT_Write(Atascii2Antic(DISTANCEUNIT));
end;




procedure calculateprices(loc: Byte);
var
  percent: Shortreal;
  modify: Real;

begin
  percent:=Random(100)/100;
  for y:=0 to NUMBEROFITEMS-1 do begin
    offset:= (NUMBEROFITEMS * loc)+y;

    // Produce new items on certain LOCATIONS
    if (itemquantity[offset] > 0) and (itemquantity[offset] <= 20) then
    begin
      case loc of
        2..9,13,14:   begin
                        itemquantity[offset]:= itemquantity[offset] + Random(500); // adding up to 500 items
                      end;
      end;
    end;

    // Increase price if less then 1000
    if (itemquantity[offset] > 0) and (itemquantity[offset] < 1000) and (itemprice[offset] > 0) and (percent < 30 ) then
    begin
      modify:=(1 + percent);
      itemprice[offset]:=Round(itemprice[offset] * modify);
    end;

    // Decrease price if more then 5000
    if (itemquantity[offset] > 5000) and (itemquantity[offset] < 10000) and (itemprice[offset] > 0) and (percent < 30) then
    begin
      modify:=(1 - percent);
      itemprice[offset]:=Round(itemprice[offset] * modify);
    end;

    // Simulate item sell
    if (itemquantity[offset] > 10000) and (itemprice[offset] > 0) and (percent < 40) then
    begin
      modify:=(1 - percent);
      itemquantity[offset]:=itemquantity[offset] * modify;
    end;

  end;

  if (percent < 40) then
  begin
    for y:=0 to NUMBEROFSHIPS-1 do begin
      offset:= (NUMBEROFSHIPS * loc)+y;
      if shipprices[offset] > shipprices[0] then // do not change price of starting ship
      begin
        count:=Random(2);
        if count = 0 then
        begin
          // price drop
          modify:=(1 - percent);
          //newprice:=Round(shipprices[offset] * (1 - percent));
          //shipprices[offset]:=Longword(shipprices[offset] * (1 - percent));
        end
        else
        begin
          // price increase
          modify:=(1 + percent);
          //newprice:=Round(shipprices[offset] * (1 + percent));
          //shipprices[offset]:=Longword(shipprices[offset] * (1 + percent));
        end;
        shipprices[offset]:=Round(shipprices[offset] * modify);
        // CRT_GotoXY(0,6);
        // if offset = 22 then begin
        //   CRT_Write(real(percent)); WriteSpaces(1); CRT_Write(modify);WriteSpaces(1);CRT_Write(shipprices[offset]);
        //   repeat until CRT_Keypressed;
        // end;
      end;
    end;
  end;
end;

procedure encounterMessage;
begin
  // sfx_play(voice1,230,200); //vol 8
  //sfx_play(voice2,230,200); //vol 8

  CRT_ClearRows(0,6);

  CRT_GotoXY(0,0);
  for y:=1 to Length(txt) do
  begin
    CRT_Write(txt[y]);
    //if (y mod 4) = 0 then sfx_play(voice1,200,200); //vol 8
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

  // sfx_play(voice1,230,200); //vol 8
  // sfx_play(voice2,230,200); //vol 8
  // sfx_play(voice3,236,200); //vol 8
  // sfx_play(voice4, 236,200); // vol 8

  gfx_fadeout(false);

  pic_openfile('LOC',newLoc);
  fileoffset:=0;
  If (xBiosCheck <> 0) then xBiosSetLength(CHUNKSIZE); //size of chunk to read

  // simulate travel
  repeat
    If (xBiosCheck <> 0) then
    begin
      xBiosLoadData(Pointer(GFX_ADDRESS+fileoffset));
      fileoffset:=fileoffset+CHUNKSIZE;
    end;
    //If distance > 0 then
    //begin
    //reuse of variable count for speed
      count:=(ROUND(15 / (ship.speed / 100))) - (5 - Trunc(ship.lenght / 25));
       Dec(distance);
       navi_distanceUpdate(distance);
       waitframes(count);
    //end;

  until ((distance = 0) and (xBiosIOresult <> 0)) or ((distance = 0) and (xBiosCheck = 0));

  If (xBiosCheck <> 0) then xBiosFlushBuffer; // close file
  // sfx_init; // reinitialize pokey
  randomEncounter;
  calculateprices(player.loc);
  player.loc:=newLoc;
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
  CRT_Write(Atascii2Antic(locations[player.loc]));
  //CRT_GotoXY(20,0);
  //CRT_Write(FFTermToString(strings[23])); // Navigation:

  CRT_GotoXY(0,1);
  WriteFF(strings[21]); // Nav:
  CRT_GotoXY(0,2);
  WriteFF(strings[22]);  // Dis:
  // CRT_GotoXY(12,2);
  // CRT_Write(Atascii2Antic(DISTANCEUNIT));
  // Help Keys
  CRT_GotoXY(0,6);
  WriteFF(strings[23]); // Navigation options
  WriteSpaces(1);
  WriteFF(strings[24]);  // FTL Jump
  WriteSpaces(1);
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
                          // sfx_play(voice4,255,168); // vol8
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

procedure console_ship;

var
  shipindex: Byte;
  selectPressed: Boolean = false;
  currentshipprice: Longword;

  //shp: ^TShip;
  //x,z: byte;

begin
  CRT_ClearRows(0,6);


  //CRT_GotoXY(0,0);

  CRT_WriteRightAligned(0,Atascii2Antic(concat(IntToStr(player.uec), CURRENCY)));

  shipindex:= 0; // show 1st available;

  tshp:=shipmatrix[availableships[shipindex]];
  offset:=(NUMBEROFSHIPS * player.loc) + availableships[shipindex];

  CRT_GotoXY(0,0);
  WriteFF(strings[38]); // Prod:
  CRT_Write(Atascii2Antic(prodmatrix[tshp^.mcode]));

  CRT_GotoXY(0,1);
  WriteFF(strings[37]); // Name:
  CRT_Write(Atascii2Antic(ships[tshp^.sindex * MAXSHIPPARAMETERS]));

  CRT_GotoXY(0,2);
  WriteFF(strings[39]); // Cargo:
  CRT_Write(tshp^.scu_max);
  // CRT_GotoXY(10,2);
  CRT_Write(Atascii2Antic(CARGOUNIT));

  CRT_GotoXY(0,3);
  WriteFF(strings[40]); // Price:
  CRT_Write(shipprices[(NUMBEROFSHIPS * player.loc) + tshp^.sindex]);
  // CRT_GotoXY(12,3);
  CRT_Write(Atascii2Antic(CURRENCY));


  CRT_GotoXY(23,1);
  WriteFF(strings[41]); // Speed:
  CRT_Write(tshp^.speed);
  // CRT_GotoXY(33,1);
  WriteFF(strings[45]);

  CRT_GotoXY(23,2);
  WriteFF(strings[42]); // Lenght:
  CRT_Write(tshp^.lenght);
  // CRT_GotoXY(33,2);
  WriteFF(strings[46]);

  CRT_GotoXY(23,3);
  WriteFF(strings[43]); // Mass:
  CRT_Write(tshp^.mass);
  // CRT_GotoXY(33,3);
  WriteFF(strings[47]);

  // Help Keys
  CRT_GotoXY(5,6);
  txt:=concat(char(30),char(31));
  CRT_Write(Atascii2Antic(txt));
  WriteFF(strings[44]);  // Choose
  WriteSpaces(1);
  CRT_Write('SELECT'*~);
  WriteFF(strings[19]);  // Confirm
  WriteSpaces(1);
  WriteFF(strings[7]);   // Back

  // CRT_GotoXY(0,0);
  // CRT_Write('shipindex='~);
  // CRT_Write(shipindex);
//   x:=0;
//   z:=0;
// for y:=0 to NUMBEROFSHIPS-1 do
//   begin
//     //offset:=(NUMBEROFSHIPS*player.loc)+y;
//     if y=7 then
//     begin
//        x:=20;
//        z:=7;
//     end;
//     CRT_GotoXY(x,y-z);
//     CRT_Write('avail_ships='~);
//     CRT_Write(availableships[y]);
//   end;
//
// repeat until CRT_Keypressed;
//
// x:=0;
// z:=0;
//
// for y:=0 to NUMBEROFSHIPS-1 do
// begin
//   offset:=(NUMBEROFSHIPS*player.loc)+y;
//   if y=7 then
//   begin
//      x:=20;
//      z:=7;
//   end;
//   CRT_GotoXY(x,y-z);
//   CRT_Write('price='~);
//   CRT_Write(shipprices[offset]);WriteSpaces(6);
// end;
//


  keyval:= 0;
  repeat

    If (CRT_Keypressed) then
    begin
        CRT_ClearRow(5);
        keyval := kbcode;
        case keyval of
          KEY_BACK:     begin
                          // sfx_play(voice4,255,168); // vol8
                          current_menu := MENU_MAIN;
                        end;
          KEY_LEFT:   begin
                          if (shipindex > 0) then
                          begin
                            // sfx_play(voice1,80,168); // vol8
                            Dec(shipindex);
                          end
                          else
                            // sfx_play(voice1,255,168); // vol8

                      end;
          KEY_RIGHT:  begin
                        if (shipindex < NUMBEROFSHIPS-1) and (availableships[shipindex+1] > 0) then
                        begin
                          // sfx_play(voice1,80,168); // vol8
                          Inc(shipindex);
                        end
                        else
                          // sfx_play(voice1,255,168); // vol8
                      end;

        end;
        if (current_menu=MENU_SHIP) and (shipindex <= NUMBEROFSHIPS-1) then

        begin
          tshp:=shipmatrix[availableships[shipindex]];
          offset:=(NUMBEROFSHIPS * player.loc) + availableships[shipindex];

          // CRT_GotoXY(0,4);
          // CRT_Write('shipindex='~);
          // CRT_Write(shipindex);
          // CRT_GotoXY(0,5);
          // CRT_Write('avail_ships='~);
          // CRT_Write(availableships[shipindex]);
          //
          // CRT_GotoXY(20,4);
          // CRT_Write('offset='~);
          // CRT_Write(offset);
          // CRT_GotoXY(20,5);
          // CRT_Write('price='~);
          // CRT_Write(shipprices[offset]);


          CRT_GotoXY(5,0);
          WriteSpaces(24);
          CRT_GotoXY(5,0);
          CRT_Write(Atascii2Antic(prodmatrix[tshp^.mcode]));
          CRT_GotoXY(5,1);
          WriteSpaces(14);
          CRT_GotoXY(5,1);
          offset:=tshp^.sindex * (MAXSHIPPARAMETERS);
          CRT_Write(Atascii2Antic(ships[offset]));
          CRT_GotoXY(6,2);
          WriteSpaces(7);
          CRT_GotoXY(6,2);
          CRT_Write(tshp^.scu_max);CRT_Write(Atascii2Antic(CARGOUNIT));
          CRT_GotoXY(6,3);
          WriteSpaces(12);
          CRT_GotoXY(6,3);
          offset:=(NUMBEROFSHIPS * player.loc) + availableships[shipindex];
          CRT_Write(shipprices[offset]);CRT_Write(Atascii2Antic(CURRENCY));
          CRT_GotoXY(29,1);
          WriteSpaces(9);
          CRT_GotoXY(29,1);
          CRT_Write(tshp^.speed);WriteFF(strings[45]);
          CRT_GotoXY(30,2);
          WriteSpaces(7);
          CRT_GotoXY(30,2);
          CRT_Write(tshp^.lenght);WriteFF(strings[46]);
          CRT_GotoXY(28,3);
          WriteSpaces(9);
          CRT_GotoXY(28,3);
          CRT_Write(tshp^.mass);WriteFF(strings[47]);
        end;
    end;


    if (CRT_SelectPressed) then
    begin
      if (selectPressed = false) then
      begin
        CRT_GotoXY(0,5);
        If ship.sindex <> availableships[shipindex] then
        begin
          currentshipprice:=shipprices[(NUMBEROFSHIPS * player.loc) + ship.sindex];
          if player.uec + currentshipprice >= shipprices[offset] then
          begin
            // sell current ship
            player.uec:=player.uec + currentshipprice;

            // buy new ship
            player.uec:=player.uec - shipprices[offset];
            ///ship:=shipmatrix[availableships[shipindex]];
            offset:=availableships[shipindex];
            tshp:=shipmatrix[offset];
            ship:= tshp^;
            current_menu:=MENU_MAIN;
          end
          else
          begin
            //Message not enough UEC
            CRT_GotoXY(6,5);
            WriteFF(strings[48]);CRT_Write(Atascii2Antic(CURRENCY));CRT_Invert(29,5,5)
          end;

        end
        else
        begin
          //Message that ship is already owned
          CRT_GotoXY(6,5);
          WriteFF(strings[49]);
        end;

      end;
      selectPressed:=true;
    end
    else
      selectPressed:=false;

    Waitframe;

  until (keyval = KEY_BACK) or (current_menu = MENU_MAIN);
end;


procedure trade_UpdateSelectedItem(selecteditemquantity:Word;selecteditemtotal:Longword);

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
  CRT_GotoXY(LISTSTART-(Length(tstr)+5),6); // -4 as 4 spaces will be drawn
  WriteSpaces(4); // fixed 4 chars for cargo size
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

  tstr:=locations[player.loc];
  CRT_GotoXY(0,0);
  CRT_Write(Atascii2Antic(tstr));
  l:=Length(tstr);

  CRT_GotoXY(LISTWIDTH-1,0);
  WriteSpaces(1);
  WriteFF(strings[8]); // Buy
  WriteSpaces(1);
  // invert at start
  CRT_Invert(LISTWIDTH-1,0,5);

  CRT_WriteRightAligned(Atascii2Antic(concat(IntToStr(currentuec), CURRENCY)));
  CRT_GotoXY(0,1);
  writeRuler;
  CRT_GotoXY(0,2);
  WriteFF(strings[10]);CRT_Write('  |'~); // Delivery
  WriteFF(strings[11]); // Available items
  CRT_GotoXY(0,3);
  CRT_Write('[ '~); CRT_Write(Atascii2Antic(ships[currentship.sindex*MAXSHIPPARAMETERS])); CRT_Write(' ]'~);
  CRT_GotoXY(LISTSTART-2,3);
  CRT_Write(' |'~);
  WriteFF(strings[12]);CRT_WriteRightAligned(FFTermToString(strings[13])); // commodity price
  CRT_GotoXY(0,4);
  writeRuler;
  CRT_GotoXY(0,5);
  WriteFF(strings[14]); //WriteSpaces(1);
  tstr:=IntToStr(currentship.scu_max);
  CRT_GotoXY(LISTSTART-(Length(tstr)+5),5);
  CRT_Write(Atascii2Antic(IntToStr(currentship.scu_max))); CRT_Write(Atascii2Antic(CARGOUNIT));CRT_Write('|'~);
  CRT_GotoXY(0,6);
  WriteFF(strings[15]); WriteSpaces(1);

  trade_UpdateCargo;

  CRT_GotoXY(0,7);
  CRT_Write('--------------------+'~);
  // sfx_play(voice4,77,200); // vol8

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


  CRT_GotoXY(0,22);
  txt:=concat(char(30+128),char(31+128));
  CRT_Write(Atascii2Antic(txt));
  CRT_Write('-x1 +'~);
  CRT_Write('CONTROL'*~);
  CRT_Write('-x100 +'~);
  CRT_Write('SHIFT'*~);
  WriteFF(strings[50]); WriteSpaces(1);
  WriteFF(strings[16]); WriteSpaces(1);
  WriteFF(strings[17]);


  // help
  CRT_GotoXY(2,23);
  CRT_Write('OPTION'*~);
  CRT_Write('-'~);
  WriteFF(strings[8]);
  CRT_Write('/'~);
  WriteFF(strings[9]);
  WriteSpaces(1);
  CRT_Write('SELECT'*~);
  WriteFF(strings[19]);
  WriteSpaces(1);
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

      selectitem:= false;
      if (selecteditemquantity < currentitemquantity) then
          if (mode = false) then begin
              if //(selecteditemquantity < currentShip.scu_max-currentShip.scu) and
                 (selecteditemtotal + currentitemprice <= currentuec ) then selectitem := true;
          end else // when selling
              if cargoPresent then selectitem:= true;

      case keyval of
        KEY_CANCEL: begin
                      currentuec:= player.uec;
                      currentShip:= ship;
                      mode:= false;

                      CRT_GotoXY(LISTSTART-3,0);
                      WriteSpaces(1);
                      WriteFF(strings[8]); // Buy
                      WriteSpaces(2);
                      CRT_Invert(LISTSTART-3,0,5);

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
                      // sfx_play(voice4,255,168); // vol8
                    end;
        KEY_OK:     begin
                      player.uec:= currentuec;
                      ship:= currentShip;
                      itemquantity[currentitemindex]:=itemquantity[currentitemindex]-selecteditemquantity;
                      current_menu:= MENU_MAIN;
                      // sfx_play(voice4,52,200); // vol8
                    end;
        KEY_BACK:   begin
                      // sfx_play(voice4,255,168); // vol8
                      current_menu := MENU_MAIN;
                      //gfx_fadeout(true);
                    end;
        KEY_UP, KEY_DOWN:
                    begin
                      d:=1;
                      if keyval = KEY_UP then d:=-1;
                      if (mode = false) then
                      begin
                        if checkItemPosition(itemindex+d) and (availableitems[itemindex+d] > 0) then
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
        KEY_CTRLLEFT:
                    begin
                      if (selecteditemquantity > 100) then
                      begin
                        selecteditemquantity:=selecteditemquantity - 100;
                        selecteditemtotal:=selecteditemquantity * currentitemprice;
                      end
                      else
                      begin
                        selecteditemquantity:=0;
                        selecteditemtotal:=0;
                      end;
                    end;
        KEY_SHIFTLEFT:
                    begin
                      if (selecteditemquantity > 0) then
                      begin
                        selecteditemquantity:=0;
                        selecteditemtotal:=0;
                      end;
                    end;
        KEY_RIGHT:  begin
                      // selectitem:= false;
                      // if (selecteditemquantity < currentitemquantity) then
                      //     if (mode = false) then begin
                      //         if (selecteditemquantity < currentShip.scu_max-currentShip.scu)
                      //           and (selecteditemtotal + currentitemprice <= currentuec ) then selectitem := true;
                      //     end else // when selling
                      //         if cargoPresent then selectitem:= true;

                      if selectitem and (selecteditemquantity < currentShip.scu_max-currentShip.scu) then
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

        KEY_CTRLRIGHT:
                    begin
                      if (mode = false) then   //buying mode
                      begin
                        //if selectitem and (selecteditemquantity < currentShip.scu_max-currentShip.scu) and
                        if selectitem and
                          (selecteditemquantity + 100 < currentShip.scu_max-currentShip.scu) and
                          (selecteditemtotal + (100 * currentitemprice) <= currentuec) then
                        begin
                          selecteditemquantity:= selecteditemquantity + 100;
//                          selecteditemtotal:=selecteditemquantity * currentitemprice;
                        end
                        else
                        begin
                          selecteditemquantity:=trunc(currentuec / currentitemprice);
                          if selecteditemquantity > currentShip.scu_max-currentShip.scu then selecteditemquantity:=currentShip.scu_max-currentShip.scu;
//                          selecteditemtotal:=selecteditemquantity * currentitemprice;
                        end;
  //                      else
  //                       CRT_WriteRightAligned(19,FFTermToString(strings[??]));
                      end
                      else  // selling mode
                      begin
                        If selectitem and (selecteditemquantity + 100 < currentShip.cargoquantity[itemindex]) then
                        begin
                          selecteditemquantity:= selecteditemquantity + 100;
//                          selecteditemtotal:=selecteditemquantity * currentitemprice;
                        end
                        else
                        begin
                          selecteditemquantity:=currentShip.cargoquantity[itemindex];
//                          selecteditemtotal:=selecteditemquantity * currentitemprice;
                        end;
                      end;
                      selecteditemtotal:=selecteditemquantity * currentitemprice;
                    end;

        KEY_SHIFTRIGHT:
                    begin
                      if (mode = false) then   //buying mode
                      begin
                        if selectitem and (selecteditemquantity < currentShip.scu_max-currentShip.scu) then
                        begin
                          selecteditemquantity:=trunc(currentuec / currentitemprice);
                          if selecteditemquantity > currentShip.scu_max-currentShip.scu then
                            selecteditemquantity:=currentShip.scu_max-currentShip.scu;
//                          selecteditemtotal:=selecteditemquantity * currentitemprice;
                        end;
  //                      else
  //                       CRT_WriteRightAligned(19,FFTermToString(strings[??]));
                      end
                      else  // selling mode
                      begin
                        if selectitem and (selecteditemquantity < currentShip.cargoquantity[itemindex]) then
                        begin
                            selecteditemquantity:=currentShip.cargoquantity[itemindex];
//                          selecteditemtotal:=selecteditemquantity * currentitemprice;
                        end;
                      end;
                      selecteditemtotal:=selecteditemquantity * currentitemprice;
                    end;



      end;
      //If keyval = (KEY_LEFT or KEY_RIGHT or KEY_CTRLLEFT or KEY_CTRLRIGHT or KEY_SHIFTLEFT or KEY_SHIFTRIGHT) then trade_UpdateSelectedItem(selecteditemquantity,selecteditemtotal);
      If (keyval = KEY_LEFT) or (keyval = KEY_RIGHT) or (keyval = KEY_CTRLLEFT) or (keyval = KEY_CTRLRIGHT) or
         (keyval = KEY_SHIFTLEFT) or (keyval = KEY_SHIFTRIGHT) then trade_UpdateSelectedItem(selecteditemquantity,selecteditemtotal);
    end;

    if (CRT_OptionPressed) and (optionPressed=false) then
    begin
      mode:= not mode;
      CRT_ClearRow(19);
      if (mode = false) then
      begin
        CRT_GotoXY(LISTSTART-3,0);
        WriteSpaces(1);
        WriteFF(strings[8]); // Buy
        WriteSpaces(2);
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
        WriteSpaces(1);
        WriteFF(strings[9]); // Buy
        WriteSpaces(1);
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
                  // for l:=y to MAXCARGOSLOTS-1 do
                  // begin
                  //   if (l < MAXCARGOSLOTS-1) then
                  //   begin
                  //     currentShip.cargoindex[l]:=currentShip.cargoindex[l+1];
                  //     currentShip.cargoquantity[l]:=currentShip.cargoquantity[l+1];
                  //   end
                  //   else
                  //   begin
                  //     currentShip.cargoindex[l]:=0;
                  //     currentShip.cargoquantity[l]:=0;
                  //   end;
                  // end;
                  move (currentShip.cargoindex[y+1],currentShip.cargoindex[y],High(currentShip.cargoindex)-y);
                  move (currentShip.cargoquantity[y+1],currentShip.cargoquantity[y],High(currentShip.cargoquantity)-y);
                  currentShip.cargoindex[High(currentShip.cargoindex)]:=0;
                  currentShip.cargoquantity[High(currentShip.cargoquantity)]:=0;
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
  //gfx_fadeout(true);

  // gfx_fadein;
   // gfxcolors[0]:=piccolors[y];
   // gfxcolors[1]:=piccolors[y+1];
   // gfxcolors[2]:=piccolors[y+2];
   // gfxcolors[3]:=piccolors[y+3];

  // load ship to be able to check if they are avaiable


  CRT_ClearRows(0,6);

  CRT_GotoXY(14,0);
  WriteFF(strings[3]); // Navigation
  CRT_GotoXY(14,1);
  WriteFF(strings[4]); // Trade Console

  LoadShips;
  // show ship console only when there are ships avaiable (price > 0 for 1st ship at a location)
  offset:=(NUMBEROFSHIPS * player.loc) + availableships[0];
  if shipprices[offset] > 0 then
  begin
    CRT_GotoXY(14,2);
    WriteFF(strings[6]); // Ship Hangar
  end;
  CRT_GotoXY(18,3);
  WriteFF(strings[7]); // Back

  // CRT_GotoXY(0,3);
  // CRT_Write('offset='~);CRT_Write(offset);
  // CRT_GotoXY(0,4);
  // CRT_Write('av_ship[0]='~);CRT_Write(availableships[0]);CRT_Write('|'~);
  // CRT_GotoXY(0,5);
  // CRT_Write('price='~);CRT_Write(shipprices[offset]);



  EnableVBLI(@vbl);
  EnableDLI(@dli1);
  Waitframe;
  DLISTL := DISPLAY_LIST_ADDRESS_MENU;
  gfx_fadein;

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
        KEY_OPTION4: begin
                      // if there is an ship in available ship enable console_ship
                      if (shipprices[offset] > 0) then current_menu := MENU_SHIP;
                     end;
        KEY_BACK: begin
                    // sfx_play(voice4,255,168); // vol8
                    current_menu := MENU_TITLE;
                  end;
      end;
    end;
    Waitframe;

  until (keyval = KEY_BACK) or (keyval = KEY_OPTION1) or (keyval = KEY_OPTION2) or (keyval = KEY_OPTION3) or (keyval = KEY_OPTION4);
end;

procedure title;

var
  startPressed: Boolean = false;

begin
  startPressed:=false;

  gfx_fadeout(true);
  pic_load(GFX,0);
  // sfx_init;

  CRT_ClearRows(0,5);
  CRT_GotoXY(14,0);
  WriteFF(strings[1]); // New game;
  y:=1;
  if gamestate = GAMEINPROGRESS then
  begin
      CRT_GotoXY(14,y);
      WriteFF(strings[51]); // Continue game;
      Inc(y);
      CRT_GotoXY(15,y);
      CRT_Write('1'*~); WriteSpaces(1); WriteFF(strings[52]); // Save
      Inc(y);
      CRT_GotoXY(15,y);
      CRT_Write('2'*~); WriteSpaces(1); WriteFF(strings[53]); // Load
      Inc(y);
  end;
  CRT_GotoXY(16,y);
  WriteFF(strings[2]); // Quit;

  txt:= FFTermToString(strings[0]); // read scroll text
  move(txt[1],pointer(SCROLL_ADDRESS+42),sizeOf(txt)); // copy text to vram

  EnableVBLI(@vbl_title);
  EnableDLI(@dli_title1);
  Waitframe;
  DLISTL := DISPLAY_LIST_ADDRESS_TITLE;
  Waitframe;
  gfx_fadein;


  //keyval:=chr(0);
  keyval:=0;
  repeat
    //msx.play;
    if CRT_Keypressed then
    begin
      //keyval := char(CRT_Keycode[kbcode]);
      keyval := kbcode;
      case keyval of
          KEY_NEW:      start;
          KEY_CANCEL:   begin
                          gfx_fadeout(true);
                          current_menu:=MENU_MAIN;
                        end;
          KEY_OPTION1:  begin
                          gfx_fadeout(true);
                          current_menu:=MENU_SAVE;
                        end;
          KEY_OPTION2:  begin
                          gfx_fadeout(true);
                          current_menu:=MENU_LOAD;
                        end;
      // else
      // begin
      //   CRT_GotoXY(0,5);
      //   CRT_Write('Klawisz='~);
      //   CRT_Write(asc(keyval));
      //   CRT_Write('   Kod='~);
      //   CRT_Write(keyval);
      //   WriteSpaces(2);
      // end;
(*
          // KEY_OPTION1: sfx_play(185,16*12+4);
          // KEY_OPTION2: sfx_play(110,16*12+4);
          // KEY_OPTION3: sfx_play(60,16*12+4);
          // KEY_OPTION4: sfx_play(20,16*12+4);
          // KEY_OPTION5: sfx_play(10,16*12+4);
          // KEY_OPTION6: sfx_play(5,16*12+4);
*)
(*
          KEY_OPTION1: msx.sfx(0,voice4,185);
          KEY_OPTION2: msx.sfx(0,voice4,110);
          KEY_OPTION4: msx.sfx(0,voice4,20);
          KEY_OPTION3: msx.sfx(0,voice4,60);
          KEY_OPTION5: msx.sfx(0,voice4,10);
          KEY_OPTION6: msx.sfx(0,voice4,5);
*)
      end;
    end;
    If CRT_StartPressed and (startPressed = false) then
    begin
      startPressed:=true;
      start;
    end;

    Waitframe;

  until (keyval = KEY_QUIT) or (keyval = KEY_NEW) or (startPressed = true) or (keyval = KEY_CANCEL) or (keyval = KEY_OPTION1) or (keyval = KEY_OPTION2);
end;

procedure disk_save(num: byte);
begin
  tstr:='slot';
  tstr:=concat(tstr,inttostr(num));
  tstr:=concat(tstr,'   SAV');
  if (xBiosCheck <> 0) then
  begin
    xBiosOpenFile(tstr);

    if (xBiosIOresult = 0) then
    begin
      xBiosWriteData(@player.uec);
      xBiosFlushBuffer;
    end
  end;
end;

procedure disk_load(num: byte);
begin
  tstr:='slot';
  tstr:=concat(tstr,inttostr(num));
  tstr:=concat(tstr,'   SAV');
  if (xBiosCheck <> 0) then
  begin
    xBiosOpenFile(tstr);

    if (xBiosIOresult = 0) then
    begin
      xBiosLoadData(@player.uec);
      xBiosFlushBuffer;
    end
  end;
end;

procedure menu_save_load(mode: Boolean);
var
  slot, oldslot : Byte;
  selectPressed: Boolean = false;

begin
  CRT_ClearRows(0,6);

  CRT_GotoXY(10,0);
  if mode then txt:=FFTermToString(strings[52])  // save mode
  else txt:=FFTermToString(strings[53]);          // load mode

  WriteSpaces(8);CRT_Write(txt);WriteSpaces(8); // Save
  CRT_Invert(10,0,Length(txt)+16); // plus all 16 spaces
  txt:=FFTermToString(strings[54]);
  count:=Length(txt);
  for y:=1 to 5 do
  begin
    CRT_GotoXY(14,y);
    WriteSpaces(3);CRT_Write(txt);CRT_Write(y);WriteSpaces(3);
  end;

  // Help Keys
  CRT_GotoXY(0,6);
  WriteFF(strings[23]); // Navigation options
  WriteSpaces(1);
  CRT_Write('SELECT'*~);
  WriteFF(strings[19]);  // Confirm
  WriteSpaces(1);
  WriteFF(strings[7]); // Back

  EnableVBLI(@vbl);
  EnableDLI(@dli1);
  Waitframe;
  DLISTL := DISPLAY_LIST_ADDRESS_MENU;
  gfx_fadein;

  slot:=0;
  oldslot:=0;
  selectPressed:=false;

  keyval:= 0;
  repeat

    If (CRT_Keypressed) then
    begin


        keyval := kbcode;
        case keyval of
          KEY_BACK:     begin
                          // sfx_play(voice4,255,168); // vol8
                          current_menu := MENU_TITLE;
                        end;
          KEY_OPTION1:  begin
                          oldslot:=slot;
                          slot:=1;
                         end;
          KEY_OPTION2:  begin
                          oldslot:=slot;
                          slot:=2;
                        end;
          KEY_OPTION3:  begin
                          oldslot:=slot;
                          slot:=3;
                        end;
          KEY_OPTION4:  begin
                          oldslot:=slot;
                          slot:=4;
                        end;
          KEY_OPTION5:  begin
                          oldslot:=slot;
                          slot:=5;
                        end;

        end;
        if (current_menu=MENU_SAVE) and (slot > 0) then
        begin
          If (oldslot > 0) then CRT_Invert(14,oldslot,count+8);
          CRT_Invert(14,slot,count+8);
        end;
    end;
    if CRT_SelectPressed and (slot > 0) and (selectPressed = false) then
    begin
      if mode then disk_save(slot)
      else disk_load(slot);
      selectPressed:= true;
      current_menu:=MENU_TITLE;
    end;
    Waitframe;

  until (keyval = KEY_BACK) or CRT_SelectPressed;
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
  //CRT_Write('Loading...'~);
  //player.loc:=STARTLOCATION; //start location Port Olisar


  // EnableVBLI(@vbl_title);
  // EnableDLI(@dli_title1);
  // Waitframe;
  // DLISTL := DISPLAY_LIST_ADDRESS_TITLE;
  //
  // gfx_fadeout;
  // pic_load(GFX,0);
  // gfx_fadein(piccolors[0],piccolors[1],piccolors[2],piccolors[3]);
  // sfx_init;

  // Initialize RMT player
  msx.player:=pointer(RMT_PLAYER_ADDRESS);
  msx.modul:=pointer(RMT_MODULE_ADDRESS);
  msx.init(0);

  // load ships data into an array of records.
  for y:=0 to NUMBEROFSHIPS-1 do
  begin
    tshp:=shipmatrix[y];
    offset:=(y * MAXSHIPPARAMETERS);
    tshp^.mcode:=byte(ships[offset+1]);
    tshp^.sindex:=y;
    tshp^.scu_max:=Word(ships[offset+2]);
    tshp^.speed:=byte(ships[offset+3]);
    tshp^.lenght:=byte(ships[offset+4]);
    tshp^.mass:=Word(ships[offset+5]);
  end;

  gamestate:= NEWGAME;
  current_menu := MENU_TITLE;

  repeat
    case current_menu of
      MENU_TITLE: title;
      MENU_MAIN:  menu;
      MENU_NAV:   console_navigation;
      MENU_TRADE: console_trade;
      //MENU_MAINT: console_maint;
      MENU_SHIP:  console_ship;
      MENU_SAVE:  menu_save_load(true);
      MENU_LOAD:  menu_save_load(false);
    end;
    repeat Waitframe until not CRT_Keypressed;

  until keyval = KEY_QUIT;

  // restore system
  SystemReset;
end.
