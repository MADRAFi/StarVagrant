program StarVagrant;
{$librarypath '../Libs/lib/';'../Libs/blibs/';'../Libs/base/'}
// {$librarypath '../blibs/'}
uses atari, b_utils, b_system, b_crt, sysutils; //, mad_xbios; // disabled till I know hot to use it

const
{$i 'const.inc'}

  CURRENCY = ' UEC';
  CARGOUNIT = ' SCU';
  DISTANCE = ' DU';
  COMMISSION = 0.05;

type
{$i 'types.inc'}
{$r 'resources.rc'}

var
  keyval: char = chr(0);


  //msx: TRMT;
  current_menu: Byte;

  (*
  * 0 - colpf0
  * 1 - colpf1
  * 2 - colpf2
  * 3 - colpf3
  * 4 - colbk
  *)
  gfxcolor0: Byte;
  gfxcolor1: Byte;
  gfxcolor2: Byte;
  gfxcolor3: Byte;
  gfxcolor4: Byte;

  player: TPlayer;
  ship: TShip;

//commission: shortreal = 0.05;
  strings: array [0..0] of Word absolute STRINGS_ADDRESS;
  locations: array [0..0] of Word absolute LOCATIONS_ADDRESS;
  items: array [0..0] of Word absolute ITEMS_ADDRESS;

  itemprice: array [0..(NUMBEROFLOCATIONS*NUMBEROFITEMS)-1] of Word = (
    26,0,0,0,8,4,0,3,7,5,0,6,0,0,28,17,0,0,0,3,8,4,1,0,
    26,0,12,0,8,4,0,0,7,5,0,6,0,0,29,18,0,0,0,0,8,4,0,24,
    0,0,12,0,0,0,0,0,0,5,0,0,0,0,0,18,1,0,0,3,0,0,0,24,
    0,1,10,0,0,0,2,0,0,5,0,0,1,0,0,18,1,0,0,3,0,0,0,15,
    24,0,12,0,0,4,0,0,0,5,0,6,0,0,0,18,1,1,0,3,0,4,1,24,
    0,0,12,0,0,0,0,0,0,5,0,0,0,0,0,18,1,0,0,3,0,0,0,24,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

  );  // price matrix for items
  itemquantity: array [0..(NUMBEROFLOCATIONS*NUMBEROFITEMS)-1] of Word = (
    0,0,0,0,10000,10000,0,10000,0,1000,0,0,0,0,0,60000,0,0,0,10000,2000,0,60000,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,60000,0,
    0,0,0,0,0,0,10000,0,0,0,10000,0,5000,5000,0,0,0,0,0,0,0,0,60000,0,
    0,0,5000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,60000,10000,
    10000,0,0,0,0,5000,0,0,0,0,0,10000,0,0,0,0,0,5000,0,0,0,10000,60000,0,
    5000,0,0,0,0,5000,0,5000,0,0,0,0,0,0,0,0,0,10000,0,0,0,5000,60000,0,
    0,0,0,0,0,0,0,0,0,10000,0,0,0,0,0,0,10000,0,0,5000,0,0,0,0,
    0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,
    0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,1,0,0,1,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,
    0,0,1,1,0,1,0,0,0,1,0,0,1,0,0,1,1,0,0,1,0,0,0,1,
    1,0,1,0,1,1,0,0,1,1,0,1,0,0,1,1,0,0,0,0,1,1,0,1,
    1,0,0,0,1,1,0,0,1,1,0,1,0,0,1,1,0,0,0,1,1,1,0,1,
    0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,
    0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

  ); // quantities of items

  locationdistance: array[0..(NUMBEROFLOCATIONS*NUMBEROFLOCATIONS)-1] of Word =
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


procedure start;
// var
//   x: byte;

begin
  //msx.Sfx(3, 2, 24);
  //generateworld;
  player.uec:= 5000; // start cash
  player.loc:= 0; //start location Port Olisar

  //mocap starting ship
  ship.sname:= 'Cuttlas Black';
  ship.scu_max:=46;
  ship.scu:=0;

  // for x:=0 to MAXCARGOSLOTS-1 do
  // begin
  //     ship.cargoindex[x]:= 0;
  //     ship.cargoquantity[x]:= 0;
  // end;

  // ship.cargoindex[0]:=8;
  // ship.cargoquantity[0]:=10;
  // ship.cargoindex[1]:=11;
  // ship.cargoquantity[1]:=20;
  // ship.scu:= 30;

  //xbios_opencurrentdir;
  //xbios_openfile('star1   sav');
  //xbios_write(@ship);

end;

procedure writeRuler;
begin
    CRT_Write('--------------------+-------------------'~);
end;

procedure WriteSpaces(len:byte);
begin
  CRT_Write(Atascii2Antic(Space(len)));
end;

procedure WriteFF(ptr:word);
begin
    CRT_Write(FFTermToString(ptr));
end;

procedure CRT_ClearRows(start: Byte;num: Byte);
var
   y: Byte;

begin
  for y:=start to num do
    CRT_ClearRow(y);
end;

procedure eraseArray(min: Byte; max: Byte; arrptr: Pointer);
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


procedure ListCargo(myship: Tship;mode : Boolean);
const
  LISTWIDTH = 20;
  LISTSTART = 0;
  TOPCARGOMARGIN = 8;

var
  x: Byte;
  count: Byte = 1;
  str: TString;
  strnum: TString;
  offset: Word = 0;


begin
  count:=1;
  for x:=0 to MAXCARGOSLOTS-1 do // max available items
  begin
    offset:=myship.cargoindex[x];
    if offset > 0 then
    begin
      CRT_GotoXY(LISTSTART,7+count); //min count:=1 so we start at 8th row
      str:= FFTermToString(items[offset]);
      CRT_Write(str);
      strnum:=IntToStr(myship.cargoquantity[x]);
      WriteSpaces(LISTWIDTH-Length(str)-Length(strnum));
      CRT_Write(Atascii2Antic(strnum));
      if (count = 1) and mode then CRT_Invert(LISTSTART,8,LISTWIDTH);
      Inc(count);
    end;
  end;
  for x:=count to MAXCARGOSLOTS-1 do
  begin
    CRT_GotoXY(LISTSTART,TOPCARGOMARGIN+x-1);
    WriteSpaces(LISTWIDTH); // -1 to clear from the end of list
  end;
end;


procedure ListItems(mode: boolean);
const
  LISTSTART = 21;
  LISTWIDTH = 19;


var
  x: byte;
  count:byte = 1;
  str: TString;
  pricestr: TString;
  countstr: Tstring;
  finalprice: word;
  offset: Word = 0;

  visible: Boolean;

begin

//load items

  count:=0;
  for x:=0 to NUMBEROFITEMS-1 do
    begin
      visible:= false;
      offset:=(NUMBEROFITEMS*player.loc) + x;

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

    // clear avaiable items array when mode is changed and less items are present
    // if (count < MAXAVAILABLEITEMS-1) then
    // begin
    //   for x:=count to MAXAVAILABLEITEMS-1 do
    //   //begin
    //     availableitems[x]:=0;
    //   //end;
    // end;
    eraseArray(count,MAXAVAILABLEITEMS-1, @availableitems);


  // list items

  count:=1;
  for x:=0 to MAXAVAILABLEITEMS-1 do // max available items
    begin
      // offset:=availableitems[x];
      if (availableitems[x] > 0) then
      begin

        offset:=availableitems[x];
        CRT_GotoXY(LISTSTART,4+count); //min count:=1 so we start at 4th row

        CRT_Write(count);CRT_Write(' '~);
        str:= FFTermToString(items[availableitems[x]-(player.loc*NUMBEROFITEMS)]);
        CRT_Write(str);
        if mode then finalprice:=Trunc(itemprice[offset]*(1-COMMISSION))
        else finalprice:=itemprice[offset];
        countstr:=IntToStr(count);
        pricestr:=IntToStr(finalprice);
        WriteSpaces(LISTWIDTH-(Length(countstr)+1+Length(str))-Length(pricestr)); // (count, space and string)-price
        CRT_Write(Atascii2Antic(pricestr));
        //CRT_WriteRightAligned(Atascii2Antic(IntToStr(finalprice)));
        if (count = 1) and (mode = false) then CRT_Invert(LISTSTART,5,LISTWIDTH);
        inc(count);
      end
      else
      begin
        CRT_GotoXY(LISTSTART,4+x+1);
        WriteSpaces(LISTWIDTH);
      end;

    end;
end;


procedure LoadDestinations(loc: Byte);
const
  LISTSTART = 20;

var
  x: Byte;
  count: Byte;
  offset: Word;

begin

  // Load destinations
  count:=0;
  for x:=0 to NUMBEROFLOCATIONS-1 do
  begin
    offset:=(NUMBEROFLOCATIONS*loc) + x;
    if locationdistance[offset] > 0 then
    begin
      availabledestinations[count]:=offset;
      inc(count);
    end;
  end;

  Waitframe;

  // if (count < MAXAVAILABLEDESTINATIONS-1) then
  // begin
  //   for x:=count to MAXAVAILABLEDESTINATIONS-1 do
  //     availabledestinations[x]:=0;
  // end;

  // clear avaiable destinations array when less destinations are present
  eraseArray(count,MAXAVAILABLEDESTINATIONS-1, @availabledestinations);



  // list destinations
  count:=0;

  for x:=0 to MAXAVAILABLEDESTINATIONS-1 do
  begin
    if (availabledestinations[x] > 0) then
    begin
      offset:=availabledestinations[x]-(loc*NUMBEROFLOCATIONS); // calculate base location index
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

end;


function CheckItemPosition(newindex : Byte) : Boolean;
begin
  result:=(newindex < MAXAVAILABLEITEMS) and (newindex >= 0);
end;

function CheckCargoPosition(newindex : Byte) : Boolean;
begin
  result:=(newindex < MAXCARGOSLOTS) and (newindex >= 0);
end;

function GetItemPrice(itemindex : Byte; mode : Boolean): Word;
// Get item price based on itemindex of available items mode is false for BUY and tru for SELL

var
  finalprice: word;
  price: word;
  offset: word;

begin
  offset:=availableitems[itemindex];
  price:=itemprice[offset];
  if mode then
  begin
    finalprice:=Trunc(price*(1-commission))
  end
  else
  begin
    finalprice:=price;
  end;
  Result:= finalprice;

end;


function GetCargoPrice(myship: TShip; itemindex: Byte): Word;
// Get item price based on itemindex of available items mode is false for BUY and tru for SELL
begin

//  price:=itemprice[offset];
//  Result:=Trunc(price*(1-commission))
  Result:=Trunc(itemprice[myship.cargoindex[itemindex]]*(1-commission))
end;

function CheckCargoPresence(myship: TShip; itemindex: Byte): Boolean;

var
  item: Word;

begin
  Result:= false;
  //for item in availableitems do
  for item:=0 to MAXAVAILABLEITEMS-1 do
    begin
      if myship.cargoindex[itemindex] = availableitems[item] then exit(true);
    end
end;

procedure navi_destinationUpdate(locationindex: Word);
//var
  //str: TString;

begin
  CRT_GotoXY(0,1);
  WriteSpaces(19); // max location lenght
  CRT_GotoXY(0,1);
  WriteFF(strings[21]);
  WriteFF(locations[locationindex-(player.loc*NUMBEROFLOCATIONS)]);
end;

procedure navi_distanceUpdate(mydistance: Word);
//var
  //str: TString;

begin
  CRT_GotoXY(0,2);
  WriteSpaces(19); // max distance lenght
  CRT_GotoXY(0,2);
  WriteFF(strings[22]);
  CRT_Write(mydistance); CRT_Write(Atascii2Antic(DISTANCE));
end;


// procedure fade_gfx;
//
// begin
//   repeat
//     If (gfxcolor0 > 0) then Dec(gfxcolor0);
//     If (gfxcolor1 > 0) then Dec(gfxcolor1);
//     If (gfxcolor2 > 0) then Dec(gfxcolor2);
//     If (gfxcolor3 > 0) then Dec(gfxcolor3);
//     If (gfxcolor4 > 0) then Dec(gfxcolor4);
//
//     Waitframe;
//   until (gfxcolor0 = 0) and (gfxcolor1 = 0) and (gfxcolor2 = 0) and (gfxcolor3 = 0) and (gfxcolor4 = 0);
// end;

procedure console_navigation;
var
  y: byte;
  destinationindex: Word;
  distance: Word;

begin
  // for y:=0 to 6 do
  //   CRT_ClearRow(y);
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

  LoadDestinations(player.loc);


  keyval:= chr(0);
  repeat
  //  pause;
  //  msx.play;
    If (CRT_Keypressed) then
    begin

        keyval := char(CRT_Keycode[kbcode]);
        case keyval of
          KEY_BACK: current_menu := MENU_MAIN;
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
                          if destinationindex > 0 then
                          begin
                            CRT_ClearRow(7);
                            for y:=0 to MAXAVAILABLEDESTINATIONS-1 do
                              begin
                                CRT_GotoXY(20,0+y); // liststart
                                WriteSpaces(18); // clear rows
                              end;

                            // fade

                            repeat
                              If (gfxcolor0 > 0) then Dec(gfxcolor0);
                              If (gfxcolor1 > 0) then Dec(gfxcolor1);
                              If (gfxcolor2 > 0) then Dec(gfxcolor2);
                              If (gfxcolor3 > 0) then Dec(gfxcolor3);
                              If (gfxcolor4 > 0) then Dec(gfxcolor4);

                              Waitframe;
                            until (gfxcolor0 or gfxcolor1 or gfxcolor2 or gfxcolor3 or gfxcolor4) = 0;

                            // simulate travel
                            repeat
                              Waitframes(5);
                              Dec(distance);
                              navi_distanceUpdate(distance);
                            until (distance = 0);

                            player.loc:=destinationindex-(player.loc*NUMBEROFLOCATIONS);
                            current_menu:=MENU_MAIN;
                          end;
                        end;
        end;
        //updateNavi(destinationindex);
        distance:=locationdistance[destinationindex];
        navi_destinationUpdate(destinationindex);
        navi_distanceUpdate(distance);
    end;
    Waitframe;

  until (keyval = KEY_BACK) OR (keyval = KEY_JUMP);
end;

procedure UpdateSelectedItem(selecteditemquantity:Word;selecteditemtotal:Longword);
var
  str: String;

begin
  str:= concat(IntToStr(selecteditemquantity),CARGOUNIT);
  str:= concat(str,FFTermToString(strings[18]));
  str:= concat(str,IntToStr(selecteditemtotal));
  str:= concat(str,CURRENCY);
  CRT_ClearRow(19);
  CRT_WriteRightAligned(19,Atascii2Antic(str));
end;


procedure trade_UpdateUEC(uec: Longword);

const
  LISTSTART = 21;
  LISTWIDTH = 19;

var
  strnum: TString;
  //liststart: Byte;
  //listwidth: Byte;

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

procedure trade_UpdateCargo(myship: TShip);

const
  LISTSTART = 21;
var
  str: TString;
  //liststart: Byte;

begin
  //liststart:=(CRT_screenWidth shr 1)+1;
  // update cargo Total
  str:=IntToStr(myship.scu_max-myship.scu);
  CRT_GotoXY(LISTSTART-(Length(str)+5)-4,6);
  CRT_Write('    '~); // fixed 4 chars for cargo size
  CRT_GotoXY(LISTSTART-(Length(str)+5),6);
  CRT_Write(Atascii2Antic(str)); CRT_Write(Atascii2Antic(CARGOUNIT));CRT_Write('|'~);
end;

procedure console_trade;

const
  LISTTOPMARGIN = 5;
  CARGOTOPMARGIN = 8;
  LISTSTART = 21;
  LISTWIDTH = 19;

var
  y: Byte;
  d: shortInt;
  mode: Boolean = false;

  optionPressed: Boolean = false;
  selectPressed: Boolean = false;
  cargoPresent: Boolean = false;
  selectitem: Boolean = false;
  str: TString;
  //strnum: TString;

  l: Byte;
  itemindex: Byte = 0;
  //listwidth: Byte = 19;
  //liststart: Byte = 21;


  currentitemindex: Word;
  currentitemquantity: Word;
  currentitemprice: Word;

  currentuec: Longword;
  currentShip:TShip;


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
  keyval:= chr(0);

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

  str:=FFTermToString(locations[player.loc]);
  CRT_GotoXY(0,0);
  CRT_Write(str);
  l:=Length(str);

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
  str:=IntToStr(currentship.scu_max-currentship.scu);
  CRT_GotoXY(LISTSTART-(Length(str)+5),6);
  CRT_Write(Atascii2Antic(str)); CRT_Write(Atascii2Antic(CARGOUNIT));CRT_Write('|'~);
  CRT_GotoXY(0,7);
  CRT_Write('--------------------+'~);


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

  //LoadItems(player.loc, false);
  ListItems(false);
  ListCargo(currentShip,false);
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
      keyval := char(CRT_Keycode[kbcode]);

      case keyval of
        KEY_CANCEL: begin
                      currentuec:= player.uec;
                      currentShip:= ship;

                      //LoadItems(player.loc,false);
                      ListItems(false);
                      ListCargo(currentShip,false);
                      selecteditemquantity:= 0;
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
                      trade_UpdateCargo(currentShip);

                    end;
        KEY_OK:     begin
                      player.uec:= currentuec;
                      ship:= currentShip;
                      itemquantity[currentitemindex]:=itemquantity[currentitemindex]-selecteditemquantity;
                      current_menu:= MENU_MAIN;
                    end;
        KEY_BACK:   current_menu := MENU_MAIN;
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
                          currentitemindex:=availableitems[itemindex];
                          CRT_ClearRow(19);
                        end;
                      end
                      else  // when selling
                      begin
                        if CheckCargoPosition(itemindex+d) and (currentShip.cargoindex[itemindex+d] > 0)  then
                        begin
                          CRT_Invert(0,itemindex + CARGOTOPMARGIN,LISTWIDTH+1);
                          itemindex:=itemindex+d;
                          currentitemquantity:=currentShip.cargoquantity[itemindex];
                          currentitemprice:=GetCargoPrice(currentShip,itemindex);
                          currentitemindex:=currentShip.cargoindex[itemindex];
                          CRT_Invert(0,itemindex + CARGOTOPMARGIN,LISTWIDTH+1); // selecting the whole row with item
                          cargoPresent:=CheckCargoPresence(currentShip,itemindex);
                        end;
                      end;
                      selecteditemtotal:=0;
                      selecteditemquantity:=0;
                    end;
        KEY_LEFT:   begin
                      if (selecteditemquantity > 0) then
                      begin
                        Dec(selecteditemquantity);
                        selecteditemtotal:=selecteditemquantity * currentitemprice;
                        UpdateSelectedItem(selecteditemquantity,selecteditemtotal);
                      end;
                    end;
        KEY_RIGHT:  begin
                      selectitem:= false;
                      if (selecteditemquantity < currentitemquantity) and (selecteditemtotal + currentitemprice <= currentuec ) then
                          if (mode = false) then begin
                              if (selecteditemquantity < currentShip.scu_max-currentShip.scu) then selectitem := true;
                          end else // when selling
                              if cargoPresent then selectitem:= true;

                      if selectitem then
                      begin
                        Inc(selecteditemquantity);
                        selecteditemtotal:=selecteditemquantity * currentitemprice;
                        UpdateSelectedItem(selecteditemquantity,selecteditemtotal);
                      end
                      else
//                        CRT_WriteRightAligned(19,FFTermToString(strings[20]));
                    end;
      end;

    end;

    if (CRT_OptionPressed) and (optionPressed=false) then
    begin
      mode:= not mode;
      if (mode = false) then
      begin
        CRT_GotoXY(LISTSTART-3,0);
        CRT_Write(' '~);
        WriteFF(strings[8]); // Buy
        CRT_Write('  '~);
        CRT_Invert(LISTSTART-3,0,5);

        //LoadItems(player.loc,false);
        ListItems(false);

        // // debug
        // for y:=0 to MAXAVAILABLEITEMS-1 do
        // begin
        //  str:=concat('availableitems[',IntToStr(y));
        //  str:=concat(str,']=');
        //  str:=concat(str,IntToStr(availableitems[y]));
        //  CRT_WriteXY(0,8+y,Atascii2Antic(str));
        // end;
        // //

        ListCargo(currentShip,false);
        itemindex:=0;
      end
      else begin
        CRT_GotoXY(LISTSTART-3,0);
        CRT_Write(' '~);
        WriteFF(strings[9]); // Buy
        CRT_Write(' '~);
        CRT_Invert(LISTSTART-3,0,6);

        //LoadItems(player.loc, true);
        ListItems(true);

       //  // debug
       //  for y:=0 to MAXAVAILABLEITEMS-1 do
       //  begin
       //   str:=concat('available[',IntToStr(y));
       //   str:=concat(str,']=');
       //   str:=concat(str,IntToStr(availableitems[y]));
       //   CRT_WriteXY(0,8+y,Atascii2Antic(str));
       // end;
       //  //

        ListCargo(currentShip,true);
        currentitemquantity:=currentShip.cargoquantity[itemindex];
        currentitemprice:=GetCargoPrice(currentShip,itemindex);
        currentitemindex:=currentShip.cargoindex[itemindex];

        itemindex:=0;
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
              trade_UpdateCargo(currentShip);

              // remove selection
              currentitemprice:=GetCargoPrice(currentShip,itemindex);
              currentitemindex:=currentShip.cargoindex[itemindex];
              selecteditemquantity:= 0;
              selecteditemtotal:=0;
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

                  // fillbyte(currentShip.cargoindex[y],(MAXCARGOSLOTS-1-y) shl 1,0);
                  // fillbyte(currentShip.cargoquantity[y],(MAXCARGOSLOTS-1-y) shl 1,0);
                end;
              end;

              // // set selection to 1st item on the list
              // currentitemquantity:=currentShip.cargoquantity[itemindex];
              // currentitemprice:=GetItemPrice(itemindex,mode);
              // currentitemindex:=currentShip.cargoindex[itemindex];

              // update player UEC (current session)
              trade_UpdateUEC(currentuec);

              // update cargo Total
              currentShip.scu:=currentShip.scu-selecteditemquantity;
              trade_UpdateCargo(currentShip);

              // remove selection
              itemindex:=0;
              currentitemprice:=GetCargoPrice(currentShip,itemindex);
              currentitemquantity:=currentShip.cargoquantity[itemindex];
              currentitemindex:=currentShip.cargoindex[itemindex];
              selecteditemquantity:= 0;
              selecteditemtotal:=0;


              // remove selected GetItemQuantity
              CRT_ClearRow(19);

            end;
          end;
        ListCargo(currentShip,mode);
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

  // gfxcolor0:=$14;
  // gfxcolor1:=$00;
  // gfxcolor2:=$10;
  // gfxcolor3:=$00;
  // gfxcolor4:=$1a;
  case player.loc of
    0:  begin
          gfxcolor0:=$14;
          gfxcolor1:=$00;
          gfxcolor2:=$10;
          gfxcolor3:=$00;
          gfxcolor4:=$1a;
        end;
  else
    begin
      gfxcolor0:=$0c;
      gfxcolor1:=$06;
      gfxcolor2:=$02;
      gfxcolor3:=$0c;
      gfxcolor4:=$00;
    end;
  end;

  EnableVBLI(@vbl);
  EnableDLI(@dli1);
  Waitframe;
  DLISTL := DISPLAY_LIST_ADDRESS_MENU;

  // for i:=0 to 6 do
  //   CRT_ClearRow(i);
  CRT_ClearRows(0,6);

  CRT_GotoXY(14,0);
  WriteFF(strings[3]); // Navigation
  CRT_GotoXY(14,1);
  WriteFF(strings[4]); // Trade Console
  CRT_GotoXY(14,2);
  WriteFF(strings[7]); // Back

  keyval:=chr(0);
  repeat
  //  pause;
  //  msx.play;
    if CRT_Keypressed then
    begin
      keyval := char(CRT_Keycode[kbcode]);
      case keyval of
        KEY_OPTION1: current_menu := MENU_NAV;
        KEY_OPTION2: current_menu := MENU_TRADE;
        KEY_BACK: current_menu := MENU_TITLE;
      end;
    end;
    Waitframe;

  until (keyval = KEY_BACK) or (keyval = KEY_OPTION1) or (keyval = KEY_OPTION2);
end;



procedure title;
var
  str: String;
  //y: Byte;

begin
  EnableVBLI(@vbl_title);
  EnableDLI(@dli_title1);
  Waitframe;
  DLISTL := DISPLAY_LIST_ADDRESS_TITLE;

   // for y:=0 to 5 do
   //  CRT_ClearRow(y);
  CRT_ClearRows(0,5);


  CRT_GotoXY(14,0);
  WriteFF(strings[1]); // New game;
  CRT_GotoXY(14,1);
  WriteFF(strings[2]); // Quit;

  //str:= Atascii2Antic(NullTermToString(strings[0])); // read scroll text
  str:= FFTermToString(strings[0]); // read scroll text
  move(str[1],pointer(SCROLL_ADDRESS+42),sizeOf(str)); // copy text to vram

  keyval:=chr(0);
  repeat
    //msx.play;
    if CRT_Keypressed then
    begin
      keyval := char(CRT_Keycode[kbcode]);
      case keyval of
          KEY_NEW:  begin
                      start;
                      current_menu := MENU_MAIN;
                    end;
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
  SetCharset (Hi(CHARSET_ADDRESS)); // when system is off
  CRT_Init(TXT_ADDRESS);


  // Initialize RMT player
  //msx.player:=pointer(RMT_PLAYER_ADDRESS);
  //msx.modul:=pointer(RMT_MODULE_ADDRESS);
  //msx.init(0);

  current_menu := MENU_TITLE;

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
