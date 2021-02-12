# i2s-toneplayer
SystemVerilog I2S target, interfaces with an I2S controller.  Controller sources WS and SCK

Uses a 32 entry 16-bit wide ROM look up table (LUT).  Programmed in this iteration to output a 1kHz tone when WS is high with a 16kHz SCK.

Tested on an Intel 10M50 FPGA EVB connected to a Raspberry Pi 3's I2s pins with Adafruit's I2S microphone script installed https://learn.adafruit.com/adafruit-i2s-mems-microphone-breakout/raspberry-pi-wiring-test.
