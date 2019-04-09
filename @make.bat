cd loader
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe loader.asm -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:loader.xex

cd ..\Intro
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mp.exe intro.pas -code:0c00
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe intro.a65 -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:intro.xex
cd ..
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mp.exe starvagrant.pas -code:0c00
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe starvagrant.a65 -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:starvagrant.xex
copy /Y D:\Atari\tools\xbios.com Release\xbios.com
rem copy /Y D:\Atari\tools\xbios.cfg Release\xbios.cfg
copy /Y Loader\loader.xex Release\XAUTORUN
copy /Y Intro\intro.xex Release\intro.xex
copy /Y starvagrant.xex Release\starv.xex
D:\Atari\tools\dir2atr -md -B D:\Atari\tools\xboot.obx starvagrant.atr Release
pause
