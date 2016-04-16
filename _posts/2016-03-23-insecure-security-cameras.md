---
layout: post
title:  "Insecure Security Cameras"
date:   2016-03-23 11:30:00
---

My family purchased a security camera system some time ago to add to our physical security stack. During initial setup, I discovered a handful of issues that left our security system a little insecure. This documents our journey through the sad state of consumer level security camera systems and how we worked around the limitations.

We picked up the `Swann SWDVK-830008-US TruBlue D1 3000` eight camera system.

![Image of Swann DVR](https://assets.mide.io/blog/2016-03-23/swann-dvr-unit.jpg)

## Problems

### Optional Password for Administration

![Web login interface](https://assets.mide.io/blog/2016-03-23/swann-web-login.png)

One of the first things I noticed, was that while the web client had a password field, it was completely optional. You read that correctly - the application will authenticate you regardless of the password you enter. I have no idea how this slipped past [QA](https://en.wikipedia.org/wiki/Quality_assurance), but that's in the past now. It's also worth mentioning that this interface isn't just for viewing. You can perform all sorts of administrative tasks remotely - like turning off camera feeds or deleting recorded footage.

This is the kind of thing that makes me relived I've disabled [UPnP](https://en.wikipedia.org/wiki/Universal_Plug_and_Play#NAT_traversal) on the home router. We really need to treat security as a first-class citizen, otherwise [bad things will happen](http://arstechnica.com/security/2016/01/how-to-search-the-internet-of-things-for-photos-of-sleeping-babies/).

### Requirement of Internet Explorer for Web Client

At the time, I ran [Arch Linux](https://www.archlinux.org/) as my primary operating system and wanted to avoid running Windows just for viewing the cameras. I tried running Internet Explorer in [Wine](https://www.winehq.org/), but the viewer needed to install an ActiveX control that wasn't supported. I'm not even sure I'd consider it a web client if it ran native code on only one operating system.

I eventually wanted to have a couple [RaspberryPi](https://www.raspberrypi.org/) setups with small screens so I could view the cameras remotely, but the requirement of Windows was a hindrance on that.

### Remote Viewer Consumes Massive Resources

![Task manager](https://assets.mide.io/blog/2016-03-23/swann-task-manager.png)

As if the previous points weren't enough of a letdown, whenever you run the Windows client, 100% of your CPU gets consumed by the application. My best guess is that the company either bundled an old codec or rolled their own.

I have a fairly beefy computer, and I couldn't do anything while the client was open. I think it's safe to say that my plans with the RaspberryPi are definitely not going to work out.


## Solutions

### Newer / Different DVR Unit

![Hikvision DVR](https://assets.mide.io/blog/2016-03-23/hikvision-dvr-unit.jpg)

I searched to see if there was a better DVR unit available. I found the `Hikvision DS-7208HVI-SV` that advertised support for Mozilla Firefox - which led me to believe it used either a Flash or HTML5 video player that could be cross platform. In an instant, we bought the vague promise of multi-browser support.

Come to find out, it used [Firefox IE Tab](https://addons.mozilla.org/en-US/firefox/addon/ie-tab/), an extension that uses the native Internet Explorer libraries to render a tab, meaning it still had a dependency on Windows and ActiveX controls. I returned that DVR in a heartbeat.

I was unable to find a reasonably priced DVR unit that had good multi-platform support and used open standards. I am sure there are enterprise level products that meet these requirements, but they're significantly outside our price point.

### Reverse Engineer Protocol

For a while, I seriously considered reverse engineering the protocol and writing my own client. Apparently I wasn't the only one that had thoughts on the matter - [Damien Walsh](http://damow.net/digging-into-dvrs/) and [Console Cowboys](http://console-cowboys.blogspot.com/2013/01/swann-song-dvr-insecurity.html) both did some research into the workings of these systems under the hood. These are both great articles if you're interested in learning more.

Walsh wrote a very complete documentation of the protocol, which you can find [here](https://cl.ly/2W0W2R150a2Z). In his blog he writes:

> ... what you should take away from this is that these things are cheap. They behave as such. The UI is shoddy at best, the compatibility and openness of the standards employed are atrocious and the security is, frankly, awful...

Even if I wrote a new client, it would only fix the cross platform and performance issues. It wouldn't fix the underlying protocol, which was a huge security concern. So I decided not to go forth with that work.

### VNC Over SSH

![VNC Screenshot](https://assets.mide.io/blog/2016-03-23/vnc-screenshot.png)

I ended up using a commodity computer I had around as a VNC server running the Windows native client 24/7. I am able to connect with almost any device over an open protocol.

To solve the security issues, I'm running VNC over SSH, which allows me to leverage [public and private key](https://en.wikipedia.org/wiki/Public-key_cryptography) authentication to the system. Thankfully, there are plenty of VNC clients that have SSH support built in. I use [bVNC Pro: Secure VNC Viewer](https://play.google.com/store/apps/details?id=com.iiordanov.bVNC&hl=en) [[Source](https://github.com/iiordanov/remote-desktop-clients)].

My computer is no longer impacted by the poor performance of the client. I know I only offloaded the workload, but that's fine for now. The computer that's running the client is old but performing well enough for our use.

## Conclusions

The current state of consumer level security camera systems is pretty sad. I was really hoping for some open standards that I could use to my benefit, like custom clients or reports. It's been some time since my initial search, but I'd give more attention to [IP cameras](https://en.wikipedia.org/wiki/IP_camera) on a second pass.

If you're looking to get a camera system, keep in mind the limitations you may hit. And definitely disable [UPnP](https://en.wikipedia.org/wiki/Universal_Plug_and_Play#NAT_traversal)!
