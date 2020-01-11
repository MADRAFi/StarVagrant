
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mp.exe starv.pas -code:0c00 -define:PL
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe starv.a65 -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:PL\starv.xex
copy /Y PL\starv.xex ..\..\Release\SourceDisk\starv.xex
copy /Y ..\Intro\PL\intro.xex ..\..\Release\SourceDisk\intro.xex
copy /Y ..\loader\Xautorun.xex ..\..\Release\SourceDisk\Xautorun
D:\Atari\Soft\tools\dir2atr -md -B D:\Atari\Soft\tools\xboot.obx c:\Users\MADRAFi\Dropbox\Atari\DEV\StarVagrant\Release\starvagrant_PL.atr c:\Users\MADRAFi\Dropbox\Atari\DEV\StarVagrant\Release\SourceDisk\
pause
