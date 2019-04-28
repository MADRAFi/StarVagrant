#!/bin/bash
cd Loader
../../MADS/mads loader.asm -x -i:../../MADS/base -o:loader.xex
cd ..
../MADS/mp starv.pas -code:0c00
../MADS/mads starv.a65 -x -i:../MADS/base -o:starv.xex
cp ~/Applications/xbios/xbios.com Release/xbios.com
# cp D:\Atari\tools\xbios.cfg Release\xbios.cfg
cp Loader/loader.xex Release/XAUTORUN
cp starv.xex Release/starv.xex
# cp starvagrant.xex Release/XAUTORUN
~/Applications/atrtools/dir2atr -md -B ~/Applications/xbios/xboot.obx starvagrant.atr Release
