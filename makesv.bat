cd loader
D:\Atari\MAD_PASCAL\mads.exe loader.asm -x -i:D:\Atari\MAD_PASCAL\base -o:loader.xex
cd ..
D:\Atari\MAD_PASCAL\mp.exe starvagrant.pas -code:$0c00
D:\Atari\MAD_PASCAL\mads.exe starvagrant.a65 -x -i:D:\Atari\MAD_PASCAL\base -o:starvagrant.xex
copy /Y D:\Atari\tools\xbios.com Release\xbios.com
copy /Y D:\Atari\tools\xbios.cfg Release\xbios.cfg
copy /Y Loader\loader.xex Release\XAUTORUN
copy /Y starvagrant.xex Release\starv.xex
D:\Atari\tools\dir2atr -md -B D:\Atari\tools\xboot.obx starvagrant.atr Release
pause
