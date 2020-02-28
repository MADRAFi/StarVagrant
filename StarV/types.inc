
TGameState = (NEWGAME=0, GAMEINPROGRESS=1, GAMEFINISHED=2);

  TShip = record
    mcode: Byte; // manufacture ship code
    sindex: Byte; // ship index
    swait: Byte; // ship wait time
    scu_max: Word;
    scu: Word;
    speed: Word;
    lenght: Word;
    mass: Word;
    qf_max: Word;
    qf : Word;  // quantum fuel
    cargoindex: array [0..MAXCARGOSLOTS-1] of Word;
    cargoquantity: array [0..MAXCARGOSLOTS-1] of Word;
  end;

  TPlayer = record
    uec: Longword;
    loc: Byte;
  end;
