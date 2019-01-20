program StarVagrant;
{$librarypath '../Libs/lib/';'../Libs/blibs/';'../Libs/base/'}
uses atari, rmt, b_utils, b_system, b_crt, sysutils;


const
{$i 'const.inc'}
type
{$i 'types.inc'}

{$r 'resources.rc'}
{$i 'interrupts.inc'}

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

  {itemmatrix: array[0..NUMBEROFITEMS] of TPriceMatrix;
  locationmatrix: array [0..NUMBEROFLOCATIONS] of itemmatrix;
}
  current_menu: Byte;
  player: TPlayer;

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

// function IntToStr(a: integer): ^string; assembler;
// (*
// @description: Convert an integer value to a decimal string
// @param: a: integer
// @returns: pointer to string
// *)
// asm
// {	txa:pha
// 	inx
// 	@ValueToStr #@printINT
// 	mwa #@buf Result
// 	pla:tax
// };
// end;

(*
function Atascii2Antic(c: byte): byte; overload;
begin
    asm {
        lda c
        asl
        php
        cmp #2*$60
        bcs @+
        sbc #2*$20-1
        bcs @+
        adc #2*$60
@       plp
        ror
        sta result;
    };
end;

function Antic2Atascii(c: byte):byte;overload;
begin
    asm {
        lda c
        asl
        php
        cmp #2*$60
        bcs @+
        sbc #2*$40-1
        bcs @+
        adc #2*$60
@       plp
        ror
        sta result;
    };
end;

function Atascii2Antic(s: string):string;overload;
var i:byte;
begin
    result[0]:=s[0];
    for i:=1 to byte(s[0]) do
        result[i]:=char(Atascii2Antic(byte(s[i])));
end;


function Antic2Atascii(s: string):string;overload;
var i:byte;
begin
    result[0]:=s[0];
    for i:=1 to byte(s[0]) do
        result[i]:=char(Antic2Atascii(byte(s[i])));
end;
*)

{
procedure  WriteString( s : string; newline : boolean); overload;
var
  x, y : byte;

begin
  x:= WhereX;
  y:= WhereY;
  CRT_GotoXy(1,y);
  ClrEol;
  CRT_GotoXy(x,y);

  If (newline = FALSE) then
    Write (s)
  else
    Writeln (s);
end;

procedure  WriteString( s : string); overload;
var
  x, y : byte;

begin
  x:= WhereX;
  y:= WhereY;
  CRT_GotoXy(1,y);
  ClrEol;
  CRT_GotoXy(x,y);

  Writeln (s);
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
  // Location 0
  itemmatrix[7]:=true;
  itemmatrix[8]:=true;
  itemmatrix[10]:=true;
  itemmatrix[14]:=true;
  itemmatrix[15]:=true;
  itemmatrix[18]:=true;
  itemmatrix[21]:=true;

end;

procedure start;
begin
  //msx.Sfx(3, 2, 24);
  generateworld;
  player.uec:= 5000;
  player.loc:= 0;

end;

procedure ListItems(loc: byte);
var
  x: byte;
  count:byte = 0;
  offset: byte;

begin
  for x:=0 to NUMBEROFITEMS-1 do
    begin
      offset:=(NUMBEROFITEMS-1)*loc + x;
      if itemmatrix[offset] = true then
        begin
          CRT_GotoXy(21,5+count);
          write (count,' ',NullTermToString(items[x]));
          inc(count);
        end;
    end;
end;


procedure console_navigation;
var
  y: byte;

begin
  for y:=0 to 6 do
    CRT_ClearRow(y);

  CRT_GotoXy(0,0);
  CRT_write (concat('L: '~,NullTermToString(locations[player.loc])));
  CRT_GotoXy(0,1);
  CRT_write ('#########################'~);
  CRT_GotoXy(14,5);
  CRT_write (NullTermToString(strings[7])); // Back
  CRT_GotoXy(0,6);
  repeat
    pause;
    msx.play;
      keyval := chr(CRT_ReadChar);
      case keyval of
        KEY_BACK: current_menu := MENU_MAIN;
      end;

  until keyval = KEY_BACK;
end;

procedure console_trade;
var y: byte;
    uec: string;
    mode: boolean = false;
    modestr: string;
    itemmax:byte;
    curlocation: string;
    l: byte = 0;

begin
  //colbk:=$06;
  //COLOR2:=$06;
  SetIntVec(iDLI, @dlic);
  SetIntVec(iVBL, @vblc);
  SDLSTL := DISPLAY_LIST_ADDRESS_CONSOLE;

  for y:=0 to TXTCOL do
    CRT_ClearRow(y);

  CRT_GotoXy(0,0);
  uec:= concat(IntToStr(player.uec) , ' UEC');
  //Write (locations[player.loc], ' [Buy] Sell '); WriteRightAligned(10,uec + ' UEC'); writeln;
  // Writeln (NullTermToString(locations[player.loc]), ' [Buy] Sell ', player.uec,' UEC');
{
  if mode = false then
    modestr:=concat('[','Buy'*,'] Sell');
  else
    modestr:=concat('Buy [','Sell*',']');
  end;
}
  modestr:=concat(' Buy '*,' Sell ');
  curlocation:=NullTermToString(locations[player.loc]);
  l:=Length(curlocation);

  CRT_Write (concat(curlocation, ' '~));CRT_Write(modestr); WriteRightAligned(17,uec);
  CRT_GotoXy(0,1);
  CRT_Write ('--------------------+-------------------'~);
{  CRT_GotoXy(0,2);
  CRT_Write ('/Delivery_Location  | ../Available_Items'~);
  CRT_GotoXy(0,3);
  CRT_Write ('[ Cuttles Black ]   | commodity    price'~);
  CRT_GotoXy(0,4);
  CRT_Write ('--------------------+-------------------'~);
  CRT_GotoXy(0,5);
  CRT_write ('Total Cargo '~); WriteRightAligned(9,'46 |');  // mocap
  CRT_GotoXy(0,6);
  CRT_write ('Empty Cargo '~); WriteRightAligned(9,'46 |');  //mocap
  CRT_GotoXy(0,7);
  Write ('--------------------+'~);
  CRT_GotoXy(0,18);
  Write ('--------------------+-------------------'~);
  CRT_GotoXy(0,22);
  WriteRightAligned(TXTCOL,'[Cancel] [OK]');

  ListItems(player.loc);
}
  repeat
    pause;
    msx.play;
    keyval := chr(CRT_ReadChar);
      case keyval of
        KEY_BACK: current_menu:=MENU_MAIN;
      end;
    if (CRT_OptionPressed) then begin
      mode:= not mode;
      if (mode = false) then
        CRT_Invert(0,l+1,5)
      else
        CRT_Invert(0,l+6,6);
    end;

  until keyval = KEY_BACK;
end;

procedure menu;
var
    str: string;
    i: byte;

begin
  SetIntVec(iDLI, @dli1);
  SetIntVec(iVBL, @vbl);
  SDLSTL := DISPLAY_LIST_ADDRESS_MENU;
  //CRT_Init;

  for i:=0 to 6 do
    CRT_ClearRow(i);

  CRT_GotoXy(14,0);
  //CRT_Write ('Navi'~);
  CRT_Write (NullTermToString(strings[3])); // Navigation
  CRT_GotoXy(14,1);
  //CRT_Write ('Trade'~);
  CRT_Write (NullTermToString(strings[4])); // Trade Console
  CRT_GotoXy(14,2);
  //CRT_Write ('Back'~);
  CRT_Write (NullTermToString(strings[7])); // Back


  //str:= ''~;
  //move(str[1],pointer(SCROLL_ADDRESS+42),sizeOf(str));
  hscrol:=0; //stop scroll.

  keyval:=chr(0);
  repeat
    pause;
    msx.play;
    keyval := chr(CRT_ReadChar);
    case keyval of
      KEY_OPTION1: current_menu := MENU_NAV;
      KEY_OPTION2: current_menu := MENU_TRADE;
      KEY_BACK: current_menu := MENU_TITLE;
    end;
  until (keyval = KEY_BACK) or (keyval = KEY_OPTION1) or (keyval = KEY_OPTION2);
end;



procedure title;
var
  str: string;
  count: byte = 3;
  offset: byte = 0;
  y: byte;

begin
  SetIntVec(iDLI, @dli1);
  SetIntVec(iVBL, @vbl);

  SDLSTL := DISPLAY_LIST_ADDRESS_MENU;

  for y:=0 to 6 do
    CRT_ClearRow(y);

  CRT_GotoXY(14,0);
  //CRT_Write (Atascii2Antic(NullTermToString(strings[1]))); // New game;
  CRT_Write('[N]ew Game'~);
  CRT_GotoXY(14,1);
  CRT_Write('[Q]uit'~);
  //CRT_Write (NullTermToString(strings[2])); // Quit;

  str:= Atascii2Antic(NullTermToString(strings[0])); // read scroll text

  move(str[1],pointer(SCROLL_ADDRESS+42),sizeOf(str)); // copy text to vram


  keyval:=chr(0);
  repeat

    pause;
    msx.play;
    keyval := chr(CRT_ReadChar);
    case keyval of
      KEY_NEW: begin
                start;
                current_menu := MENU_MAIN;
              end;
    end;

    if count = $ff then begin // $ff is one below zero
        count := 3;
        offset := (offset + 1) mod 140;  // 140 = 2x string size
        //DL_PokeW(114, SCROLL_ADDRESS + offset); // set new memory offset
        dpoke(DISPLAY_LIST_ADDRESS_MENU + 114, SCROLL_ADDRESS + offset);
    end;

    hscrol := count; // set hscroll
    dec(count);

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
      //TextBackground(fadecolors[i]);
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

  savmsc:= TXT_ADDRESS;

  lmargin:= 0;
  rmargin:= 0;
  CRT_Init;
  //CRT_Init(TXT_ADDRESS);

  fade;
  //CursorOff;

  // Initialize RMT player
  msx.player:=pointer(RMT_PLAYER_ADDRESS);
  msx.modul:=pointer(RMT_MODULE_ADDRESS);
  msx.init(0); //pause;


  // save old vbl and dli interrupt
  GetIntVec(iVBL, oldvbl);
  GetIntVec(iDLI, olddli);
  nmien:= $c0;

  //SetCharset (Hi(CHARSET_ADDRESS)); // when system is off
  chbas:= Hi(CHARSET_ADDRESS);



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
    //if keyval = KEY_QUIT then break;
//until FALSE;
until keyval = KEY_QUIT;

  // restore system
  SetIntVec(iVBL, oldvbl);
  SetIntVec(iDLI, olddli);
  nmien:= $40;
  msx.stop;
  //CursorOn;
  SystemReset;
end.
