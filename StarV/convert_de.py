# -*- coding: utf-8 -*-

# commandline tool for converting polish letters into ATASCII codes
# usage python convert.py inputFile.asm > otputFile.asm

# author: bocianu@gmail.com <Wojciech Bociański>
# modified by MADRAFi
import sys
import re

def convertPL(newdata):
    newdata = newdata.replace("ä","'#123'")
    newdata = newdata.replace("ö","'#15'")    
    newdata = newdata.replace("ü","'#14'")

    newdata = newdata.replace("Ä","'#81'")
    newdata = newdata.replace("Ö","'#16'")
    newdata = newdata.replace("Ü","'#13'")
    newdata = newdata.replace("s|s","'#96'")
    # newdata = newdata.replace("ss","ss")
    
    # newdata = newdata.replace(",''",",")
    # newdata = newdata.replace(",,",",")
    return newdata

if len(sys.argv)>1 :
    newdata = '';
    filename = sys.argv[1]
    f = open(filename,'r')
    for line in f:
        if (not re.match("(\t*);(.*)",line)) and (line.strip()!=''):
            line = convertPL(line)
        newdata += line
    f.close()

    print(newdata)
else:
    print('no input file')
