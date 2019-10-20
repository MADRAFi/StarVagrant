program SVIntro;
{$librarypath '../../../MADS/lib/'}
{$librarypath '../../../MADS/base/'}
{$librarypath '../../../MADS/blibs/'}

uses atari, b_utils, b_system, b_crt, sysutils, rmt;

const
{$i const.inc}

{$IFDEF PL}
  {$r 'PL/charset.rc'}
{$ENDIF}
{$IFDEF DE}
  {$r 'DE/charset.rc'}
{$ENDIF}
{$IFDEF EN}
  {$r 'EN/charset.rc'}
{$ENDIF}

{$r resources.rc}

var
  gfxcolors: array [0..3] of Byte = (
   $04,$0a,$0e,$00
  );

{$IFDEF DEMO}
piccolors: array [0..(4*NUMBEROFPICS)-1] of Byte = (
    $74,$36,$fc,$00,   // 0
    $84,$88,$0e,$00,   // 1
    $24,$1a,$0e,$00,   // 2
    $62,$68,$7c,$00
  );
{$ELSE}
  piccolors: array [0..(4*NUMBEROFPICS)-1] of Byte = (
    $74,$36,$fc,$00,   // 0
    $84,$88,$0e,$00,   // 1
    $24,$1a,$0e,$00,   // 2
    $12,$18,$1e,$00
  );
{$ENDIF}

  txtcolors : array [0..1] of Byte = (
    $00,$00
  );
  msx: TRMT;
  // txt: String;
  picnumber: Byte; //count from 0
  b,y: Byte;
  skip: Boolean;
  music: Boolean;
  count: Word;
  firstDLI: pointer;

{$IFDEF PL}
  {$i 'PL/strings.inc'}
{$ENDIF}
{$IFDEF DE}
  {$i 'DE/strings.inc'}
{$ENDIF}
{$IFDEF EN}
  {$i 'EN/strings.inc'}
{$ENDIF}

{$i interrupts.inc}

procedure gfx_fadein;
const
  TEXTCOLOR1 = $00;
  TEXTCOLOR2 = $1c;

begin
  y:= picnumber shl 2;
  repeat
    Waitframes(2);
    // If (gfxcolors[0] and %00001111 <> piccolors[y] and %00001111) then Inc(gfxcolors[0]) else gfxcolors[0]:=piccolors[y];
    // If (gfxcolors[1] and %00001111 <> piccolors[y+1] and %00001111) then Inc(gfxcolors[1]) else gfxcolors[1]:=piccolors[y+1];
    // If (gfxcolors[2] and %00001111 <> piccolors[y+2] and %00001111) then Inc(gfxcolors[2]) else gfxcolors[2]:=piccolors[y+2];
    // If (gfxcolors[3] and %00001111 <> piccolors[y+3] and %00001111) then Inc(gfxcolors[3]) else gfxcolors[3]:=piccolors[y+3];
    for b:=0 to 3 do 
      If ((gfxcolors[b] and %00001111) <= (piccolors[y+b] and %00001111)) then Inc(gfxcolors[b]) else gfxcolors[b]:=piccolors[y+b];

    If (txtcolors[0] and %00001111 <> TEXTCOLOR1 and %00001111) then Inc(txtcolors[0]) else txtcolors[0]:=TEXTCOLOR1;
    If (txtcolors[1] and %00001111 <> TEXTCOLOR2 and %00001111) then Inc(txtcolors[1]) else txtcolors[1]:=TEXTCOLOR2;

  until (gfxcolors[0]=piccolors[y]) and
        (gfxcolors[1]=piccolors[y+1]) and
        (gfxcolors[2]=piccolors[y+2]) and
        (gfxcolors[3]=piccolors[y+3]) and
        (txtcolors[0]=TEXTCOLOR1) and (txtcolors[1]=TEXTCOLOR2);
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

// procedure back_to_loader;assembler;
//   asm {
//         clc
//         rts
//       };
// end;

// procedure SystemOn;assembler;
//   asm {
//         lda:rne vcount
//         mva #$ff portb
//         dec nmien
//         cli

//         rts
//     };
// end;

procedure wait(time:Word);
begin
  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if CRT_Keypressed then skip:= true;
  until skip or (count > time);
end;

begin
  //fadeoff;
  SystemOff;
  SetCharset (Hi(CHARSET_ADDRESS)); // when system is off
  CRT_Init(TXT_ADDRESS);

  // Initialize player
  msx.player:=pointer(PLAYER_ADDRESS);
  msx.modul:=pointer(MODULE_ADDRESS);
  msx.init(0);

  skip:= false;
  music:= true;

  Waitframe;
  firstDLI:=@dli_title;
  EnableVBLI(@vbl);
  EnableDLI(@dli_title);
  DLISTL:= DISPLAY_LIST_ADDRESS_TITLE;
  DMACTL:=$22; //%00100010;
  
  // clear screen memory
  fillbyte(pointer(TXT_ADDRESS), 1320, 0);

  wait(75);

  if skip = false then begin
    gfx_fadeout;
    CRT_GotoXY(0,24);
    CRT_Write(strings[0]);
    gfx_fadein;
  end;

  wait(450);

  if skip = false then begin
    gfx_fadeout;
    CRT_ClearRow(24);
    CRT_WriteXY(0,24, strings[1]);
    gfx_fadein;
  end;

  wait(450);

  if skip = false then begin
    gfx_fadeout;
    picnumber:=0;


    Waitframe;
    firstDLI:=@dli_pic1_f1;
    DLISTL:= DISPLAY_LIST_ADDRESS_PIC1;

    // fillbyte(pointer(TXT_ADDRESS), 1380, 0);
    move(pointer(SCREEN_ADDRESS_PIC1), pointer(TXT_ADDRESS), 1200);

    CRT_ClearRow(24);
    CRT_ClearRow(25);
    CRT_ClearRow(26);
    CRT_WriteXY(0,24, strings[2]);
    CRT_WriteXY(0,25, strings[3]);
    gfx_fadein;
  end;

  wait(450);

  if skip = false then begin
    gfx_fadeout;
    picnumber:=1;

    Waitframe;
    firstDLI:=@dli_pic2_f1;
    DLISTL:= DISPLAY_LIST_ADDRESS_PIC2;

    move(pointer(SCREEN_ADDRESS_PIC2), pointer(TXT_ADDRESS), 1200);

    CRT_ClearRow(24);
    CRT_ClearRow(25);
    CRT_ClearRow(26);
    CRT_WriteXY(0,24, strings[4]);
    CRT_WriteXY(0,25, strings[5]);
    CRT_WriteXY(0,26, strings[6]);
    gfx_fadein;
  end;

  wait(450);

  if skip = false then begin
    gfx_fadeout;
    picnumber:=2;
    
    Waitframe;
    firstDLI:=@dli_pic3_f1;
    DLISTL:= DISPLAY_LIST_ADDRESS_PIC3;

    move(pointer(SCREEN_ADDRESS_PIC3), pointer(TXT_ADDRESS), 1200);

    CRT_ClearRow(24);
    CRT_ClearRow(25);
    CRT_ClearRow(26);
    CRT_WriteXY(0,24, strings[7]);
    CRT_WriteXY(0,25, strings[8]);
    CRT_WriteXY(0,26, strings[9]);
    gfx_fadein;
  end;

  wait(450);

  if skip = false then begin
    gfx_fadeout;

    Waitframe;
    firstDLI:=@dli_title;
    DLISTL:= DISPLAY_LIST_ADDRESS_TITLE;

    // clear screen memory
    fillbyte(pointer(TXT_ADDRESS), 1320, 0);
    SetCharset (Hi(CHARSET_ADDRESS)); // when system is off

    CRT_GotoXY(0,24);
    CRT_Write(strings[10]);
    gfx_fadein;
  end;

  wait(450);
  if skip = false then begin
    gfx_fadeout;
    picnumber:=3;

    Waitframe;
    DLISTL:=DISPLAY_LIST_ADDRESS_PIC4;
    firstDLI:=@dli_pic4_f1;


    move(pointer(SCREEN_ADDRESS_PIC4), pointer(TXT_ADDRESS), 1200);

    for y:=0 to 9 do
      begin
        CRT_ClearRow(y + 15);
        CRT_WriteCentered(y + 15, creditstxt[y]);
      end;
    CRT_ClearRow(25);  
    CRT_WriteCentered(25,strings[11]);
    gfx_fadein;
  end;

  count:= 0;
  repeat 
    inc(count);
    waitframe;
    if count = 50 then
    begin
{$IFDEF PL}
    CRT_Invert(2,25,34);
{$ENDIF}
{$IFDEF DE}
    CRT_Invert(5,25,29);
{$ENDIF}
{$IFDEF EN}
    CRT_Invert(5,25,29);
{$ENDIF}
    count:= 0;
    end;
    if CRT_Keypressed then skip:= true;
  until skip; //or (count > 450);

  gfx_fadeout;  
  music:= false;
  msx.stop;
  waitframe;
  DisableDLI;
  DisableVBLI;
  nmien:=0;
  Dmactl:= 0;

  asm {
        clc
        rts
      };

  // {$DEFINE intro}
  // {$IFDEF intro}
  // // SystemReset;
  // SystemOn;
  // {$ELSE}
  // back_to_loader;
  // {$ENDIF}

end.
