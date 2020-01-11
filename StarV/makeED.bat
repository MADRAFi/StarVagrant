
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mp.exe starv.pas -code:0c00 -define:EN
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe starv.a65 -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:starv.xex
copy /Y starv.xex ..\..\Release\SourceDisk\starv.xex
del /f ..\..\Release\SourceDisk\intro.xex
copy /Y ..\loader\loader_nointro.xex ..\..\Release\SourceDisk\Xautorun
D:\Atari\Soft\tools\dir2atr -m -E -B D:\Atari\Soft\tools\xboot.obx c:\Users\MADRAFi\Dropbox\Atari\DEV\StarVagrant\Release\starv_ED.atr c:\Users\MADRAFi\Dropbox\Atari\DEV\StarVagrant\Release\SourceDisk\
pause
