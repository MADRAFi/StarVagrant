
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
    //CRT_Write('xBios not found at address: $'~); CRT_Write(HexStr(xBIOS_ADDRESS,4));
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
  msx.stop;

  If mytype = LOC then pic_openfile('LOC',num)
  else pic_openfile('GFX',num);
  //if (xBiosCheck = 1) and (xBiosIOresult = 0) then
  if (xBiosCheck <> 0) and (xBiosIOresult = 0) then
  begin
    xBiosLoadData(Pointer(GFX_ADDRESS));
    xBiosFlushBuffer;
  end;
  msx.init;
  music:= true;
end;

procedure navi_ftljump(distance: Word);
const
    CHUNKSIZE = 800;

var
  fileoffset: Cardinal;

begin
  CRT_ClearRow(6);
  for y:=0 to MAXAVAILABLEDESTINATIONS-1 do
  begin
    CRT_GotoXY(20,0+y); // liststart
    WriteSpaces(18); // clear rows
  end;

  // sfx_play(voice1,230,200); //vol 8
  // sfx_play(voice2,230,200); //vol 8
  // sfx_play(voice3,236,200); //vol 8
  // sfx_play(voice4, 236,200); // vol 8

  gfx_fadeout(false);
  music:=false;
  waitframe;
  msx.stop;

  pic_openfile('LOC',newLoc);
  fileoffset:=0;
  If (xBiosCheck <> 0) then xBiosSetLength(CHUNKSIZE); //size of chunk to read

  // simulate travel
  repeat
    If (xBiosCheck <> 0) then
    begin
      xBiosLoadData(Pointer(GFX_ADDRESS+fileoffset));
      fileoffset:=fileoffset+CHUNKSIZE;
    end;
    // If (xBiosIOresult <> 0) and (music = false) then
    // begin
    //   msx.init;
    //   music:= true;
    // end;
    //If distance > 0 then
    //begin
    //reuse of variable count for speed
      count:=(ROUND(15 / (ship.speed / 100))) - (5 - Trunc(ship.lenght / 25));
       Dec(distance);
       navi_distanceUpdate(distance);
       waitframes(count);
    //end;

  until ((distance = 0) and (xBiosIOresult <> 0)) or ((distance = 0) and (xBiosCheck = 0));

  If (xBiosCheck <> 0) then xBiosFlushBuffer; // close file
  // sfx_init; // reinitialize pokey
  msx.init;
  waitframe;
  music:= true;
  
  randomEncounter;
  calculateprices;
  player.loc:=newLoc;
end;