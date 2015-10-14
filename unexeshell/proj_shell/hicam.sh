#!system/bin/sh
i=1;
name=$1;
time=` date +%Y_%m_%d_%H_%M_%S`;
echo "" >/sdcard/${time}${name}.txt;
echo "     时间        电量电流 电压 温度" >>/sdcard/${time}${name}.txt; 
while [ i -gt 0 ];do 
  _TEMP=`cat /sys/class/power_supply/battery/batt_temp` ;
  _mA=`cat /sys/devices/platform/battery/FG_Battery_CurrentConsumption`;
  _mV=`cat /sys/class/power_supply/battery/batt_vol` ; 
  _POWER=`cat /sys/class/power_supply/battery/capacity`;
  _date=` date +"%Y/%m/%d %H:%M"`;
  `echo ${_date},${_POWER},${_mA},${_mV},${_TEMP} >>/sdcard/${time}${name}.txt`;
  sleep 5;
done 

