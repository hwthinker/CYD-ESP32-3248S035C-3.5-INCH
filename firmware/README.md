# Firmware siap-flash — ESP32-3248S035C (3.5" landscape 480×320)

Folder ini berisi firmware **LVGL 9 Widgets Demo** yang sudah jadi, untuk di-flash **tanpa VS Code / PlatformIO**, hanya dengan **esptool**.

## Isi folder

| File | Alamat flash | Keterangan |
|---|---|---|
| `firmware-merged.bin` | **0x0** | Semua bagian digabung jadi satu file — **paling mudah** |
| `bootloader.bin` | 0x1000 | Bootloader ESP32 |
| `partitions.bin` | 0x8000 | Tabel partisi (4 MB) |
| `boot_app0.bin` | 0xe000 | Data OTA boot |
| `firmware.bin` | 0x10000 | Aplikasi (demo LVGL) |
| `SHA256SUMS.txt` | — | Checksum untuk verifikasi file |
| `flash.bat` | — | Script bantu Windows |
| `flash.sh` | — | Script bantu Linux/macOS |

Firmware dibangun dari source commit **79f4b91** (tampilan **landscape 480×320**, touch GT911 kapasitif).

## Yang dibutuhkan

1. **Python 3** — https://www.python.org/downloads/ (centang *Add Python to PATH* saat install)
2. **esptool**:
   ```bash
   pip install esptool
   ```
3. **Driver CH340** (kalau port COM belum muncul) — https://www.wch-ic.com/downloads/CH341SER_EXE.html
4. Kabel USB **data**

Cek instalasi:

```bash
python -m esptool version
```

## Langkah 1 — Masukkan board ke mode download (WAJIB manual)

Modul ini **tidak bisa auto-upload**, jadi lakukan urutan berikut:

1. Colok board ke PC.
2. **Tekan dan tahan** tombol **BOOT**.
3. Sambil menahan **BOOT**, **tekan lalu lepas** tombol **RST**.
4. **Lepas** tombol **BOOT**.

Board sekarang di mode download (layar tetap gelap). Jangan cabut USB.

## Langkah 2 — Flash firmware

Sesuaikan `COM33` dengan port board Anda (lihat **Device Manager → Ports (COM & LPT) → USB-SERIAL CH340 (COMxx)**).

### Cara A — satu file (disarankan)

```bash
python -m esptool --chip esp32 --port COM33 --baud 460800 --before no_reset --after no_reset write_flash 0x0 firmware-merged.bin
```

### Cara B — file terpisah

```bash
python -m esptool --chip esp32 --port COM33 --baud 460800 --before no_reset --after no_reset write_flash 0x1000 bootloader.bin 0x8000 partitions.bin 0xe000 boot_app0.bin 0x10000 firmware.bin
```

### Hapus flash dulu (opsional, kalau firmware lama bermasalah)

```bash
python -m esptool --chip esp32 --port COM33 --baud 460800 --before no_reset --after no_reset erase_flash
```

> Opsi `--before no_reset --after no_reset` dipakai karena board sudah dimasukkan ke mode download secara manual. Jangan biarkan esptool melakukan reset otomatis — pada modul ini auto-reset tidak reliable.

Setelah itu jalankan Cara A lagi.

## Langkah 3 — Jalankan program

Setelah muncul `Hash of data verified.` dan `Hard resetting...`:

**Tekan tombol RST sekali.** Board akan boot dan menampilkan halaman **Profile "Elena Smith"** dalam mode landscape.

## Menggunakan script bantu

Windows (PowerShell / CMD), dari folder ini:

```bat
flash.bat COM33
```

Linux/macOS:

```bash
chmod +x flash.sh
./flash.sh /dev/ttyUSB0
```

Script akan mengingatkan urutan BOOT+RST, mem-flash `firmware-merged.bin` di alamat 0x0, lalu meminta Anda menekan RST.

## Troubleshooting

| Masalah | Solusi |
|---|---|
| `Failed to connect to ESP32` / `Wrong boot mode detected` | Board belum di mode download. Ulangi: **tahan BOOT → klik RST → lepas BOOT**, lalu flash lagi. |
| `Timed out waiting for packet header` | Sama seperti di atas. Coba turunkan baud ke `115200`. |
| `could not open port 'COM33'` | Port salah atau dipakai aplikasi lain (Arduino IDE, serial monitor, PuTTY). Tutup aplikasi itu. |
| `esptool: command not found` / `No module named esptool` | Jalankan `pip install esptool` (atau `py -m pip install esptool` di Windows). |
| Port COM tidak muncul | Install driver CH340 dan pakai kabel USB data. |
| Flash sukses tapi layar hitam | Tekan **RST**. Pastikan board varian **3248S035C** (bukan N/R). |
| Layar menyala tapi warna aneh | Firmware ini untuk panel BGR; jangan pakai firmware board lain. |

## Verifikasi checksum (opsional)

Windows:

```powershell
Get-FileHash firmware-merged.bin -Algorithm SHA256
```

Linux/macOS:

```bash
sha256sum -c SHA256SUMS.txt
```

## Catatan

- Alamat flash di atas **khusus ESP32 klasik** (bukan ESP32-S3). Untuk board 4.3" (ESP32-S3) firmware-nya berbeda.
- Jangan flash `firmware-merged.bin` ke alamat selain **0x0**.
- Setelah flash, seluruh isi flash (termasuk partisi OTA) diganti; data pengguna di flash akan hilang.
