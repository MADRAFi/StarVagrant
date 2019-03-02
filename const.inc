// stale

FREE_TOP = $9500;

DISPLAY_LIST_ADDRESS_TITLE = FREE_TOP + $100;
DISPLAY_LIST_ADDRESS_MENU = DISPLAY_LIST_ADDRESS_TITLE + $100;
DISPLAY_LIST_ADDRESS_CONSOLE = DISPLAY_LIST_ADDRESS_MENU + $100;
TXT_ADDRESS = DISPLAY_LIST_ADDRESS_CONSOLE + $100;

SCROLL_ADDRESS = TXT_ADDRESS + $3D0; // $400;
STRINGS_ADDRESS = SCROLL_ADDRESS + $FA5; // $1800;
// lenght 1A05
//RMT_PLAYER_ADDRESS = $1000;
//RMT_MODULE_ADDRESS = $BF00;
//RMT_MODULE_ADDRESS = STRINGS_ADDRESS  + $500;
//RMT_PLAYER_ADDRESS = $AD00;
//RMT_MODULE_ADDRESS = RMT_PLAYER_ADDRESS + $800;
//RMT_PLAYER_ADDRESS = $BB00;


CHARSET_ADDRESS = $D800;
GFX_ADDRESS = $E000;
//GFX2_ADDRESS = $1000; // $C00;






NUMBEROFLOCATIONS = 17; // number of locations defined in locations.asm. Needs to match.
NUMBEROFITEMS = 24; // number of items defined in items.asm. Needs to match.
NUMBEROFSHIPS = 12; // number of ships defined in ships array.
MAXSHIPPARAMETERS = 6; // number of ship parameters in ship array
MAXAVAILABLEITEMS = 12; // numer of concurrent items displayed
MAXCARGOSLOTS = 10;  // number of cargo slots
MAXAVAILABLEDESTINATIONS = 6;  // number of destinations fron location.

// ***************************************************************************//

STARTUEC = 5000;
STARTLOCATION = 0; // Port Olisar

// ***************************************************************************//
KEY_OPTION1 = 31; //1
KEY_OPTION2 = 30; //2
KEY_OPTION3 = 26;  //3
KEY_OPTION4 = 24;  //4
KEY_OPTION5 = 29;  //5
KEY_OPTION6 = 27;  //6

KEY_BACK = 21;    //b
KEY_QUIT = 47;    //q
KEY_NEW = 35;     //n
KEY_JUMP = 1;    //j

KEY_UP = 142;
KEY_DOWN = 143;
KEY_LEFT = 134;
KEY_RIGHT = 135;

KEY_CANCEL = 18;  //c
KEY_OK = 8;      //o

//----------------------------------------------------------------------------//
MENU_TITLE = 0;
MENU_MAIN = 1;
MENU_NAV = 2;
MENU_TRADE = 3;
MENU_MAINT = 4;
MENU_SHIP = 5;
