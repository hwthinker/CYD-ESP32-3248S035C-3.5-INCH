#!/usr/bin/env bash
# Flash firmware ESP32-3248S035C (3.5" landscape 480x320)
set -u

PORT="${1:-/dev/ttyUSB0}"
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "============================================================"
echo "  Flash firmware ESP32-3248S035C (3.5\" landscape 480x320)"
echo "  File : firmware-merged.bin  |  Alamat : 0x0"
echo "  Port : $PORT"
echo "============================================================"
echo
echo "SEBELUM melanjutkan, lakukan pada board:"
echo "  1. Tekan dan TAHAN tombol BOOT"
echo "  2. Sambil menahan BOOT, tekan lalu lepas tombol RST"
echo "  3. Lepas tombol BOOT  (layar tetap gelap = mode download)"
echo
read -r -p "Tekan ENTER kalau board sudah di mode download..."
echo

python -m esptool --chip esp32 --port "$PORT" --baud 460800 --before no_reset --after no_reset write_flash 0x0 "$DIR/firmware-merged.bin"

if [ $? -ne 0 ]; then
  echo
  echo "[GAGAL] Ulangi urutan BOOT + RST di atas, lalu jalankan script ini lagi."
  exit 1
fi

echo
echo "[SUKSES] Tekan tombol RST pada board untuk menjalankan program."
