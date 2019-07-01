#!/bin/bash
cd Loader
../../MADS/mads loader.asm -x -i:../../MADS/base -o:loader.xex
cd ../Intro
../../MADS/mp intro.pas -code:0c00
../../MADS/mads intro.a65 -x -i:../../MADS/base -o:intro.xex
cd ..
../MADS/mp starv.pas -code:0c00
../MADS/mads starv.a65 -x -i:../MADS/base -o:starv.xex
cp ~/Applications/xbios/xbios.com Release/xbios.com
# cp D:\Atari\tools\xbios.cfg Release\xbios.cfg
cp Loader/loader.xex Release/XAUTORUN
cp Intro/intro.xex Release/intro.xex
cp starv.xex Release/starv.xex
~/Applications/atrtools/dir2atr -md -B ~/Applications/xbios/xboot.obx starvagrant.atr Release

