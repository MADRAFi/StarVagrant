@Echo off
echo Comiling EN
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mp.exe starv.pas -code:0c00 -define:EN
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe starv.a65 -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:EN\starv_uncmp.xex
echo.
rem pause
