---
layout: post
title:  "Server Traffic Light"
date:   2015-04-20 16:12:48
---

Some time ago, I read about [Greg Borenstein's GitHub Stoplight Project](http://urbanhonking.com/ideasfordozens/2010/05/19/the_github_stoplight/) and I thought how awesome it would be if I could do something of the sort at my company. So I set off to build one.

A technical guide is on [my GitHub](https://github.com/mide/traffic-light-controller), complete with instructions and a parts list. This writeup is more of the journey than anything else.

## Proof of Concept

Before investing too much into this project, I wanted to make sure it was something that was possible. The first version of the light consisted of a handful of resistors, some LEDs and a Raspberry Pi; at this point in the project there were no relays or large lights.

![Taffic Light Version 1.0](https://i.imgur.com/qmjnEAt.jpg)

Once I had [the code written](https://github.com/mide/traffic-light-controller) and I was sure this was a project that was feasible, I went ahead and bought a toy traffic light.

## Version 1.0

Since the goal of the project wasn't to have a couple LEDs sitting on my desk, I bought a toy traffic light and a relay board. Thankfully, [the board I picked up](http://amzn.com/B0057OC5O8) had transistors built in to allow the Raspberry Pi's 3.3 volt GPIO pins to trigger the relays.

The lights in [the toy I bought](http://amzn.com/B004YE2934) would blink randomly, so I figured I'd just cut out their logic board and put in my own. To my surprise, there was no logic board - the light sockets were fitted with [blinking C7 lights](https://duckduckgo.com/?q=+C7+Light+Bulb&iax=1&ia=images). Easily enough, switching the light bulbs provided the "always on" logic I needed.

I was able to fit the relay board and all the high voltage wires inside the toy casing. I drilled a small hole out the back for the jumper wires to get to the Raspberry Pi. There wasn't any fancy mounting done with the Raspberry Pi - it just sat next to the light, which was okay because it looked cool.

![Taffic Light Version 1.0](https://i.imgur.com/0AaiyCk.jpg)

With the initial vesion of the project live, jokes in the office started to rise about how much better a real traffic light would be. It was hard to debate the fact that the existing light was small and there wasn't a good spot for it anymore (we just moved offices). So The quest began for a real traffic light.

## Version 2.0

I found a [seller on eBay](Traffic Light !ebay) that had some retired traffic lights, so I grabbed one that seemed to be in reasonable condition. It was advertised that it came with the controller circuit, but that didn't really matter since I was going to gut it and put in my own logic.

I was careful when picking the unit to find one that ran at 120 volts AC, so it could be run off regular household voltage. The unit I found also had LED lamps, so I'm not concerned about it being on all the time.

Wiring the full size light was no different from wiring the toy, except the full size light actually had more room inside. While the lamps were large (12" diameter), there was enough space behind them to fit the relay board, wires and whatever else I needed. I could have stuck the Raspberry Pi in there too, but I decided it was best for wifi and future maintenance to keep it accessible.

![Taffic Light Version 2.0](https://i.imgur.com/BaaSthn.jpg)

The light is now live in our office and shows the state of our servers, updated every minute. If one of our monitoring services reports an issue, we'll know almost immediately by the change in colors (along with a bunch of emails, of course).

## Lessons Learned

- The Raspberry Pi GPIO pins only output 3.3 volts - which would not have been high enough to trigger the 5 volt relay. I really lucked out that the relay board uses the Raspberry Pi's 5 volt line along with the 3.3 volt GPIO pins and transistors to trigger the relays.
- While the Raspberry Pi is awesome, it's still fairly limited. You've got to think small to get your programs to run efficiently. The original plan (years ago) for this app was to parse our public uptime page and look for outages that way, but XML/HTML processing was far too memory intensive. Thankfully, when we added [PagerDuty](https://pagerduty.com) to our stack, they had an API that we could use.
- The relays I have on my board need a low GPIO pin output to close the circuit and a hgih GPIO pin output to open the circuit. This is exactly the opposite to what I was expecting, so there is a mapping in my script that corrects for that.
