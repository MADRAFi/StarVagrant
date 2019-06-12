TPokeyVoice = (Voice1=$D200, Voice2=$D202, Voice3=$D204, Voice4=$D206);
// TVoice = (Voice1=0, Voice2=1, Voice3=2, Voice4=3);
TManufacture = (ARGO=0, DRAK=1, RSI=2, MISC=3, AEGIS=4, CRSD=5, ANVL=6, BANU=7);
TPicType = (LOC=0, GFX=1);
TGameState = (NEWGAME=0, GAMEINPROGRESS=1);

  // TShipType = record
  //   producer: TProducer;
  //   sname: TString;
  //   scu_max: Word;
  //   speed: Byte;
  //
  // end;

  TShip = record
    mcode: Byte; // manufacture ship code
    sindex: Byte; // ship index
    scu_max: Word;
    scu: Word;
    speed: Byte;
    lenght: Byte;
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
