@echo "导出log"
adb pull /sdcard/monkey_system.log monkey_logs/monkey_system.log

@echo "抓出mtklog" 
adb pull /mnt/sdcard2/mtklog mtklog 

@echo "抓出trace" 
adb pull /data/anr mtklog/anr 

@echo "抓出data aee db" 
adb pull /data/aee_exp mtklog/data_aee_exp 

@echo "抓出data mobilelog" 
adb pull /data/mobilelog mtklog/data_mobilelog 

@echo "抓出NE core" 
adb pull /data/core mtklog/data_core 

@echo "抓出tombstones" 
adb pull /data/tombstones mtklog/tombstones 

@echo "完成" 

pause 