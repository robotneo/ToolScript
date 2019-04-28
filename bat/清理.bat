@echo off
color 0a
title windows10检测病毒清理!
echo ★☆ ★☆ ★☆ ★☆ ★☆★☆★☆ ★☆ ★☆ ★☆ ★☆ ★☆ ★☆★
echo ★☆ ★☆ ★☆ ★☆ ★☆★☆★☆ ★☆ ★☆ ★☆ ★☆ ★☆ ★☆★
echo.★☆ ☆★ ★☆★
echo.★☆ ☆★ ★☆★
echo.★☆ ☆★	正在清理病毒文件，请稍等...... ★☆★
echo ★☆ ☆★ ★☆★
echo.★☆ ☆★ ★☆★
echo ★☆ ★☆ ★☆ ★☆ ★☆★☆★☆ ★☆ ★☆ ★☆ ★☆ ★☆ ★☆★
echo ★☆ ★☆ ★☆ ★☆ ★☆★☆★☆ ★☆ ★☆ ★☆ ★☆ ★☆ ★☆★
echo 检测病毒文件，速度视电脑中毒程度而定。在没看到结尾信息时
echo 请勿关闭本窗口。
echo 正在检测病毒文件中，请稍后......
del /f /s /q %systemdrive%\*.tmp
del /f /s /q %systemdrive%\*._mp
del /f /s /q %systemdrive%\*.log
del /f /s /q %systemdrive%\*.gid
del /f /s /q %systemdrive%\*.chk
del /f /s /q %systemdrive%\*.old
del /f /s /q %systemdrive%\recycled\*.*
del /f /s /q %windir%\*.bak
del /f /s /q %windir%\prefetch\*.*
rd /s /q %windir%\temp & md %windir%\temp
del /f /q %userprofile%\cookies\*.*
del /f /q %userprofile%\recent\*.*
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*"
del /f /s /q "%userprofile%\Local Settings\Temp\*.*"
del /f /s /q "%userprofile%\recent\*.*"
echo ★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★
echo ★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★
echo ★☆ ☆★ ★☆ ☆★
echo.★☆ ☆★ ★☆ ☆★
echo.★☆ ☆★ ★☆ ☆★
echo ★☆ ☆★ ★☆ ☆★
echo ★☆ ☆★ ★☆ ☆★
echo.★☆ ☆★ ★☆ ☆★
echo ★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★
echo ★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★
echo. & pause