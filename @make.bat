D:\Atari\MAD_PASCAL\mp.exe starvagrant.pas
D:\Atari\MAD_PASCAL\mads.exe starvagrant.a65 -x -i:D:\Atari\MAD_PASCAL\base -o:starvagrant.xex
copy /Y starvagrant.xex Release\XAUTORUN
copy /Y D:\Atari\tools\xbios.com Release\
D:\Atari\tools\dir2atr -md -B D:\Atari\tools\xboot.obx starvagrant.atr Release
pause
