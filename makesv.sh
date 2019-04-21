#!/bin/bash
cd Loader
../../MADS/mads loader.asm -x -i:../../MADS/base -o:loader.xex
cd ..
../MADS/mp starvagrant.pas -code:0c00
../MADS/mads starvagrant.a65 -x -i:../MADS/base -o:starvagrant.xex
cp ~/Applications/xbios/xbios.com Release/xbios.com
# cp D:\Atari\tools\xbios.cfg Release\xbios.cfg
cp Loader/loader.xex Release/XAUTORUN
cp starvagrant.xex Release/starv.xex
# cp starvagrant.xex Release/XAUTORUN
~/Applications/atrtools/dir2atr -md -B ~/Applications/xbios/xboot.obx starvagrant.atr Release
