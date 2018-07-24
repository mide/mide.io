---
layout: post
title:  "Listening to the Space Station"
date:   2015-04-12 17:00:00
---

I was told that the International Space Station would be doing a broadcast of some SSTV images on April 12, 2015. The transmission was to celebrate the anniversary of [Yuri Gagarin](https://en.wikipedia.org/wiki/Yuri_Gagarin) becoming the first human in space.

The transmissions were sent from `RS0ISS`, the Russian call sign on the space station, over `145.800 MHz FM` using the [SSTV](https://en.wikipedia.org/wiki/Slow-scan_television) mode PD180. There were twelve different images that were sent between 1000 UTC April 11 until 2130 UTC April 12.

## Hardware Used

I used the following hardware to listen to the space station from my back yard.

- Baofung UV-5R ([$30 on Amazon](https://duckduckgo.com/?q=baofeng+uv-5r+a!))
- A SMA Female to UFH Adapter ([$3 on Amazon](http://a.co/8QF9eQI))
- Android phone for decoding (other software would have worked, too)
- Homemade Two Meter Yagi (See below for parts list)
- Coax

## Antenna Construction

I used [the design by `WB2HOL`](http://theleggios.net/wb2hol/projects/rdf/tape_bm.htm) when building my antenna. I used the following parts when building mine:

- (1) 0.5" x 8" Schedule 40 PVC
- (1) 0.5" x 12.5" Schedule 40 PVC
- (2) 0.5" Schedule 40 PVC Cross
- (1) 0.5" Schedule 40 PVC Tee
- (1) 10' tape measure, 1" thick
- (6) 1.5" Stainless Steel Hose Clamps
- (1) 4.5" wire for the hairpin match
- (1) 0.5" x 2' Schedule 40 PVC (used for the handle)
- Sandpaper or griding tool to prepare tape measure for solder
- Electrical Tape
- Soldering Equipment
- Coax (enough to go from the middle element to your receiver)

That list might seem to be overwhelming, but take a look at the image from `WB2HOL`'s site below. Assembly plans should be clear now. If not, be sure to [read his page](http://theleggios.net/wb2hol/projects/rdf/tape_bm.htm).

![Tape Measure Yagi Design](https://assets.mide.io/blog/2015-04-12/wb2hol-yagi-image.jpg)

It's a good idea to tape off the ends of the cut tape measure - they'll be very sharp and you don't want to hurt yourself.

## Decoding the Images

I used [Robot36 - SSTV Image Decoder](https://play.google.com/store/apps/details?id=xdsopl.robot36&hl=en) ([open source](https://github.com/xdsopl/robot36)) on my Android phone. I had the volume on my UV-5R up high enough that it would activate the microphone on my phone. It was anything but a professional setup, but it worked!

Seeing as this was my first time listening for the space station, I was very excited when I saw anything at all. I'm pretty sure some of the interference you see is from me yelling "I got it!". Next time around, I'd definitely want to use a hard link between the radio and the software to cut back on some of the interference.

![Decoded SSTV Image](https://assets.mide.io/blog/2015-04-12/capture-mine.jpg)

You can see how the image became more distorted as the ISS was going out of range. Unfortunately, my timing cut off the first bit of the image, but I was able to copy most of it. Even with all the noise, it was a great success!

For reference and comparison, this is a much cleaner reception of the same image (possibly a different transmission). The [other images from this set](https://ariss-sstv.blogspot.com/2015/04/series-3-images.html) are all online.

![High Quality Copy](https://assets.mide.io/blog/2015-04-12/capture-clean.jpg)

I also found [a video posted by `K7AGE`](https://youtu.be/yAzX4S4KEyc?t=202) of his setup receiving the same transmission. If you're curious what SSTV looks and sounds like, click the image below to be brought to the video.

[![YouTube Link](https://assets.mide.io/blog/2015-04-12/k7age-space-station-youtube-screenshot.png)](https://youtu.be/yAzX4S4KEyc?t=202)

I had a lot of fun doing this project; it was my first home-made antenna and I heard the space station on it. That's enough of an accomplishment that I'm okay that the picture is grainy and incomplete. I hope to get back out there and maybe one day talk back to the ISS!

You can follow the discussions at [/r/amateurradio](https://redd.it/37zrju), [/r/space](https://redd.it/37zsx9), and on [Hacker News](https://news.ycombinator.com/item?id=9887706).
