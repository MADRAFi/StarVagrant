cd loader
rem D:\Atari\MAD_PASCAL\mp.exe loader.pas -code:$0580
rem D:\Atari\MAD_PASCAL\mads.exe loader.a65 -x -i:D:\Atari\MAD_PASCAL\base -o:loader.xex
D:\Atari\MAD_PASCAL\mads.exe loader.asm -x -i:D:\Atari\MAD_PASCAL\base -o:loader.xex

cd ..\Intro
D:\Atari\MAD_PASCAL\mp.exe intro.pas -code:$0c00
D:\Atari\MAD_PASCAL\mads.exe intro.a65 -x -i:D:\Atari\MAD_PASCAL\base -o:intro.xex
cd ..
D:\Atari\MAD_PASCAL\mp.exe starvagrant.pas -code:$0c00
D:\Atari\MAD_PASCAL\mads.exe starvagrant.a65 -x -i:D:\Atari\MAD_PASCAL\base -o:starvagrant.xex
copy /Y D:\Atari\tools\xbios.com Release\xbios.com
rem copy /Y D:\Atari\tools\xbios.cfg Release\xbios.cfg
copy /Y Loader\loader.xex Release\XAUTORUN
copy /Y Intro\intro.xex Release\intro.xex
copy /Y starvagrant.xex Release\starv.xex
rem copy /Y starvagrant.xex Release\XAUTORUN
D:\Atari\tools\dir2atr -md -B D:\Atari\tools\xboot.obx starvagrant.atr Release
pause
