#!/bin/python2
import sys
import re
path=sys.argv[1]
duration=open(path+"/Duration.dat",'r')
pitch=open(path+"/Pitch.f0",'r')
lines=duration.readlines()
lines2=pitch.readlines()
duration.close()
pitch.close()
ptime=0
ptime2=0
psound='SIL'
count=0
for i in range(0,len(lines)):
    dur=lines[i][0:-2]
    pit=lines2[i][0:-2]
    pit=pit.replace("X","0")
    pit=pit.replace("SIL","")
    data=dur.split(',')
    data2=pit.split(',')
    time=float(data[3])
    time2=float(data[2])
    sound=data[0]
    if ptime!=time:
        count=count+1
        if i>0:
            output.close()
            output2.close()
        output=open(path+"/%04d.dur" %(count),'w');
        output2=open(path+"/%04d.pit" %(count),'w');
        output3=open(path+"/%04d.tone" %(count),'w');
    ptime=time
    psound=sound
    output.write(data[2]+'\n')
    for i in range(0,len(data2)):
        if i>0:
            output2.write(data2[i]+' ')
    output2.write('\n')
    if data[0]!='SIL':
        output3.write(data[0]+data[1]+' ')
    output.flush()
    output2.flush()
print(count)
