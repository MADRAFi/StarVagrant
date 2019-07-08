
procedure pic_openfile(myname: TString; mynum: Byte);
begin
  tstr:='';
  if (mynum < 10) then tstr:=concat(myname,'0')
  else tstr:=myname;

  tstr:=concat(tstr,inttostr(mynum));
  tstr:=concat(tstr,'   DAT');

  if xBiosCheck = 0 then
  begin
    CRT_GotoXY(0,5);
    CRT_Write(strings[25]); // no xBios
  end
  else begin
    xBiosOpenFile(tstr);
  end;

end;

procedure pic_load(mytype: Byte; num: Byte);
begin
  music:= false;
  waitframe;
  // msx.interrupt_play;

  If mytype = LOC then pic_openfile('LOC',num);
  // else pic_openfile('GFX',num);
  //if (xBiosCheck = 1) and (xBiosIOresult = 0) then
  if (xBiosCheck <> 0) and (xBiosIOresult = 0) then
  begin
    xBiosLoadData(Pointer(GFX_ADDRESS));
    xBiosFlushBuffer;
  end;
  // msx.continue_play;
  // music:= true;
  sfx_init;
end;

procedure navi_ftljump(distance: Word);
const
    CHUNKSIZE = 600;

var
  fileoffset: Cardinal;
  // usedqf: Word;

begin
  // usedqf:= distance;

  CRT_ClearRow(6);
  for y:=0 to MAXAVAILABLEDESTINATIONS-1 do
  begin
    CRT_GotoXY(20,0+y); // liststart
    WriteSpaces(18); // clear rows
  end;

  sfx_play(voice4, 236,202); // vol 10

  gfx_fadeout(false);
  music:=false;
  waitframe;
  // msx.interrupt_play;

  pic_openfile('LOC',newLoc);
  fileoffset:=0;
  If (xBiosCheck <> 0) then xBiosSetLength(CHUNKSIZE); //size of chunk to read

  // count:=(ROUND(15 / (ship.speed / 100))) - (5 - Trunc(ship.lenght / 25));
  count:= ship.swait;

  // simulate travel
  repeat
    If (xBiosCheck <> 0) then
    begin
      xBiosLoadData(Pointer(GFX_ADDRESS+fileoffset));
      fileoffset:=fileoffset+CHUNKSIZE;
    end;
    If (xBiosIOresult <> 0) and (music = false) then
    begin
      xBiosFlushBuffer; // close file
      // msx.continue_play;
      // music:= true;
      sfx_init; // reinitialize pokey
    end;

    Dec(distance);
    Dec(ship.qf);
    navi_distanceUpdate(distance);
    waitframes(count);
  

  until ((distance = 0)); // and (xBiosIOresult <> 0)) or ((distance = 0) and (xBiosCheck = 0));

  // If (xBiosCheck <> 0) then
  // begin
  //   // msx.interrupt_play;
  //       xBiosFlushBuffer; // close file
  //   // msx.continue_play;
  //   waitframe;
  //   // music:= true;
    
  // end; 
  
  randomEncounter;
  calculateprices;
  player.loc:=newLoc;
end;