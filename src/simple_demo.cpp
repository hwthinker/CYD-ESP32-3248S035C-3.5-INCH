// ESP32-3248S035C (3.5" landscape 480x320, GT911 touch) - simple LVGL demo (label saja)
// Env PlatformIO: simple_demo
#include <Arduino.h>
#include <esp32_smartdisplay.h>

void setup()
{
    Serial.begin(115200);

    // WAJIB: init LCD + touch + LVGL + backlight
    smartdisplay_init();
    smartdisplay_lcd_set_backlight(1.0f);

    // Panel 3.5" native portrait; putar ke landscape seperti demo utama
    lv_display_set_rotation(lv_display_get_default(), LV_DISPLAY_ROTATION_90);

    lv_obj_t *label = lv_label_create(lv_screen_active());
    lv_label_set_text(label, "Halo dari ESP32-S3!");
    lv_obj_set_style_text_font(label, &lv_font_montserrat_24, 0);
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
