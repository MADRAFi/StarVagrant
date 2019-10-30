c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mp.exe starv.pas -code:0c00 -define:DE
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe starv.a65 -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:DE\starv.xex
copy /Y DE\starv.xex ..\..\Release\SourceDisk\starv.xex
copy /Y ..\Intro\DE\intro.xex ..\..\Release\SourceDisk\intro.xex
D:\Atari\Soft\tools\dir2atr -md -B D:\Atari\Soft\tools\xboot.obx c:\Users\MADRAFi\Dropbox\Atari\DEV\StarVagrant\Release\starvagrant_DE.atr c:\Users\MADRAFi\Dropbox\Atari\DEV\StarVagrant\Release\SourceDisk\
pause
