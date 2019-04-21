cd loader
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe loader.asm -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:loader.xex
cd ..
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mp.exe starvagrant.pas -code:0c00
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe starvagrant.a65 -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:starvagrant.xex
copy /Y D:\Atari\Soft\tools\xbios.com Release\xbios.com
rem remcopy /Y D:\Atari\Soft\tools\xbios.cfg Release\xbios.cfg
copy /Y Loader\loader.xex Release\XAUTORUN
copy /Y starvagrant.xex Release\starv.xex
D:\Atari\Soft\tools\dir2atr -md -B D:\Atari\Soft\tools\xboot.obx starvagrant.atr Release
pause
