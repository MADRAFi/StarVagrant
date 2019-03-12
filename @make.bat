cd Intro
rem D:\Atari\MAD_PASCAL\mp.exe intro.pas
rem D:\Atari\MAD_PASCAL\mads.exe intro.a65 -x -i:D:\Atari\MAD_PASCAL\base -o:intro.xex
cd ..
D:\Atari\MAD_PASCAL\mp.exe starvagrant.pas
D:\Atari\MAD_PASCAL\mads.exe starvagrant.a65 -x -i:D:\Atari\MAD_PASCAL\base -o:starvagrant.xex
copy /Y D:\Atari\tools\xbios.com Release\xbios.com
copy /Y D:\Atari\tools\xbios.cfg Release\xbios.cfg
rem copy /Y Intro\intro.xex Release\XAUTORUN
copy /Y starvagrant.xex Release\starv.xex
rem copy /Y starvagrant.xex Release\XAUTORUN
D:\Atari\tools\dir2atr -md -B D:\Atari\tools\xboot.obx starvagrant.atr Release
pause
