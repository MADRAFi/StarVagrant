{$librarypath '../../MADS/lib/'}
{$librarypath '../../MADS/base/'}
{$librarypath '../../MADS/blibs/'}
uses atari, b_utils, b_system, b_crt, sysutils, cmc;

const
{$i const.inc}

{$r resources.rc}

var
  gfxcolors: array [0..3] of Byte = (
    $10,$14,$1a,$00
  );
  piccolors: array [0..3] of Byte = (
    $10,$14,$1a,$00
  );
  strings: array [0..0] of Word absolute STRINGS_ADDRESS;
  msx: TCMC;
  txt: String;



{$i interrupts.inc}

procedure fadeoff;
begin
    repeat
  //    Delay(50);
      pause;pause;
      If (color2 and %00001111 <> 0) then Dec(color2) else color2:=0;
      If (color1 and %00001111 <> 0) then Dec(color1) else color1:=0;
    until (color1 or color2) = 0;
     //  If (colpf2 and %00001111 <> 0) then Dec(colpf2) else colpf2:=0;
     //  If (colpf1 and %00001111 <> 0) then Dec(colpf1) else colpf1:=0;
     // until (colpf1 or colpf2) = 0;
end;

procedure gfx_fadein;

begin
  gfxcolors[0]:=0;
  gfxcolors[1]:=0;
  gfxcolors[2]:=0;
  gfxcolors[3]:=0;

  repeat
    Waitframes(2);
    If (gfxcolors[0] and %00001111 < piccolors[0] and %00001111 ) then Inc(gfxcolors[0]) else gfxcolors[0]:=piccolors[0];
    If (gfxcolors[1] and %00001111 < piccolors[1] and %00001111) then Inc(gfxcolors[1]) else gfxcolors[1]:=piccolors[1];
    If (gfxcolors[2] and %00001111 < piccolors[2] and %00001111) then Inc(gfxcolors[2]) else gfxcolors[2]:=piccolors[2];
    If (gfxcolors[3] and %00001111 < piccolors[3] and %00001111) then Inc(gfxcolors[3]) else gfxcolors[3]:=piccolors[3];

      // If (txtcolors[0] and %00001111 < 0 and %00001111) then inc(txtcolors[0]) else txtcolors[0]:=0;
      // If (txtcolors[1] and %00001111 < $1c and %00001111) then inc(txtcolors[1]) else txtcolors[1]:=$1c;

  until (gfxcolors[0]=piccolors[0]) and (gfxcolors[1]=piccolors[1]) and (gfxcolors[2]=piccolors[2]) and (gfxcolors[3]=piccolors[3]);
end;

procedure gfx_fadeout; //(hidetext: Boolean);
begin

  repeat
    Waitframes(2);
    If (gfxcolors[0] and %00001111 <> 0) then Dec(gfxcolors[0]) else gfxcolors[0]:=0;
    If (gfxcolors[1] and %00001111 <> 0) then Dec(gfxcolors[1]) else gfxcolors[1]:=0;
    If (gfxcolors[2] and %00001111 <> 0) then Dec(gfxcolors[2]) else gfxcolors[2]:=0;
    If (gfxcolors[3] and %00001111 <> 0) then Dec(gfxcolors[3]) else gfxcolors[3]:=0;
    // If hidetext then
    // begin
    //   If (txtcolors[0] and %00001111 <> 0) then Dec(txtcolors[0]) else txtcolors[0]:=0;
    //   If (txtcolors[1] and %00001111 <> 0) then Dec(txtcolors[1]) else txtcolors[1]:=0;
    // end;
  //until (gfxcolors[0] or gfxcolors[1] or gfxcolors[2] or gfxcolors[3] or txtcolors[0] or txtcolors[1]) = 0;
  until (gfxcolors[0] or gfxcolors[1] or gfxcolors[2] or gfxcolors[3]) = 0;
  waitframes(10);
end;

function extendNibble(n:byte):byte;
var bit,colorMask,testMask:byte;
begin
    colorMask:=%11;
    testMask:=1;
    result:=0;
    for bit:=0 to 3 do begin
        if n and testMask <> 0 then result:=result or colorMask;
        testMask:=testMask shl 1;
        colorMask:=colorMask shl 2;
    end;
end;

procedure putChar(dest:Word; onechar:Byte);
var src: Word;
    nib1, nib2 : Byte;
    x: Byte;
    bsrc: Byte;
    res: Word;

begin
    src:=CHARSET_ADDRESS + (onechar) * 8;
    for x:=0 to 7 do begin
        bsrc:=Peek(src);
        nib1:= extendNibble(bsrc and %00001111);
        nib2:= extendNibble(bsrc shr 4);
        res:=nib1 * 256 + nib2;
        DPoke(dest, res);
        Inc(src);
        Inc(dest,40);
    end;
end;

procedure putString(x,y: Byte; text: String);
var
  mem: Word;
  i: Byte;

  tmem: Word;
  tstr: String;

begin
  mem:=GFX_ADDRESS + word(y * 320) + (x * 2); // 40 is screen size in bytes
  tmem:= GFX_ADDRESS;
  tstr:=Atascii2Antic(InttoStr(mem));
  for i:=1 to tstr[0] do
    begin
      putChar(tmem, Ord(tstr[i]));
      Inc(tmem,2);
    end;

  for i:=1 to text[0] do
    begin
      putChar(mem, Ord(text[i]));
      Inc(mem,2);
    end;
end;

begin
  //CursorOff;
  //clrscr;

  // old_dli:=pointer(0);
  // old_vbl:=pointer(0);


  //fadeoff;
//  GetIntVec(iDLI, old_dli);
//  GetIntVec(iVBL, old_vbl);
//  repeat until keypressed;

//  SetIntVec(iDLI, @dli_title1);
//  SetIntVec(iVBL, @vbl_title);
//  nmien:=$c0;

  //SDLSTL:= DISPLAY_LIST_ADDRESS_TITLE;
  fadeoff;
  SystemOff;
  SetCharset (Hi(CHARSET_ADDRESS)); // when system is off
  //CRT_Init(GFX_ADDRESS);

  EnableVBLI(@vbl_title);
  EnableDLI(@dli_title1);
  Waitframe;
  DLISTL := DISPLAY_LIST_ADDRESS_TITLE;

  // Initialize player
  // msx.player:=pointer(RMT_PLAYER_ADDRESS);
  // msx.modul:=pointer(RMT_MODULE_ADDRESS);
  // msx.init(0);
  msx.player:=pointer(CMC_PLAYER_ADDRESS);
  msx.modul:=pointer(CMC_MODULE_ADDRESS);
  msx.init;

  // waitframes(50);
  // txt:=FFTermToString(strings[0]);
  // putString(0,140,txt);
  // gfx_fadein;
  // waitframes(100);
  //
  // gfx_fadeout;
  // fillbyte(dest,word(txt[0]),0);
  // txt:=FFTermToString(strings[1]);
  // putString(0,140,txt);
  // gfx_fadein;
  // waitframes(100);
  //
  // gfx_fadeout;
  // fillbyte(dest,word(txt[0]),$0);
  // txt:=FFTermToString(strings[2]);
  // putString(0,140,txt);
  // gfx_fadein;
  // waitframes(100);
  //
  // gfx_fadeout;
  // fillbyte(dest,word(txt[0]),0);
  // txt:=FFTermToString(strings[3]);
  // putString(0,140,txt);
  // gfx_fadein;
  // waitframes(100);

  gfx_fadeout;
  putString(0,0,'                    '~);
  // txt:=FFTermToString(strings[4]);
  // putString(0,140,txt);
  putString(0,5,'Ala ma kota'~);
  gfx_fadein;
  waitframes(255);

  gfx_fadeout;
  putString(0,5,'                    '~);
  txt:=FFTermToString(strings[6]);
  putString(0,6,txt);
  gfx_fadein;
  // waitframes(300);

  repeat
    waitframe;
    msx.play;
  until CRT_keypressed;
  msx.stop;
  DisableDLI;
  DisableVBLI;
  nmien:=0;
  Dmactl:= 0;
  asm {
      clc
      rts
  };

end.
