@Echo off
echo Compiling DEMO
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mp.exe starv.pas -code:0c00 -define:EN -define:demo
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe starv.a65 -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:DEMO\svdemo_uncmp.xex
echo.
rem pause
