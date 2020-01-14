@Echo off
echo Compiling DE
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mp.exe intro.pas -code:0c00 -define:DE
c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\mads.exe intro.a65 -x -i:c:\Users\MADRAFi\Dropbox\Atari\DEV\MADS\base -o:DE\intro_uncmp.xex
rem pause