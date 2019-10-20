// stale

FREE_TOP = $AC00;
// FREE_TOP = $AE80;

PLAYER_ADDRESS = FREE_TOP;
MODULE_ADDRESS = PLAYER_ADDRESS + $800;

PMG_ADDRESS = $BC00;

GFX_ADDRESS = $C000;
TXT_ADDRESS = $D800;

LOGO_CHARSET_ADDRESS  = $DC00;
LOGO_CHARSET_ADDRESS2  = LOGO_CHARSET_ADDRESS + $400;
CHARSET_ADDRESS = $E400;

DISPLAY_LIST_ADDRESS_TITLE = CHARSET_ADDRESS + $400;
DISPLAY_LIST_ADDRESS_MENU = DISPLAY_LIST_ADDRESS_TITLE + $100;
DISPLAY_LIST_ADDRESS_CONSOLE = DISPLAY_LIST_ADDRESS_MENU + $100;
LOGODATA_ADDRESS = DISPLAY_LIST_ADDRESS_CONSOLE + $100;
// ***************************************************************************//
NUMBEROFLOCATIONS = 13; // number of locations defined in locations.asm. Needs to match.
NUMBEROFITEMS = 24; // number of items defined in items.asm. Needs to match.
NUMBEROFSHIPS = 3; // number of ships defined in ships array.

MAXSHIPPARAMETERS = 8; // number of ship parameters in ship array
MAXAVAILABLEITEMS = 12; // numer of concurrent items displayed
MAXCARGOSLOTS = 10;  // number of cargo slots
MAXAVAILABLEDESTINATIONS = 6;  // number of destinations from location.

STARTUEC = 10000;
STARTLOCATION = 0;

// ***************************************************************************//

MENU_TITLE = 0;
MENU_MAIN = 1;
MENU_NAV = 2;
MENU_TRADE = 3;
MENU_MAINT = 4;
MENU_SHIP = 5;
MENU_SAVE = 6;
MENU_LOAD = 7;
MENU_CREDITS = 8;
