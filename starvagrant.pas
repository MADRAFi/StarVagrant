program StarVagrant;
{$librarypath '../Libs/lib/';'../Libs/blibs/';'../Libs/base/'}
uses atari, crt, rmt, b_utils, b_dl, b_system;


const
{$i 'const.inc'}
type
{$i 'types.inc'}

{$r 'resources.rc'}
{$i 'interrupts.inc'}

var
  keyval: char = chr(0);
  msx: TRMT;

  oldvbl, olddli: pointer;

  strings: array [0..0] of word absolute STRINGS_ADDRESS;
  locations: array [0..0] of word absolute LOCATIONS_ADDRESS;
  items: array [0..0] of word absolute ITEMS_ADDRESS;


  current_menu: Byte;
  player: TPlayer;


procedure ClrLine;
(*
@description:
ClrLine clears the current line, starting from the position 1, to the end of the window.

The cursor doesn't move.
*)
begin
   FillChar( pointer(word(DPeek(88)+1)+WhereY*40-41), byte(41-byte(1)), 0);

   //FillByte(pointer(VIDEO_RAM_ADDRESS+(WhereY*TXTCOL)), TXTCOL, 0);
   //ClrEol;
end;

{
procedure  WriteString( s : string; newline : boolean); overload;
var
  x, y : byte;

begin
  x:= WhereX;
  y:= WhereY;
  GotoXy(1,y);
  ClrEol;
  GotoXy(x,y);

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
  GotoXy(1,y);
  ClrEol;
  GotoXy(x,y);

  Writeln (s);
end;
}

function IntToStr(val:integer): string; overload;
begin
  Str(val,Result);
end;

function WordToStr(val:longword): string; overload;
begin
  Str(val,Result);
end;

procedure generateworld;

begin

end;

procedure start;
begin
  //msx.Sfx(3, 2, 24);

  //generateworld;
  player.uec:= 5000;
  player.loc:= 0;

end;

procedure console_navigation;
begin
  GotoXy(1,1);ClrLine;
  writeln ('L: ',NullTermToString(locations[player.loc]));
  GotoXy(1,2);ClrLine;
  writeln ('#########################');
  GotoXy(1,3); ClrLine;
  GotoXy(1,4); ClrLine;
  GotoXy(1,5); ClrLine;
  GotoXy(15,6);ClrLine;
  writeln (NullTermToString(strings[6])); // Back
  GotoXy(1,7); ClrLine;
  repeat
    //pause;
    //msx.play;
    if (keyPressed) then begin
      keyval := ReadKey;
      case keyval of
        KEY_BACK: current_menu := MENU_MAIN;
      end;
    end;
  until keyval = KEY_BACK;
end;

procedure console_trade;
var y: byte;
    uec: string;
begin
  SetIntVec(iDLI, @dlic);
  SetIntVec(iVBL, @vblc);
  SDLSTL := DISPLAY_LIST_ADDRESS_CONSOLE;
  colbk:=$06;
  For y:=1 to TXTCOL do
    begin
      GotoXy(1,y); ClrLine;
    end;
  GotoXy(1,1);
  uec:= concat(IntToStr(player.uec) , ' UEC');
  //Write (locations[player.loc], ' [Buy] Sell '); WriteRightAligned(10,uec + ' UEC'); writeln;
  // Writeln (NullTermToString(locations[player.loc]), ' [Buy] Sell ', player.uec,' UEC');
  Write (NullTermToString(locations[player.loc]), ' [Buy] Sell '); WriteRightAligned(8,uec);
  GotoXy(1,2);
  Write ('----------------------------------------');
  GotoXy(1,3);
  Write ('/Delivery_Locations | ../Available_Items');
  GotoXy(1,4);
  Write ('[ Cuttles Black ]   | commodity    price');
  GotoXy(1,5);
  Write ('--------------------+-------------------');
  write ('Total Cargo '); WriteRightAligned(9,'46 |');writeln;
  write ('Empty Cargo '); WriteRightAligned(9,'46 |');writeln;
  GotoXy(1,8);
  Write ('--------------------+-------------------');
  GotoXy(1,19);
  Write ('--------------------+-------------------');
  GotoXy(1,23);
  WriteRightAligned(40,'[Cancel] [OK]');


  repeat
    //pause;
    //msx.play;
    if (keyPressed) then begin
      keyval := ReadKey;
      case keyval of
        KEY_BACK: current_menu:=MENU_MAIN;
      end;
    end;
  until keyval = KEY_BACK;
end;

procedure menu;
begin
  SetIntVec(iDLI, @dli1);
  SetIntVec(iVBL, @vbl);
  SDLSTL := DISPLAY_LIST_ADDRESS_MENU;

  GotoXy(15,1);ClrLine;
  Writeln (NullTermToString(strings[3])); // Navigation
  GotoXy(15,2);ClrLine;
  Writeln (NullTermToString(strings[4])); // Trade Console
  GotoXy(15,3);ClrLine;
  Writeln (NullTermToString(strings[6])); // Back
  GotoXy(1,4); ClrLine;
  GotoXy(1,5); ClrLine;
  GotoXy(1,6); ClrLine;
  GotoXy(1,7); ClrLine;
  keyval:=char(0);
  repeat
    //pause;
    //msx.play;
    if (keyPressed) then begin
      keyval := ReadKey;
      case keyval of
      KEY_OPTION1: current_menu := MENU_NAV;
      KEY_OPTION2: current_menu := MENU_TRADE;
      KEY_BACK: current_menu := MENU_TITLE;
      end;
    end;
  until (keyval = KEY_BACK) or (keyval = KEY_OPTION1) or (keyval = KEY_OPTION2);
end;



procedure title;
var str : string;
begin
  SetIntVec(iDLI, @dli1);
  SetIntVec(iVBL, @vbl);

  SDLSTL := DISPLAY_LIST_ADDRESS_MENU;


  str:= NullTermToString(strings[1]); // New game
  GotoXy(15,1);ClrLine;
  Writeln (str);
  str:= NullTermToString(strings[2]); // Quit
  GotoXy(15,2);ClrLine;
  Writeln (str);
  GotoXy(1,3); ClrLine;
  GotoXy(1,4); ClrLine;
  GotoXy(1,5); ClrLine;
  GotoXy(1,6); ClrLine;
  str:= NullTermToString(strings[0]); // Scroll
  GotoXy(21,7); ClrLine;
  //GotoXy(21,7); ClrLine;
  Writeln (str);


  keyval:=char(0);
  repeat
    //pause;
    //msx.play;
    if (keyPressed) then begin
      keyval := ReadKey;
      case keyval of
        KEY_NEW: begin
                  start;
                  current_menu := MENU_MAIN;
                end;
      end;
    end;
{
    if count=0 then begin
      count:=8;
      poke(scrol+23, ptext^);
      move(pointer(scrol+1), pointer(scrol), 23);
      inc(ptext);
      if ptext^=$ff then ptext:=pointer(stext);
    end;

    hscrol := count; // set hscroll
    dec(count);
    //blankSize := (blankSize + 1) and 15; // go trough 0-15
    //DL_Poke(10, blanks[blankSize]); // set new blankline height
}
  until (keyval = KEY_QUIT) or (keyval = KEY_NEW);
end;





procedure fade;
var
  fadecolors: Array[0..6] of byte = ($95,$94,$93,$92,$91,$90,$00);
  i: byte;

begin
  for i:=Low(fadecolors) to high(fadecolors)  do
    begin
      TextBackground(fadecolors[i]);
      delay(35);
    end;
  //poke($2C6,$C4);
  TextColor(COLOR_GRAY2);
end;



{
--------------------------------------------------------------------------------
MAIN LOOP
--------------------------------------------------------------------------------
}

begin


  savmsc:= VIDEO_RAM_ADDRESS;

  lmargin:= 0;
  fade;
  CursorOff;
  // Initialize RMT player
{
  msx.player:=pointer(RMT_PLAYER_ADDRESS);
  msx.modul:=pointer(RMT_MODULE_ADDRESS);
  msx.init(0); //pause;

}
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
    if keyval = KEY_QUIT then break;
  until FALSE;

  // restore system
  SetIntVec(iVBL, oldvbl);
  SetIntVec(iDLI, olddli);
  nmien:= $40;

  //msx.stop;
  CursorOn;
end.
