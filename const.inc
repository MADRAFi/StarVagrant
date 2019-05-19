// stale

FREE_TOP = $A000;

DISPLAY_LIST_ADDRESS_TITLE = FREE_TOP;
DISPLAY_LIST_ADDRESS_MENU = DISPLAY_LIST_ADDRESS_TITLE + $100;
DISPLAY_LIST_ADDRESS_CONSOLE = DISPLAY_LIST_ADDRESS_MENU + $100;
PLAYER_ADDRESS = $A300; // CMC only
MODULE_ADDRESS = PLAYER_ADDRESS + $800;

CHARSET_ADDRESS = $BC00;
LOGO_CHARSET_ADDRESS  = $DC00;
LOGO_CHARSET_ADDRESS2  = LOGO_CHARSET_ADDRESS + $400;
//LOGO_CHARSET_ADDRESS3 = LOGO_CHARSET_ADDRESS2 + $400;



// RMT_PLAYER_ADDRESS = $B500; // + 100 due to rmt player mem alloc
// RMT_MODULE_ADDRESS = $E000;

GFX_ADDRESS = $C000; // $C000 - $D000
TXT_ADDRESS = $D800;
// ***************************************************************************//

NUMBEROFLOCATIONS = 17; // number of locations defined in locations.asm. Needs to match.
NUMBEROFITEMS = 24; // number of items defined in items.asm. Needs to match.
NUMBEROFSHIPS = 12; // number of ships defined in ships array.
MAXSHIPPARAMETERS = 6; // number of ship parameters in ship array
MAXAVAILABLEITEMS = 12; // numer of concurrent items displayed
MAXCARGOSLOTS = 10;  // number of cargo slots
MAXAVAILABLEDESTINATIONS = 6;  // number of destinations fron location.
MAXLOGOCHARS = 479;

STARTUEC = 5000;
STARTLOCATION = 0;

// ***************************************************************************//
KEY_OPTION1 = 31; //1
KEY_OPTION2 = 30; //2
KEY_OPTION3 = 26;  //3
KEY_OPTION4 = 24;  //4
KEY_OPTION5 = 29;  //5
KEY_OPTION6 = 27;  //6

KEY_BACK = 21;     //b
KEY_QUIT = 47;     //q
KEY_NEW = 35;      //n
KEY_JUMP = 1;      //j
KEY_CREDITS = 40; //r

KEY_BUYSELL = 33;
KEY_SELECT = 12;

KEY_UP = 14;
KEY_DOWN = 15;
KEY_LEFT = 6;
KEY_RIGHT = 7;
KEY_CTRLLEFT = 134;
KEY_CTRLRIGHT = 135;
KEY_SHIFTLEFT = 70;
KEY_SHIFTRIGHT = 71;


KEY_CANCEL = 18;  //c
//KEY_OK = 8;      //o

//----------------------------------------------------------------------------//
MENU_TITLE = 0;
MENU_MAIN = 1;
MENU_NAV = 2;
MENU_TRADE = 3;
//MENU_MAINT = 4;
MENU_SHIP = 5;
MENU_SAVE = 6;
MENU_LOAD = 7;
MENU_CREDITS = 8;
