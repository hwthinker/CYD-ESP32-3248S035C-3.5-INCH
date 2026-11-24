# ESP32 3.5" CYD (ESP32-3248S035C) — LVGL 9 Widgets Demo

Demo **LVGL 9 Widgets** (halaman *Profile* "Elena Smith" yang legendaris, plus tab *Analytics* dan *Shop*) untuk board **Sunton ESP32-3248S035C** — LCD 3.5 inch **landscape 480×320** dengan **touch kapasitif GT911**.

Project ini siap pakai dengan **PlatformIO**: clone → build → upload, tanpa setting tambahan.

## Hardware

| Item | Keterangan |
|---|---|
| Board | Sunton **ESP32-3248S035C** (huruf **C** = capacitive touch) |
| MCU | ESP32 klasik (dual-core 240 MHz), 4 MB flash, 520 KB SRAM, **tanpa PSRAM** |
| Layar | 3.5" **480×320 landscape**, SPI (ST7796) — panel native portrait 320×480, diputar oleh LVGL |
| Touch | GT911 kapasitif (I²C: SDA 33, SCL 32, RST 25, INT 21) |
| Backlight | GPIO 27 |
| Lainnya | slot microSD, RGB LED (4/16/17), sensor cahaya (GPIO 34), speaker (GPIO 26) |
| USB | chip USB-serial **CH340** |

> Varian **N** (tanpa touch) dan **R** (touch resistif) **tidak** cocok dengan project ini tanpa mengganti file board.

> Catatan orientasi: panel 3.5" ini native **portrait 320×480**. Project ini memutarnya menjadi **landscape 480×320** lewat `lv_display_set_rotation(..., LV_DISPLAY_ROTATION_90)` di `src/main.cpp`; koordinat touch ikut diputar otomatis oleh LVGL.

## Yang dibutuhkan

1. **VS Code** — https://code.visualstudio.com
2. Extension **PlatformIO IDE** (cari "PlatformIO" di tab Extensions VS Code)
3. **Driver CH340** jika board tidak muncul sebagai port COM — https://www.wch-ic.com/downloads/CH341SER_EXE.html
4. Kabel USB **data** (bukan kabel charge saja)

## Firmware siap-flash (tanpa PlatformIO)

Kalau hanya ingin mem-flash board tanpa install VS Code/PlatformIO, gunakan folder [`firmware/`](firmware/). Di dalamnya sudah ada `firmware-merged.bin` (siap flash di alamat `0x0`), binary pendukung, script bantu, dan panduan lengkap esptool: **[firmware/README.md](firmware/README.md)**.

## Dua environment PlatformIO

| Env | Isi | Perintah upload |
|---|---|---|
| `esp32-3248S035C` (**default**) | Demo LVGL Widgets "Elena Smith" (`src/main.cpp`) | `pio run -t upload --upload-port COM33` |
| `simple_demo` | Label sederhana "Halo dari ESP32-S3!" (`src/simple_demo.cpp`) | `pio run -e simple_demo -t upload --upload-port COM33` |

Kalau `-e` tidak ditulis, PlatformIO memakai env default. Folder [`firmware/`](firmware/) tetap berisi **demo Widgets** (bukan `simple_demo`).

## Langkah-langkah

### 1. Download project

```bash
git clone https://github.com/hwthinker/CYD-ESP32-3248S035C-3.5-INCH.git
```

atau klik **Code → Download ZIP** di GitHub, lalu extract.

> ⚠️ **Windows:** taruh project di folder dengan path pendek, misalnya `C:\Users\<nama>\Documents\<nama-repo>`. Path yang sangat panjang (>~80 karakter) bisa membuat compile gagal dengan error `No such file or directory` karena batas 260 karakter Windows.

### 2. Buka di VS Code

**File → Open Folder…** → pilih folder project (yang berisi `platformio.ini`).
PlatformIO otomatis men-download platform ESP32, toolchain, dan LVGL. **Proses pertama bisa 5–15 menit**, tunggu sampai selesai (lihat status bar bawah).

### 3. Build

Klik ikon **✓ (Build)** di status bar bawah, atau di terminal:

```bash
pio run
```

Berhasil jika muncul `[SUCCESS]`.

### 4. Upload ke board (manual — board ini tidak bisa auto-upload)

> ⚠️ **Penting:** modul 3.5" ini **tidak bisa masuk mode download otomatis**. Upload harus lewat urutan tombol di bawah, kalau tidak akan muncul `Wrong boot mode detected` / `Failed to connect`.

1. Colok board ke PC lewat USB.
2. **Tekan dan tahan** tombol **BOOT**.
3. Sambil menahan **BOOT**, **tekan lalu lepas** tombol **RST**.
4. **Lepas** tombol **BOOT**. Board sekarang berada di mode download (layar tetap gelap).
5. Jalankan upload (sesuaikan nomor COM dengan board Anda):

```bash
pio run -t upload --upload-port COM33
```

6. Setelah muncul `[SUCCESS]`, **tekan tombol RST sekali** untuk menjalankan program.

(Lihat nomor port di **Device Manager → Ports (COM & LPT) → USB-SERIAL CH340 (COMxx)**.)

> Kalau upload gagal (`Wrong boot mode detected`, `Failed to connect`, atau `Timed out waiting for packet header`), ulangi langkah 2–4 lalu upload lagi. Pastikan tidak ada aplikasi lain yang memakai port COM tersebut.

### 5. Selesai 🎉

Setelah menekan **RST**, board restart dan menampilkan halaman **Profile Elena Smith** dalam mode **landscape**. Coba sentuh tab **Profile / Analytics / Shop**, slider, switch, dan textbox (keyboard muncul di layar).

Serial monitor (opsional): `pio device monitor`

## Troubleshooting

| Masalah | Solusi |
|---|---|
| `Could not open COMxx ... Access is denied` | Port sedang dipakai aplikasi lain (Arduino IDE, serial monitor, dll). Tutup aplikasi itu, lalu upload lagi. |
| Port COM tidak muncul | Install driver CH340, ganti kabel USB (harus kabel data). |
| `Failed to connect to ESP32` / `Wrong boot mode detected` | Board belum di mode download. Ulangi: **tahan BOOT → klik RST → lepas BOOT**, lalu upload lagi. |
| `Timed out waiting for packet header` | Sama seperti di atas — ulangi urutan BOOT + RST, pastikan kabel USB data dan tidak ada aplikasi lain memakai port COM. |
| Compile error `No such file or directory` pada file yang sebenarnya ada | Path folder project terlalu panjang — pindahkan ke folder yang lebih pendek. |
| `Sketch too big` / flash penuh | Project ini memakai partisi app default (±1.2 MB). Firmware demo ±840 KB, masih muat. Kalau menambah banyak kode, ganti partisi di `boards/esp32-3248S035C.json`. |
| Layar hitam tapi upload sukses | Cek serial monitor; tekan RST. Pastikan board benar varian **3248S035C**. |
| Warna tampak tertukar (merah/biru) | Board ini memakai panel BGR; pastikan `ST7796_DEV_CONFIG_COLOR_SPACE` di `include/board_3248S035C.h` tetap `ESP_LCD_COLOR_SPACE_BGR`. |

## Struktur project

```
├── LICENSE                     # GPL-3.0
├── THIRD_PARTY_NOTICES.md      # lisensi pihak ketiga + daftar modifikasi
├── LICENSES/                   # teks lisensi Apache-2.0 & MIT (LVGL)
├── platformio.ini              # konfigurasi build (espressif32@6.13.0, LVGL 9.6.0)
├── boards/esp32-3248S035C.json # definisi board untuk PlatformIO
├── include/
│   ├── board_3248S035C.h       # semua pin & timing LCD/touch/SD card
│   └── lv_conf.h               # konfigurasi LVGL (demo widgets aktif)
├── lib/esp32_smartdisplay/     # driver LCD + touch (sudah di-patch, lihat bawah)
└── src/
    ├── main.cpp                # env default: init display + lv_demo_widgets()
    ├── simple_demo.cpp         # env simple_demo: contoh UI label sederhana
    └── lvgl_demo/              # wrapper agar source demo LVGL ikut di-compile
```

## Membuat UI sendiri

Ganti **hanya** `lv_demo_widgets();` di `src/main.cpp` dengan widget buatan sendiri. `smartdisplay_init()` dan `smartdisplay_lcd_set_backlight()` **wajib tetap ada** — keduanya yang menginisialisasi LVGL, panel LCD, touch, dan menyalakan backlight. Contoh lengkap yang sudah siap dipakai ada di [`src/simple_demo.cpp`](src/simple_demo.cpp) (env `simple_demo`).

```cpp
#include <Arduino.h>
#include <esp32_smartdisplay.h>
// #include <demos/lv_demos.h>   // tidak perlu kalau tidak memakai demo

void setup()
{
    Serial.begin(115200);

    smartdisplay_init();                  // WAJIB
    smartdisplay_lcd_set_backlight(1.0f); // WAJIB (kecerahan penuh)

    // Board 3.5" native portrait -> landscape
    lv_display_set_rotation(lv_display_get_default(), LV_DISPLAY_ROTATION_90);

    lv_obj_t *label = lv_label_create(lv_screen_active());
    lv_label_set_text(label, "Halo dari ESP32-S3!");
    lv_obj_center(label);
}

auto lv_last_tick = millis();

void loop()
{
    auto const now = millis();
    lv_tick_inc(now - lv_last_tick);
    lv_last_tick = now;
    lv_timer_handler();
}
```

> ⚠️ Kalau `smartdisplay_init()` ikut dihapus/dikomentari, layar akan **gelap**: LVGL belum di-`init`, panel belum dibuat, dan backlight tidak menyala.

Jika demo tidak dipakai lagi, hapus folder `src/lvgl_demo/` dan set `LV_BUILD_DEMOS 0` di `include/lv_conf.h` agar firmware lebih kecil.

## Catatan teknis

- **Platform `espressif32@6.13.0`** (Arduino 2.x / ESP-IDF 4.4) wajib — library `esp32-smartdisplay` belum kompatibel dengan Arduino 3.x / IDF 5.
- **Patch 1** — `lib/esp32_smartdisplay/include/lvgl_panel_common.h`: `esp_lcd_panel_disp_on_off()` mengembalikan `ESP_ERR_NOT_SUPPORTED` pada panel tanpa pin DISP sehingga board bisa boot-loop. Error tersebut sekarang diabaikan.
- **Patch 2 (opsional)** — `lib/esp32_smartdisplay/src/esp_touch_gt911.c`: fallback area sentuh native GT911 bila register resolusinya terbaca 0 (dipakai di project 4.3" 8048S043C_I). Di board 3.5" ini fallback **tidak aktif** karena `GT911_TOUCH_NATIVE_WIDTH` tidak didefinisikan di `board_3248S035C.h`.
- **Tanpa PSRAM**: draw buffer LVGL dialokasikan di RAM internal (`LVGL_BUFFER_PIXELS = W*H/16` ± 19 KB), dan `LV_MEM_SIZE` = 96 KB. RAM statis terpakai ±122 KB dari 320 KB.
- **Rotasi landscape**: `lv_display_set_rotation(..., LV_DISPLAY_ROTATION_90)` di `setup()` memutar panel (MADCTL swap/mirror) dan resolusi LVGL menjadi 480×320. Jika di board lain gambar justru terbalik, ganti ke `LV_DISPLAY_ROTATION_270`.
- **Define hardware** dipindah dari board JSON ke `include/board_3248S035C.h` (force-include via `build_flags`) agar command line compiler tidak melebihi batas 32K karakter Windows.
- Source demo LVGL ada di folder `demos/` yang tidak di-compile otomatis oleh PlatformIO, karena itu ada wrapper di `src/lvgl_demo/`.

## Kredit & lisensi

Project ini dirilis di bawah **GNU GPL v3** (lihat [`LICENSE`](LICENSE)). Boleh dipakai, diubah, dan dibagikan, termasuk untuk komersial, dengan syarat versi yang dibagikan juga tetap GPL-3.0 dan source code-nya tersedia.

- [rzeldent/esp32-smartdisplay](https://github.com/rzeldent/esp32-smartdisplay): driver display/touch (GPL-3.0, sudah dimodifikasi). Di dalamnya ada driver Espressif (Apache-2.0).
- [rzeldent/platformio-espressif32-sunton](https://github.com/rzeldent/platformio-espressif32-sunton): definisi board (GPL-3.0)
- [LVGL](https://lvgl.io): library grafis dan demo Widgets "Elena Smith" (MIT), di-download otomatis saat build.

Daftar lengkap lisensi pihak ketiga dan modifikasi yang dibuat ada di [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md). Teks lisensi pendukungnya ada di folder [`LICENSES/`](LICENSES).
