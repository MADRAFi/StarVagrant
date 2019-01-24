// stale

FREE_TOP = $6000;
CHARSET_ADDRESS = FREE_TOP;
DISPLAY_LIST_ADDRESS_MENU = CHARSET_ADDRESS + $400;
DISPLAY_LIST_ADDRESS_CONSOLE = DISPLAY_LIST_ADDRESS_MENU + $100;
TXT_ADDRESS = DISPLAY_LIST_ADDRESS_CONSOLE + $100;
SCROLL_ADDRESS = TXT_ADDRESS + $400; //$F0;
//SCROLL_ADDRESS = $7000;
// end at $4590

//RMT_PLAYER_ADDRESS = $7000; // begining of a new mem page
//RMT_MODULE_ADDRESS = RMT_PLAYER_ADDRESS + $800;
// end at $6F8D

// logo length $178D;
GFX_ADDRESS = $8000;

STRINGS_ADDRESS = GFX_ADDRESS + $2809;
LOCATIONS_ADDRESS = STRINGS_ADDRESS + $200;
ITEMS_ADDRESS = LOCATIONS_ADDRESS + $200;


NUMBEROFLOCATIONS = 15; // number of locations defined in locations.asm. Needs to match.
NUMBEROFITEMS = 22; // number of items defined in items.asm. Needs to match.
MAXAVAILABLEITEMS = 12; // numer of cocnrunnet items displayed
MAXCARGOSLOTS = 10;

// ***************************************************************************//
KEY_OPTION1 = '1';
KEY_OPTION2 = '2';
KEY_OPTION3 = '3';
KEY_OPTION4 = '4';
KEY_BACK = 'b';
KEY_QUIT = 'q';
KEY_NEW = 'n';


//----------------------------------------------------------------------------//
MENU_TITLE = 0;
MENU_MAIN = 1;
MENU_NAV = 2;
MENU_TRADE = 3;
MENU_MAINT = 4;
