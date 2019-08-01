---
layout: post
title:  "Arduino Controlled LED Fire Strip"
date:   2017-04-12 12:30:00
---

## About the Project

The students at [Nipmuc Regional High School](https://www.mursd.org/o/nipmuc-regional-high-school) recently put on a wonderful performance of [The Wizard of Oz](https://en.wikipedia.org/wiki/The_Wizard_of_Oz_(1939_film)). The whole cast did such a wonderful job, that I forgot I was watching a high school play and felt like I was watching the film.

The [scarecrow](https://en.wikipedia.org/wiki/Scarecrow_(Oz)) has a couple of scenes where he is set on fire by the [wicked witch](https://en.wikipedia.org/wiki/Wicked_Witch_of_the_West). In one scene, it's just a few embers and in the other it's a full flame. Using an Arduino with a switch and an addressable RGB LED strip, we were able to supply some special effects.

<video controls loop>
  <source src="https://assets.mide.io/blog/2017-04-12/led-project-recording.mp4" type="video/mp4">
Your browser does not support the video tag. <a href="https://assets.mide.io/blog/2017-04-12/led-project-recording.mp4">Video link</a>.
</video>

## Construction

### Parts List

- [Arduino](https://store.arduino.cc/usa/arduino-uno-rev3) (Any compatible board will work, I used a [Velleman Atmega328 Uno](http://www.youdoitelectronics.com/velleman-atmega328-uno-development-board-vma100?fee=1&fep=3504))
- 5 Volt, 2 Amp USB Battery (I used an [Anker Astro E1](http://a.co/8dLMTeo))
- [NeoPixel Addressable RGB LED Strip, 1 meter](https://www.adafruit.com/product/1376) (Note the three contacts, _Vin_, _Gnd_, _Din_)
- [SPDT Switch](http://www.youdoitelectronics.com/philmore-mini-3-postion-momentary-toggle-spdt-30-10008?fee=2&fep=8131)
- (Optional) [Switch Boot](http://www.youdoitelectronics.com/philmore-rubber-boot-for-toggle-switch-30-1200?fee=1&fep=955)
- Breadboard Jumper Wires
- Cat5e Cable _(Or at least that's what I had lying around)_
- Heat shrink tubing
- Solder, Flux, Soldering Iron
- Project boxes (I picked mine up at [You Do It Electronics](http://www.youdoitelectronics.com/electronic-parts/storage-project-boxes))

### Assembly

A picture is worth a thousand words, so here is the breadboard diagram (drawn with [Fritzing](http://fritzing.org/home/)). You can download [the project file here](https://assets.mide.io/blog/2017-04-12/fritzing-led-strip-sketch.fzz).

[![Breadboard diagram](https://assets.mide.io/blog/2017-04-12/fritzing-led-strip-export.png)](https://assets.mide.io/blog/2017-04-12/fritzing-led-strip-export.png)

Below is a picture of the completed project so you can zoom in. The Arduino is on, but the switch is in the off position. Please note that a few of the ground pins are switched in the image below.

[![Finished Project](https://assets.mide.io/blog/2017-04-12/led-project-finished.jpg)](https://assets.mide.io/blog/2017-04-12/led-project-finished.jpg)

### Notes

- I am not an electrical engineer, so I have no doubt my wiring may make some people cringe. Perhaps I could have used a breadboard to clean things up, but it works.
- The two resistors are critical in addressing floating pins. Without them, you'll find the Arduino registering a constantly changing value when you expect the pin to be `LOW`.
- It is not suggested to run the LED strip right off the 5V output of the Arduino. Running this much current through the device may cause issues and shorten its lifespan. I knew the lights would only be on for a short time (seconds) so I was not concerned. I did see issues during testing when I had all the LEDs on at full brightness.

## Code

Below is the code that was uploaded onto the device.

**Full disclosure:** it was very late when this was written and I now see many optimizations that could have been made, but that's not what ended up as part of the project. For that reason, here is the actual code that was run during the musical. You may use this as a basis for your project.

```c
// Copyright (c) 2017 Mark Ide Jr <https://www.mide.io>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// ----------------------------------------------------------------------------
//
// This code includes functions and derived works from code published by Pololu
// Corporation. Their code is licensed under the MIT license, and can be found
// below.
//
// ----------------------------------------------------------------------------
//
//     Copyright (c) 2012-2017 Pololu Corporation.  For more information, see
//
//     http://www.pololu.com/
//     http://forum.pololu.com/
//
//     Permission is hereby granted, free of charge, to any person obtaining a
//     copy of this software and associated documentation files (the
//     "Software"), to deal in the Software without restriction, including
//     without limitation the rights to use, copy, modify, merge, publish,
//     distribute, sublicense, and/or sell copies of the Software, and to permit
//     persons to whom the Software is furnished to do so, subject to the
//     following conditions:
//
//     The above copyright notice and this permission notice shall be included
//     in all copies or substantial portions of the Software.
//
//     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
//     NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//     DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//     OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
//     USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// ----------------------------------------------------------------------------

// Load the Pololu Library (https://github.com/pololu/pololu-led-strip-arduino)
#include <PololuLedStrip.h>

// Create an ledStrip object and specify the pin it will use.
PololuLedStrip<12> ledStrip;

// Create a buffer for holding the colors (3 bytes per color).
#define LED_COUNT 30
rgb_color colors[LED_COUNT];

void setup()
{
  // Setup the SPDT switch (Two pins are 4 & 5)
  pinMode(4, INPUT);
  pinMode(5, INPUT);

  // Perform Color Test of LED Strip, allows for the verification the
  // Arduino-LED link is correct (eliminating potential issues with switch.)
  makeLedsSolidColor(5); // RED
  delay(1000);
  makeLedsSolidColor(40); // YELLOW
  delay(1000);
  makeLedsSolidColor(100); // GREEN
  delay(1000);
}

void loop()
{
  // If the switch is in the "Flame" position
  if(digitalRead(4) == 1)
  {
    setFlameOn();
  }
  // If the switch is in the "Embers" position
  else if(digitalRead(5) == 1)
  {
    setEmbersOn();
  }
  // Otherwise, turn everything off.
  else
  {
    turnLedsOff();
  }
}

void makeLedsSolidColor(uint16_t value)
{
  for(uint16_t i = 0; i < LED_COUNT; i++)
  {
    colors[i] = hsvToRgb(value, 255, 50);
  }
  ledStrip.write(colors, LED_COUNT);
}

// Converts a color from HSV to RGB.
// h is hue, as a number between 0 and 360.
// s is the saturation, as a number between 0 and 255.
// v is the value, as a number between 0 and 255.
rgb_color hsvToRgb(uint16_t h, uint8_t s, uint8_t v)
{
    uint8_t f = (h % 60) * 255 / 60;
    uint8_t p = (255 - s) * (uint16_t)v / 255;
    uint8_t q = (255 - f * (uint16_t)s / 255) * (uint16_t)v / 255;
    uint8_t t = (255 - (255 - f) * (uint16_t)s / 255) * (uint16_t)v / 255;
    uint8_t r = 0, g = 0, b = 0;
    switch((h / 60) % 6){
        case 0: r = v; g = t; b = p; break;
        case 1: r = q; g = v; b = p; break;
        case 2: r = p; g = v; b = t; break;
        case 3: r = p; g = q; b = v; break;
        case 4: r = t; g = p; b = v; break;
        case 5: r = v; g = p; b = q; break;
    }
    return rgb_color(r, g, b);
}

void turnLedsOff()
{
   for(uint16_t i = 0; i < LED_COUNT; i++)
  {
    colors[i] = hsvToRgb(0, 0, 0);
  }
  ledStrip.write(colors, LED_COUNT);
}

void setEmbersOn()
{
  // Define a color and value (brightness) range that is valid for the ember
  // visual. This function exits after one call.
  int colorRangeStart = 0;
  int colorRangeEnd = 15;
  int valueRangeStart = 0;
  int valueRangeEnd = 100;
  for(uint16_t i = 0; i < LED_COUNT; i++)
  {
    int randomColor = random(colorRangeStart, colorRangeEnd);
    int randomValue = random(valueRangeStart, valueRangeEnd);
    colors[i] = hsvToRgb(randomColor, 255, randomValue);
  }
  ledStrip.write(colors, LED_COUNT);
}

void setFlameOn()
{
  // Define a color and value (brightness) range that is valid for the fire
  // visual. This function exits after one call.
  int colorRangeStart = 0;
  int colorRangeEnd = 22;
  int valueRangeStart = 0;
  int valueRangeEnd = 200;
  for(uint16_t i = 0; i < LED_COUNT; i++)
  {
    int randomColor = random(colorRangeStart, colorRangeEnd);
    int randomValue = random(valueRangeStart, valueRangeEnd);
    colors[i] = hsvToRgb(randomColor, 255, randomValue);
  }
  ledStrip.write(colors, LED_COUNT);
}
```

## Lessons Learned

- Floating pins are wild, but make sense. At first I attempted to construct a proof-of-concept that just had the switch connected directly to `+5V` and `Digital Pin 4`. I figured when the switch was open, the pin would register a `0` because of the lack of connectivity to the `+5V`, but instead it seemed to randomly fluctuate between `1` and `0`. Upon investigation, I tried adding the resistors in, and sure enough that worked.
- There are many different types of LED Strips. Some are addressable (can control lights individually), some are RGB (can make the lights any color), and some are addressable RGB. And to further complicate things, there are different connections to these LED strips. Some have `+5V`, Digital In, and Ground, where others have `+5V`, Clock, Input, and Ground.
