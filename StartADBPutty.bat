@echo OFF
mode con cols=15 lines=2
ECHO Loading...
adb.exe kill-server >nul 2>nul
taskkill /f /im "adb.exe" >nul 2>nul
taskkill /f /im "tadb.exe" >nul 2>nul
taskkill /f /fi "imagename eq wandoujia*" >nul 2>nul
taskkill /f /im "AndroidInterface.exe" >nul 2>nul
taskkill /f /im "Android PC Suite.exe" >nul 2>nul
taskkill /f /im "360MobileMgr.exe" >nul 2>nul
netstat -p TCP -n -o -a | findstr ":5037" > port
for /f "tokens=5 delims= " %%a in (port) do taskkill /F /PID %%a >nul 2>nul
del /f /q port >nul 2>nul
adb.exe start-server >nul
reg add "HKCU\Software\SimonTatham\PuTTY\Sessions\Default%%20Settings" /v "CloseOnExit" /t REG_DWORD /d 0x00000002 /f >nul
reg add "HKCU\Software\SimonTatham\PuTTY\Sessions\Default%%20Settings" /v "WarnOnClose" /t REG_DWORD /d 0x00000000 /f >nul
reg add "HKCU\Software\SimonTatham\PuTTY\Sessions\Default%%20Settings" /v "BlinkCur" /t REG_DWORD /d 0x00000001 /f >nul
reg add "HKCU\Software\SimonTatham\PuTTY\Sessions\Default%%20Settings" /v "Font" /t REG_SZ /d "Fixedsys" /f >nul
reg add "HKCU\Software\SimonTatham\PuTTY\Sessions\Default%%20Settings" /v "FontCharSet" /t REG_DWORD /d 0x000003a8 /f >nul
reg add "HKCU\Software\SimonTatham\PuTTY\Sessions\Default%%20Settings" /v "MouseOverride" /t REG_DWORD /d 0x00000001 /f >nul
reg add "HKCU\Software\SimonTatham\PuTTY\Sessions\Default%%20Settings" /v "RectSelect" /t REG_DWORD /d 0x00000000 /f >nul
reg add "HKCU\Software\SimonTatham\PuTTY\Sessions\Default%%20Settings" /v "FontIsBold" /t REG_DWORD /d 0x00000000 /f >nul
reg add "HKCU\Software\SimonTatham\PuTTY\Sessions\Default%%20Settings" /v "FontHeight" /t REG_DWORD /d 0x0000000a /f >nul
reg add "HKCU\Software\SimonTatham\PuTTY\Sessions\Default%%20Settings" /v "TermWidth" /t REG_DWORD /d 0x0000006a /f >nul
reg add "HKCU\Software\SimonTatham\PuTTY\Sessions\Default%%20Settings" /v "TermHeight" /t REG_DWORD /d 0x00000020 /f >nul
start adbputty.exe -adb transport-usb -P 5037
