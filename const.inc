// stale

FREE_TOP = $8000;

CHARSET_ADDRESS = FREE_TOP;
DISPLAY_LIST_ADDRESS_TITLE = CHARSET_ADDRESS + $400;
DISPLAY_LIST_ADDRESS_MENU = DISPLAY_LIST_ADDRESS_TITLE + $100;
DISPLAY_LIST_ADDRESS_CONSOLE = DISPLAY_LIST_ADDRESS_MENU + $100;
TXT_ADDRESS = DISPLAY_LIST_ADDRESS_CONSOLE + $100;

SCROLL_ADDRESS = TXT_ADDRESS + $400;

//RMT_PLAYER_ADDRESS = $7000; // begining of a new mem page
//RMT_MODULE_ADDRESS = RMT_PLAYER_ADDRESS + $800;
// end at $6F8D

// logo length $178D;
//GFX_ADDRESS = $A000;
GFX_ADDRESS = $9000;
GFX2_ADDRESS = $C000;  //GFX_ADDRESS + $2000;


STRINGS_ADDRESS = GFX_ADDRESS + $2000; // $1800;
LOCATIONS_ADDRESS = STRINGS_ADDRESS + $200;
ITEMS_ADDRESS = LOCATIONS_ADDRESS + $200;


NUMBEROFLOCATIONS = 17; // number of locations defined in locations.asm. Needs to match.
NUMBEROFITEMS = 24; // number of items defined in items.asm. Needs to match.
MAXAVAILABLEITEMS = 12; // numer of concurrent items displayed
MAXCARGOSLOTS = 10;  // number of cargo slots
MAXAVAILABLEDESTINATIONS = 5;  // number of destinations fron location.

// ***************************************************************************//
KEY_OPTION1 = '1';
KEY_OPTION2 = '2';
KEY_OPTION3 = '3';
KEY_OPTION4 = '4';
KEY_OPTION5 = '5';

KEY_BACK = 'b';
KEY_QUIT = 'q';
KEY_NEW = 'n';

KEY_UP = 'p';
KEY_DOWN = ';';
KEY_LEFT = 'k';
KEY_RIGHT = 'l';
//  KEY_UP = Chr(28);
//  KEY_DOWN = Chr(29);
//  KEY_LEFT = Chr(30);
//  KEY_RIGHT = Chr(31);

KEY_CANCEL = 'c';
KEY_OK = 'o';


//----------------------------------------------------------------------------//
MENU_TITLE = 0;
MENU_MAIN = 1;
MENU_NAV = 2;
MENU_TRADE = 3;
MENU_MAINT = 4;
