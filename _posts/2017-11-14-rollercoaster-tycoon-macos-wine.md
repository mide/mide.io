---
layout: post
title:  "RollerCoaster Tycoon on MacOS"
date:   2017-11-14 17:00:00
---

## About

[RollerCoaster Tycoon](https://en.wikipedia.org/wiki/RollerCoaster_Tycoon_(video_game)) is a simulation game where players are tasked with developing and maintaining a theme park; they must keep the park profitable and visitors happy. I remember a middle school friend had the game (I was 9 when this came out) and I was immediately engrossed. I can even remember going to the store with my grandmother to pick out the CD off the shelf, and the overwhelming excitement of bringing it home.

This game was a part of my childhood, and with the recent release of RollerCoaster Tycoon Classic (on [Steam](http://store.steampowered.com/app/683900/RollerCoaster_Tycoon_Classic/), [iOS](https://itunes.apple.com/us/app/rollercoaster-tycoon-classic/id1113736426?mt=8), and [Android](https://play.google.com/store/apps/details?id=com.atari.mobile.rctclassic)), I wanted to revisit that fun. When I installed the game, it was _close_, but not quite right; there were little differences that I wasn't happy with. So I set out to install the original copy (I still have the original CD's along with a backup).

Unfortunately, I have a Mac, so I couldn't just run this in native Windows in [compatibility mode](https://support.microsoft.com/en-us/help/15078/windows-make-older-programs-compatible).

## Running in VirtualBox

My first attempt was to install Windows XP inside [VirtualBox](https://www.virtualbox.org/). The installation went great, but clicking anything in game lagged horribly. For some reason, the game was completely unplayable when running in the virtual environment. I tried using windowed mode, and several different VirtualBox settings, but everything left the game slowing to a halt.

[![Screenshot of VirtualBox](https://assets.mide.io/blog/2017-11-14/rct-in-virtualbox.png)](https://assets.mide.io/blog/2017-11-14/rct-in-virtualbox.png)

## Investigating OpenRCT

The [OpenRCT Project](https://openrct2.org/) is an open source re-implementation of RollerCoaster Tycoon 2 (not 1, as I wanted). Many people want the additional features of RCT2 over RCT1, but I specifically was going for the nostalgia. I think the RCT2 project looks awesome and would recommend looking at it.

## Running in Wine / Wineskin

I found a [great YouTube tutorial](https://www.youtube.com/watch?v=axC8A5suhQw) showing how to install RollerCoaster Tycoon via Wineskin. This tutorial used the [GOG distribution](https://www.gog.com/game/rollercoaster_tycoon_deluxe) of the game. I was hesitant to buy the game, since I already own it, but when I saw "DRM-FREE" I was sold.

[WineHQ](https://www.winehq.org/) does a great job of explaining what Wine is:
> Wine (originally an acronym for "Wine Is Not an Emulator") is a compatibility layer capable of running Windows applications on several POSIX-compliant operating systems, such as Linux, macOS, & BSD. Instead of simulating internal Windows logic like a virtual machine or emulator, Wine translates Windows API calls into POSIX calls on-the-fly, eliminating the performance and memory penalties of other methods and allowing you to cleanly integrate Windows applications into your desktop.

[Wineskin](http://wineskin.urgesoftware.com/) is a wrapper that uses Wine to make user-friendly bundles.

### Install Wineskin Winery

[Wineskin Winery](http://wineskin.urgesoftware.com/) can be installed by simply visiting the site and downloading it. I installed it using [Homebrew](https://brew.sh/) and [Cask](https://caskroom.github.io/); the command below installs it as I did.

```bash
brew cask install wineskin-winery
```

![Screenshot of Winescreen Winery](https://assets.mide.io/blog/2017-11-14/homebrew-wineskin-winery.png)

### Obtain Installation Medium

I had the original CD's, and digital backups of those, but [GOG](https://www.gog.com/game/rollercoaster_tycoon_deluxe) sells RollerCoaster Tycoon as a single installer, which looked simpler for me to install. I'm sure you could use the CD's without too many modifications to this guide.

### Configure Winery

On the first startup of Winery, you'll need to add an engine. _(my screenshot has one listed because I've already done this)_. Click the `+` symbol.

![Screenshot of Winescreen Winery](https://assets.mide.io/blog/2017-11-14/winery-add-engine.png)

I opted to install the latest (`WS9Wine2.16`) engine. Select your version from the dropdown. Once you've picked that, click "Download and Install"

![Screenshot of Winescreen Winery](https://assets.mide.io/blog/2017-11-14/winery-add-engine-2.png)

You'll return to the previous screen, click "Create Blank Wrapper" to carve off a new Wine environment.

![Screenshot of Winescreen Winery](https://assets.mide.io/blog/2017-11-14/winery-create-blank-wrapper-1.png)

You'll need to pick a name for the wrapper; I picked "RollerCoaster Tycoon". This name will show up on the MacOS dock if you end up docking it.

![Screenshot of Winescreen Winery](https://assets.mide.io/blog/2017-11-14/winery-create-blank-wrapper-2.png)

The creation of the wrapper may take a moment, and you may get prompted to allow network connections. Make sure you allow, so that Wine can download needed packages.

![Screenshot of Winescreen Winery](https://assets.mide.io/blog/2017-11-14/winery-allow-firewall.png)

You can then open the wrapper in Finder. If it did not open you can probably find it in the directory, `/Users/$USER/Applications/Wineskin`.

![Screenshot of Winescreen Winery](https://assets.mide.io/blog/2017-11-14/winery-finished.png)

On the first launch you'll likely see "The application RollerCoaster Tycoon can't be opened". **This is normal.** Just relaunch it.

![Screenshot of Winescreen Winery](https://assets.mide.io/blog/2017-11-14/cant-open.png)

![Screenshot of Winescreen Winery](https://assets.mide.io/blog/2017-11-14/winery-start.png)

When the wrapper starts, you may be tempted to start and click "Install Software" but make sure you select "Set Screen Options" first.

[![Screenshot of Winescreen Winery](https://assets.mide.io/blog/2017-11-14/winery-configure.png)](https://assets.mide.io/blog/2017-11-14/winery-configure.png)

### Installing RollerCoaster Tycoon

Clicking "Done" brings you back to the main Wineskin screen. You can now click "Install Software". Browse to the RollerCoaster Tycoon setup `.exe`. If this is your GOG copy, it will be the single file you downloaded.

[![Screenshot of Winescreen Winery](https://assets.mide.io/blog/2017-11-14/winery-select-installer.png)](https://assets.mide.io/blog/2017-11-14/winery-select-installer.png)

The setup will begin shortly. Click "Install" to begin the installation. **When the installation is complete, do not click "Launch Game".** Click "Exit" instead.

[![Screenshot of RCT](https://assets.mide.io/blog/2017-11-14/rct-setup-1.png)](https://assets.mide.io/blog/2017-11-14/rct-setup-1.png)

[![Screenshot of RCT](https://assets.mide.io/blog/2017-11-14/rct-setup-2.png)](https://assets.mide.io/blog/2017-11-14/rct-setup-2.png)

[![Screenshot of RCT](https://assets.mide.io/blog/2017-11-14/rct-install-3.png)](https://assets.mide.io/blog/2017-11-14/rct-install-3.png)

When you click "Exit", Winery will finish some cleanup work and ask you what `.exe` you want to load by default. Likely the default is okay, just make sure it's set to `RCT.exe`. Then click "OK" and "Quit".

[![Screenshot of RCT](https://assets.mide.io/blog/2017-11-14/winery-select-exe.png)](https://assets.mide.io/blog/2017-11-14/winery-select-exe.png)

In order to get the resolution set to something reasonable, open a game, go into Options, set to Windowed mode and then quit. On the next launch, it will be windowed and you can resize to your liking.

### Setting a Custom Launch Icon

If the Winery icon does not represent RCT to you, simply set your own image for the icon. Find an image (perhaps online) and copy the image into your clipboard.

Find the RollerCoaster Tycoon Launcher, right click it and select "Get Info". (You can also press `CMD+i`).

[![Screenshot of RCT](https://assets.mide.io/blog/2017-11-14/get-info-1.png)](https://assets.mide.io/blog/2017-11-14/get-info-1.png)

In the upper left corner of that window, you'll see a small version of the Winery icon. Click it, and then press `CMD+v` to paste.

[![Screenshot of RCT](https://assets.mide.io/blog/2017-11-14/get-info-2.png)](https://assets.mide.io/blog/2017-11-14/get-info-2.png)

That launcher can now be dragged onto your dock to quickly open the game and you can now play the game like it's 1999!

[![Screenshot of RCT](https://assets.mide.io/blog/2017-11-14/desktop-screenshot-2.png)](https://assets.mide.io/blog/2017-11-14/desktop-screenshot-2.png)
