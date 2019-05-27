cd loader
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe loader.asm -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:loader.xex

cd ..\Intro
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mp.exe intro.pas -code:0c00
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe intro.a65 -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:intro.xex
cd ..
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mp.exe starv.pas -code:0c00
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe starv.a65 -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:starv.xex
copy /Y D:\Atari\Soft\tools\xbios.com Release\xbios.com
rem copy /Y D:\Atari\Soft\tools\xbios.cfg Release\xbios.cfg
copy /Y Loader\loader.xex Release\XAUTORUN
copy /Y Intro\intro.xex Release\intro.xex
copy /Y starv.xex Release\starv.xex
D:\Atari\Soft\tools\dir2atr -md -B D:\Atari\Soft\tools\xboot.obx starvagrant.atr Release
pause
