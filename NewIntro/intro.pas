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

  piccolors: array [0..(4*NUMBEROFPICS)-1] of Byte = (
    $74,$36,$fc,$00,   // 0
    $84,$88,$0e,$00,   // 1
    $24,$1a,$0e,$00,   // 2
    $90,$96,$9c,$00    // 3    
  );
  
  txtcolors : array [0..1] of Byte = (
    $00,$00
  );
  // strings: array [0..0] of Word absolute STRINGS_ADDRESS;
  msx: TCMC;
  // txt: String;
  picnumber: Byte; //count from 0
  y: Byte;
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
const
  TEXTCOLOR1 = $00;
  TEXTCOLOR2 = $1c;

begin
  y:= (picnumber - 1) shl 2;
  repeat
    Waitframes(2);
    If (gfxcolors[0] and %00001111 <> piccolors[y] and %00001111) then Inc(gfxcolors[0]) else gfxcolors[0]:=piccolors[y];
    If (gfxcolors[1] and %00001111 <> piccolors[y+1] and %00001111) then Inc(gfxcolors[1]) else gfxcolors[1]:=piccolors[y+1];
    If (gfxcolors[2] and %00001111 <> piccolors[y+2] and %00001111) then Inc(gfxcolors[2]) else gfxcolors[2]:=piccolors[y+2];
    If (gfxcolors[3] and %00001111 <> piccolors[y+3] and %00001111) then Inc(gfxcolors[3]) else gfxcolors[3]:=piccolors[y+3];

    If (txtcolors[0] and %00001111 <> TEXTCOLOR1 and %00001111) then Inc(txtcolors[0]) else txtcolors[0]:=TEXTCOLOR1;
    If (txtcolors[1] and %00001111 <> TEXTCOLOR2 and %00001111) then Inc(txtcolors[1]) else txtcolors[1]:=TEXTCOLOR2;

  until (gfxcolors[0]=piccolors[y]) and (gfxcolors[1]=piccolors[y+1]) and (gfxcolors[2]=piccolors[y+2]) and (gfxcolors[3]=piccolors[y+3]) and (txtcolors[0]=TEXTCOLOR1) and (txtcolors[1]=TEXTCOLOR2);
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
      If (txtcolors[0] and %00001111 <> 0) then Dec(txtcolors[0]) else txtcolors[0]:=0;
      If (txtcolors[1] and %00001111 <> 0) then Dec(txtcolors[1]) else txtcolors[1]:=0;
    // end;
  until (gfxcolors[0] or gfxcolors[1] or gfxcolors[2] or gfxcolors[3] or txtcolors[0] or txtcolors[1]) = 0;
  // until (gfxcolors[0] or gfxcolors[1] or gfxcolors[2] or gfxcolors[3]) = 0;

end;

begin
  //fadeoff;
  SystemOff;

  // Initialize player
  msx.player:=pointer(PLAYER_ADDRESS);
  msx.modul:=pointer(MODULE_ADDRESS);
  msx.init;
  // msx.init(0);

  skip:= false;
  music:= true;

  // clear screen memory
  // fillbyte(pointer(TXT_ADDRESS), 1200, 0);
  // SetCharset (Hi(CHARSET_ADDRESS)); // when system is off
  

  // VDSLST:=Word(@DLI_TITLE);
  // EnableVBLI(@vbl_title);
  // EnableDLI(@dli_title);
  // Waitframe;
  // DLISTL:= DISPLAY_LIST_ADDRESS_TITLE;
  DMACTL:=$22; //%00100010;
  
  // CRT_Init(TXT_ADDRESS);

  // count:= 0;
  // repeat 
  //   inc(count);
  //   waitframe;
  //   if CRT_Keypressed then skip:= true;
  // until skip or (count > 300);

  // if skip = false then begin
  //   gfx_fadeout;
  //   CRT_GotoXY(0,24);
  //   CRT_Write(strings[0]);
  //   gfx_fadein;
  // end;

  // count:= 0;
  // repeat 
  //   inc(count);
  //   waitframe;
  //   if CRT_Keypressed then skip:= true;
  // until skip or (count > 450);


  // if skip = false then begin
  //   gfx_fadeout;
  //   CRT_ClearRow(24);
  //   CRT_WriteXY(0,24, strings[1]);
  //   CRT_WriteXY(0,25, strings[2]);
  //   gfx_fadein;
  // end;

  // count:= 0;
  // repeat 
  //   inc(count);
  //   waitframe;
  //   if CRT_Keypressed then skip:= true;
  // until skip or (count > 450);

  if skip = false then begin
    gfx_fadeout;
    picnumber:=1;
    move(pointer(SCREEN_ADDRESS_PIC1), pointer(TXT_ADDRESS), 1200);

    VDSLST:=Word(@dli_pic1_f1);
    EnableVBLI(@vbl_pic);
    EnableDLI(@dli_pic1_f1);
    Waitframe;
    DLISTL:= DISPLAY_LIST_ADDRESS_PIC1;
    DMACTL:=$22; //%00100010;


    // DMACTL:=$22; //%00100010;  

    // CRT_ClearRow(24);
    // CRT_ClearRow(25);
    // CRT_ClearRow(26);
    // CRT_WriteXY(0,24, strings[3]);
    // CRT_WriteXY(0,25, strings[4]);
    gfx_fadein;
  end;

  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if CRT_Keypressed then skip:= true;
  until skip or (count > 450);

  // if skip = false then begin
    // CRT_ClearRow(24);
    // CRT_ClearRow(25);
    // CRT_ClearRow(26);
    // CRT_WriteXY(0,24, strings[5]);
    // CRT_WriteXY(0,25, strings[6]);
  // end;

  // count:= 0;
  // repeat 
  //   inc(count);
  //   waitframe;
  //   if CRT_Keypressed then skip:= true;
  // until skip or (count > 450);

  if skip = false then begin
    gfx_fadeout;
    picnumber:=2;
    fillbyte(pointer(TXT_ADDRESS), 1320, 0);
    move(pointer(SCREEN_ADDRESS_PIC1), pointer(TXT_ADDRESS), 1200);

    // VDSLST:=Word(@dli_pic2_f1);
    // EnableVBLI(@vbl_pic);
    // EnableDLI(@dli_pic2_f1);
    // Waitframe;
    // DLISTL:= DISPLAY_LIST_ADDRESS_PIC2;
    VDSLST:=Word(@dli_title);
    EnableVBLI(@vbl_pic);
    EnableDLI(@dli_title);
    Waitframe;
    DLISTL:= DISPLAY_LIST_ADDRESS_TITLE;
    DMACTL:=$22; //%00100010;
    // CRT_ClearRow(24);
    // CRT_ClearRow(25);
    // CRT_ClearRow(26);
    // CRT_WriteXY(0,24, strings[7]);
    // CRT_WriteXY(0,25, strings[8]);

    gfx_fadein;
  end;

  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if CRT_Keypressed then skip:= true;
  until (skip = true) or (count > 450);

  // if skip = false then begin
  //   // putString(0,20,'                    '~);
  //   // putString(0,21,'                    '~);
  //   line:=GFX_ADDRESS + 6320;
  //   fillbyte(pointer(line), 80, 0);
  //   putString(0,20,strings[9]);
  //   putString(0,21,strings[10]);
  //   putString(0,22,strings[11]);
  //   line:=GFX_ADDRESS + 7360;
  //   fillbyte(pointer(line), 80, 0);
  // end;

  // count:= 0;
  // repeat 
  //   inc(count);
  //   waitframe;
  //   if CRT_Keypressed then skip:= true;
  // until skip or (count > 450);

  // if skip = false then begin
  //   gfx_fadeout;
  //   move(pointer(PIC3_ADDRESS), pointer(GFX_ADDRESS), 7684);
  //   // putString(0,20,'                    '~);
  //   // putString(0,21,'                    '~);
  //   line:=GFX_ADDRESS + 6320;
  //   fillbyte(pointer(line), 80, 0);
  //   putString(0,20,strings[12]);
  //   putString(0,21,strings[13]);
  //   line:=GFX_ADDRESS + 7040;
  //   fillbyte(pointer(line), 80, 0);
  //   gfx_fadein;
  // end;

  // count:= 0;
  // repeat 
  //   inc(count);
  //   waitframe;
  //   if CRT_Keypressed then skip:= true;
  // until skip or (count > 450);

  // if skip = false then begin
  //   // putString(0,20,'                    '~);
  //   // putString(0,21,'                    '~);
  //   line:=GFX_ADDRESS + 6320;
  //   fillbyte(pointer(line), 80, 0);
  //   putString(0,20,strings[14]);
  //   putString(0,21,strings[15]);
  //   putString(0,22,strings[16]);
  //   line:=GFX_ADDRESS + 7360;
  //   fillbyte(pointer(line), 80, 0);
  // end;

  // count:= 0;
  // repeat 
  //   inc(count);
  //   waitframe;
  //   if CRT_Keypressed then skip:= true;
  // until skip or (count > 450);

  // if skip = false then begin
  //   gfx_fadeout;
  //   // putString(0,22,'                    '~);
  //   fillbyte(pointer(GFX_ADDRESS), 7684, 0);
  //   // putString(0,20,'                    '~);
  //   // putString(0,21,'                    '~);
  //   putString(0,20,strings[17]);
  //   putString(0,21,strings[18]);
  //   gfx_fadein;
  // end;

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
