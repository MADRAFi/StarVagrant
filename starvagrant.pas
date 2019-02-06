program StarVagrant;
{$librarypath '../Libs/lib/';'../Libs/blibs/';'../Libs/base/'}
uses atari, b_utils, b_system, b_crt, sysutils;

const
{$i 'const.inc'}
  CURRENCY = ' UEC';
  CARGOUNIT = ' SCU'~;
  DISTANCE = ' SDU';
  COMMISSION = 0.05;

type
{$i 'types.inc'}
{$r 'resources.rc'}

var
  keyval: char = chr(0);
//  keyval: byte = 0;

  //msx: TRMT;

  strings: array [0..0] of word absolute STRINGS_ADDRESS;
  locations: array [0..0] of word absolute LOCATIONS_ADDRESS;
  items: array [0..0] of word absolute ITEMS_ADDRESS;

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
  availableitems: array [0..(MAXAVAILABLEITEMS-1)] of Word; // only 12 avaiable items

  locationdistance: array[0..(NUMBEROFLOCATIONS*NUMBEROFLOCATIONS)-1] of Word =
  (
    0,5,0,0,0,0,0,0,6,0,0,3655,86,0,0,5,5,
    5,0,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,2,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,
    6,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,5,0,6,0,0,0,0,
    0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,
    3655,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    86,0,0,0,0,0,0,0,0,6,0,0,0,1,7,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,
    5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    5,0,0,0,2,3,0,0,0,0,0,0,0,0,0,0,0

  );

  availabledestinations: array [0..(MAXAVAILABLEDESTINATIONS-1)] of Word; // only 5 avaiable destinations

  current_menu: Byte;
  player: TPlayer;
  ship: TShip;

//commission: shortreal = 0.05;

{$i 'interrupts.inc'}



// procedure generateworld;
//
// begin
//   {
//   locationmatrix[0].item[0].quantity:=0;
//   locationmatrix[0].item[0].price:=0;
//   locationmatrix[0].item[1].quantity:=0;
//   locationmatrix[0].item[1].price:=0;
//   locationmatrix[0].item[3].quantity:=10000;
//   locationmatrix[0].item[3].price:=2;
//   locationmatrix[0].item[4].quantity:=0;
//   locationmatrix[0].item[4].price:=0;
//   locationmatrix[0].item[5].quantity:=10000;
//   locationmatrix[0].item[5].price:=10;
// }
//
// end;

procedure start;
var
  x: byte;

begin
  //msx.Sfx(3, 2, 24);
  //generateworld;
  player.uec:= 5000; // start cash
  player.loc:= 0; //start location Port Olisar

  //mocap starting ship
  ship.sname:= 'Cuttlas Black';
  ship.scu_max:=46;
  ship.scu:=0;

  for x:=0 to MAXCARGOSLOTS-1 do
  begin
      ship.cargoindex[x]:= 0;
      ship.cargoquantity[x]:= 0;
  end;

  ship.cargoindex[0]:=7;
  ship.cargoquantity[0]:=10;
  ship.cargoindex[1]:=10;
  ship.cargoquantity[1]:=20;
  ship.scu:= 30;
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
      //strnum:=concat(IntToStr(myship.cargoquantity[x]),CARGOUNIT);
      strnum:=IntToStr(myship.cargoquantity[x]);
      CRT_Write(Atascii2Antic(Space(listwidth-Length(str)-Length(strnum))));
      CRT_Write(Atascii2Antic(strnum));
      if (count = 1) and (mode = true) then CRT_Invert(LISTSTART,8,LISTWIDTH);
      Inc(count);
    end;
  end;
  for x:=count to MAXCARGOSLOTS-1 do
  begin
    CRT_WriteXY(LISTSTART,TOPCARGOMARGIN+x-1,Atascii2Antic(space(LISTWIDTH))); // -1 to clear from the end of list
    //CRT_WriteXY(LISTSTART,TOPCARGOMARGIN+x-1,Atascii2Antic('c '~)); // -1 to clear from the end of list
  end;
end;


procedure ListItems(mode: boolean);
const
  LISTWIDTH = 19;
  LISTSTART = 21;

var
  x: byte;
  count:byte = 1;
  str: TString;
  pricestr: TString;
  finalprice: word;
  price: word;
  offset: Word = 0;


begin
  count:=1;
  for x:=0 to MAXAVAILABLEITEMS-1 do // max available items
    begin
      offset:=availableitems[x];
      if (offset > 0) then
      begin
        CRT_GotoXY(LISTSTART,4+count); //min count:=1 so we start at 4th row
        str:= concat(Atascii2Antic(IntToStr(count)),' '~);
        str:= concat(str,FFTermToString(items[offset]));
        CRT_Write(str);
        price:=itemprice[offset];
        if mode then finalprice:=Trunc(price*(1-COMMISSION))
        else finalprice:=price;
        pricestr:=IntToStr(finalprice);
        CRT_Write(Atascii2Antic(Space(listwidth-Length(str)-Length(pricestr))));
        CRT_Write(Atascii2Antic(pricestr));
        //CRT_WriteRightAligned(Atascii2Antic(IntToStr(finalprice)));
        if (count = 1) and (mode = false) then CRT_Invert(LISTSTART,5,LISTWIDTH);
        inc(count);
      end
      else
      begin
        CRT_GotoXY(LISTSTART,4+x+1);
        CRT_Write(Atascii2Antic(Space(listwidth)));
      end;

    end;
end;


procedure LoadItems(loc: Byte; mode: Boolean);
var
  x: byte;
  count:byte = 0;
  offset: word = 0;
  visible: Boolean;

begin
  count:=0;
  for x:=0 to NUMBEROFITEMS-1 do
    begin
      visible:= false;
      offset:=(NUMBEROFITEMS-1)*loc + x;

      if (mode = true) then
      begin
        if (itemprice[offset] <> 0) then // show item even if quantity is 0
          visible:=true;
      end
      else
      begin
        if (itemprice[offset] <> 0) and (itemquantity[offset] <> 0) then // show item if quantity > 0
          visible:=true;
      end;
//      if (itemprice[offset] <> 0) and (itemquantity[offset] <> 0) then
//      if (itemprice[offset] <> 0) then
      if (visible = true) then
      begin
        if count <= MAXAVAILABLEITEMS-1 then // max avaiable items
        begin
          availableitems[count]:=offset;
          inc(count);
        end;
      end;
    end;

    // clear avaiable items array when mode is changed and less items are present
    if (count < MAXAVAILABLEITEMS-1) then
    begin
      for x:=count to MAXAVAILABLEITEMS-1 do
      begin
        availableitems[x]:=0;
      end;
    end;
end;



// procedure ListDestinations;
// const
//   LISTSTART = 20;
//
// var
//   x: byte;
//   count:byte;
//   offset: Word;
//
// begin
//   count:=0;
//   for x:=0 to MAXAVAILABLEDESTINATIONS-1 do
//     begin
//       offset:=availabledestinations[x];
//       if (offset > 0) then
//       begin
//         CRT_GotoXY(LISTSTART,count);
//         CRT_Write(count+1);CRT_Write(' '~);
//         CRT_Write(FFTermToString(locations[offset]));
//       end;
//     end;
//
// end;

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
    offset:=(NUMBEROFLOCATIONS-1)*loc + x;
    if locationdistance[offset] > 0 then
    begin
      availabledestinations[count]:=offset;
      inc(count);
    end;
  end;


  // clear avaiable destinations array when less destinations are present
  if (count < MAXAVAILABLEDESTINATIONS-1) then
  begin
    for x:=count to MAXAVAILABLEDESTINATIONS-1 do
    begin
      availabledestinations[x]:=0;
    end;
  end;


  // list destinations
  count:=0;
  for x:=0 to MAXAVAILABLEDESTINATIONS-1 do
  begin
    offset:=availabledestinations[x];
    if (offset > 0) then
    begin
      CRT_GotoXY(LISTSTART,count);
      CRT_Write(count+1);CRT_Write(' '~);
      CRT_Write(FFTermToString(locations[offset]));
      Inc(count);
    end;
  end;

end;


function CheckItemPosition(newindex : Byte) : Boolean;
begin
  if (newindex < MAXAVAILABLEITEMS) and (newindex >= 0) then Result:=true
  else Result:=false;
end;

function CheckCargoPosition(newindex : Byte) : Boolean;
begin
  if (newindex < MAXCARGOSLOTS) and (newindex >= 0) then Result:=true
  else Result:=false;
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
  if (mode = true) then
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

var
//  price: word;
  offset: word;

begin
  offset:=myship.cargoindex[itemindex];
//  price:=itemprice[offset];
//  Result:=Trunc(price*(1-commission))
  Result:=Trunc(itemprice[offset]*(1-commission))
end;

function CheckCargoPresence(myship: TShip; itemindex: Byte): Boolean;

var
  offset: Word;
  item: Word;

begin
  offset:=myship.cargoindex[itemindex];
  Result:= false;
  //for item in availableitems do
  for item:=0 to MAXAVAILABLEITEMS-1 do
    begin
      Result:= offset =  availableitems[item];
      If (Result = true) then break;
    end
end;


procedure console_navigation;
var
  y: byte;
  stillPressed: Boolean;

begin
  for y:=0 to 6 do
    CRT_ClearRow(y);

  CRT_GotoXY(0,0);
  CRT_Write(FFTermToString(strings[20])); // Loc:
  CRT_Write(FFTermToString(locations[player.loc]));
  //CRT_GotoXY(20,0);
  //CRT_Write(FFTermToString(strings[23])); // Navigation:

  CRT_GotoXY(0,1);
  CRT_Write(FFTermToString(strings[21])); // Nav:
  CRT_GotoXY(0,2);
  CRT_Write(FFTermToString(strings[22]));CRT_Write(' 2356 SDU'~); // Dis:

  // Keys Help
  CRT_GotoXY(0,6);
  CRT_Write(FFTermToString(strings[23])); // Navigation
  CRT_Write(' '~);
  CRT_Write(FFTermToString(strings[24]));  // Launch
  CRT_Write(' '~);
  CRT_Write(FFTermToString(strings[7])); // Back

  LoadDestinations(player.loc);


  keyval:= chr(0);
  stillPressed:= false;
  repeat
  //  pause;
  //  msx.play;
    If (CRT_Keypressed) then
    begin
      if (stillPressed = false) then
      begin
        keyval := char(CRT_Keycode[kbcode]);
        case keyval of
          KEY_BACK: current_menu := MENU_MAIN;
        end;
        stillPressed:= true;
      end;
    end
    else
    begin
      stillPressed:= false;
    end;

  until keyval = KEY_BACK;
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

procedure console_trade;

const
  LISTTOPMARGIN = 5;
  CARGOTOPMARGIN = 8;

var
  y: Byte;
  mode: Boolean = false;
  stillPressed: Boolean = false;
  optionPressed: Boolean = false;
  selectPressed: Boolean = false;
  cargoPresent: Boolean = false;

  str: TString;
  strnum: TString;

  l: Byte;
  itemindex: Byte = 0;
  listwidth: Byte = 19;
  liststart: Byte = 21;
  //cargoindex: Byte = 0;

  currentitemindex: Word;
  currentitemquantity: Word;
  currentitemprice: Word;
  //currentcargo: array [0..MAXCARGOSLOTS-1] of Word;
  //currentcargoquantity: array [0..MAXCARGOSLOTS-1] of Word;
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
  stillPressed:= false;
  optionPressed:= false;
  selectPressed:= false;
  cargoPresent:= false;
  keyval:= chr(0);

  //currentcargo:= ship.cargoindex;
  //currentcargoquantity:= ship.cargoquantity;

  //cargoindex:= 0;


  liststart:=(CRT_screenWidth div 2)+1;
  listwidth:=CRT_screenWidth-liststart;

  EnableVBLI(@vbl_console);
  EnableDLI(@dli_console);
  Waitframe;
  DLISTL:= DISPLAY_LIST_ADDRESS_CONSOLE;




  for y:=0 to CRT_screenHeight do
    CRT_ClearRow(y);

  str:=FFTermToString(locations[player.loc]);
  CRT_WriteXY(0,0,str);
  l:=Length(str);
  str:=' '~;
  str:=concat(str,FFTermToString(strings[8]));
  str:=concat(str,' '~);
  CRT_WriteXY(listwidth-4,0,str); // Buy
  // invert at start
  CRT_Invert(listwidth-4,0,5);

  str:=' '~;
  str:=concat(str,FFTermToString(strings[9]));
  str:=concat(str,' '~);
  CRT_Write(str); // Sell
  CRT_WriteRightAligned(Atascii2Antic(concat(IntToStr(currentuec), CURRENCY)));
  CRT_WriteXY(0,1,'--------------------+-------------------'~);
  CRT_WriteXY(0,2,concat(FFTermToString(strings[10]),'  |'~)); // Delivery
  CRT_Write(FFTermToString(strings[11])); // Available items
  CRT_WriteXY(0,3,'[ '~); CRT_Write(Atascii2Antic(currentship.sname)); CRT_Write(' ]'~);CRT_WriteXY(liststart-2,3,' |'~);
  CRT_Write(FFTermToString(strings[12]));CRT_WriteRightAligned(FFTermToString(strings[13])); // commodity price
  CRT_WriteXY(0,4,'--------------------+-------------------'~);
  CRT_WriteXY(0,5,FFTermToString(strings[14])); CRT_Write(' '~);
  CRT_WriteXY(listwidth-5,5,Atascii2Antic(IntToStr(currentship.scu_max))); CRT_Write(concat(CARGOUNIT,'|'~));//CRT_Write(' SCU|'~); //CRT_WriteXY(listwidth-2,5,'46 |'~);  // mocap
  CRT_WriteXY(0,6,FFTermToString(strings[15])); CRT_Write(' '~);
  str:=IntToStr(currentship.scu_max-currentship.scu);
  CRT_WriteXY(liststart-(Length(str)+5),6,Atascii2Antic(str)); CRT_Write(concat(CARGOUNIT,'|'~)); //CRT_Write(' SCU|'~);
  CRT_WriteXY(0,7,'--------------------+'~);

  str:='|';
  for y:=8 to 17 do
  begin
      CRT_WriteXY(liststart-1,y,Atascii2Antic(str));
  end;

  CRT_WriteXY(0,18,'--------------------+-------------------'~);
  // str:=StringOfChar('-',20);
  // str:=concat(str,'+');
  // str:=concat(str,StringOfChar('-',19));
  // CRT_WriteXY(0,18,Atascii2Antic(str));
  //
  CRT_GotoXY(0,22);
  str:=concat(FFTermToString(strings[16]),' '~);
  CRT_WriteRightAligned(concat(str,FFTermToString(strings[17])));
  // CRT_WriteRightAligned('[Cancel] [OK]'~);

  // help

  str:='OPTION'*~;
  str:=concat(str,'-'~);
  str:=concat(str,FFTermToString(strings[8]));
  str:=concat(str,'/'~);
  str:=concat(str,FFTermToString(strings[9]));
  str:=concat(str,' '~);
  str:=concat(str,'SELECT'*~);
  str:=concat(str,'-'~);
  str:=concat(str,FFTermToString(strings[19]));
  str:=concat(str,' '~);
  str:=concat(str,FFTermToString(strings[7]));
  CRT_WriteCentered(23,str);

  //move(str[1],pointer(SCROLL_ADDRESS+42),sizeOf(str)); // copy text to vram

  LoadItems(player.loc, false);
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

                      LoadItems(player.loc,false);
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
                      CRT_GotoXY(liststart+7,0); // +7 for Sell string
                      strnum:=IntToStr(currentuec);
                      CRT_Write(Atascii2Antic(space(LISTWIDTH-Length(strnum)-Length(CURRENCY)-7)));
                      CRT_Write(Atascii2Antic(concat(IntToStr(currentuec),CURRENCY)));

                      // update cargo Total
                      currentShip.scu:=currentShip.scu-selecteditemquantity;
                      str:=IntToStr(currentship.scu_max-currentship.scu);
                      CRT_WriteXY(liststart-(Length(str)+5)-4,6,Atascii2Antic(Space(4))); // fixed 4 chars for cargo size
                      CRT_WriteXY(liststart-(Length(str)+5),6,Atascii2Antic(str)); CRT_Write(concat(CARGOUNIT,'|'~)); //CRT_Write(' SCU|'~);

                    end;
        KEY_OK:     begin
                      player.uec:= currentuec;
                      ship:= currentShip;
                      itemquantity[currentitemindex]:=itemquantity[currentitemindex]-selecteditemquantity;
                      current_menu:= MENU_MAIN;
                    end;
        KEY_BACK: if (stillPressed = false) then current_menu := MENU_MAIN;
        KEY_UP:     begin
                      if stillPressed = false then
                        if (mode = false) then
                        begin
                          if CheckItemPosition(itemindex-1) and (availableitems[itemindex-1] > 0) then
                          begin
                            CRT_Invert(liststart,itemindex + LISTTOPMARGIN,listwidth);
                            Dec(itemindex);
                            CRT_Invert(liststart,itemindex + LISTTOPMARGIN,listwidth); // selecting the whole row with item
                            currentitemquantity:=itemquantity[availableitems[itemindex]];
                            currentitemprice:=GetItemPrice(itemindex,false);
                            currentitemindex:=availableitems[itemindex];
                            selecteditemtotal:=0;
                            selecteditemquantity:=0;
                            CRT_ClearRow(19);
                          end;
                        end
                        else  // when selling
                          begin
                            if CheckCargoPosition(itemindex-1) and (currentShip.cargoindex[itemindex-1] > 0)  then
                            begin
                              CRT_Invert(0,itemindex + CARGOTOPMARGIN,listwidth+1);
                              Dec(itemindex);
                              currentitemquantity:=currentShip.cargoquantity[itemindex];
                              currentitemprice:=GetCargoPrice(currentShip,itemindex);
                              currentitemindex:=currentShip.cargoindex[itemindex];
                              selecteditemtotal:=0;
                              selecteditemquantity:=0;
                              CRT_Invert(0,itemindex + CARGOTOPMARGIN,listwidth+1); // selecting the whole row with item
                              cargoPresent:=CheckCargoPresence(currentShip,itemindex);
                            end;
                          end;
                    end;
        KEY_DOWN:   begin
                      if stillPressed = false then
                        if (mode = false) then
                        begin
                          if CheckItemPosition(itemindex+1) and (availableitems[itemindex+1] > 0)  then
                          begin
                            CRT_Invert(liststart,itemindex + LISTTOPMARGIN,listwidth);
                            Inc(itemindex);
                            CRT_Invert(liststart,itemindex + LISTTOPMARGIN,listwidth); // selecting the whole row with item
                            currentitemquantity:=itemquantity[availableitems[itemindex]];
                            currentitemprice:=GetItemPrice(itemindex,false);
                            currentitemindex:=availableitems[itemindex];
                            selecteditemtotal:=0;
                            selecteditemquantity:=0;
                            CRT_ClearRow(19);
                          end;
                        end
                        else // when selling
                        begin
                          if CheckCargoPosition(itemindex+1) and (currentShip.cargoindex[itemindex+1] > 0)  then
                          begin
                            CRT_Invert(0,itemindex + CARGOTOPMARGIN,listwidth+1);
                            Inc(itemindex);
                            currentitemquantity:=currentShip.cargoquantity[itemindex];
                            currentitemprice:=GetCargoPrice(currentShip,itemindex);
                            currentitemindex:=currentShip.cargoindex[itemindex];
                            selecteditemtotal:=0;
                            selecteditemquantity:=0;
                            CRT_Invert(0,itemindex + CARGOTOPMARGIN,listwidth+1); // selecting the whole row with item
                            cargoPresent:=CheckCargoPresence(currentShip,itemindex);
                          end;
                        end;
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
                      stillPressed:= false;
                      if (mode = false) then
                      begin
                        if (selecteditemquantity < currentitemquantity) and (selecteditemtotal + currentitemprice <= currentuec )
                           and (selecteditemquantity < currentShip.scu_max-currentShip.scu) then
                          stillPressed:= true; //reuse boolean variable
                      end
                      else // when selling
                      begin
                        if (selecteditemquantity < currentitemquantity) and (selecteditemtotal + currentitemprice <= currentuec )
                          and (cargoPresent = true) then
                          stillPressed:= true; //reuse boolean variable
                      end;
                      if (stillPressed = true) then
                      begin
                        Inc(selecteditemquantity);
                        selecteditemtotal:=selecteditemquantity * currentitemprice;
                        UpdateSelectedItem(selecteditemquantity,selecteditemtotal);
                      end
                      else
//                        CRT_WriteRightAligned(19,FFTermToString(strings[20]));
                    end;
      end;
      // str:=concat('itemindex=',IntToStr(itemindex));
      // str:=concat(str,' cena=');
      // str:=concat(str,IntToStr(GetItemPrice(itemindex,mode)));
      // str:=concat(str,' ilosc=');
      // str:=concat(str,IntToStr(GetItemQuantity(itemindex)));
      // CRT_WriteXY(0,19,Atascii2Antic(str));
      stillPressed:= true;
    end
    else
    begin
      stillPressed:= false;
    end;

    if (CRT_OptionPressed) and (optionPressed=false) then
    begin
      l:=liststart-6; // Buy text is x char on left from screen center
      mode:= not mode;
      if (mode = false) then
      begin
        CRT_Invert(l,0,5);CRT_Invert(l+5,0,6);
        LoadItems(player.loc,false);
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
        CRT_Invert(l,0,5);CRT_Invert(l+5,0,6);
        LoadItems(player.loc, true);
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
      if (CRT_OptionPressed = false) then optionPressed:=false;

    if (CRT_SelectPressed) then
    begin
      if (selectPressed = false) then
      begin
//         if (selecteditemquantity > 0) and (cargoindex < MAXCARGOSLOTS) then
//         begin
// // //          str:=FFTermToString(items[currentitemindex]);
// //           str:=IntToStr(currentitemindex);
// // //          str:=concat(str,' '~);
// //           strnum:=IntToStr(selecteditemquantity);
// //           CRT_WriteXY(0,cargoindex+CARGOTOPMARGIN, Atascii2Antic(str));
// //           CRT_Write(Atascii2Antic(Space(CRT_screenWidth-listwidth-1-Length(str)-Length(strnum))));
// //
// //           CRT_Write(Atascii2Antic(strnum));
// //           Inc(cargoindex);
//         end;

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
                else
                begin
                  // some item exists
                  if currentship.cargoindex[y] = currentitemindex then
                  begin
                    // found same cargo
                    currentShip.cargoquantity[y]:=currentShip.cargoquantity[itemindex] + selecteditemquantity;
                    break;
                  end;
                end;
              end;

              // update UEC on screen not on player
              currentuec:=currentuec - selecteditemtotal;

              // update player UEC (current session)
              CRT_GotoXY(liststart+7,0); // +7 for Sell string
              strnum:=IntToStr(currentuec);
              CRT_Write(Atascii2Antic(space(LISTWIDTH-Length(strnum)-Length(CURRENCY)-7)));
              CRT_Write(Atascii2Antic(concat(IntToStr(currentuec),CURRENCY)));

              // update cargo Total
              currentShip.scu:=currentShip.scu + selecteditemquantity;
              str:=IntToStr(currentship.scu_max-currentship.scu);
              CRT_WriteXY(liststart-(Length(str)+5)-4,6,Atascii2Antic(Space(4))); // fixed 4 chars for cargo size
              CRT_WriteXY(liststart-(Length(str)+5),6,Atascii2Antic(str)); CRT_Write(concat(CARGOUNIT,'|'~)); //CRT_Write(' SCU|'~);

              // remove selection
              currentitemprice:=GetCargoPrice(currentShip,itemindex);
              currentitemindex:=currentShip.cargoindex[itemindex];
              selecteditemquantity:= 0;
              selecteditemtotal:=0;
              itemindex:=0;

            end;
          end
          else // Selling mode
          begin
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
                    if (l < High(ship.cargoindex)) then
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
                end;
              end;

              // set selection to 1st item on the list
              currentitemquantity:=currentShip.cargoquantity[itemindex];
              currentitemprice:=GetItemPrice(itemindex,mode);
              currentitemindex:=currentShip.cargoindex[itemindex];

              // update player UEC (current session)
              CRT_GotoXY(liststart+7,0); // +7 for Sell string
              strnum:=IntToStr(currentuec);
              CRT_Write(Atascii2Antic(space(LISTWIDTH-Length(strnum)-Length(CURRENCY)-7)));
              CRT_Write(Atascii2Antic(concat(IntToStr(currentuec),CURRENCY)));

              // update cargo Total
              currentShip.scu:=currentShip.scu-selecteditemquantity;
              str:=IntToStr(currentship.scu_max-currentship.scu);
              CRT_WriteXY(liststart-(Length(str)+5)-4,6,Atascii2Antic(Space(4))); // fixed 4 chars for cargo size
              CRT_WriteXY(liststart-(Length(str)+5),6,Atascii2Antic(str)); CRT_Write(CARGOUNIT~);

              // remove selection
              currentitemprice:=GetCargoPrice(currentShip,itemindex);
              currentitemindex:=currentShip.cargoindex[itemindex];
              selecteditemquantity:= 0;
              selecteditemtotal:=0;
//              itemindex:=0;

            end;
          end;
        ListCargo(currentShip,mode);
      end;
      selectPressed:=true;
    end
    else
      selectPressed:=false;


  until (keyval = KEY_BACK) or (keyval = KEY_OK);
end;

procedure menu;

var
    i: byte;
    stillPressed: Boolean;

begin
  EnableVBLI(@vbl);
  EnableDLI(@dli1);
  Waitframe;
  DLISTL := DISPLAY_LIST_ADDRESS_MENU;

  //CRT_Init(TXT_ADDRESS);

  for i:=0 to 6 do
    CRT_ClearRow(i);

  CRT_WriteXY(14,0,FFTermToString(strings[3])); // Navigation
  CRT_WriteXY(14,1,FFTermToString(strings[4])); // Trade Console
  CRT_WriteXY(14,2,FFTermToString(strings[7])); // Back
  // CRT_WriteXY(14,3,'Linia 4'~);
  // CRT_WriteXY(14,4,'Linia 5'~);
  // CRT_WriteXY(14,5,'Linia 6'~);
  // CRT_WriteXY(14,6,'Linia 7'~);


  stillPressed:= false;
  keyval:=chr(0);
  repeat
  //  pause;
  //  msx.play;
    if CRT_Keypressed then
    begin
      if (stillPressed = false) then
      begin
        keyval := char(CRT_Keycode[kbcode]);
        case keyval of
          KEY_OPTION1: current_menu := MENU_NAV;
          KEY_OPTION2: current_menu := MENU_TRADE;
          KEY_BACK: current_menu := MENU_TITLE;
        end;
        stillPressed:= true;
      end;
    end
    else
    begin
      stillPressed:= false;
    end;
  until (keyval = KEY_BACK) or (keyval = KEY_OPTION1) or (keyval = KEY_OPTION2); // temp solution for the dev ( should be restored to KEY_BACK)
end;



procedure title;
var
  str: String;
  y: Byte;
  stillPressed: Boolean;

begin
  EnableVBLI(@vbl_title);
  EnableDLI(@dli_title1);
  Waitframe;
  DLISTL := DISPLAY_LIST_ADDRESS_TITLE;

   for y:=0 to 5 do
    CRT_ClearRow(y);

  CRT_WriteXY(14,0,FFTermToString(strings[1])); // New game;
  CRT_WriteXY(14,1,FFTermToString(strings[2])); // Quit;

  // for y:=0 to 5 do
  //   CRT_WriteXY(0,y,Atascii2Antic(IntToStr(y)));

  //str:= Atascii2Antic(NullTermToString(strings[0])); // read scroll text
  str:= FFTermToString(strings[0]); // read scroll text
  move(str[1],pointer(SCROLL_ADDRESS+42),sizeOf(str)); // copy text to vram


  keyval:=chr(0);
  repeat
    pause;
    //msx.play;
    if CRT_Keypressed then
    begin
      keyval := char(CRT_Keycode[kbcode]);
      case keyval of
        KEY_NEW:  if (stillPressed = false) then
                  begin
                    start;
                    current_menu := MENU_MAIN;
                  end;
      end;
      stillPressed:= true;
    end
    else
    begin
      stillPressed:= false;
    end;

  until (keyval = KEY_QUIT) or (keyval = KEY_NEW);
end;





// procedure fade;
// var
//   fadecolors: Array[0..6] of byte = ($95,$94,$93,$92,$91,$90,$00);
//   i: byte;
//
// begin
//   for i:=Low(fadecolors) to high(fadecolors)  do
//     begin
//       colbk:=fadecolors[i];
//       Waitframe;
//     end;
//   //poke($2C6,$C4);
// end;



{
--------------------------------------------------------------------------------
MAIN LOOP
--------------------------------------------------------------------------------
}

begin
  SystemOff;
  SetCharset (Hi(CHARSET_ADDRESS)); // when system is off
  CRT_Init(TXT_ADDRESS);

  //fade;

  // Initialize RMT player
  //msx.player:=pointer(RMT_PLAYER_ADDRESS);
  //msx.modul:=pointer(RMT_MODULE_ADDRESS);
  //msx.init(0);

  current_menu := MENU_TITLE;

  repeat
    case current_menu of
      MENU_TITLE: begin
                  title;
                  end;
      MENU_MAIN: menu;
      MENU_NAV: console_navigation;
      MENU_TRADE: console_trade;
      //MENU_MAINT: console_maint;
    end;

until keyval = KEY_QUIT;

  // restore system
  SystemReset;
end.
