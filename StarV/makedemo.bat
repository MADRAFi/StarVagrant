
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mp.exe starv.pas -code:0c00 -define:EN -define:DEMO
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe starv.a65 -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:DEMO\svdemo.xex
copy /Y DEMO\svdemo.xex ..\..\Release\SourceDisk\starv.xex
copy /Y ..\Intro\EN\intrdemo.xex ..\..\Release\SourceDisk\intro.xex
D:\Atari\Soft\tools\dir2atr -md -B D:\Atari\Soft\tools\xboot.obx c:\Users\MADRAFi\Dropbox\Atari\DEV\StarVagrant\Release\svdemo.atr c:\Users\MADRAFi\Dropbox\Atari\DEV\StarVagrant\Release\SourceDisk\
pause
