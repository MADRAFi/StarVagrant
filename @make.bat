cd Intro
D:\Atari\MAD_PASCAL\mp.exe scroll.pas
D:\Atari\MAD_PASCAL\mads.exe scroll.a65 -x -i:D:\Atari\MAD_PASCAL\base -o:intro.xex
cd ..
D:\Atari\MAD_PASCAL\mp.exe starvagrant.pas
D:\Atari\MAD_PASCAL\mads.exe starvagrant.a65 -x -i:D:\Atari\MAD_PASCAL\base -o:starvagrant.xex
copy /Y Intro\intro.xex Release\AUTORUN
copy /Y starvagrant.xex Release\starv.xex
D:\Atari\tools\dir2atr -md -B D:\Atari\tools\xboot.obx starvagrant.atr Release
pause
