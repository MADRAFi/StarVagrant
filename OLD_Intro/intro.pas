{$librarypath '../../MADS/lib/'}
{$librarypath '../../MADS/base/'}
{$librarypath '../../MADS/blibs/'}
uses atari, b_utils, b_system, b_crt, sysutils, cmc;

const
{$i const.inc}

{$r resources.rc}

var
  gfxcolors: array [0..3] of Byte = (
   // $10,$14,$1a,$00
   $04,$0a,$0e,$00
  );
  piccolors: array [0..3] of Byte = (
    $04,$0a,$0e,$00
    // $0e,$04,$0c,$00
  );
  // strings: array [0..0] of Word absolute STRINGS_ADDRESS;
  msx: TCMC;
  // txt: String;
  line: Word;
  skip: Boolean;
  music: Boolean;
  count: Word;

{$i strings.inc}

{$i interrupts.inc}

// procedure fadeoff;
// begin
//     repeat
//   //    Delay(50);
//       pause;pause;
//       If (color2 and %00001111 <> 0) then Dec(color2) else color2:=0;
//       If (color1 and %00001111 <> 0) then Dec(color1) else color1:=0;
//     until (color1 or color2) = 0;
//      //  If (colpf2 and %00001111 <> 0) then Dec(colpf2) else colpf2:=0;
//      //  If (colpf1 and %00001111 <> 0) then Dec(colpf1) else colpf1:=0;
//      // until (colpf1 or colpf2) = 0;
// end;

procedure gfx_fadein;

begin
  count:=0;
  repeat
    Waitframes(2);
    If (gfxcolors[0] and %00001111 <> piccolors[0] and %00001111) then Inc(gfxcolors[0]) else gfxcolors[0]:=piccolors[0];
    If (gfxcolors[1] and %00001111 <> piccolors[1] and %00001111) then Inc(gfxcolors[1]) else gfxcolors[1]:=piccolors[1];
    If (gfxcolors[2] and %00001111 <> piccolors[2] and %00001111) then Inc(gfxcolors[2]) else gfxcolors[2]:=piccolors[2];
    If (gfxcolors[3] and %00001111 <> piccolors[3] and %00001111) then Inc(gfxcolors[3]) else gfxcolors[3]:=piccolors[3];
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
  // waitframes(10);
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

  // tmem: Word;
  // tstr: String;

begin
  mem:=GFX_ADDRESS + (y * 320) + (x * 2); // 40 is screen size in bytes

  for i:=1 to text[0] do
    begin
      putChar(mem, Ord(text[i]));
      Inc(mem,2);
    end;
end;

begin
  //fadeoff;
  SystemOff;

  // Initialize player
  // msx.player:=pointer(PLAYER_ADDRESS);
  // msx.modul:=pointer(MODULE_ADDRESS);
  // msx.init(0);
  msx.player:=pointer(PLAYER_ADDRESS);
  msx.modul:=pointer(MODULE_ADDRESS);
  msx.init;

  skip:= false;
  music:= true;

  // clear gfx memory
  fillbyte(pointer(GFX_ADDRESS), 7684, 0);
  SetCharset (Hi(CHARSET_ADDRESS)); // when system is off
  //CRT_Init(GFX_ADDRESS);

  VDSLST:=Word(@DLI_TITLE1);
  EnableVBLI(@vbl_title);
  EnableDLI(@dli_title1);
  Waitframe;
  DLISTL:= DISPLAY_LIST_ADDRESS_TITLE;
  DMACTL:=$22; //%00100010;
  
  // if skip = false then waitframes(150);
  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if CRT_Keypressed then skip:= true;
  until skip or (count > 300);

  if skip = false then begin
    gfx_fadeout;
    putString(0,20,strings[0]);
    gfx_fadein;
  end;

  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if CRT_Keypressed then skip:= true;
  until skip or (count > 450);


  if skip = false then begin
    gfx_fadeout;
    // putString(0,20,'                    '~);
    // putString(0,21,'                    '~);
    putString(0,20,strings[1]);
    putString(0,21,strings[2]);
    gfx_fadein;
  end;

  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if CRT_Keypressed then skip:= true;
  until skip or (count > 450);

  if skip = false then begin
    gfx_fadeout;
    move(pointer(PIC1_ADDRESS), pointer(GFX_ADDRESS), 7684);
    // putString(0,20,'                    '~);
    // putString(0,21,'                    '~);
    // // line:=GFX_ADDRESS + word(20 * 40 * 8)-(40*2) + (0 * 2);
    // // 20 - y, 40 - screen size,  8 char size, 2 - 2 line before, 0 - x
    line:=GFX_ADDRESS + 6320;
    fillbyte(pointer(line), 80, 0); // 2 lines before
    putString(0,20,strings[3]);
    putString(0,21,strings[4]);
    line:=GFX_ADDRESS + 7040;  // 22 * 40 * 8 - next line after text
    fillbyte(pointer(line), 80, 0); // 2 lines after
    gfx_fadein;
  end;

  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if CRT_Keypressed then skip:= true;
  until skip or (count > 450);

  if skip = false then begin
    // putString(0,20,'                    '~);
    // putString(0,21,'                    '~);
    line:=GFX_ADDRESS + 6320;
    fillbyte(pointer(line), 80, 0);
    putString(0,20,strings[5]);
    putString(0,21,strings[6]);
    line:=GFX_ADDRESS + 7040;
    fillbyte(pointer(line), 80, 0);
  end;

  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if CRT_Keypressed then skip:= true;
  until skip or (count > 450);

  if skip = false then begin
    gfx_fadeout;
    move(pointer(PIC2_ADDRESS), pointer(GFX_ADDRESS), 7684);
    // putString(0,20,'                    '~);
    // putString(0,21,'                    '~);
    line:=GFX_ADDRESS + 6320;
    fillbyte(pointer(line), 80, 0);
    putString(0,20,strings[7]);
    putString(0,21,strings[8]);
    line:=GFX_ADDRESS + 7040;
    fillbyte(pointer(line), 80, 0);
    gfx_fadein;
  end;
  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if CRT_Keypressed then skip:= true;
  until (skip = true) or (count > 450);

  if skip = false then begin
    // putString(0,20,'                    '~);
    // putString(0,21,'                    '~);
    line:=GFX_ADDRESS + 6320;
    fillbyte(pointer(line), 80, 0);
    putString(0,20,strings[9]);
    putString(0,21,strings[10]);
    putString(0,22,strings[11]);
    line:=GFX_ADDRESS + 7360;
    fillbyte(pointer(line), 80, 0);
  end;

  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if CRT_Keypressed then skip:= true;
  until skip or (count > 450);

  if skip = false then begin
    gfx_fadeout;
    move(pointer(PIC3_ADDRESS), pointer(GFX_ADDRESS), 7684);
    // putString(0,20,'                    '~);
    // putString(0,21,'                    '~);
    line:=GFX_ADDRESS + 6320;
    fillbyte(pointer(line), 80, 0);
    putString(0,20,strings[12]);
    putString(0,21,strings[13]);
    line:=GFX_ADDRESS + 7040;
    fillbyte(pointer(line), 80, 0);
    gfx_fadein;
  end;

  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if CRT_Keypressed then skip:= true;
  until skip or (count > 450);

  if skip = false then begin
    // putString(0,20,'                    '~);
    // putString(0,21,'                    '~);
    line:=GFX_ADDRESS + 6320;
    fillbyte(pointer(line), 80, 0);
    putString(0,20,strings[14]);
    putString(0,21,strings[15]);
    putString(0,22,strings[16]);
    line:=GFX_ADDRESS + 7360;
    fillbyte(pointer(line), 80, 0);
  end;

  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if CRT_Keypressed then skip:= true;
  until skip or (count > 450);

  if skip = false then begin
    gfx_fadeout;
    // putString(0,22,'                    '~);
    fillbyte(pointer(GFX_ADDRESS), 7684, 0);
    // putString(0,20,'                    '~);
    // putString(0,21,'                    '~);
    putString(0,20,strings[17]);
    putString(0,21,strings[18]);
    gfx_fadein;
  end;

  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if CRT_Keypressed then skip:= true;
  until skip or (count > 450);

  gfx_fadeout;  
  music:= false;
  waitframe;
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
