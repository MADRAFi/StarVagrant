//types

//    TLocType = (Station, Planet, Asteroid);
//    TMenu = (MENU_TITLE, MENU_MAIN, MENU_NAV, MENU_TRADE, MENU_MAINT);

//    TLoc = record
//        locname: string;
//        loctype: byte;
//    end;

  TShip = record
    sname: string;//Byte;
    scu_max: Word;
    scu: Word;
    cargoindex: array [0..MAXCARGOSLOTS-1] of Word;
    cargoquantity: array [0..MAXCARGOSLOTS-1] of Word;
  end;

  TPlayer = record
    uec: Longword;
    loc: Byte; //TLoc;
    //ship: TShip;
  end;

    // TPriceMatrix = record
    //   price: byte;
    //   quantity: word;
    // end;

  // TItem = record
  //   itemindex: byte;
  //   quantity: word;
  //   price: byte;
  // end;
  // TCargoSlot = record
  //   cargoindex: byte;
  //   quantity: word;
  // end;
