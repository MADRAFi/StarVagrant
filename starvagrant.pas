program StarVagrant;
{$librarypath '../Libs/lib/';'../Libs/blibs/';'../Libs/base/'}
uses atari, b_utils, b_system, b_crt, sysutils;



const
{$i 'const.inc'}
  CURRENCY = ' UEC';
  COMMISSION = 0.05;

type
{$i 'types.inc'}
{$r 'resources.rc'}

var
  keyval: char = chr(0);
//  keyval: byte = 0;

  //msx: TRMT;

  strings: array [0..0] of word absolute STRINGS_ADDRESS;
  locations: array [0..0] of word absolute LOCATIONS_ADDRESS;
  items: array [0..0] of word absolute ITEMS_ADDRESS;

  itemmatrix: array [0..(NUMBEROFLOCATIONS-1)*(NUMBEROFITEMS-1)] of boolean;  // matrix where items are available
  itemprice: array [0..(NUMBEROFLOCATIONS-1)*(NUMBEROFITEMS-1)] of Word;  // price matrix for items
  itemquantity: array [0..(NUMBEROFLOCATIONS-1)*(NUMBEROFITEMS-1)] of Word; // quantities of items
  availableitems: array [0..(MAXAVAILABLEITEMS-1)] of Word; // only 12 avaiable items
  //currentcargo: array [0..MAXCARGOSLOTS-1] of Word;
  //currentcargoquantity: array [0..MAXCARGOSLOTS-1] of Word;

  {itemmatrix: array[0..NUMBEROFITEMS] of TPriceMatrix;
  locationmatrix: array [0..NUMBEROFLOCATIONS] of itemmatrix;
}
  current_menu: Byte;
  player: TPlayer;
  ship: TShip;

//commission: shortreal = 0.05;

{$i 'interrupts.inc'}


{
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
}
{
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
  // item * location
  // Location 0
  itemmatrix[7]:=true;
  itemmatrix[8]:=true;
  itemmatrix[10]:=true;
  itemmatrix[14]:=true;
  itemmatrix[15]:=true;
  itemmatrix[18]:=true;
  itemmatrix[21]:=true;

  // Prices location 0
  itemprice[7]:=127;
  itemprice[8]:=5;
  itemprice[10]:=99;
  itemprice[14]:=10;
  itemprice[15]:=2;
  itemprice[18]:=100;
  itemprice[21]:=1;

// quantity location 0
  itemquantity[7]:=10;
  itemquantity[8]:=5000;
  itemquantity[10]:=400;
  itemquantity[14]:=10000;
  itemquantity[15]:=65535;
  itemquantity[18]:=100;
  itemquantity[21]:=65535;

end;

procedure start;
var
  x: byte;

begin
  //msx.Sfx(3, 2, 24);
  generateworld;
  player.uec:= 5000; // start cash
  player.loc:= 0; //start location Port Olisar

  //mocap starting ship
  ship.sname:= 'Cuttlas Black';
  ship.scu_max:=46;
  ship.scu:=0;

  for x:=0 to MAXCARGOSLOTS-1 do
  begin
      ship.cargoindex[x]:= 0;
      ship.cargoquantity[x]:= 0;
  end;

  ship.cargoindex[0]:=7;
  ship.cargoquantity[0]:=10;
  ship.cargoindex[1]:=10;
  ship.cargoquantity[1]:=20;
  ship.scu:= 30;
end;



// procedure ListCargo;
// const
//   LISTWIDTH = 20;
//   LISTSTART = 0;
//
// var
//   x: byte;
//   count:byte = 1;
//   str: string;
//   strnum: string;
//   offset: Word = 0;
//
//
// begin
//   count:=1;
//   for x:=0 to MAXCARGOSLOTS-1 do // max available items
//     begin
//       offset:=currentcargo[x];
//       if offset > 0 then
//       begin
//         CRT_WriteXY(LISTSTART,7+count,'found'~);
//         CRT_GotoXY(LISTSTART,8+count); //min count:=1 so we start at 4th row
// //        str:= FFTermToString(items[offset]);
//         str:= IntToStr(offset);
//         CRT_Write(Atascii2Antic(str));
//         strnum:=IntToStr(currentcargoquantity[x]);
//         CRT_Write(Atascii2Antic(Space(listwidth-Length(str)-Length(strnum))));
//         CRT_Write(Atascii2Antic(strnum));
// //        if count =1 then CRT_Invert(liststart,8,listwidth);
//         inc(count);
//       end;
//     end;
//     CRT_WriteXY(liststart,8+count+1,concat('CARGO END:'~,Atascii2Antic(IntToStr(count))));
// end;

procedure ListCargo(myship: Tship;mode : Boolean);
const
  LISTWIDTH = 20;
  LISTSTART = 0;
  TOPCARGOMARGIN = 8;

var
  x: byte;
  count:byte = 1;
  str: string;
  strnum: string;
  offset: Word = 0;


begin
  count:=1;
  for x:=0 to MAXCARGOSLOTS-1 do // max available items
  begin
    offset:=myship.cargoindex[x];
    if offset > 0 then
    begin
      CRT_GotoXY(LISTSTART,7+count); //min count:=1 so we start at 8th row
      str:= FFTermToString(items[offset]);
      CRT_Write(str);
      strnum:=concat(IntToStr(myship.cargoquantity[x]),' SCU');
      CRT_Write(Atascii2Antic(Space(listwidth-Length(str)-Length(strnum))));
      CRT_Write(Atascii2Antic(strnum));
      if (count = 1) and (mode = true) then CRT_Invert(LISTSTART,8,LISTWIDTH);
      inc(count);
    end;
  end;
  for x:=count to MAXCARGOSLOTS-1 do
  begin
    CRT_WriteXY(LISTSTART,TOPCARGOMARGIN+x-1,Atascii2Antic(space(LISTWIDTH))); // -1 to clear from the end of list
    //CRT_WriteXY(LISTSTART,TOPCARGOMARGIN+x-1,Atascii2Antic('c '~)); // -1 to clear from the end of list
  end;
end;


procedure ListItems(mode: boolean);
const
  LISTWIDTH = 19;
  LISTSTART = 21;

var
  x: byte;
  count:byte = 1;
  str: string;
  pricestr: string;
  finalprice: word;
  price: word;
  offset: Word = 0;


begin
  count:=1;
  for x:=0 to MAXAVAILABLEITEMS-1 do // max available items
    begin
      offset:=availableitems[x];
      if offset > 0 then
      begin
        CRT_GotoXY(LISTSTART,4+count); //min count:=1 so we start at 4th row
        str:= concat(Atascii2Antic(IntToStr(count)),' '~);
        str:= concat(str,FFTermToString(items[offset]));
        CRT_Write(str);
        price:=itemprice[offset];
        if mode then finalprice:=Trunc(price*(1-COMMISSION))
        else finalprice:=price;
        pricestr:=IntToStr(finalprice);
        CRT_Write(Atascii2Antic(Space(listwidth-Length(str)-Length(pricestr))));
        CRT_Write(Atascii2Antic(pricestr));
        //CRT_WriteRightAligned(Atascii2Antic(IntToStr(finalprice)));
        if (count = 1) and (mode = false) then CRT_Invert(LISTSTART,5,LISTWIDTH);
        inc(count);
      end;
    end;
end;


procedure LoadItems(loc: byte);
var
  x: byte;
  count:byte = 0;
  offset: word = 0;

begin
  count:=0;
  for x:=0 to NUMBEROFITEMS-1 do
    begin
      offset:=(NUMBEROFITEMS-1)*loc + x;
      if itemmatrix[offset] = true then
      begin
        if count <= MAXAVAILABLEITEMS-1 then // max avaiable items
        begin
          availableitems[count]:=offset;
          inc(count);
        end;
      end;
    end;
end;

function CheckItemPosition(newindex : Byte) : Boolean;
begin
  if (newindex < MAXAVAILABLEITEMS) and (newindex >= 0) then Result:=true
  else Result:=false;
end;

function CheckCargoPosition(newindex : Byte) : Boolean;
begin
  if (newindex < MAXCARGOSLOTS) and (newindex >= 0) then Result:=true
  else Result:=false;
end;

function GetItemPrice(itemindex : Byte; mode : Boolean): Word;
// Get item price based on itemindex of available items mode is false for BUY and tru for SELL

var
  finalprice: word;
  price: word;
  offset: word;

begin
  offset:=availableitems[itemindex];
  price:=itemprice[offset];
  if (mode = true) then
  begin
    finalprice:=Trunc(price*(1-commission))
  end
  else
  begin
    finalprice:=price;
  end;
  Result:= finalprice;

end;


function GetCargoPrice(myship: TShip; itemindex : Byte): Word;
// Get item price based on itemindex of available items mode is false for BUY and tru for SELL

var
//  price: word;
  offset: word;

begin
  offset:=myship.cargoindex[itemindex];
//  price:=itemprice[offset];
//  Result:=Trunc(price*(1-commission))
  Result:=Trunc(itemprice[offset]*(1-commission))
end;

// function GetItemQuantity(itemindex : Byte): Word;
// // Get item quantity based on itemindex of available items
//
// var
//   offset: word;
//
// begin
//   offset:=availableitems[itemindex];
//   Result:=itemquantity[offset];
// end;


procedure console_navigation;
var
  y: byte;
  // str: string;
  stillPressed: Boolean;

begin
  for y:=0 to 6 do
    CRT_ClearRow(y);


  CRT_WriteXY(0,0,concat('Location: '~,FFTermToString(locations[player.loc]))); //mocap
  CRT_WriteXY(0,1,'#########################'~);
  CRT_WriteXY(14,5,FFTermToString(strings[7])); // Back

  repeat
  //  pause;
  //  msx.play;
    If (CRT_Keypressed) then
    begin
      keyval := char(CRT_Keycode[kbcode]);
      case keyval of
        KEY_BACK: current_menu := MENU_MAIN;
      end;
      stillPressed:= true;
    end
    else
    begin
      stillPressed:= false;
    end;

  until keyval = KEY_BACK;
end;

procedure UpdateSelectedItem(selecteditemquantity:Word;selecteditemtotal:Longword);
var
  str: String;

begin
  str:= concat(IntToStr(selecteditemquantity),' SCU');
  str:= concat(str,FFTermToString(strings[18]));
  str:= concat(str,IntToStr(selecteditemtotal));
  str:= concat(str,CURRENCY);
  CRT_ClearRow(19);
  CRT_WriteRightAligned(19,Atascii2Antic(str));
end;

procedure console_trade;

const
  LISTTOPMARGIN = 5;
  CARGOTOPMARGIN = 8;

var
  y: Byte;
  mode: Boolean = false;
  stillPressed: Boolean = false;
  optionPressed: Boolean = false;
  selectPressed: Boolean = false;

  str: String;
  strnum: String;

  l: Byte;
  itemindex: Byte = 0;
  listwidth: Byte = 19;
  liststart: Byte = 21;
  //cargoindex: Byte = 0;

  currentitemindex: Word;
  currentitemquantity: Word;
  currentitemprice: Word;
  //currentcargo: array [0..MAXCARGOSLOTS-1] of Word;
  //currentcargoquantity: array [0..MAXCARGOSLOTS-1] of Word;
  currentuec: Longword;
  currentShip:TShip;


  selecteditemtotal: Longword;
  selecteditemquantity: Word;





begin
  currentuec:= player.uec;
  currentShip:= ship;
  selecteditemtotal:= 0;
  selecteditemquantity:= 0; // reset choosen quantity at start;
  mode:= false;
  stillPressed:= false;
  optionPressed:= false;
  selectPressed:= false;

  //currentcargo:= ship.cargoindex;
  //currentcargoquantity:= ship.cargoquantity;

  //cargoindex:= 0;


  liststart:=(CRT_screenWidth div 2)+1;
  listwidth:=CRT_screenWidth-liststart;


  Waitframe;
  DLISTL:= DISPLAY_LIST_ADDRESS_CONSOLE;
  Waitframe;
  EnableVBLI(@vblc);
  EnableDLI(@dlic);


  for y:=0 to CRT_screenWidth do
    CRT_ClearRow(y);

  str:=FFTermToString(locations[player.loc]);
  CRT_WriteXY(0,0,str);
  l:=Length(str);
  str:=' '~;
  str:=concat(str,FFTermToString(strings[8]));
  str:=concat(str,' '~);
  CRT_WriteXY(listwidth-4,0,str); // Buy
  // invert at start
  CRT_Invert(listwidth-4,0,5);

  str:=' '~;
  str:=concat(str,FFTermToString(strings[9]));
  str:=concat(str,' '~);
  CRT_Write(str); // Sell
  CRT_WriteRightAligned(Atascii2Antic(concat(IntToStr(currentuec), CURRENCY)));
  CRT_WriteXY(0,1,'--------------------+-------------------'~);
  CRT_WriteXY(0,2,concat(FFTermToString(strings[10]),'  |'~)); // Delivery
  CRT_Write(FFTermToString(strings[11])); // Available items
  CRT_WriteXY(0,3,'[ '~); CRT_Write(Atascii2Antic(currentship.sname)); CRT_Write(' ]'~);CRT_WriteXY(liststart-2,3,' |'~);
  CRT_Write(FFTermToString(strings[12]));CRT_WriteRightAligned(FFTermToString(strings[13])); // commodity price
  CRT_WriteXY(0,4,'--------------------+-------------------'~);
  CRT_WriteXY(0,5,FFTermToString(strings[14])); CRT_Write(' '~);
  CRT_WriteXY(listwidth-5,5,Atascii2Antic(IntToStr(currentship.scu_max))); CRT_Write(' SCU|'~); //CRT_WriteXY(listwidth-2,5,'46 |'~);  // mocap
  CRT_WriteXY(0,6,FFTermToString(strings[15])); CRT_Write(' '~);
  str:=IntToStr(currentship.scu_max-currentship.scu);
  CRT_WriteXY(liststart-(Length(str)+5),6,Atascii2Antic(str)); CRT_Write(' SCU|'~);
  CRT_WriteXY(0,7,'--------------------+'~);

  str:='|'~;
  for y:=8 to 17 do
  begin
      CRT_WriteXY(liststart-1,y,Atascii2Antic(str));
  end;

  CRT_WriteXY(0,18,'--------------------+-------------------'~);
  CRT_GotoXY(0,22);
  str:=concat(FFTermToString(strings[16]),' '~);
  CRT_WriteRightAligned(concat(str,FFTermToString(strings[17])));
  // CRT_WriteRightAligned('[Cancel] [OK]'~);

  // help

  str:='OPTION'*~;
  str:=concat(str,'-'~);
  str:=concat(str,FFTermToString(strings[8]));
  str:=concat(str,'/'~);
  str:=concat(str,FFTermToString(strings[9]));
  str:=concat(str,' '~);
  str:=concat(str,'SELECT'*~);
  str:=concat(str,'-'~);
  str:=concat(str,FFTermToString(strings[19]));
  str:=concat(str,' '~);
  str:=concat(str,FFTermToString(strings[7]));
  CRT_WriteCentered(23,str);

  //move(str[1],pointer(SCROLL_ADDRESS+42),sizeOf(str)); // copy text to vram



  LoadItems(player.loc);
  ListItems(false);
  ListCargo(currentShip,false);
  itemindex:=0;
  // assign 1st item on the avaiable items
  currentitemquantity:=itemquantity[availableitems[itemindex]];
  currentitemprice:=GetItemPrice(itemindex,mode);
  currentitemindex:=availableitems[itemindex];



  repeat
    Waitframe;
    //msx.play;
    If (CRT_Keypressed) then
    begin
      keyval := char(CRT_Keycode[kbcode]);

      case keyval of
        KEY_CANCEL: begin
                      currentuec:= player.uec;
                      currentShip:= ship;

                      LoadItems(player.loc);
                      ListItems(false);
                      ListCargo(currentShip,false);
                      selecteditemquantity:= 0;
                      selecteditemtotal:=0;
                      itemindex:=0;
                      // assign 1st item on the avaiable items
                      currentitemquantity:=itemquantity[availableitems[itemindex]];
                      currentitemprice:=GetItemPrice(itemindex,mode);
                      currentitemindex:=availableitems[itemindex];

                      // update player UEC (current session)
                      CRT_GotoXY(liststart+7,0); // +7 for Sell string
                      strnum:=IntToStr(currentuec);
                      CRT_Write(Atascii2Antic(space(LISTWIDTH-Length(strnum)-Length(CURRENCY)-7)));
                      CRT_Write(Atascii2Antic(concat(IntToStr(currentuec),CURRENCY)));

                      // update cargo Total
                      currentShip.scu:=currentShip.scu-selecteditemquantity;
                      str:=IntToStr(currentship.scu_max-currentship.scu);
                      CRT_WriteXY(liststart-(Length(str)+5)-4,6,Atascii2Antic(Space(4))); // fixed 4 chars for cargo size
                      CRT_WriteXY(liststart-(Length(str)+5),6,Atascii2Antic(str)); CRT_Write(' SCU|'~);

                    end;
        KEY_OK:     begin
                      player.uec:= currentuec;
                      ship:= currentShip;
                      current_menu:= MENU_MAIN;
                    end;
        KEY_BACK: current_menu:=MENU_MAIN;
        KEY_UP:     begin
                      if stillPressed = false then
                        if (mode = false) then
                        begin
                          if CheckItemPosition(itemindex-1) and (availableitems[itemindex-1] > 0) then
                          begin
                            CRT_Invert(liststart,itemindex + LISTTOPMARGIN,listwidth);
                            Dec(itemindex);
                            CRT_Invert(liststart,itemindex + LISTTOPMARGIN,listwidth); // selecting the whole row with item
                            currentitemquantity:=itemquantity[availableitems[itemindex]];
                            currentitemprice:=GetItemPrice(itemindex,false);
                            currentitemindex:=availableitems[itemindex];
                            selecteditemtotal:=0;
                            selecteditemquantity:=0;
                            CRT_ClearRow(19);
                          end;
                        end
                        else
                          begin
                            if CheckItemPosition(itemindex-1) and (currentShip.cargoindex[itemindex-1] > 0)  then
                            begin
                              CRT_Invert(0,itemindex + CARGOTOPMARGIN,listwidth+1);
                              Dec(itemindex);
                              currentitemquantity:=currentShip.cargoquantity[itemindex];
                              //currentitemprice:=GetItemPrice(itemindex,true);
                              currentitemprice:=GetCargoPrice(currentShip,itemindex);
                              currentitemindex:=currentShip.cargoindex[itemindex];
                              selecteditemtotal:=0;
                              selecteditemquantity:=0;
                              CRT_Invert(0,itemindex + CARGOTOPMARGIN,listwidth+1); // selecting the whole row with item

                            end;
                          end;
                    end;
        KEY_DOWN:   begin
                      if stillPressed = false then
                        if (mode = false) then
                        begin
                          if CheckItemPosition(itemindex+1) and (availableitems[itemindex+1] > 0)  then
                          begin
                            CRT_Invert(liststart,itemindex + LISTTOPMARGIN,listwidth);
                            Inc(itemindex);
                            CRT_Invert(liststart,itemindex + LISTTOPMARGIN,listwidth); // selecting the whole row with item
//                            currentitemquantity:=GetItemQuantity(itemindex);
                            currentitemquantity:=itemquantity[availableitems[itemindex]];
                            currentitemprice:=GetItemPrice(itemindex,false);
                            currentitemindex:=availableitems[itemindex];
                            selecteditemtotal:=0;
                            selecteditemquantity:=0;
                            CRT_ClearRow(19);
                          end;
                        end
                        else
                        begin
                          if CheckItemPosition(itemindex+1) and (currentShip.cargoindex[itemindex+1] > 0)  then
                          begin
                            CRT_Invert(0,itemindex + CARGOTOPMARGIN,listwidth+1);
                            Inc(itemindex);
                            currentitemquantity:=currentShip.cargoquantity[itemindex];
                            //currentitemprice:=GetItemPrice(itemindex,true);
                            currentitemprice:=GetCargoPrice(currentShip,itemindex);
                            currentitemindex:=currentShip.cargoindex[itemindex];
                            selecteditemtotal:=0;
                            selecteditemquantity:=0;
                            CRT_Invert(0,itemindex + CARGOTOPMARGIN,listwidth+1); // selecting the whole row with item

                          end;
                        end;
                    end;
        KEY_LEFT:   begin
                      if (selecteditemquantity > 0) then
                      begin
                        Dec(selecteditemquantity);
                        selecteditemtotal:=selecteditemquantity * currentitemprice;
                        UpdateSelectedItem(selecteditemquantity,selecteditemtotal);
                      end;
                    end;
        KEY_RIGHT:  begin
                      stillPressed:= false;
                      if (mode = false) then
                      begin
                        if (selecteditemquantity < currentitemquantity) and (selecteditemtotal + currentitemprice <= currentuec ) and (selecteditemquantity < currentShip.scu_max-currentShip.scu) then
                          stillPressed:= true; //reuse boolean variable
                      end
                      else
                      begin
                        if (selecteditemquantity < currentitemquantity) and (selecteditemtotal + currentitemprice <= currentuec ) then
                          stillPressed:= true; //reuse boolean variable
                      end;
                      if (stillPressed = true) then
                      begin
                        Inc(selecteditemquantity);
                        selecteditemtotal:=selecteditemquantity * currentitemprice;
                        UpdateSelectedItem(selecteditemquantity,selecteditemtotal);
                      end;
                    end;
      end;
      // str:=concat('itemindex=',IntToStr(itemindex));
      // str:=concat(str,' cena=');
      // str:=concat(str,IntToStr(GetItemPrice(itemindex,mode)));
      // str:=concat(str,' ilosc=');
      // str:=concat(str,IntToStr(GetItemQuantity(itemindex)));
      // CRT_WriteXY(0,19,Atascii2Antic(str));
      stillPressed:= true;
    end
    else
    begin
      stillPressed:= false;
    end;

    if (CRT_OptionPressed) and (optionPressed=false) then
    begin
      l:=liststart-6; // Buy text is x char on left from screen center
      mode:= not mode;
      if (mode = false) then
      begin
          CRT_Invert(l,0,5);CRT_Invert(l+5,0,6);
          ListItems(false);
          ListCargo(currentShip,false);
          itemindex:=0;
      end
      else begin
        CRT_Invert(l,0,5);CRT_Invert(l+5,0,6);
        ListItems(true);
        ListCargo(currentShip,true);
        itemindex:=0;
      end;
      optionPressed:=true;
    end
    else
      if (CRT_OptionPressed = false) then optionPressed:=false;

    if (CRT_SelectPressed) then
    begin
      if (selectPressed = false) then
      begin
//         if (selecteditemquantity > 0) and (cargoindex < MAXCARGOSLOTS) then
//         begin
// // //          str:=FFTermToString(items[currentitemindex]);
// //           str:=IntToStr(currentitemindex);
// // //          str:=concat(str,' '~);
// //           strnum:=IntToStr(selecteditemquantity);
// //           CRT_WriteXY(0,cargoindex+CARGOTOPMARGIN, Atascii2Antic(str));
// //           CRT_Write(Atascii2Antic(Space(CRT_screenWidth-listwidth-1-Length(str)-Length(strnum))));
// //
// //           CRT_Write(Atascii2Antic(strnum));
// //           Inc(cargoindex);
//         end;

          if (mode = false) then // buying mode
          begin
            if (selecteditemquantity > 0) then
            begin
              for y:=0 to MAXCARGOSLOTS-1 do
              begin
                if currentShip.cargoindex[y] = 0 then
                begin
                  currentShip.cargoindex[y]:=currentitemindex;
                  currentShip.cargoquantity[y]:=selecteditemquantity;
                  break;
                end
                else
                begin
                  // some item exists
                  if currentship.cargoindex[y] = currentitemindex then
                  begin
                    // found same cargo
                    currentShip.cargoquantity[y]:=currentShip.cargoquantity[itemindex] + selecteditemquantity;
                    break;
                  end;
                end;
              end;

              // update UEC on screen not on player
              currentuec:=currentuec - selecteditemtotal;

              // update player UEC (current session)
              CRT_GotoXY(liststart+7,0); // +7 for Sell string
              strnum:=IntToStr(currentuec);
              CRT_Write(Atascii2Antic(space(LISTWIDTH-Length(strnum)-Length(CURRENCY)-7)));
              CRT_Write(Atascii2Antic(concat(IntToStr(currentuec),CURRENCY)));

              // update cargo Total
              currentShip.scu:=currentShip.scu + selecteditemquantity;
              str:=IntToStr(currentship.scu_max-currentship.scu);
              CRT_WriteXY(liststart-(Length(str)+5)-4,6,Atascii2Antic(Space(4))); // fixed 4 chars for cargo size
              CRT_WriteXY(liststart-(Length(str)+5),6,Atascii2Antic(str)); CRT_Write(' SCU|'~);

              // remove selection
              currentitemprice:=GetCargoPrice(currentShip,itemindex);
              currentitemindex:=currentShip.cargoindex[itemindex];
              selecteditemquantity:= 0;
              selecteditemtotal:=0;
//              itemindex:=0;

            end;
          end
          else // Selling mode
          begin
            if (selecteditemquantity > 0) then
            begin
              currentShip.cargoquantity[itemindex]:=currentShip.cargoquantity[itemindex]-selecteditemquantity;
              If currentShip.cargoquantity[itemindex] = 0 then currentShip.cargoindex[itemindex]:= 0; // erasing item form cargoindex

              // update UEC on screen not on player
              currentuec:=currentuec + selecteditemtotal;

              for y:=0 to MAXCARGOSLOTS-1 do
              begin
                if currentShip.cargoquantity[y] = 0 then
                begin
                  for l:=y to MAXCARGOSLOTS-1 do
                  begin
                    if (l < High(ship.cargoindex)) then
                    begin
                      currentShip.cargoindex[l]:=currentShip.cargoindex[l+1];
                      currentShip.cargoquantity[l]:=currentShip.cargoquantity[l+1];
                    end
                    else
                    begin
                      currentShip.cargoindex[l]:=0;
                      currentShip.cargoquantity[l]:=0;
                    end;
                  end;
                end;
              end;

              // set selection to 1st item on the list
              currentitemquantity:=currentShip.cargoquantity[itemindex];
              currentitemprice:=GetItemPrice(itemindex,mode);
              currentitemindex:=currentShip.cargoindex[itemindex];

              // update player UEC (current session)
              CRT_GotoXY(liststart+7,0); // +7 for Sell string
              strnum:=IntToStr(currentuec);
              CRT_Write(Atascii2Antic(space(LISTWIDTH-Length(strnum)-Length(CURRENCY)-7)));
              CRT_Write(Atascii2Antic(concat(IntToStr(currentuec),CURRENCY)));

              // update cargo Total
              currentShip.scu:=currentShip.scu-selecteditemquantity;
              str:=IntToStr(currentship.scu_max-currentship.scu);
              CRT_WriteXY(liststart-(Length(str)+5)-4,6,Atascii2Antic(Space(4))); // fixed 4 chars for cargo size
              CRT_WriteXY(liststart-(Length(str)+5),6,Atascii2Antic(str)); CRT_Write(' SCU|'~);

              // remove selection
              currentitemprice:=GetCargoPrice(currentShip,itemindex);
              currentitemindex:=currentShip.cargoindex[itemindex];
              selecteditemquantity:= 0;
              selecteditemtotal:=0;
//              itemindex:=0;

            end;
          end;
        ListCargo(currentShip,mode);
      end;
      selectPressed:=true;
    end
    else
      selectPressed:=false;


  until (keyval = KEY_BACK) or (keyval = KEY_OK);
end;

procedure menu;

var
    //str: string;
    i: byte;
    stillPressed: Boolean;

begin
  Waitframe;
  DLISTL := DISPLAY_LIST_ADDRESS_MENU;
  Waitframe;
  EnableVBLI(@vbl);
  EnableDLI(@dli1);
  //CRT_Init(TXT_ADDRESS);

  for i:=0 to 6 do
    CRT_ClearRow(i);

  CRT_WriteXY(14,0,FFTermToString(strings[3])); // Navigation
  CRT_WriteXY(14,1,FFTermToString(strings[4])); // Trade Console
  CRT_WriteXY(14,2,FFTermToString(strings[7])); // Back

  // erase scroll content
  //str:= ''~;
  //move(str[1],pointer(SCROLL_ADDRESS+42),sizeOf(str));
  //hscrol:=0; //stop scroll.

  keyval:=chr(0);

  repeat
  //  pause;
  //  msx.play;
    if CRT_Keypressed then
    begin
      keyval := char(CRT_Keycode[kbcode]);
      case keyval of
        KEY_OPTION1: current_menu := MENU_NAV;
        KEY_OPTION2: current_menu := MENU_TRADE;
        KEY_BACK: current_menu := MENU_TITLE;
      end;
      stillPressed:= true;
    end
    else
    begin
      stillPressed:= false;
    end;
  until (keyval = KEY_BACK) or (keyval = KEY_OPTION1) or (keyval = KEY_OPTION2);
end;



procedure title;
var
  str: string;
  y: byte;
  stillPressed: Boolean;

begin
  DLISTL := DISPLAY_LIST_ADDRESS_MENU;
  Waitframe;
  EnableVBLI(@vbl);
  EnableDLI(@dli1);


  for y:=0 to 6 do
    CRT_ClearRow(y);

  CRT_WriteXY(14,0,FFTermToString(strings[1])); // New game;
  CRT_WriteXY(14,1,FFTermToString(strings[2])); // Quit;

  //str:= Atascii2Antic(NullTermToString(strings[0])); // read scroll text
  str:= FFTermToString(strings[0]); // read scroll text

  move(str[1],pointer(SCROLL_ADDRESS+42),sizeOf(str)); // copy text to vram


  keyval:=chr(0);
  repeat
    pause;
    //msx.play;
    if CRT_Keypressed then
    begin
      keyval := char(CRT_Keycode[kbcode]);
      case keyval of
        KEY_NEW: begin
                  start;
                  current_menu := MENU_MAIN;
                end;
      end;
      stillPressed:= true;
    end
    else
    begin
      stillPressed:= false;
    end;

  until (keyval = KEY_QUIT) or (keyval = KEY_NEW);
end;





procedure fade;
var
  fadecolors: Array[0..6] of byte = ($95,$94,$93,$92,$91,$90,$00);
  i: byte;

begin
  for i:=Low(fadecolors) to high(fadecolors)  do
    begin
      colbk:=fadecolors[i];
      Waitframe;
    end;
  //poke($2C6,$C4);
end;



{
--------------------------------------------------------------------------------
MAIN LOOP
--------------------------------------------------------------------------------
}

begin
  SystemOff;
  SetCharset (Hi(CHARSET_ADDRESS)); // when system is off
  CRT_Init(TXT_ADDRESS);

  fade;

  // Initialize RMT player
  //msx.player:=pointer(RMT_PLAYER_ADDRESS);
  //msx.modul:=pointer(RMT_MODULE_ADDRESS);
  //msx.init(0);

  current_menu := MENU_TITLE;
  //current_menu := MENU_TRADE;

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
  SystemReset;
end.
