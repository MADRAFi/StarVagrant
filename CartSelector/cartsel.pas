program CARTSelector;

{$librarypath '../../../MADS/blibs/'}

uses atari, b_utils, b_system, b_crt, sysutils, rmt;

const
{$i const.inc}

{$r resources.rc}

var
  gfxcolors: array [0..3] of Byte = (
   $00,$00,$00,$00
  );

  piccolors: array [0..3] of Byte = (
    $12,$18,$1e,$00
  );

  txtcolors : array [0..1] of Byte = (
    $00,$00
  );
  msx: TRMT;

  b: Byte;
  x, y: Byte;
  tab: array [0..127] of byte;

  keyval: Byte;
  music: Boolean;
  firstDLI: pointer;
  optionPressed: Boolean;
  filename: TString;

strings: array [0..2] of String = (
    '1'*' English'~,
    '2'*' Polski'~,
    '3'*' Deutsch'~
);

{$i interrupts.inc}

procedure gfx_fadeout; //(hidetext: Boolean);

begin

  repeat
    Waitframes(1);
    for b:=0 to 3 do 
              If (gfxcolors[b] and %00001111 <> 0) then Dec(gfxcolors[b]) else gfxcolors[b]:=0;

      If (txtcolors[0] and %00001111 <> 0) then Dec(txtcolors[0]) else txtcolors[0]:=0;
      If (txtcolors[1] and %00001111 <> 0) then Dec(txtcolors[1]) else txtcolors[1]:=0;

until ((gfxcolors[0] or gfxcolors[1] or gfxcolors[2] or gfxcolors[3])=0);
  //  until ((gfxcolors[0] or gfxcolors[1] or gfxcolors[2] or gfxcolors[3])=0) and ((txtcolors[0] or txtcolors[1])=0);
  //  waitframes(10);
end;


procedure gfx_fadein;
const
  TXTCOLOR = $1c;
  TXTBACK = 0;

begin
  repeat
    Waitframes(1);
    for b:=0 to 3 do 
      If ((gfxcolors[b] and %00001111) <= (piccolors[b] and %00001111)) then Inc(gfxcolors[b]) else gfxcolors[b]:=piccolors[b];

    If ((txtcolors[0] and %00001111) <= (TXTBACK and %00001111)) then Inc(txtcolors[0]) else txtcolors[0]:=TXTBACK;
    If ((txtcolors[1] and %00001111) <= (TXTCOLOR and %00001111)) then Inc(txtcolors[1]) else txtcolors[1]:=TXTCOLOR;

  until ((gfxcolors[0]=piccolors[0]) and
        (gfxcolors[1]=piccolors[1]) and
        (gfxcolors[2]=piccolors[2]) and
        (gfxcolors[3]=piccolors[3])); // or ((txtcolors[0]=TXTBACK) and (txtcolors[1]=TXTCOLOR));
end;

procedure CRT_ClearRows(start: Byte;num: Byte);
begin
  for b:=start to num do
    CRT_ClearRow(b);
end;


procedure draw_stars;
begin
    repeat until vcount=10;
    repeat
        x:=vcount;
        y:=(x and 3) + 1;
        inc(tab[x], y);
        y:= 15 - (y shl 1);
        wsync:=0;
        hposm3:=tab[x];
        colpm3:=y;
        grafm:=128;
    until vcount > 65;
    
    hposm3:=0;
end;


begin
  //fadeoff;
  SystemOff;
  SetCharset (Hi(CHARSET_ADDRESS3)); // when system is off
  CRT_Init(GFX_ADDRESS);

  // Initialize player
  msx.player:=pointer(PLAYER_ADDRESS);
  msx.modul:=pointer(MODULE_ADDRESS);
  msx.init($11);


  music:= true;

  gfx_fadeout;
  Waitframe;
  firstDLI:=@dli_f1;
  DMACTL:=$22; //%00100010;
  DLISTL:=DISPLAY_LIST_ADDRESS;
  EnableVBLI(@vbl);
  EnableDLI(@dli_f1);
  
  gractl:=3; // Turn on P/M graphics
  pmbase:=Hi(PMG_BASE);

  // clear screen memory
  fillbyte(pointer(GFX_ADDRESS), 1200, 0);

  //   // // Clear player 1 memory
  // fillchar(pointer(PMG_BASE+512), 128, 0);

  // PMG setting
  sizem:=0;
  colpm3:=$0e;
  gprior:=1;
  

  CRT_ClearRows(0,CRT_screenHeight);
  move(pointer(SCREEN_ADDRESS1), pointer(GFX_ADDRESS), 600);

  for b:=0 to 2 do
  begin
    CRT_GotoXY(16,16+b);
    CRT_Write(strings[b]);

    // CRT_WriteCentered(20 + b,strings[0+b]);
  end;


  // initiate starfield
  for x:=0 to 127 do begin
    tab[x]:=peek($d20a);
  end;



  gfx_fadein;

  CRT_GotoXY(0,15);
  
  keyval:= 0;
  repeat
    draw_stars;
    If CRT_Keypressed then
    begin
      // CRT_Write('key pressed'~);
        keyval := kbcode;
        case keyval of
          KEY_OPTION1:  begin
                          if not optionPressed  then 
                          begin
                            CRT_ClearRow(17);
                            CRT_ClearRow(18);
                            b:=1;
                          end;
                          optionPressed:=true;
                        end;
          KEY_OPTION2:  begin
                          if not optionPressed  then
                          begin
                            CRT_ClearRow(16);
                            CRT_ClearRow(18);
                            b:=2;
                          end;
                          optionPressed:=true;
                        end;
          KEY_OPTION3:  begin
                          if not optionPressed  then
                          begin
                            CRT_ClearRow(16);
                            CRT_ClearRow(17);
                            b:=3;
                          end;
                          optionPressed:=true;
                        end;

        end;

    end
    else
    begin
      optionPressed:=false;
    end;
    Waitframe;


  until (keyval = KEY_OPTION1) or (keyval = KEY_OPTION2) or (keyval = KEY_OPTION3);

  gfx_fadeout;
  // turn off PMG objects
  colpm0:=0;
  // hposp0:=0;

  music:= false;
  msx.stop;
  waitframe;

  // case b of
  //   1: filename:= 'STARV   XEX';
  //   2: filename:= 'STARV   XEX';
  //   3: filename:= 'STARV   XEX';
  // end;
  // xBiosLoadFile(filename);
  // waitframe;

  // DisableDLI;
  // DisableVBLI;
  // nmien:=0;
  // Dmactl:= 0;

end.
