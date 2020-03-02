@Echo off
echo Compiling ABBUC
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mp.exe starv.pas -code:0c00 -define:EN -define:abbuc
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe starv.a65 -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:ABBUC\svdemo_uncmp.xex
echo.
rem pause
