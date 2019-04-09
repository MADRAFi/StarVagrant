#!/bin/bash
cd Loader
~/Applications/MAD_PASCAL/mads loader.asm -x -i:/Applications/MAD_PASCAL/base -o:loader.xex
cd ..
~/Applications/MAD_PASCAL/mp starvagrant.pas -code:0c00
~/Applications/MAD_PASCAL/mads starvagrant.a65 -x -i:~/Applications/MAD_PASCAL/base -o:starvagrant.xex
cp ~/Applications/xbios/xbios.com Release/xbios.com
# cp D:\Atari\tools\xbios.cfg Release\xbios.cfg
cp Loader/loader.xex Release/XAUTORUN
cp starvagrant.xex Release/starv.xex
# cp starvagrant.xex Release/XAUTORUN
~/Applications/atrtools/dir2atr -md -B ~/Applications/xbios/xboot.obx starvagrant.atr Release
