# i2s-toneplayer
Send 16-bit wide I2S audio out over SDO from a LUT.  Synthesizable SystemVerilog I2S target (slave), interfaces with an I2S controller and provides SDO to controller.  Controller sources WS and SCK.  

Uses a 32 entry 16-bit wide ROM look up table (LUT).  Programmed in this iteration to output a 1kHz tone when WS is high with a 16kHz SCK.

Interface Ports
-------------

### i2s_play
<table>
    <tr>
      <td>Name</td> 
      <td>Type</td>
      <td>Width</td>
      <td>Description</td>
    </tr>
  <tr>
    <td>clk</td>
    <td>Input</td>
    <td>1</td>
    <td>System Clock</td>
  </tr>
    <tr>
    <td>sclk</td>
    <td>Input</td>
    <td>1</td>
    <td>i2s controller (master) clock</td>
  </tr>
    <tr>
    <td>reset_n</td>
    <td>Input</td>
    <td>1</td>
    <td>asynchronous reset (active low)</td>
  </tr>
     <tr>
    <td>addr</td>
    <td>Output</td>
    <td>4</td>
    <td>address for ROM</td>
  </tr>
    <tr>
    <td>word_data</td>
    <td>Input</td>
    <td>16</td>
    <td>data word from ROM to be output on sdo.</td>
  </tr>
      <tr>
    <td>ws</td>
    <td>Input</td>
    <td>1</td>
    <td>i2s word select.  Sourced by controller</td>
  </tr>
        <tr>
    <td>sdo</td>
    <td>Output</td>
    <td>1</td>
    <td>i2s serial data out</td>
  </tr>
</table>

## Verification

Simulation -- testbench checked using ModelSim - INTEL FPGA STARTER EDITION 2020.1
Revision: 2020.02

Implemented and tested on an Intel 10M50 FPGA EVB connected to a Raspberry Pi. Raspberry Pi installed with Adafruit's I2S microphone module/script script installed https://learn.adafruit.com/adafruit-i2s-mems-microphone-breakout/raspberry-pi-wiring-test.
