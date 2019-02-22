
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

TPokeyVoice = (Voice1=$D200, Voice2=$D202, Voice3=$D204, Voice4=$D206);
