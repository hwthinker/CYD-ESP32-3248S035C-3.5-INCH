@echo off
setlocal
set PORT=%~1
if "%PORT%"=="" set PORT=COM33

echo ============================================================
echo   Flash firmware ESP32-3248S035C (3.5" landscape 480x320)
echo   File : firmware-merged.bin  ^|  Alamat : 0x0
echo   Port : %PORT%
echo ============================================================
echo.
echo SEBELUM melanjutkan, lakukan pada board:
echo   1. Tekan dan TAHAN tombol BOOT
echo   2. Sambil menahan BOOT, tekan lalu lepas tombol RST
echo   3. Lepas tombol BOOT  (layar tetap gelap = mode download)
echo.
pause
echo.

python -m esptool --chip esp32 --port %PORT% --baud 460800 --before no_reset --after no_reset write_flash 0x0 "%~dp0firmware-merged.bin"

if errorlevel 1 (
    echo.
    echo [GAGAL] Ulangi urutan BOOT + RST di atas, lalu jalankan script ini lagi.
) else (
    echo.
    echo [SUKSES] Tekan tombol RST pada board untuk menjalankan program.
)
echo.
pause
