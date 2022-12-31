#!/bin/bash
myip="192.168.1.3";
adb connect $myip
adb connect 192.168.1.6
adb connect 192.168.1.4
adb connect 192.168.1.5
sleep 2

adb shell dumpsys power | grep 'state=';
adb shell su -c echo 'temp:';
adb shell echo "App running:";
focusapp=$(adb shell dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp');
echo $focusapp ;

#TEMPERATURE
for i in {1..5}
do
sleep 1;

temp=$(adb shell su -c cat /sys/devices/virtual/thermal/thermal_zone1/temp);
echo '';
echo "TEMPERATURE:  "${temp:0:2}'°c'; 
echo -—------ ; 
counter=$(($counter+1));
done;

##end temperature

#CPU RAM UASAGE
adb shell top -n 3 -m 4


#NETWORK UASAGE

function getUsage () 
{ 
    rb=0;
    tb=0;
    for a in $(adb shell dumpsys netstats|grep "rb="|cut -d "=" -f 3|cut -d " " -f 1);
    do
        rb=$((rb+a/1024));
    done;
    rb=$((rb/2));
    for a in $(adb shell dumpsys netstats|grep "rb="|cut -d "=" -f 5|cut -d " " -f 1);
    do
        tb=$((tb+a/1024));
    done;
    tb=$((tb/2));
    echo RX: $rb Kb TX: $tb Kb
    echo Total: $(((rb+tb)/1024)) Mb
    
};

for i in {1..1}

do
sleep 2;
getUsage
done



adb disconnect 

