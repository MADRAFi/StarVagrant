#!/bin/bash
../../../MADS/mp starv.pas -code:0c00
../../../MADS/mads starv.a65 -x -i:../../../MADS/base -o:starv.xex
cp starv.xex ../../Release/SourceDisk/starv.xex
~/Applications/atrtools/dir2atr -md -B ~/Applications/xbios/xboot.obx starvagrant.atr ../../Release/SourceDisk
