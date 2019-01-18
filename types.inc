//types
    TLocType = (Station, Planet, Asteroid);
//    TMenu = (MENU_TITLE, MENU_MAIN, MENU_NAV, MENU_TRADE, MENU_MAINT);

    TLoc = record
        locname: string;
        loctype: byte;
    end;

    TShip = record
      sname: string;
      scu_max: word;
      scu: word;
      //cargo:
    end;

    //type
        TPlayer = record
            uec: longword;
            loc: byte; //TLoc;
            ship: TShip;
        end;
