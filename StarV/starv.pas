program StarVagrant;
{$librarypath '../../../MADS/lib/'}
{$librarypath '../../../MADS/base/'}
{$librarypath '../../../MADS/blibs/'}

uses atari, b_utils, b_system, b_crt, sysutils, xbios, cmc;


  (*
                   _____ _
                  / ____| |
                 | (___ | |_ __ _ _ __
                  \___ \| __/ _` | `__|
     __      __   ____) | || (_| | |    _
     \ \    / /  |_____/ \__\__,_|_|   | |
      \ \  / /_ _  __ _ _ __ __ _ _ __ | |_
       \ \/ / _` |/ _` | `__/ _` | `_ \| __|
        \  / (_| | (_| | | | (_| | | | | |_
         \/ \__,_|\__, |_|  \__,_|_| |_|\__|
                   __/ |
                  |___/   (c) 2019 MADsoft

  *)

const
{$i 'const.inc'}

  CURRENCY = ' UEC'~;
  CARGOUNIT = ' SCU'~ ;
  DISTANCEUNIT = ' DU'~;
  COMMISSION = 3;

type
{$i 'types.inc'}

{$r 'resources.rc'}

var
  keyval : Byte = 0;
  player: TPlayer; // player
  ship: TShip; // player's ship
  currentship: TShip; // temp ship for operations
  newLoc: Byte; // new Location (destination)
  tstr : TString; // string used in various routines.
  strnum: TString; // string used in various routines to display numbers
  txt: String; // Some strings
  offset: Word; // offset counted to get items from arrays
  y: Byte; // index for loops
  x: Byte;
  count: Word; // count in item iterations
  msx: TCMC;
  current_menu: Byte;
  gamestate: TGameState;
  music: Boolean;
  disablemusic: Boolean;

  {$i 'strings.inc'}
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
    $04,$0c,$08,$00,    // 0
    $16,$12,$1e,$00,    // 1
    $c2,$c8,$ce,$00,    // 2
    $14,$1a,$ee,$00,    // 3
    $a0,$de,$c6,$00,    // 4
    $96,$82,$9c,$00,    // 5
    $02,$08,$0c,$00,    // 6
    $22,$28,$ee,$00,    // 7
    $a0,$d2,$e8,$00,    // 8
    $10,$14,$1a,$00,    // 9
    $40,$56,$2c,$00,    // 10
    $42,$2c,$38,$00,    // 11
    $26,$B4,$2e,$00,    // 12
    $10,$14,$1c,$00,    // 13
    $86,$8a,$80,$00,    // 14
    $de,$72,$76,$00,    // 15
    $72,$78,$ee,$00,     // 16
    $94,$90,$fe,$00,     // 17
    $70,$74,$7c,$00,     // 18
    $30,$34,$3c,$00,     // 19
    $82,$66,$6e,$00,     // 20
    $70,$74,$7c,$00,     // 21
    $10,$14,$1c,$00,     // 22
    $24,$28,$2c,$00,     // 23
    $24,$20,$76,$00      // 24
  );

  // current gfx colors
  //  $10,$14,$1a,$00
  gfxcolors: array [0..3] of Byte = (
    $00,$00,$00,$00
  );
  txtcolors : array [0..1] of Byte = (
    $00,$1c
  );

  itemprice: array [0..(NUMBEROFLOCATIONS * NUMBEROFITEMS)-1] of Word = (
    0,0,0,0,83,40,0,31,69,0,0,198,16,0,280,170,0,0,0,34,145,199,1,0,
    640,0,252,0,83,52,0,0,69,32,0,198,20,0,0,180,0,0,10,0,0,179,0,240,
    0,0,280,0,0,0,23,0,0,32,21,0,13,15,0,221,14,0,0,34,0,0,0,256,
    0,12,139,0,0,0,26,0,0,32,0,0,0,0,0,180,14,0,0,34,0,0,1,234,
    450,0,280,0,0,66,0,0,0,32,0,98,0,0,0,221,14,15,0,34,0,123,1,0,
    475,0,280,0,0,25,0,21,0,32,0,0,0,0,0,221,14,8,0,34,0,101,0,384,
    0,45,0,0,0,0,26,0,0,16,0,0,15,0,0,0,10,0,0,23,0,0,20,0,
    0,65,0,110,0,74,0,0,0,0,0,258,0,0,0,276,0,0,8,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,52,12,0,8,23,0,0,10,0,0,88,0,0,18,0,
    563,0,0,0,0,0,0,47,39,0,0,0,0,15,0,0,14,21,16,0,0,0,2,0,
    563,22,0,0,0,0,0,36,0,92,75,0,14,45,0,0,0,24,20,0,0,0,1,398,
    513,0,175,0,178,107,0,0,176,98,0,198,10,0,560,0,0,0,0,0,43,333,0,448,
    0,0,0,110,173,38,0,0,46,0,0,198,16,0,292,201,0,0,20,0,203,276,0,398,
    0,0,280,60,0,50,15,0,39,47,0,0,0,0,0,201,14,0,0,0,0,0,1,398,
    0,24,280,60,0,0,0,0,0,47,0,168,0,0,0,201,14,0,0,0,0,0,1,398,
    0,55,0,0,0,0,15,25,0,0,35,168,11,40,377,0,14,33,0,0,89,0,0,384,
    0,0,0,110,0,0,38,49,0,40,26,0,12,15,300,175,16,0,0,56,99,0,0,0,
    350,0,0,100,160,32,0,27,0,0,0,0,44,0,250,0,0,10,5,0,89,125,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    500,0,0,125,0,44,0,33,0,16,0,0,0,0,0,150,0,0,0,0,389,0,0,0,
    0,40,0,0,0,0,32,42,0,0,31,0,32,25,0,0,10,0,0,0,0,0,1,0,
    0,0,630,125,0,0,0,0,176,98,0,258,40,0,0,195,20,0,0,88,389,0,1,768,
    0,6,0,100,0,90,0,40,10,8,0,50,4,0,500,0,0,29,0,100,400,0,0,0,
    0,6,0,100,0,0,35,0,10,8,70,50,4,40,0,300,30,0,0,0,0,300,0,0



  );  // price matrix for items

  itemquantity: array [0..(NUMBEROFLOCATIONS * NUMBEROFITEMS)-1] of Word = (
    0,0,0,0,5000,5000,0,5000,0,0,0,0,65000,0,0,5000,0,0,0,5000,2000,0,10000,0,
    0,0,0,0,0,0,0,0,0,0,0,0,65000,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,5000,0,0,0,5000,0,2500,2500,0,0,0,0,0,0,0,0,10000,0,
    0,2500,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000,1000,
    5000,0,0,0,0,2500,0,0,0,0,0,5000,0,0,0,0,0,2500,0,0,0,5000,10000,0,
    2500,0,0,0,0,2500,0,2500,0,0,0,0,0,0,0,0,0,5000,0,0,0,2500,10000,0,
    0,0,0,0,0,0,0,0,0,5000,0,0,2500,0,0,0,5000,0,0,2500,0,0,0,0,
    0,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,2500,0,0,5000,0,0,0,10000,0,
    0,0,0,0,0,0,0,0,0,2500,500,0,2500,2500,0,0,5000,0,0,2500,0,0,10000,0,
    5000,0,0,0,0,0,0,1500,0,0,0,0,0,1000,0,0,0,0,5000,0,0,0,10000,0,
    0,2500,0,0,0,0,0,0,0,0,0,0,65000,0,0,0,0,0,2500,0,0,0,10000,0,
    5000,0,0,0,5000,5000,0,0,5000,100,0,500,65000,0,5000,0,0,0,0,0,5000,2000,0,0,
    1000,0,0,0,1000,1000,0,0,1000,0,0,1000,65000,0,1000,1000,0,0,0,0,1000,1000,0,0,
    0,0,0,5000,0,0,0,0,2500,0,0,0,0,0,0,0,0,0,0,0,0,0,10000,0,
    0,500,0,5000,0,0,0,0,0,0,0,5000,0,0,0,0,0,0,0,0,0,0,10000,0,
    0,5000,0,0,0,0,5000,5000,0,0,5000,0,5000,5000,2500,0,2500,5000,0,0,0,0,0,0,
    0,0,0,500,0,0,500,500,0,500,500,0,5000,500,500,500,500,0,0,500,500,0,0,0,
    10000,0,0,10000,10000,10000,0,10000,0,0,0,0,65000,0,10000,0,0,10000,65000,0,10000,10000,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    5000,0,0,5000,0,5000,0,5000,0,5000,0,0,0,0,0,5000,0,0,0,0,5000,0,0,0,
    0,10000,0,0,0,0,10000,10000,0,0,10000,0,65000,10000,0,0,65000,0,0,0,0,0,65000,0,
    0,0,0,5000,0,0,0,0,5000,5000,0,5000,0,0,0,0,0,0,0,0,10000,0,65000,0,
    0,65000,0,0,0,0,0,0,65000,65000,0,65000,65000,0,0,0,0,0,0,0,0,0,0,0,
    0,65000,0,0,0,0,0,0,65000,65000,0,65000,65000,0,0,0,0,0,0,0,0,0,0,0

  ); // quantities of items

  locationdistance: array[0..(NUMBEROFLOCATIONS * NUMBEROFLOCATIONS)-1] of Word = (
    0,50,0,0,0,0,0,0,60,0,0,365,120,0,0,50,50,0,0,0,0,0,0,0,0,
    80,0,20,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,0,0,0,0,0,0,0,0,
    0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    60,0,0,0,0,0,0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,50,0,60,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,50,0,0,0,0,0,0,0,500,0,0,0,0,0,600,0,
    365,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1200,
    120,0,0,0,0,0,0,0,0,60,0,0,0,10,70,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,70,0,0,0,0,0,0,0,0,0,0,0,0,
    50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    50,0,0,0,20,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,500,0,0,0,0,0,0,0,150,0,95,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,150,0,80,180,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,80,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,95,180,0,0,220,300,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,220,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,300,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,600,0,0,0,0,0,0,0,0,0,0,0,0,0,720,
    0,0,0,0,0,0,0,0,0,0,0,1200,0,0,0,0,0,0,0,0,0,0,0,720,0


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
    0,8000,11999,22700,32000,0,0,0,124900,166000,330000,0,
    0,0,0,0,0,0,0,0,0,0,0,0,
    1000,5000,11900,18000,29000,0,50000,59000,124000,130000,300000,0,
    0,0,0,0,0,0,0,0,0,0,0,0,
    0,4000,10000,16000,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,
    0,9000,12990,22700,32000,0,75000,62000,0,0,330000,0,
    0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0



    
  ); // ship prices

  creditstxt: array [0..9] of String = (
    'Programming'~,
    'MADRAFi'~,
    ''~,
    'Graphics'~,
    'Broniu  Kaz    '~,
    'MADRAFi'~,
    ''~,
    'Music'~,
    'Caruso'~,
    ''~
    
);

  thankstxt: array [0..9] of String = (
    'Special thanks to:'~,
    ''~,
    'Bocianu for all the support'~,
    ''~,
    'XXL for xBios support'~,
    'Tebe for providing MAD-Pascal help'~,
    'Kaz for testing and advise'~,
    'Dely for QA testing'~,
    ''~,
    ''~
);

  availableitems: array [0..(MAXAVAILABLEITEMS-1)] of Word; // only 12 avaiable items
  availabledestinations: array [0..(MAXAVAILABLEDESTINATIONS-1)] of Word; // only 6 available destinations
  availableships: array [0..(NUMBEROFSHIPS-1)] of Word; // only available ships

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

procedure writeRuler(row:Byte);

// var
//   output: String;

begin
    CRT_GotoXY(0,row);
    for y:=0 to 19 do
    begin
      CRT_Write(Chr(82)); // 18 adding 64 to convert to ANTIC codes.
    end;

    CRT_Write(Chr(83));  // 19 + 64
    for y:=0 to 18 do
    begin
      CRT_Write(Chr(82));  // 18 + 64
    end;

    sfx_play(voice4,77,202); // vol10
end;

procedure WriteSpaces(len:Byte);
begin
  CRT_Write(Atascii2Antic(Space(len)));
end;

// procedure WriteFF(var ptr:word);
// begin
//     CRT_Write(FFTermToString(ptr));
// end;

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
var b:byte;
begin

  repeat
    Waitframes(2);
    for b:=0 to 3 do 
        If (gfxcolors[b] and %00001111 <> 0) then Dec(gfxcolors[b]) else gfxcolors[b]:=0;
    If hidetext then
    begin
      If (txtcolors[0] and %00001111 <> 0) then Dec(txtcolors[0]) else txtcolors[0]:=0;
      If (txtcolors[1] and %00001111 <> 0) then Dec(txtcolors[1]) else txtcolors[1]:=0;
    end;
  until ((gfxcolors[0] or gfxcolors[1] or gfxcolors[2] or gfxcolors[3])=0) and ((hidetext = false) or ((txtcolors[0] or txtcolors[1])=0));
  waitframes(10);
end;

procedure gfx_fadein;
var
  b : byte;
  targetcolors: array [0..3] of Byte;

const
  txtcolor = $1c;
  txtback = 0;
  // titlecolors : array [0..3] of Byte = ($10,$14,$1a,$00);
  titlecolors : array [0..3] of Byte = ($12,$18,$1e,$00);


begin
  // gfxcolors[0]:=0;
  // gfxcolors[1]:=0;
  // gfxcolors[2]:=0;
  // gfxcolors[3]:=0;
  y:= newLoc shl 2; // x 4 for number of colors
  if (current_menu = MENU_TITLE) or (current_menu = MENU_SAVE) or (current_menu = MENU_LOAD) or (current_menu = MENU_CREDITS) then
  begin
    targetcolors:=titlecolors;
  end
  else
  begin
    for b:=0 to 3 do 
      targetcolors[b]:=piccolors[y+b];
  end;

  repeat
    Waitframes(2);
    for b:=0 to 3 do 
      If ((gfxcolors[b] and %00001111) <= (targetcolors[b] and %00001111)) then Inc(gfxcolors[b]) else gfxcolors[b]:=targetcolors[b];

    If ((txtcolors[0] and %00001111) <= (txtback and %00001111)) then inc(txtcolors[0]) else txtcolors[0]:=txtback;
    If ((txtcolors[1] and %00001111) <= (txtcolor and %00001111)) then inc(txtcolors[1]) else txtcolors[1]:=txtcolor;

  until (gfxcolors[0]=targetcolors[0]) and
        (gfxcolors[1]=targetcolors[1]) and
        (gfxcolors[2]=targetcolors[2]) and
        (gfxcolors[3]=targetcolors[3]);


  // CRT_GotoXY(0,23);
  // CRT_Write('gfxcolors[2]='~);CRT_Write(gfxcolors[2]);CRT_Write(' titlecolors[2]='~);CRT_Write(titlecolors[2]);
end;

procedure putStringAt(snum,x,y:byte);
begin
  CRT_GotoXY(x,y);
  CRT_Write(strings[snum]); // Navigation
end;

procedure putSpacesAt(snum,x,y:byte);
begin
  CRT_GotoXY(x,y);
  WriteSpaces(snum);
end;

procedure WriteSpace;
begin
    CRT_Write(' '~);
end;

procedure navi_destinationUpdate(locationindex: Word);

begin
  //CRT_GotoXY(0,1);
  //WriteSpaces(19); // max location lenght
  putSpacesAt(19,0,1);
  //CRT_GotoXY(0,1);
  //CRT_Write(strings[21]);
  putStringAt(21,0,1);
  CRT_Write(locations[locationindex-(player.loc * NUMBEROFLOCATIONS)]);
end;

procedure navi_distanceUpdate(mydistance: Word);

begin
  //CRT_GotoXY(9,2);
  //WriteSpaces(6); // max distance lenght + distance symbol
  putSpacesAt(6,9,2);
  CRT_GotoXY(9,2);
  //CRT_Write(strings[22]);
  CRT_Write(mydistance); CRT_Write(DISTANCEUNIT);
  //CRT_GotoXY(6,3);
  //WriteSpaces(5);
  putSpacesAt(5,6,3);
  CRT_GotoXY(6,3);
  // CRT_Write(Trunc((ship.qf / ship.qf_max) * 100)); CRT_Write(' %'~);
  CRT_Write(ship.qf * 100 div ship.qf_max); CRT_Write(' %'~);
  // CRT_GotoXY(0,5);
  // CRT_Write(ship.swait);
end;

function getcargotypenum : Byte;
begin
  Result:=0;
  for y:=0 to MAXCARGOSLOTS-1 do
  begin
    If ship.cargoindex[y] > 0 then Inc(Result)
    else break;
  end;
end;

procedure beep185;
begin
    sfx_play(voice4,185,202);
end;

procedure beep200;
begin
    sfx_play(voice4,200,202);
end;

procedure beep230;
begin
    sfx_play(voice4,230,202);
end;

procedure beep255;
begin
    sfx_play(voice4,255,170);
end;

procedure encounterMessage;
begin
  beep230; //vol 10

  CRT_ClearRows(0,7);

  CRT_GotoXY(0,0);
  for y:=1 to Length(txt) do
  begin
    CRT_Write(txt[y]);
    if (y mod 4) = 0 then beep200; //vol 10
    // waitframes(2);
    waitframe;
  end;

  //CRT_GotoXY(12,6);
  //CRT_Write(strings[26]); // press any key
  putStringAt(26,12,6);

  repeat
    Waitframe;
  until CRT_Keypressed;

end;


function percentC(v:word):word;
begin
    // need to set count before calling the procedure
    // example count:= Random(100);
    result:=v * count div 100;
end;  


procedure randomEncounter;

// var
//   modify: Real;

begin
  y:=Random(34);
  txt:='#';
  case y of

    1:    begin
            if player.uec > 0 then
            begin
              txt:=strings[34];
              player.uec:=player.uec - 2500;
            end;
          end;
    3:    begin
              txt:=strings[35];

              // offset:=Round(Random * 50000);
              // player.uec:=player.uec + offset;
              player.uec:=player.uec + (Random(100) * 500);  // Random % from 50000 UEC
          end;
    5:    begin
            if ship.cargoquantity[0] > 0 then
            begin
              count:=getcargotypenum;
              y:=Random(count);
              if ship.cargoindex[y] > 0 then
              begin
                txt:=strings[33];
                // modify:=(1 - Random(100)/100);
                // ship.cargoquantity[y]:=Round(ship.cargoquantity[y] * modify);
                count:=Random(100);
                ship.cargoquantity[y]:=ship.cargoquantity[y] - percentC(ship.cargoquantity[y]);
                Dec(ship.scu,percentC(ship.cargoquantity[y]));
              end;
            end;
          end;
    10:   begin
            txt:=strings[32];

            // offset:= Round(Random * 10000);
            // player.uec:=player.uec + offset;
            player.uec:=player.uec + (Random(100) * 100);  // Random % from 10000 UEC

          end;
    20:   begin
            if player.uec > 0 then
            begin
              txt:=strings[31];
              player.uec:=0;
            end;
          end;
    22:   begin
            if ship.cargoquantity[0] > 0 then
            begin
              txt:=strings[30];
              offset:=Random(getcargotypenum);
              ship.cargoindex[offset]:=0;
              Dec(ship.scu,ship.cargoquantity[offset]);
              ship.cargoquantity[offset]:=0;
            end;
          end;
    24:   begin
            if ship.cargoindex[0] > 0 then
            begin
              txt:=strings[29];
              eraseArray(0,MAXCARGOSLOTS-1, @ship.cargoindex);
              eraseArray(0,MAXCARGOSLOTS-1, @ship.cargoquantity);
              ship.scu:=0;
            end;
          end;
  end;
  If (txt <> '#') then encounterMessage;
end;

procedure calculateprices;
// var
  // percent: Shortreal;
  // modify: Real;
  // percent: Real;
var priceChange: word;

begin
  count:=Random(100);
  priceChange:=percentc(itemprice[offset]);
  for y:=0 to NUMBEROFITEMS-1 do begin
    offset:= (NUMBEROFITEMS * player.loc)+y;

    // Produce new items on certain LOCATIONS
    if (itemquantity[offset] > 0) and (itemquantity[offset] <= 100) then
    begin
      case loc of
        2..9,13,14:   begin
                        Inc(itemquantity[offset],Random(500)); // adding up to 500 items
                      end;
      end;
    end;

    // Increase price if less then 5000
    if (itemquantity[offset] > 0) and (itemquantity[offset] < 5000) and (itemprice[offset] > 0) and (count < 70 ) then
    begin
      // modify:=(1 + percent);
      // itemprice[offset]:=Round(itemprice[offset] * modify);
      // itemprice[offset]:=Round(itemprice[offset] * (1 + percent));
      Inc(itemprice[offset],priceChange);
    end;

    // Decrease price if more then 5000
    if (itemquantity[offset] > 10000) and (itemquantity[offset] < 20000) and (itemprice[offset] > 0) and (count <= 30) then
    begin
      // modify:=(1 - percent);
      // itemprice[offset]:=Round(itemprice[offset] * modify);
      // itemprice[offset]:=Round(itemprice[offset] * (1 - percent))
      Dec(itemprice[offset],priceChange);
    end;

    // Simulate item sell
    if (itemquantity[offset] > 20000) and (itemprice[offset] > 0) and (count <= 80) then
    begin
      // modify:=(1 - percent);
      // itemquantity[offset]:=Trunc(itemquantity[offset] * modify);
      // itemquantity[offset]:=Trunc(itemquantity[offset] * (1 - percent));
      Dec(itemquantity[offset],percentc(itemquantity[offset]));
    end;

  end;

  if (count < 40) then // only 40% chance for ship's price change
  begin
    for y:=0 to NUMBEROFSHIPS-1 do begin
      offset:= (NUMBEROFSHIPS * loc)+y;
      if shipprices[offset] > shipprices[0] then // do not change price of starting ship
      begin
        x:=Random(2);
        count:= Random(30);
        priceChange:=percentc(shipprices[offset]);
        if x = 0 then
        begin
          // price drop
          // modify:=(1 - percent);
          // shipprices[offset]:=Round(shipprices[offset] * (1 - percent));
          Dec(shipprices[offset],priceChange);

          //newprice:=Round(shipprices[offset] * (1 - percent));
          //shipprices[offset]:=Longword(shipprices[offset] * (1 - percent));
        end
        else
        begin
          // price increase
          // modify:=(1 + percent);
          // shipprices[offset]:=Round(shipprices[offset] * (1 + percent));
          Inc(shipprices[offset],priceChange);

          //newprice:=Round(shipprices[offset] * (1 + percent));
          //shipprices[offset]:=Longword(shipprices[offset] * (1 + percent));
        end;
        // shipprices[offset]:=Round(shipprices[offset] * modify);


        // CRT_GotoXY(0,6);
        // if offset = 22 then begin
        //   CRT_Write(real(percent)); WriteSpaces(1); CRT_Write(modify);WriteSpaces(1);CRT_Write(shipprices[offset]);
        //   repeat until CRT_Keypressed;
        // end;
      end;
    end;
  end;
end;

{$ifdef highmem }
  {$i 'highmem.inc'}
{$else}
  {$i 'lowmem.inc'} // lowmem procs to load pictures from disk 
{$endif}

procedure initWorld;

var
  priceChange: word;

begin

  for offset:=0 to (NUMBEROFITEMS-1) * (NUMBEROFLOCATIONS-1) do
  begin
    if (itemprice[offset] > 0) then
      x:=Random(2); 
      count:=Random(25);
      priceChange:=percentc(itemprice[offset]);
      if x = 0 then
      begin
        // price drop
        Dec(itemprice[offset],priceChange);
      end
      else
      begin
        // price increase
        Inc(itemprice[offset],priceChange);
    end;
  end;
    
  // test cargo
  // ship.cargoindex[0]:=8;
  // ship.cargoquantity[0]:=10;
  // ship.cargoindex[1]:=11;
  // ship.cargoquantity[1]:=20;
  // ship.scu:= 30;

  
end;


procedure start;

begin
  sfx_play(voice4,88,202); // vol10
  gfx_fadeout(true);
  WaitFrame;
  
  current_menu := MENU_MAIN;
  gamestate:=GAMEINPROGRESS;
  player.uec:= STARTUEC;
  //if player.loc <> 0  then
  //begin
  player.loc:= STARTLOCATION;
  newLoc:= STARTLOCATION; //0;
  //end;
  
  pic_load(LOC,player.loc);
  
  initWorld;

  // tshp:= shipmatrix[0];
  // ship:= tshp^;
  // ship:= shipmatrix[0];
  move(shipmatrix[0], ship, sizeof(TShip));
  ship.qf:= ship.qf_max; // starting fuel

  eraseArray(0,MAXCARGOSLOTS-1, @ship.cargoindex);
  eraseArray(0,MAXCARGOSLOTS-1, @ship.cargoquantity);


  // gfx_fadein;

end;


procedure ListCargo(trade_mode : Boolean);
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
      CRT_Write(tstr);
      strnum:=IntToStr(currentship.cargoquantity[y]);
      WriteSpaces(LISTWIDTH-Length(tstr)-Length(strnum));
      CRT_Write(Atascii2Antic(strnum));
      if (count = 1) and trade_mode then CRT_Invert(LISTSTART,8,LISTWIDTH);
      Inc(count);
    end;
  end;
  for y:=count to MAXCARGOSLOTS-1 do
  begin
    //CRT_GotoXY(LISTSTART,TOPCARGOMARGIN+y-1);
    //WriteSpaces(LISTWIDTH); // -1 to clear from the end of list
    putSpacesAt(LISTWIDTH,LISTSTART,TOPCARGOMARGIN+y-1);
  end;

end;


procedure ListItems(trade_mode: boolean);
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

      if trade_mode then
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

        CRT_Write(count);WriteSpace;
        tstr:= items[availableitems[y]-(player.loc * NUMBEROFITEMS)];
        CRT_Write(tstr);
        //if mode then finalprice:=Trunc(itemprice[offset] * (1-COMMISSION))
        // if mode then finalprice:=Round(itemprice[offset] * (1-COMMISSION))
        if trade_mode then finalprice:=itemprice[offset] - (itemprice[offset] * COMMISSION div 100)
        else finalprice:=itemprice[offset];
        countstr:=IntToStr(count);
        strnum:=IntToStr(finalprice);
        WriteSpaces(LISTWIDTH-(Length(countstr)+1+Length(tstr))-Length(strnum)); // (count, space and string)-price
        CRT_Write(Atascii2Antic(strnum));
        //CRT_WriteRightAligned(Atascii2Antic(IntToStr(finalprice)));
        if (count = 1) and not trade_mode then CRT_Invert(LISTSTART,5,LISTWIDTH);
        inc(count);
      end
      else
      begin
        //CRT_GotoXY(LISTSTART,4+y+1);
        //WriteSpaces(LISTWIDTH);
        putSpacesAt(LISTWIDTH, LISTSTART, 4+y+1);
      end;

    end;
  beep185; // vol10
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
      CRT_Write(count+1);WriteSpace;
      CRT_Write(locations[offset]);
      //CRT_Write('offset='~); CRT_Write(offset);
      Inc(count);
    end;

  // debug
  //   CRT_GotoXY(LISTSTART,count);
  //   CRT_Write('avdes='~);
  //   CRT_Write(availabledestinations[x]);
  //   Inc(count);
  end;
  beep185; // vol10

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
    // Result:=Round(itemprice[offset] * (1-commission))
    Result:=itemprice[offset] - (itemprice[offset] * COMMISSION div 100)
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
  // Result:=Round(itemprice[offset] * (1-commission));
  Result:=itemprice[offset] - (itemprice[offset] * COMMISSION div 100);
end;

function CheckCargoPresence(itemindex: Byte): Boolean;

// var
//   item: Word;

begin
  //for item in availableitems do
  // for item:=0 to MAXAVAILABLEITEMS-1 do
  //   begin
  //     if currentShip.cargoindex[itemindex] = availableitems[item] then exit(true);
  //   end
  Result := currentship.cargoindex[itemindex] > 0;
end;


procedure console_navigation;
var
  //y: byte;
  destinationindex: Word;
  distance: Word;
  fuel: Boolean;

procedure setDestIdx(v:word);
begin
  beep230; //vol 10
  x:=1; // reused variable
  destinationindex:=v;
end;

begin
  CRT_ClearRows(0,7);

  //CRT_GotoXY(0,0);
  //CRT_Write(strings[20]); // Loc:
  putStringAt(20,0,0);

  
  CRT_Write(locations[player.loc]);
  //CRT_GotoXY(20,0);
  //CRT_Write(strings[23]); // Navigation:

  //CRT_GotoXY(0,1);
  //CRT_Write(strings[21]); // Nav:
  putStringAt(21,0,1);

  //CRT_GotoXY(0,2);
  //CRT_Write(strings[22]);  // Dis:
  putStringAt(22,0,2);

  // CRT_GotoXY(12,2);
  // CRT_Write(Atascii2Antic(DISTANCEUNIT));
  //CRT_GotoXY(0,3);
  //CRT_Write(strings[59]); // QFuell:
  putStringAt(59,0,3);

  // CRT_Write(Trunc((ship.qf / ship.qf_max) * 100)); CRT_Write(' %'~);
  CRT_Write(ship.qf * 100 div ship.qf_max); CRT_Write(' %'~);

  // Help Keys
  CRT_GotoXY(0,7);
  CRT_Write('1-6'*~); // Navigation options
  putStringAt(23,3,7);

  WriteSpace;
  CRT_Write(strings[24]);  // FTL Jump
  WriteSpace;
  CRT_Write(strings[7]); // Back

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
                          beep255; // vol10
                          current_menu := MENU_MAIN;
                        end;
          KEY_OPTION1:  begin
                          //sfx_play(voice4,230,202); //vol 10
                          //destinationindex:=availabledestinations[0];
                          setDestIdx(availabledestinations[0]);
                        end;
          KEY_OPTION2:  begin
                          //sfx_play(voice4,230,202); //vol 10
                          //destinationindex:=availabledestinations[1];
                          setDestIdx(availabledestinations[1]);
                        end;
          KEY_OPTION3:  begin
                          //sfx_play(voice4,230,202); //vol 10
                          //destinationindex:=availabledestinations[2];
                          setDestIdx(availabledestinations[2]);
                        end;
          KEY_OPTION4:  begin
                          //sfx_play(voice4,230,202); //vol 10
                          //destinationindex:=availabledestinations[3];
                          setDestIdx(availabledestinations[3]);
                        end;
          KEY_OPTION5:  begin
                          //sfx_play(voice4,230,202); //vol 10
                          //destinationindex:=availabledestinations[4];
                          setDestIdx(availabledestinations[4]);
                        end;
          KEY_OPTION6:  begin
                          //sfx_play(voice4,230,202); //vol 10
                          //destinationindex:=availabledestinations[5];
                          setDestIdx(availabledestinations[5]);
                        end;
          KEY_JUMP:     begin
                          if (destinationindex > 0) then
                          begin
                            if (ship.qf >= distance) then fuel:= true
                            else fuel:= false;

                            if fuel then
                            begin
                              beep200; //vol 10
                              newLoc:=destinationindex-(player.loc * NUMBEROFLOCATIONS);
                              navi_ftljump(distance);
                              current_menu:=MENU_MAIN;
                            end
                            else
                            begin
                              //CRT_GotoXY(7,6);
                              //CRT_Write(strings[60]);
                              putStringAt(60,7,6);

                              destinationindex:=0;
                            end;
                          end;
                        end;
          else 
             x:=0; // reuse variable
        end;
        if (current_menu=MENU_NAV) and (destinationindex > 0) and (x > 0) then
        begin
          distance:=locationdistance[destinationindex];
          navi_destinationUpdate(destinationindex);
          navi_distanceUpdate(distance);
        end;
        If (destinationindex > 0) then CRT_ClearRow(6);  // clear msg row when enough fuel for destination
    end;
    Waitframe;

  until (keyval = KEY_BACK) OR ((keyval = KEY_JUMP) and fuel);
end;

procedure console_ship;

var
  shipindex: Byte;
  selectPressed: Boolean = false;
  currentshipprice: Longword;

begin
  x:=0;
  beep230; //vol 10
  CRT_ClearRows(0,7);


  //CRT_GotoXY(0,0);

  CRT_WriteRightAligned(0,concat(Atascii2Antic(IntToStr(player.uec)), CURRENCY));

  shipindex:= 0; // show 1st available;

  tshp:=shipmatrix[availableships[shipindex]];
  offset:=(NUMBEROFSHIPS * player.loc) + availableships[shipindex];

  //CRT_GotoXY(0,0);
  //CRT_Write(strings[38]); // Prod:
  putStringAt(38,0,0);

  CRT_Write(prodmatrix[tshp^.mcode]);

  //CRT_GotoXY(0,1);
  //CRT_Write(strings[37]); // Name:
  putStringAt(37,0,1);

  CRT_Write(ships[tshp^.sindex * MAXSHIPPARAMETERS]);

  //CRT_GotoXY(0,2);
  //CRT_Write(strings[39]); // Cargo:
  putStringAt(39,0,2);

  CRT_Write(tshp^.scu_max);
  // CRT_GotoXY(10,2);
  CRT_Write(CARGOUNIT);

  //CRT_GotoXY(0,3);
  //CRT_Write(strings[40]); // Price:
  putStringAt(40,0,3);

  CRT_Write(shipprices[(NUMBEROFSHIPS * player.loc) + tshp^.sindex]);
  // CRT_GotoXY(12,3);
  CRT_Write(CURRENCY);


  //CRT_GotoXY(23,1);
  //CRT_Write(strings[41]); // Speed:
  putStringAt(41,23,1);

  CRT_Write(tshp^.speed);
  // CRT_GotoXY(33,1);
  CRT_Write(strings[45]);

  //CRT_GotoXY(23,2);
  //CRT_Write(strings[42]); // Lenght:
  putStringAt(42,23,2);

  CRT_Write(tshp^.lenght);
  // CRT_GotoXY(33,2);
  CRT_Write(strings[46]);

  //CRT_GotoXY(23,3);
  //CRT_Write(strings[43]); // Mass:
  putStringAt(43,23,3);

  CRT_Write(tshp^.mass);
  // CRT_GotoXY(33,3);
  CRT_Write(strings[47]);

  // Help Keys
  CRT_GotoXY(5,7);
  // txt:=concat(char(30),char(31));
  // CRT_Write(Atascii2Antic(txt));
  CRT_Write(Chr(30+128+64)); CRT_Write(Chr(31+128+64)); // character code + 128 for inverse + 64 for antic code
  CRT_Write(strings[44]);  // Choose
  WriteSpace;
  CRT_Write('RETURN'*~);
  CRT_Write(strings[19]);  // Confirm
  WriteSpace;
  CRT_Write(strings[7]);   // Back

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
                          beep255; // vol10
                          current_menu := MENU_MAIN;
                        end;
          KEY_LEFT:   begin
                          if (shipindex > 0) then
                          begin
                            sfx_play(voice4,80,170); // vol10
                            Dec(shipindex);
                            x:=1; //reused variable
                          end
                          else
                          begin
                            beep255; // vol10
                            x:=0; //reused variable
                          end;
                      end;
          KEY_RIGHT:  begin
                        if (shipindex < NUMBEROFSHIPS-1) and (availableships[shipindex+1] > 0) then
                        begin
                          sfx_play(voice4,80,170); // vol10
                          Inc(shipindex);
                          x:=1; //reused variable
                        end
                        else
                        begin
                          beep255; // vol10
                          x:=0; //reused variable
                        end;
                      end;
          KEY_SELECT: begin
                        if not selectPressed then
                        begin
                          CRT_GotoXY(0,5);
                          If ship.sindex <> availableships[shipindex] then
                          begin
                            beep230; //vol 10
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
                              ship.qf:= ship.qf_max;
                              //CRT_GotoXY(0,5);
                              //CRT_Write(strings[27]);
                              putStringAt(27,0,5);

                              repeat until CRT_Keypressed;
                              current_menu:=MENU_MAIN;
                            end
                            else
                            begin
                              //Message not enough UEC
                              beep255; // vol10
                              //CRT_GotoXY(6,5);
                              //CRT_Write(strings[48]);
                              putStringAt(48,6,5);

                              CRT_Write(CURRENCY);CRT_Invert(29,5,5)
                            end;
                          end
                          else
                          begin
                            //Message that ship is already owned
                            beep255; // vol10
                            //CRT_GotoXY(0,5);
                            //CRT_Write(strings[49]);
                            putStringAt(49,0,5);

                          end;
                        end;
                        selectPressed:=true;
                      end;

        end;
   
        if (current_menu=MENU_SHIP) and (shipindex <= NUMBEROFSHIPS-1) and (x > 0) then

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


          //CRT_GotoXY(5,0);
          //WriteSpaces(24);
          putSpacesAt(24,5,0);
          CRT_GotoXY(5,0);
          CRT_Write(prodmatrix[tshp^.mcode]);
          //CRT_GotoXY(5,1);
          //WriteSpaces(14);
          putSpacesAt(14,5,1);
          CRT_GotoXY(5,1);
          offset:=tshp^.sindex * (MAXSHIPPARAMETERS);
          CRT_Write(ships[offset]);
          //CRT_GotoXY(6,2);
          //WriteSpaces(7);
          putSpacesAt(7,6,2);
          CRT_GotoXY(6,2);
          CRT_Write(tshp^.scu_max);CRT_Write(CARGOUNIT);
          //CRT_GotoXY(6,3);
          //WriteSpaces(12);
          putSpacesAt(12,6,3);
          CRT_GotoXY(6,3);
          offset:=(NUMBEROFSHIPS * player.loc) + availableships[shipindex];
          CRT_Write(shipprices[offset]);CRT_Write(CURRENCY);
          //CRT_GotoXY(29,1);
          //WriteSpaces(9);
          putSpacesAt(9,29,1);
          CRT_GotoXY(29,1);
          CRT_Write(tshp^.speed);CRT_Write(strings[45]);
          //CRT_GotoXY(30,2);
          //WriteSpaces(7);
          putSpacesAt(7,30,2);
          CRT_GotoXY(30,2);
          CRT_Write(tshp^.lenght);CRT_Write(strings[46]);
          //CRT_GotoXY(28,3);
          //WriteSpaces(9);
          putSpacesAt(9,28,3);
          CRT_GotoXY(28,3);
          CRT_Write(tshp^.mass);CRT_Write(strings[47]);
        end;
    end
    else
    begin
      selectPressed:=false;
    end;

    Waitframe;

  until (keyval = KEY_BACK) or (current_menu = MENU_MAIN);
end;

procedure console_maint;

var
  // shipindex: Byte;
  selectPressed: Boolean = false;
  fuelprice: Word;
  fuelquantity: Word;
  reqfuel: Word;
  fueltotal: Longword;
  reqtotal: LongWord;
  itemoffset: Word;
  

begin
  beep230; //vol 10
  CRT_ClearRows(0,7);

  itemoffset:=(NUMBEROFITEMS * player.loc) + 12; // check hydrogen
  fuelquantity:= 0;
  if (itemquantity[itemoffset] > 0) then
  begin
    fuelprice:=itemprice[itemoffset] div 4;     // Fuel price is 1/4 of Hydrogen
  end
  else
  begin    
    // There is no Hydrogen to refuel
    fuelprice:= 0;
    CRT_WriteCentered(6,strings[60]);
  end;
  reqfuel:= 0;
  reqtotal:= 0;
  // CRT_GotoXY(0,6);
  // CRT_Write('offset:'~);CRT_Write(itemoffset);CRT_Write(' iprice:'~);CRT_Write(iprice);CRT_Write(' fuelprice:'~);CRT_Write(fuelprice);
  
  If (ship.qf < ship.qf_max) then
  begin
    reqfuel:=ship.qf_max - ship.qf;
    reqtotal:= reqfuel * fuelprice;
    if (player.uec  >= reqtotal) then
    begin
     fuelquantity:=ship.qf_max - ship.qf;

    end
    else 
    begin
      if (player.uec > 0) then
      begin
        // fuelquantity:= Trunc(player.uec / fuelprice);
        fuelquantity:= player.uec div fuelprice;
        //CRT_GotoXY(3,6);
        //CRT_Write(strings[63]);
        putStringAt(63,3,6);

      end
      else 
      begin
        fuelquantity:= 0;
        //CRT_GotoXY(6,6);
        //CRT_Write(strings[48]);
        putStringAt(48,6,6);
        CRT_Write(CURRENCY);CRT_Invert(29,6,5);
      end;
    end;
  end;
  // else 
  // begin
  //   fuelquantity:=0;
  // end;

  // recalculate fuel total
  fueltotal:= fuelquantity * fuelprice;

  CRT_WriteRightAligned(0,concat(Atascii2Antic(IntToStr(player.uec)), CURRENCY));

  //CRT_GotoXY(0,0);
  //CRT_Write(strings[38]); // Prod:
  putStringAt(38,0,0);

  CRT_Write(prodmatrix[ship.mcode]);

  //CRT_GotoXY(0,1);
  //CRT_Write(strings[37]); // Name:
  putStringAt(37,0,1);

  CRT_Write(ships[ship.sindex * MAXSHIPPARAMETERS]);

  //CRT_GotoXY(0,2);
  //CRT_Write(strings[39]); // Cargo:
  putStringAt(39,0,2);

  CRT_Write(ship.scu_max);
  // CRT_GotoXY(10,2);
  CRT_Write(CARGOUNIT);

  //CRT_GotoXY(0,3);
  //CRT_Write(strings[59]); // QFuell:
  putStringAt(59,0,3);

  // CRT_Write(Trunc((ship.qf / ship.qf_max) * 100)); CRT_Write(' %'~);
  CRT_Write(ship.qf * 100 div ship.qf_max); CRT_Write(' %'~);
  // CRT_Write(ship.qf);


  //CRT_GotoXY(23,1);
  //CRT_Write(strings[40]); // Price:
  putStringAt(40,23,1);

  CRT_Write(fuelprice);
  CRT_Write(CURRENCY);

  //CRT_GotoXY(23,2);
  //CRT_Write(strings[64]); // Refuel:
  putStringAt(64,23,2);

  CRT_Write(fuelquantity);


  //CRT_GotoXY(23,3);
  //CRT_Write(strings[65]); // Total:
  putStringAt(65,23,3);

  CRT_Write(fueltotal);
  CRT_Write(CURRENCY);

  // Help Keys
  CRT_GotoXY(10,7);
  CRT_Write('RETURN'*~);
  CRT_Write(strings[19]);  // Confirm
  WriteSpace;
  CRT_Write(strings[7]);   // Back


  keyval:= 0;
  repeat

    If (CRT_Keypressed) then
    begin
        CRT_ClearRow(5);
        keyval := kbcode;
        case keyval of
          KEY_BACK:     begin
                          beep255; // vol10
                          current_menu := MENU_MAIN;
                        end;
          KEY_SELECT: begin
                        if not selectPressed and (fuelprice > 0) then
                        begin
                          CRT_ClearRow(6);
                          // CRT_GotoXY(6,6);
                          If (ship.qf < ship.qf_max) then
                          begin
                            beep230; //vol 10
                            if (player.uec  >= reqtotal) then
                            begin
                              player.uec:=player.uec - fueltotal;
                              // player.uec:= newuec;
                              ship.qf:= ship.qf_max;
                              // CRT_GotoXY(6,6);
                              CRT_WriteCentered(6,strings[62]);

                              CRT_GotoXY(6,3);
                              CRT_Write('100 %'~);
                          //     // repeat until CRT_Keypressed;
                          //     // current_menu:=MENU_MAIN;
                            end
                            else
                            begin
                              //not enough UEC, refuel for all credits
                              if (player.uec > 0) then
                              begin
                                ship.qf:= ship.qf + fuelquantity;
                                player.uec:=player.uec - fueltotal;
                                // player.uec:= newuec;

                                // CRT_GotoXY(6,6);
                                CRT_WriteCentered(6,strings[62]);  

                                CRT_GotoXY(6,3);
                                // CRT_Write(Trunc((ship.qf / ship.qf_max) * 100)); CRT_Write(' %'~);
                                CRT_Write(ship.qf * 100 div ship.qf_max); CRT_Write(' %'~);
                            
                              end
                              else
                              begin
                                beep255; // vol10
                                //CRT_GotoXY(6,6);
                                //CRT_Write(strings[48]);
                                putStringAt(48,6,6);

                                CRT_Write(CURRENCY);CRT_Invert(29,6,5)
                              end; 
                            end;
                            // if (newuec > 0) then
                            // begin
                            //   CRT_GotoXY(6,6);
                            //   CRT_Write(strings[62]);
                            // end;
                            // update UEC
                            CRT_WriteRightAligned(0,'                    '~);
                            CRT_WriteRightAligned(0,concat(Atascii2Antic(IntToStr(player.uec)), CURRENCY));
                          end
                          else
                          begin
                            //Message that ship does not need refuel
                            beep255; // vol10
                            // CRT_GotoXY(4,6);
                            CRT_WriteCentered(6,strings[61]);
                          end;
                        end;
                        selectPressed:=true;
                      end;

        end;
    end
    else
    begin
      selectPressed:=false;
    end;

    Waitframe;

  until (keyval = KEY_BACK) or (current_menu = MENU_MAIN);
end;

procedure trade_UpdateSelectedItem(selecteditemquantity:Word;selecteditemtotal:Longword);

begin
  txt:=Atascii2Antic(IntToStr(selecteditemquantity));
  txt:= concat(txt,CARGOUNIT);
  txt:= concat(txt,strings[18]);
  txt:= concat(txt,Atascii2Antic(IntToStr(selecteditemtotal)));
  txt:= concat(txt,CURRENCY);
  CRT_ClearRow(19);
  CRT_WriteRightAligned(19,txt);
end;


procedure trade_UpdateUEC(uec: Longword);

// const
//   LISTSTART = 21;
//   LISTWIDTH = 19;

begin
//    liststart:=(CRT_screenWidth shr 1)+1;
//    listwidth:=CRT_screenWidth-liststart;

  // update player UEC (current session)
  strnum:=IntToStr(uec);
  //CRT_GotoXY(LISTSTART+7,0); // +7 for Sell string
  //WriteSpaces(LISTWIDTH-Length(strnum)-Length(CURRENCY)-7);
  // putSpacesAt(LISTWIDTH-Length(strnum)-Length(CURRENCY)-7,LISTSTART+7,0);
  
  // 19-Length(strnum)-4-7,21+7
  putSpacesAt(12-Length(strnum),24,0);
  CRT_Write(uec);
  CRT_Write(CURRENCY);
end;

procedure trade_UpdateCargo;
// updates Cargo Total in console_trade
const
  LISTSTART = 21;

begin
  //liststart:=(CRT_screenWidth shr 1)+1;
  // update cargo Total
  tstr:=IntToStr(currentship.scu_max-currentship.scu);
  //CRT_GotoXY(LISTSTART-(Length(tstr)+5),6); // -4 as 4 spaces will be drawn
  //CRT_GotoXY(LISTSTART-8,6); // -8 to clear all space right after string Total Cargo
  //WriteSpaces(4); // fixed 4 chars for cargo size
  
  // putSpacesAt(4,LISTSTART-8,6);
  // CRT_GotoXY(LISTSTART-(Length(tstr)+5),6);
  putSpacesAt(4,13,6);
  CRT_GotoXY(26-Length(tstr),6);
  CRT_Write(Atascii2Antic(tstr)); CRT_Write(CARGOUNIT);CRT_Write('|'~);
end;

// procedure switch_modes;
// begin

// end;

// procedure accept_selection;
// begin

// end;

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
  CRT_Write(tstr);
  l:=Length(tstr);

  //CRT_GotoXY(LISTWIDTH-1,0);
  //WriteSpaces(1);
  // putSpacesAt(1,LISTWIDTH-1,0);
  putSpacesAt(1,18,0);
  CRT_Write(strings[8]); // Buy
  WriteSpace;
  // invert at start
  CRT_Invert(18,0,5);

  CRT_WriteRightAligned(concat(Atascii2Antic(IntToStr(currentuec)), CURRENCY));
  //CRT_GotoXY(0,1);
  writeRuler(1);
  //CRT_GotoXY(0,2);
  //CRT_Write(strings[10]);
  putStringAt(10,0,2);
  CRT_Write('  |'~); // Delivery
  CRT_Write(strings[11]); // Available items
  CRT_GotoXY(0,3);
  CRT_Write('[ '~); CRT_Write(ships[currentship.sindex*MAXSHIPPARAMETERS]); CRT_Write(' ]'~);
  // CRT_GotoXY(LISTSTART-2,3);
  CRT_GotoXY(19,3);
  CRT_Write(' |'~);
  CRT_Write(strings[12]);CRT_WriteRightAligned(strings[13]); // commodity price
  //CRT_GotoXY(0,4);
  writeRuler(4);
  //CRT_GotoXY(0,5);
  //CRT_Write(strings[14]); //WriteSpaces(1);
  putStringAt(14,0,5);
  
  tstr:=IntToStr(currentship.scu_max);
  // CRT_GotoXY(LISTSTART-(Length(tstr)+5),5);
  CRT_GotoXY(26-Length(tstr),5);
  CRT_Write(Atascii2Antic(IntToStr(currentship.scu_max))); CRT_Write(CARGOUNIT);CRT_Write('|'~);
  //CRT_GotoXY(0,6);
  //CRT_Write(strings[15]); 
  putStringAt(15,0,6);

  WriteSpace;

  trade_UpdateCargo;

  CRT_GotoXY(0,7);
  // CRT_Write('--------------------+'~);

  for y:=0 to 19 do
    begin
      CRT_Write(Chr(82));  // 18+64 adding 64 for antic mode
    end;
  CRT_Write(Chr(68));    // 4+64
  sfx_play(voice4,77,202); // vol10

  for y:=8 to 17 do
  begin
      // CRT_GotoXY(LISTSTART-1,y);
      CRT_GotoXY(20,y);
      CRT_Write('|'~);
  end;

  //CRT_GotoXY(0,18);
  writeRuler(18);


  // CRT_Write(StringOfChar('-'~,20));
  // CRT_Write('+'~);
  // CRT_Write(StringOfChar('-'~,19));

  // help
  CRT_GotoXY(1,22);
  // txt:=concat(char(30+128),char(31+128));
  // CRT_Write(Atascii2Antic(txt));
  // CRT_Write(Chr(30+128+64)); CRT_Write(Chr(31+128+64)); // character code + 128 for inverse + 64 for antic code
  CRT_Write(Chr(222)); CRT_Write(Chr(223)); // character code + 128 for inverse + 64 for antic code
  CRT_Write('-x1 +'~);
  CRT_Write('CONTROL'*~);
  CRT_Write('-x100 +'~);
  CRT_Write('SHIFT'*~);
  CRT_Write(strings[50]); WriteSpaces(1);
  CRT_Write(strings[16]); //WriteSpaces(1);
  // CRT_Write(strings[17]);



  CRT_GotoXY(3,23);
  CRT_Write('SPACE'*~);
  CRT_Write('-'~);
  CRT_Write(strings[8]);
  CRT_Write('/'~);
  CRT_Write(strings[9]);
  WriteSpace;
  CRT_Write('RETURN'*~);
  CRT_Write(strings[19]);
  WriteSpace;
  CRT_Write(strings[7]);


  ListItems(false);
  ListCargo(false);
  itemindex:=0;

  // assign 1st item on the avaiable items
  currentitemquantity:=itemquantity[availableitems[itemindex]];
  currentitemprice:=GetItemPrice(itemindex,mode);
  currentitemindex:=availableitems[itemindex]-(NUMBEROFITEMS * player.loc);


  repeat
    Waitframe;
    If (CRT_Keypressed) then
    begin
      keyval := kbcode;

      selectitem:= false;
      if (selecteditemquantity < currentitemquantity) then
          if not mode then begin
              if (selecteditemquantity < currentShip.scu_max-currentShip.scu) and
                 (selecteditemtotal + currentitemprice <= currentuec ) then selectitem := true;
          end else // when selling
              if cargoPresent then selectitem:= true;

      case keyval of
        KEY_CANCEL: begin
                      currentuec:= player.uec;
                      currentShip:= ship;
                      mode:= false;

                      //CRT_GotoXY(LISTSTART-3,0);
                      //WriteSpaces(1);
                      // putSpacesAt(1,LISTSTART-3,0);
                      putSpacesAt(1,18,0);
                      CRT_Write(strings[8]); // Buy
                      WriteSpace;WriteSpace;
                      // CRT_Invert(LISTSTART-3,0,5);
                      CRT_Invert(18,0,5);

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
                      beep255; // vol10
                    end;
        KEY_BACK:   begin
                      beep255; // vol10
                      if currentship <> ship then 
                      begin
                        for y:=0 to MAXCARGOSLOTS-1 do
                        begin
                          if currentship.cargoindex[y] > 0 then //if there is a cargo in ship
                          begin
                            offset:= (NUMBEROFITEMS * player.loc) + currentship.cargoindex[y];
                            if currentship.cargoindex[y] = ship.cargoindex[y] then 
                            begin 
                              count:=ship.cargoquantity[y] - currentship.cargoquantity[y];
                              if count > 0 then Inc(itemquantity[offset],count)
                              else Dec(itemquantity[offset],count)
                            end
                            else
                            begin
                              if (ship.cargoindex[y] = 0) then
                              begin
                                // Bought item
                                Dec(itemquantity[offset],currentship.cargoquantity[y]);
                              end
                            end;  
                          end
                          else
                          break;
                        end;

                        for y:=0 to MAXCARGOSLOTS-1 do
                        begin
                          if ship.cargoindex[y] > 0 then //if there is a cargo in ship
                          begin
                            if (ship.cargoindex[y] <> currentship.cargoindex[y]) then
                            begin
                              // Sold item
                              offset:= (NUMBEROFITEMS * player.loc) + ship.cargoindex[y];
                              Inc(itemquantity[offset],ship.cargoquantity[y]);
                            end;  
                          end
                          else
                          break;
                        end;
                        ship:= currentShip;
                      end;


                      player.uec:= currentuec;
                      current_menu := MENU_MAIN;
                      //gfx_fadeout(true);
                    end;
        KEY_UP, KEY_DOWN:
                    begin
                      d:=1;
                      if keyval = KEY_UP then d:=-1;
                      if not mode then
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

                      //if selectitem and (selecteditemquantity < currentShip.scu_max-currentShip.scu) then
                      if selectitem then
                      begin
                        Inc(selecteditemquantity);
                        selecteditemtotal:=selecteditemquantity * currentitemprice;
                      end

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
                      if not mode then   //buying mode
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
                          // selecteditemquantity:=trunc(currentuec / currentitemprice);
                          selecteditemquantity:=currentuec div currentitemprice;
                          if selecteditemquantity > currentShip.scu_max-currentShip.scu then selecteditemquantity:=currentShip.scu_max-currentShip.scu;
//                          selecteditemtotal:=selecteditemquantity * currentitemprice;
                        end;
  //                      else
  //                       CRT_WriteRightAligned(19,strings[??]);
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
                      if not mode then   //buying mode
                      begin
                        if selectitem and (selecteditemquantity < currentShip.scu_max-currentShip.scu) then
                        begin
                          // selecteditemquantity:=trunc(currentuec / currentitemprice);
                          selecteditemquantity:=currentuec div currentitemprice;
                          if selecteditemquantity > currentShip.scu_max-currentShip.scu then
                            selecteditemquantity:=currentShip.scu_max-currentShip.scu;
//                          selecteditemtotal:=selecteditemquantity * currentitemprice;
                        end;
  //                      else
  //                       CRT_WriteRightAligned(19,strings[??]);
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

        KEY_SELECT:
                    begin
                      if not selectPressed then
                      begin
                        if not mode then // buying mode
                        begin
                          if (selecteditemquantity > 0) then
                          begin


                            // CRT_GotoXY(21,10);
                            // CRT_Write('                  '~);
                            // for y:=0 to MAXCARGOSLOTS-1 do
                            // begin
                            //   CRT_GotoXY(21,11+y);
                            //   CRT_Write('cargoindex='~);CRT_Write(currentship.cargoindex[y]);CRT_Write('        '~);
                            // end;


                            beep200; //vol 10
                            for y:=0 to MAXCARGOSLOTS-1 do
                            begin
                              if (currentShip.cargoindex[y] = 0) then
                              begin
                                currentShip.cargoindex[y]:=currentitemindex;
                                currentShip.cargoquantity[y]:=selecteditemquantity;
                                                                
                                // CRT_GotoXY(0,19);
                                // CRT_Write('cur_itemidx='~);CRT_Write(currentitemindex);CRT_Write('           '~);
                                // CRT_GotoXY(0,20);
                                // CRT_Write('selquant='~);CRT_Write(selecteditemquantity);CRT_Write('           '~);

                                // CRT_GotoXY(0,21);
                                // CRT_Write('y='~);CRT_Write(y);CRT_Write('           '~);

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
                            
                            // currentitemindex:=currentShip.cargoindex[itemindex];
                            currentitemindex:=availableitems[itemindex];
                            currentitemquantity:=itemquantity[availableitems[itemindex]];

                            selecteditemquantity:= 0;
                            selecteditemtotal:= 0;
                      //              itemindex:=0;

                            // repeat until CRT_KeyPressed;
                            // CRT_GotoXY(21,10);
                            // CRT_Write('                  '~);
                            // for y:=0 to MAXCARGOSLOTS-1 do
                            // begin
                            //   CRT_GotoXY(21,11+y);
                            //   CRT_Write('cargoindex='~);CRT_Write(currentship.cargoindex[y]);CRT_Write('        '~);
                            // end;


                          end;
                        end
                        else begin // Selling mode
                          if (selecteditemquantity > 0) then
                          begin
                            beep200; //vol 10

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
                    end;

        KEY_BUYSELL:
                    begin
                      if not optionPressed then
                      begin
                        beep200; //vol 10
                        mode:= not mode;
                        CRT_ClearRow(19);
                        if not mode then
                        begin
                          //CRT_GotoXY(LISTSTART-3,0);
                          //WriteSpaces(1);
                          // putSpacesAt(1,LISTSTART-3,0);
                          putSpacesAt(1,18,0);
                          CRT_Write(strings[8]); // Buy
                          WriteSpace;WriteSpace;
                          // CRT_Invert(LISTSTART-3,0,5);
                          CRT_Invert(18,0,5);

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
                          // itemindex:=0;
                        end
                        else begin // selling mode
                          //CRT_GotoXY(LISTSTART-3,0);
                          //WriteSpaces(1);
                          // putSpacesAt(1,LISTSTART-3,0);
                          putSpacesAt(1,18,0);
                          CRT_Write(strings[9]); // Buy
                          WriteSpace;
                          // CRT_Invert(LISTSTART-3,0,6);
                          CRT_Invert(18,0,6);

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
                          // itemindex:=0;
                          // currentitemquantity:=currentShip.cargoquantity[itemindex];
                          // currentitemprice:=GetCargoPrice(itemindex);
                          // currentitemindex:=currentShip.cargoindex[itemindex];
                          cargoPresent:=CheckCargoPresence(itemindex);
                          // selecteditemquantity:=0;

                        end;
                        itemindex:=0;
                        currentitemquantity:=currentShip.cargoquantity[itemindex];
                        currentitemprice:=GetCargoPrice(itemindex);
                        currentitemindex:=currentShip.cargoindex[itemindex];
                        selecteditemquantity:=0;
                        optionPressed:=true;
                      end;
                    end;
      // KEY_OPTION6:
      //               begin
      //                 // putSpacesAt(40,0,21);
      //                 CRT_ClearRow(21);
      //                 CRT_GotoXY(0,21);
      //                 offset:= (NUMBEROFITEMS * player.loc) + currentitemindex;
      //                 CRT_Write('ci_qty='~);CRT_Write(currentitemquantity);WriteSpace;CRT_Write('iq='~);CRT_Write(itemquantity[offset]);WriteSpace;CRT_Write('ci_idx='~);CRT_Write(currentitemindex);
      //               end;            

      end;
      If (keyval = KEY_LEFT) or (keyval = KEY_RIGHT) or (keyval = KEY_CTRLLEFT) or (keyval = KEY_CTRLRIGHT) or
         (keyval = KEY_SHIFTLEFT) or (keyval = KEY_SHIFTRIGHT) then trade_UpdateSelectedItem(selecteditemquantity,selecteditemtotal);
    end
    else 
    begin
      optionPressed:=false;
      selectPressed:=false;
    end;

    // if (CRT_OptionPressed) and (optionPressed=false) then
    // begin
    //   switch_modes;
    // end
    // else
    //   if not CRT_OptionPressed then optionPressed:=false;

    // if (CRT_SelectPressed) then
    // begin
    //   if (selectPressed = false) then
    //   begin
    //     accept_selection;
    //   end;
    //   selectPressed:=true;
    // end
    // else
    //   selectPressed:=false;
    Waitframe;

  until (keyval = KEY_BACK); // or (keyval = KEY_OK);
end;

procedure draw_logo;
begin
  EnableVBLI(@vbl_title);
  EnableDLI(@dli_title1);
  Waitframe;
  DLISTL:= DISPLAY_LIST_ADDRESS_TITLE;

  CRT_ClearRows(0,CRT_screenHeight);
  move(pointer(LOGODATA_ADDRESS), pointer(TXT_ADDRESS), 600);
end;

procedure credits;
var
  a:array[0..0] of string;
  ee: Boolean = false;
  tcount: Byte;
  sign: Byte;
	tab: array [0..255] of byte absolute $BE00;
  add: array [0..255] of byte absolute $BF00;


const
  SHOWTIME = 400;

procedure showArray;
begin
      CRT_ClearRows(15,CRT_screenHeight - 1);
      for y:=0 to 9 do
      begin
        CRT_WriteCentered(y + 15, a[y]);
      end;
end;  

begin
  keyval:= 0;
  
  draw_logo;

  // // help
  CRT_WriteRightAligned(24, strings[7]);
  gfx_fadein;

  count:= 0;
  tcount:= 0;
  
  ee:=true; // temp
  
  // randomize;
  for x:=0 to 255 do begin
    // tab[x]:=peek($d20a);
    // add[x]:=peek($d20a) and 3 + 1;
    tab[x]:=random(255);
    add[x]:=random(255) and 3 + 1;
  end;

  // colpm0:=$0e;
  // pcolr0:=$0e;
  sizep0:=0;
  grafp0:=1;
  

  repeat
    // offset:=32;
    if (count = 0) and (ee = false) then
    begin
        a:=creditstxt;
        showArray;
    end;

    if (count = SHOWTIME) and (ee = false) then
    begin
        a:=thankstxt;
        showArray;
    end;    
    
    if ee then
    begin
      // if ((count mod 16)=0) then
      // begin
      //   // x:= Random(39);
      //   // y:= Random(23);
      //   // sign:=CRT_GetXY(x,y);
      //   // if (sign <> 20) then
      //   // begin
      //   //   Inc(sign);
      //   //   txt[0]:=char(1);
      //   //   txt[1]:=char(sign+64); // add 64 to convert for antic
      //   //   CRT_GotoXY(x,y);
      //   //   CRT_Write(txt);
      //   // end;
        
        
      //   // color2:= COLOR_WHITE;
      //   y:=120; // 3rd row 120/40=3
      //   repeat
      //     for x:=32 to 35 do   //32 to 35 character in a row
      //     begin
      //       sign:=y+x;
      //       poke(TXT_ADDRESS + sign, (peek(TXT_ADDRESS + sign)  xor $80) + 0);
      //     end;
      //     Inc(y,40);
      //   until y>160;  //4th row
      //   // offset:=8;
      // end;
    
      x:=vcount;
      wsync:=0;
      hposp0:=tab[x];
      inc(tab[x], add[x]);
    end;

    if (count = SHOWTIME * 2) then
    begin
       count:= 0;
       Inc(tcount);
    end
    else inc(count);
    if tcount = 5 then ee:= true;


    

    If (CRT_Keypressed) then
    begin
      keyval := kbcode;
      case keyval of
        KEY_BACK:   begin
                      beep255; // vol10
                      current_menu := MENU_TITLE;
                      gfx_fadeout(true);
                    end;
      end;
    end;
    
    Waitframe;
  until (keyval = KEY_BACK);


end;

procedure menu;
// var 
//   shipoffset: Word;

begin
  EnableVBLI(@vbl);
  EnableDLI(@dli1);
  Waitframe;
  DLISTL := DISPLAY_LIST_ADDRESS_MENU;
  // offset for player location colors
  //gfx_fadeout(true);

  // gfx_fadein;
   // gfxcolors[0]:=piccolors[y];
   // gfxcolors[1]:=piccolors[y+1];
   // gfxcolors[2]:=piccolors[y+2];
   // gfxcolors[3]:=piccolors[y+3];

  CRT_ClearRows(0,7);

  //CRT_GotoXY(14,0);
  //CRT_Write(strings[3]); // Navigation
  putStringAt(3,14,0);
  //CRT_GotoXY(14,1);
  //CRT_Write(strings[4]); // Trade
  putStringAt(4,14,1);
  //CRT_GotoXY(14,2);
  //CRT_Write(strings[5]); // Maint
  putStringAt(5,14,2);
  // load ship to be able to check if they are available
  LoadShips;

  // show ship console only when there are ships avaiable (price > 0 for 1st ship at a location)
  offset:=(NUMBEROFSHIPS * player.loc) + availableships[0];
  // offset:=(NUMBEROFLOCATIONS * player.loc) + 12; // check hydrogen

  if shipprices[offset] > 0 then
  begin
    //CRT_GotoXY(14,3);
    //CRT_Write(strings[6]); // Ship Hangar
    putStringAt(6,14,3);

  end;
  //CRT_GotoXY(18,4);
  //CRT_Write(strings[7]); // Back
  putStringAt(7,18,4);



  // count:= 1;
  // CRT_GotoXY(0,1);
  // CRT_Write('name='~);CRT_Write(ships[shipmatrix[count].sindex*MAXSHIPPARAMETERS]);
  // CRT_GotoXY(0,2);
  // CRT_Write('sindex='~);CRT_Write(shipmatrix[count].sindex);
  // CRT_GotoXY(0,3);
  // CRT_Write('scu_max='~);CRT_Write(shipmatrix[count].scu_max);

  // CRT_Write('av_ship[0]='~);CRT_Write(availableships[0]);CRT_Write('|'~);
  // CRT_GotoXY(0,5);
  // CRT_Write('price='~);CRT_Write(shipprices[offset]);

  gfx_fadein;

  keyval:=0;
  repeat
    if CRT_Keypressed then
    begin
      keyval := kbcode;
      case keyval of
        KEY_OPTION1: current_menu:= MENU_NAV;
        KEY_OPTION2: current_menu:= MENU_TRADE;
        KEY_OPTION3: current_menu:= MENU_MAINT;
        // KEY_OPTION3: begin
        //                offset:=(NUMBEROFLOCATIONS * player.loc) + 12; // check hydrogen
        //                if (itemquantity[offset] > 0) then current_menu:= MENU_MAINT
        //                else 
        //                begin
        //                  CRT_GotoXY(0,6);
        //                  CRT_Write(strings[60]);
        //                end;
        //             end;
        KEY_OPTION4: begin
                      // if there is an ship in available ship enable console_ship
                      if (shipprices[offset] > 0) then current_menu := MENU_SHIP;
                     end;
        KEY_BACK:   begin
                      beep255; // vol10
                      current_menu := MENU_TITLE;
                    end;
      end;
    end;
    Waitframe;

  until (keyval = KEY_BACK) or (keyval = KEY_OPTION1) or (keyval = KEY_OPTION2) or (keyval = KEY_OPTION3) or (keyval = KEY_OPTION4);
end;

procedure beepnfade;
begin 
  beep230; //vol 10
  gfx_fadeout(true);
end;

procedure title;

var
  startPressed: Boolean = false;
  musicPressed: Boolean = false;

begin
  startPressed:=false;
  musicPressed:=false;

  gfx_fadeout(true);
  draw_logo;

  y:=15;
  //CRT_GotoXY(16,y);
  //CRT_Write(strings[1]); // New game;
  putStringAt(1,16,y);

  Inc(y);
  if gamestate = GAMEINPROGRESS then
  begin
    //CRT_GotoXY(16,y);
    //CRT_Write(strings[51]); // Continue game;
    putStringAt(51,16,y);

    Inc(y);
    CRT_GotoXY(17,y);
    CRT_Write('1'*~); WriteSpace; CRT_Write(strings[53]); // Load
    Inc(y);
    CRT_GotoXY(17,y);
    CRT_Write('2'*~); WriteSpace; CRT_Write(strings[52]); // Save
    Inc(y);
  end
  else
  begin
    CRT_GotoXY(17,y);
    CRT_Write('1'*~); WriteSpace; CRT_Write(strings[53]); // Load
    Inc(y);
  end;
  //CRT_GotoXY(16,y);
  //CRT_Write(strings[58]);  // Credits
  putStringAt(58,16,y);

  CRT_Invert(17,y,1);
  Inc(y);
  //CRT_GotoXY(18,y);
  //CRT_Write(strings[2]); // Quit;
  putStringAt(2,18,y);


  //CRT_GotoXY(16,CRT_screenHeight - 2);
  //CRT_Write(strings[0]); // copyright
  putStringAt(0,16,CRT_screenHeight - 2);

  DMACTL:=$22; //%00100010;
  // Waitframe;
  gfx_fadein;


  // x:=-2;
  // CRT_GotoXY(0,20);
  // CRT_Write('>'~); putSpacesAt(x,1,20); CRT_Write('<'~);




  //keyval:=chr(0);
  keyval:=0;
  repeat
    if CRT_Keypressed then
    begin
      //keyval := char(CRT_Keycode[kbcode]);
      keyval := kbcode;
      case keyval of
          KEY_NEW:      start;
          KEY_CANCEL:   begin // continue game
                          if gamestate = GAMEINPROGRESS then
                          begin
                            beep255; // vol10
                            current_menu:=MENU_MAIN;
                            gfx_fadeout(true);
                            // pic_load(LOC,player.loc);
                          end;
                        end;
          KEY_OPTION1:  begin
                          //sfx_play(voice4,230,202); //vol 10
                          //gfx_fadeout(true);
                          beepnfade;
                          current_menu:=MENU_LOAD;
                        end;
          KEY_OPTION2:  begin
                          if gamestate = GAMEINPROGRESS then
                          begin
                            //sfx_play(voice4,230,202); //vol 10
                            //gfx_fadeout(true);
                            beepnfade;
                            current_menu:=MENU_SAVE;
                          end;  
                        end;
          KEY_CREDITS:  begin
                          //sfx_play(voice4,230,202); //vol 10
                          //gfx_fadeout(true);
                          beepnfade;
                          current_menu:=MENU_CREDITS;
                        end;
          KEY_JUMP:   begin
                        if not musicPressed then
                        begin
                          if disablemusic then
                          begin
                            msx.stop;
                            music:= false;
                            // disablemusic:=true;
                          end 
                          else
                          begin
                            msx.init;
                            music:= true;
                            // disablemusic:=false
                          end;
                          disablemusic:= not disablemusic;
                          musicPressed:= true;
                        end; 
                      end;
(*
          // KEY_OPTION1: sfx_play(185,16*12+4);
          // KEY_OPTION2: sfx_play(110,16*12+4);
          // KEY_OPTION3: sfx_play(60,16*12+4);
          // KEY_OPTION4: sfx_play(20,16*12+4);
          // KEY_OPTION5: sfx_play(10,16*12+4);
          // KEY_OPTION6: sfx_play(5,16*12+4);
*)

      end;
    end
    else
    begin
      musicPressed:=false;
    end;

    If CRT_StartPressed and not startPressed then
    begin
      startPressed:=true;
      start;
    end;

    Waitframe;

  until (keyval = KEY_QUIT) or (keyval = KEY_NEW) or startPressed or (keyval = KEY_CANCEL) or ((keyval = KEY_OPTION2) and (gamestate = GAMEINPROGRESS)) or (keyval = KEY_OPTION1) or (keyval = KEY_CREDITS);
end;

procedure writeStatus(x,snum1,snum2,snum3:byte);
begin
    //CRT_GotoXY(x,20);
    //CRT_Write(strings[snum1]);
    putStringAt(snum1,x,21);
    CRT_Write(strings[snum2]);CRT_Invert(x-1,21,CRT_WhereX-x+1);
    CRT_Write('.'~*);CRT_Write(strings[snum3]);
end;

procedure disk_save(num: Byte);
begin
  tstr:='SLOT';
  tstr:=concat(tstr,IntToStr(num));
  tstr:=concat(tstr,'   SAV');
  if (xBiosCheck <> 0) then
  begin
    xBiosOpenFile(tstr);

    if (xBiosIOresult = 0) then
    begin
      xBiosSetLength(60); // 5+15+20+20
      xBiosWriteData(@player);
      xBiosWriteData(@ship);
      if (xBiosIOresult = 0) then
      begin
        //CRT_GotoXY(5,20); // success
        //CRT_Write('Save Successfull. Press any key'~);
        writeStatus(5,52,56,26);
        //CRT_Write(strings[52]);CRT_Write(strings[56]);CRT_Write('.'~*);CRT_Write(strings[26]);
      end
      else
      begin
        //CRT_GotoXY(7,20); // error
        //CRT_WriteXY(0,5,'Save error. Press any key'~);
        writeStatus(7,52,55,26);
        //CRT_Write(strings[52]);CRT_Write(strings[55]);CRT_Write('.'~*);CRT_Write(strings[26]);
      end;
      xBiosFlushBuffer;
    end
    else
    begin
      //CRT_GotoXY(5,20); // error opening
      //CRT_WriteXY(0,5,'Open file error. Press any key'~*);
      writeStatus(5,57,55,26);
      //CRT_Write(strings[57]);CRT_Write(strings[55]);CRT_Write('.'~*);CRT_Write(strings[26]);
    end;
    repeat until CRT_Keypressed;
  end;
end;

procedure disk_load(num: Byte);
begin
  tstr:='SLOT';
  tstr:=concat(tstr,IntToStr(num));
  tstr:=concat(tstr,'   SAV');
  if (xBiosCheck <> 0) then
  begin
    xBiosOpenFile(tstr);

    if (xBiosIOresult = 0) then
    begin
      xBiosSetLength(60); // 5+15+20+20 both variable size ( all in records)
      xBiosLoadData(@player);
      xBiosLoadData(@ship);
      if (xBiosIOresult = 0) then
      begin
        //CRT_GotoXY(5,20); // success
        writeStatus(5,53,56,26);
        //CRT_Write(strings[53]);CRT_Write(strings[56]);CRT_Write('.'~*);CRT_Write(strings[26]);
      end
      else
      begin
        //CRT_GotoXY(7,20); // error
        writeStatus(7,53,55,26);
        //CRT_Write(strings[53]);CRT_Write(strings[55]);CRT_Write('.'~*);CRT_Write(strings[26]);
      end;
      xBiosFlushBuffer;
    end
    else
    begin
      //CRT_GotoXY(5,20); // error opening
      writeStatus(5,57,55,26);
      //CRT_Write(strings[57]);CRT_Write(strings[55]);CRT_Write('.'~*);CRT_Write(strings[26]);
    end;

    repeat until CRT_Keypressed;
  end;
end;

procedure menu_save_load(mode: Boolean);

const LOGOSIZE = 15;
var
  slot, oldslot : Byte;
  selectPressed: Boolean = false;

procedure setSlot(snum:byte);
begin
    oldslot:=slot;
    slot:=snum;
    beep230; //vol 10
end;

begin
  CRT_ClearRows(15,CRT_screenHeight);


  if mode then txt:=strings[52]  // save mode
  else txt:=strings[53];          // load mode

  //CRT_GotoXY(10,LOGOSIZE);
  //WriteSpaces(8);
  putSpacesAt(8,10,LOGOSIZE);
  CRT_Write(txt);WriteSpaces(8); // Save
  CRT_Invert(10,LOGOSIZE,Length(txt)+16); // plus all 16 spaces
  txt:=strings[54];
  count:=Length(txt);
  for y:=1 to 5 do
  begin
    //CRT_GotoXY(14,y + LOGOSIZE);
    //WriteSpaces(3);
    putSpacesAt(3,14,y + LOGOSIZE);
    CRT_Write(txt);CRT_Write(y);WriteSpaces(3);
  end;

  // Help Keys
  CRT_GotoXY(0,CRT_screenHeight - 2);
  CRT_Write('1-5'*~); // Navigation options
  putStringAt(23,3,CRT_screenHeight - 2);
  WriteSpace;
  CRT_Write('RETURN'*~);
  CRT_Write(strings[19]);  // Confirm
  WriteSpace;
  CRT_Write(strings[7]); // Back


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
                          beep255; // vol10
                          current_menu := MENU_TITLE;
                        end;
          KEY_OPTION1:  begin
                          //oldslot:=slot;
                          //slot:=1;
                          //sfx_play(voice4,230,202); //vol 10
                          setSlot(1);
                         end;
          KEY_OPTION2:  begin
                          //oldslot:=slot;
                          //slot:=2;
                          //sfx_play(voice4,230,202); //vol 10
                          setSlot(2);
                        end;
          KEY_OPTION3:  begin
                          //oldslot:=slot;
                          //slot:=3;
                          //sfx_play(voice4,230,202); //vol 10
                          setSlot(3);
                        end;
          KEY_OPTION4:  begin
                          //oldslot:=slot;
                          //slot:=4;
                          //sfx_play(voice4,230,202); //vol 10
                          setSlot(4);
                        end;
          KEY_OPTION5:  begin
                          //oldslot:=slot;
                          //slot:=5;
                          //sfx_play(voice4,230,202); //vol 10
                          setSlot(5);
                        end;
          KEY_SELECT:   begin
                          if (slot > 0 ) and not selectPressed then
                          begin
                            beep200; //vol 10
                            if mode then disk_save(slot)
                            else disk_load(slot);
                            sfx_init;
                            current_menu:=MENU_TITLE;
                          end;
                          selectPressed:= true;
                        end;

        end;
        
        if (slot > 0) then
        begin
          If (oldslot > 0) then CRT_Invert(14,oldslot + LOGOSIZE,count+8);
          CRT_Invert(14,slot + LOGOSIZE,count+8);
        end;
    end
    else
    begin
      selectPressed:=false;
    end;
    Waitframe;

  until (keyval = KEY_BACK) or (current_menu=MENU_TITLE);
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

  //player.loc:=STARTLOCATION; //start location Port Olisar

  msx.player:=pointer(PLAYER_ADDRESS);
  msx.modul:=pointer(MODULE_ADDRESS);
  msx.init;
  
  disablemusic:= false;
  sfx_init;
  music:= true;

  // load ships data into an array of records.
  for y:=0 to NUMBEROFSHIPS-1 do
  begin
    offset:=(y * MAXSHIPPARAMETERS);
    tshp:=shipmatrix[y];
    tshp^.mcode:=StrToInt(ships[offset+1]);
    tshp^.sindex:=y;
    tshp^.scu_max:=StrToInt(ships[offset+2]);
    tshp^.speed:=StrToInt(ships[offset+3]);
    tshp^.lenght:=StrToInt(ships[offset+4]);
    tshp^.mass:=StrToInt(ships[offset+5]);
    tshp^.qf_max:=StrToInt(ships[offset+6]);
    tshp^.swait:=StrToInt(ships[offset+7]);
  end;

  gamestate:= NEWGAME;
  current_menu := MENU_TITLE;

  repeat
    case current_menu of
      MENU_TITLE: title;
      MENU_MAIN:  menu;
      MENU_NAV:   console_navigation;
      MENU_TRADE: console_trade;
      MENU_MAINT: console_maint;
      MENU_SHIP:  console_ship;
      MENU_SAVE:  menu_save_load(true);
      MENU_LOAD:  menu_save_load(false);
      MENU_CREDITS: credits;
    end;
    repeat Waitframe until not CRT_Keypressed;

  until keyval = KEY_QUIT;

  DisableDLI;
  DisableVBLI;
  // restore system
  SystemReset;
end.
