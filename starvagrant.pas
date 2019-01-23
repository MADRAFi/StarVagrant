program StarVagrant;
{$librarypath '../Libs/lib/';'../Libs/blibs/';'../Libs/base/'}
uses atari, rmt, b_utils, b_system, b_crt, sysutils;


const
{$i 'const.inc'}
  CURRENCY = ' UEC';
{
  KEY_UP = Chr(28);
  KEY_DOWN = Chr(29);
}
  KEY_UP = 'o';
  KEY_DOWN = 'l';
  KEY_LEFT = Chr(30);
  KEY_RIGHT = Chr(31);

type
{$i 'types.inc'}
{$r 'resources.rc'}

var
  keyval: char = chr(0);
//  keyval: byte = 0;

  msx: TRMT;

  oldvbl, olddli: pointer;

  strings: array [0..0] of word absolute STRINGS_ADDRESS;
  locations: array [0..0] of word absolute LOCATIONS_ADDRESS;
  items: array [0..0] of word absolute ITEMS_ADDRESS;
  //itemprice: array [0..NUMBEROFLOCATIONS-1, 0..NUMBEROFITEMS-1] of byte;
  //itemquantity: array [0..NUMBEROFLOCATIONS-1, 0..NUMBEROFITEMS-1] of word;
  // itemmatrix: array [0..NUMBEROFLOCATIONS-1, 0..NUMBEROFITEMS-1] of boolean;
  itemmatrix: array [0..(NUMBEROFLOCATIONS-1)*(NUMBEROFITEMS-1)] of boolean;
  itemprice: array [0..(NUMBEROFLOCATIONS-1)*(NUMBEROFITEMS-1)] of byte;
  availableitems: array [0..11] of byte; // only 12 avaiable items

  {itemmatrix: array[0..NUMBEROFITEMS] of TPriceMatrix;
  locationmatrix: array [0..NUMBEROFLOCATIONS] of itemmatrix;
}
  current_menu: Byte;
  player: TPlayer;


{$i 'interrupts.inc'}


{
procedure ClrLine;
(*
@description:
ClrLine clears the current line, starting from the position 1, to the end of the window.

The cursor doesn't move.
*)
begin
   FillChar( pointer(word(DPeek(88)+1)+CRT_WhereY*40-41), byte(41-byte(1)), 0);
   //FillChar( pointer(word(DPeek(88))+WhereY*TXTCOL-41), byte(TXTCOL), 0);

   //FillByte(pointer(TXT_ADDRESS+(WhereY*TXTCOL)), TXTCOL, 0);
   //ClrEol;
end;
}
{
procedure ClrSroll;
(*
@description:
ClrLine clears the current line, starting from the position 1, to the end of the window.

The cursor doesn't move.
*)
begin
   FillChar(pointer(SCROLL_ADDRESS), byte(TXTCOL), 0);
   //move(0,pointer(SCROLL_ADDRESS),255);
   //FillByte(pointer(TXT_ADDRESS+(WhereY*TXTCOL)), TXTCOL, 0);
   //ClrEol;
end;
}


procedure generateworld;

begin
  {
  locationmatrix[0].item[0].quantity:=0;
  locationmatrix[0].item[0].price:=0;
  locationmatrix[0].item[1].quantity:=0;
  locationmatrix[0].item[1].price:=0;
  locationmatrix[0].item[3].quantity:=10000;
  locationmatrix[0].item[3].price:=2;
  locationmatrix[0].item[4].quantity:=0;
  locationmatrix[0].item[4].price:=0;
  locationmatrix[0].item[5].quantity:=10000;
  locationmatrix[0].item[5].price:=10;
}
  // Location 0 item * location
  itemmatrix[7]:=true;
  itemmatrix[8]:=true;
  itemmatrix[10]:=true;
  itemmatrix[14]:=true;
  itemmatrix[15]:=true;
  itemmatrix[18]:=true;
  itemmatrix[21]:=true;

  // Prices
  itemprice[7]:=127;
  itemprice[8]:=5;
  itemprice[10]:=99;
  itemprice[14]:=10;
  itemprice[15]:=2;
  itemprice[18]:=100;
  itemprice[21]:=1;


end;

procedure start;
begin
  //msx.Sfx(3, 2, 24);
  generateworld;
  player.uec:= 5000; // start cash
  player.loc:= 0; //start location Port Olisar

end;

procedure CRT_Window(x1,y1,x2,y2:byte);
begin
  CRT_leftMargin:=x1;
  CRT_screenWidth:=x2-x1;
  CRT_screenHeight:=y2-y1;
  //CRT_Cursor:=CRT_vram+(x1*y1);
  CRT_Cursor:=CRT_vram+(y1*DEFAULT_SCREENWIDTH)+x1;
  CRT_size:=CRT_screenWidth*CRT_screenHeight;
  //CRT_NewLine(y1);
end;

procedure ListItems(mode: boolean);
const
  listwidth = 19;
  liststart = 21;

var
  x: byte;
  count:byte = 1;
  str: string;
  pricestr: string;
  finalprice: longword;
  price: byte;
  commission: shortreal = 0.05;
  itemindex: byte = 0;


begin
  count:=1;
  for x:=0 to 11 do // max available items
    begin
      itemindex:=availableitems[x];
      if itemindex > 0 then
      begin
        CRT_GotoXY(CRT_screenWidth div 2 + 1,4+count); //min count:=1 so we start at 4th row
        str:= concat(Atascii2Antic(IntToStr(count)),' '~);
        str:= concat(str,FFTermToString(items[itemindex]));
        CRT_Write(str);
        price:=itemprice[itemindex];
        if mode then finalprice:=Trunc(price*(1-commission))
        else finalprice:=price;
        pricestr:=IntToStr(finalprice);
        CRT_Write(Atascii2Antic(Space(listwidth-Length(str)-Length(pricestr))));
        CRT_Write(Atascii2Antic(pricestr));
        //CRT_WriteRightAligned(Atascii2Antic(IntToStr(finalprice)));
        if count =1 then CRT_Invert(liststart,5,listwidth);
        inc(count);
      end;
    end;
end;


procedure LoadItems(loc: byte);
var
  x: byte;
  count:byte = 0;
  offset: byte = 0;

begin
  count:=0;
  for x:=0 to NUMBEROFITEMS-1 do
    begin
      offset:=(NUMBEROFITEMS-1)*loc + x;
      if itemmatrix[offset] = true then
      begin
        if count <= 11 then // max avaiable items
        begin
          availableitems[count]:=offset;
          inc(count);
        end;
      end;
    end;
end;

function CheckItemPosition(newindex: Byte) : Boolean;
begin
  if (newindex < MAXAVAILABLEITEMS) and (newindex >= 0) then Result:=true
  else Result:=false;
end;

procedure console_navigation;
var
  y: byte;
  str: string;
begin
  for y:=0 to 6 do
    CRT_ClearRow(y);


  CRT_WriteXY(0,0,concat('Location: '~,FFTermToString(locations[player.loc]))); //mocap
  CRT_WriteXY(0,1,'#########################'~);
  CRT_WriteXY(14,5,FFTermToString(strings[7])); // Back

  repeat
  //  pause;
  //  msx.play;
      keyval := chr(CRT_ReadChar);
      case keyval of
        KEY_BACK: current_menu := MENU_MAIN;
      end;

  until keyval = KEY_BACK;
end;

procedure console_trade;
const
  TOPMARGIN = 5;

var
  y: byte;
  mode: boolean = false;
  toggled: boolean = false;
  str: string;
  l: byte;
  itemindex: byte = 0;
  listwidth: byte = 19;
  liststart: byte = 21;


begin
  liststart:=(CRT_screenWidth div 2)+1;
  listwidth:=CRT_screenWidth-liststart;
  //colbk:=$06;
  //COLOR2:=$06;
  // SetIntVec(iDLI, @dlic);
  // SetIntVec(iVBL, @vblc);
  Waitframe;
  SDLSTL := DISPLAY_LIST_ADDRESS_CONSOLE;
  //CRT_Init;
  //CRT_Window(0,0,40,24);
  for y:=0 to CRT_screenWidth do
    CRT_ClearRow(y);

  str:=FFTermToString(locations[player.loc]);
  CRT_WriteXY(0,0,str);
  CRT_WriteXY(listwidth-4,0,FFTermToString(strings[8])); // Buy
  CRT_Write(FFTermToString(strings[9])); // Sell
  CRT_WriteRightAligned(Atascii2Antic(concat(IntToStr(player.uec), CURRENCY)));
  CRT_WriteXY(0,1,'--------------------+-------------------'~);
  CRT_WriteXY(0,2,concat(FFTermToString(strings[10]),'  |'~)); // Delivery
  CRT_Write(FFTermToString(strings[11])); // Available items
  CRT_WriteXY(0,3,'[ Cuttles Black ]   |'~);
  CRT_Write(FFTermToString(strings[12]));CRT_WriteRightAligned(FFTermToString(strings[13])); // commodity price
  CRT_WriteXY(0,4,'--------------------+-------------------'~);
  CRT_WriteXY(0,5,FFTermToString(strings[14])); CRT_Write(' '~);CRT_WriteXY(listwidth-2,5,'46 |'~);  // mocap
  CRT_WriteXY(0,6,FFTermToString(strings[15])); CRT_Write(' '~);CRT_WriteXY(listwidth-2,6,'46 |'~);  //mocap
  CRT_WriteXY(0,7,'--------------------+'~);
  CRT_WriteXY(0,18,'--------------------+-------------------'~);
  CRT_GotoXY(0,22);
  CRT_WriteRightAligned('[Cancel] [OK]'~);

  //str:=FFTermToString(strings[16]);
  //tmp:=FFTermToString(strings[17]);
  //CRT_WriteRightAligned(concat(str,tmp));

  LoadItems(player.loc);
  ListItems(false);

  //CRT_Invert(liststart,5,listwidth); // selecting the whole row with items
  itemindex:=0;

  // ListItems(availableitems,false);
  // CRT_Window(15,14,30,19);
  // CRT_WriteXY(0,0,'Row1'~);
  // CRT_WriteXY(0,1,'Row2'~);
  // CRT_WriteXY(0,2,'Row3'~);

  repeat
    //pause;
    //msx.play;
    If (CRT_Keypressed) then
    begin
      keyval := chr(CRT_ReadChar);
      case keyval of
        KEY_BACK: current_menu:=MENU_MAIN;
        KEY_UP:   begin
                    if CheckItemPosition(itemindex-1) and (availableitems[itemindex-1] > 0) then
                    begin
                      CRT_Invert(liststart,itemindex+TOPMARGIN,listwidth);
                      Dec(itemindex);
                      CRT_Invert(liststart,itemindex+TOPMARGIN,listwidth); // selecting the whole row with items
                    end;
                  end;
        KEY_DOWN: begin
                    if CheckItemPosition(itemindex+1) and (availableitems[itemindex+1] > 0) then
                    begin
                      CRT_Invert(liststart,itemindex+TOPMARGIN,listwidth);
                      Inc(itemindex);
                      CRT_Invert(liststart,itemindex+TOPMARGIN,listwidth); // selecting the whole row with items
                    end;
                  end;
      end;
      str:=concat('itemindex=',IntToStr(itemindex));
      CRT_WriteXY(0,19,Atascii2Antic(str));
    end;

    if (CRT_OptionPressed) and (toggled=false) then
    begin
      l:=liststart-6; // Buy text is x char on left from screen center
      mode:= not mode;
      if (mode = false) then
      begin
          CRT_Invert(l,0,5);CRT_Invert(l+5,0,6);
          ListItems(false);
//          CRT_Invert(liststart,5,listwidth); // selecting the whole row with items
          itemindex:=0;
      end
      else begin
        CRT_Invert(l,0,5);CRT_Invert(l+5,0,6);
        ListItems(true);
//        CRT_Invert(liststart,5,listwidth); // selecting the whole row with items
        itemindex:=0;
      end;
      toggled:=true;
    end
    else
      if (CRT_OptionPressed = false) then toggled:=false;

  until keyval = KEY_BACK;
end;

procedure menu;
var
    str: string;
    i: byte;

begin
  // SetIntVec(iDLI, @dli1);
  // SetIntVec(iVBL, @vbl);
  Waitframe;
  SDLSTL := DISPLAY_LIST_ADDRESS_MENU;
  //CRT_Init;

  for i:=0 to 6 do
    CRT_ClearRow(i);

  CRT_WriteXY(14,0,FFTermToString(strings[3])); // Navigation
  CRT_WriteXY(14,1,FFTermToString(strings[4])); // Trade Console
  CRT_WriteXY(14,2,FFTermToString(strings[7])); // Back


  // erase scroll content
  //str:= ''~;
  //move(str[1],pointer(SCROLL_ADDRESS+42),sizeOf(str));
  //hscrol:=0; //stop scroll.

  keyval:=chr(0);
  repeat
  //  pause;
  //  msx.play;
    if CRT_Keypressed then
    begin
      keyval := chr(CRT_ReadChar);
      case keyval of
        KEY_OPTION1: current_menu := MENU_NAV;
        KEY_OPTION2: current_menu := MENU_TRADE;
        KEY_BACK: current_menu := MENU_TITLE;
      end;
    end;
  until (keyval = KEY_BACK) or (keyval = KEY_OPTION1) or (keyval = KEY_OPTION2);
end;



procedure title;
var
  str: string;
  // count: byte = 3;
  // offset: byte = 0;
  y: byte;

begin
//  SetIntVec(iDLI, @dli1);
//  SetIntVec(iVBL, @vbl);

  Waitframe;
  SDLSTL := DISPLAY_LIST_ADDRESS_MENU;


  for y:=0 to 6 do
    CRT_ClearRow(y);

  CRT_WriteXY(14,0,FFTermToString(strings[1])); // New game;
  CRT_WriteXY(14,1,FFTermToString(strings[2])); // Quit;

  //str:= Atascii2Antic(NullTermToString(strings[0])); // read scroll text
  str:= FFTermToString(strings[0]); // read scroll text

  move(str[1],pointer(SCROLL_ADDRESS+42),sizeOf(str)); // copy text to vram


  keyval:=chr(0);
  repeat
    pause;
    //msx.play;
    if CRT_Keypressed then
    begin
      keyval := chr(CRT_ReadChar);
      case keyval of
        KEY_NEW: begin
                  start;
                  current_menu := MENU_MAIN;
                end;
      end;
    end;

    // if count = $ff then begin // $ff is one below zero
    //     count := 3;
    //     offset := (offset + 1) mod 140;  // 140 = 2x string size
    //     //DL_PokeW(114, SCROLL_ADDRESS + offset); // set new memory offset
    //     dpoke(DISPLAY_LIST_ADDRESS_MENU + 114, SCROLL_ADDRESS + offset);
    // end;
    //
    // hscrol := count; // set hscroll
    // dec(count);

    //blankSize := (blankSize + 1) and 15; // go trough 0-15
    //DL_Poke(10, blanks[blankSize]); // set new blankline height

  until (keyval = KEY_QUIT) or (keyval = KEY_NEW);
end;





procedure fade;
var
  fadecolors: Array[0..6] of byte = ($95,$94,$93,$92,$91,$90,$00);
  i: byte;

begin
  for i:=Low(fadecolors) to high(fadecolors)  do
    begin
      colbk:=fadecolors[i];
      //Delay(35);
    end;
  //poke($2C6,$C4);
end;



{
--------------------------------------------------------------------------------
MAIN LOOP
--------------------------------------------------------------------------------
}

begin
  SystemOff;
  SetCharset (Hi(CHARSET_ADDRESS)); // when system is off
  //savmsc:=TXT_ADDRESS;
  //  savmsc:= TXT_ADDRESS;


  lmargin:= 0;
  rmargin:= 0;

  //fade;

  // Initialize RMT player
  //msx.player:=pointer(RMT_PLAYER_ADDRESS);
  //msx.modul:=pointer(RMT_MODULE_ADDRESS);
  //msx.init(0);

    // save old vbl and dli interrupt
  // GetIntVec(iVBL, oldvbl);
  // GetIntVec(iDLI, olddli);
  // nmien:= $c0;
  //
  //
  //
  // SetIntVec(iDLI, @dli1);
  // SetIntVec(iVBL, @vbl);

  CRT_Init;

  current_menu := MENU_TITLE;
  //current_menu := MENU_TRADE;

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
    //if keyval = KEY_QUIT then break;
//until FALSE;
until keyval = KEY_QUIT;

  // restore system
  // SetIntVec(iVBL, oldvbl);
  // SetIntVec(iDLI, olddli);
  // nmien:= $40;
  //msx.stop;

  //SystemReset;
end.
