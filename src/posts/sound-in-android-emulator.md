---
title: "Sound in the Android emulator"
date: 2008-09-20
tags: [android]
description: "Getting sound to work in the Android emulator on Linux with OSS audio."
layout: layouts/post.njk
---

The Android application I'm developing needs sound, unfortunately I couldn't get sound to work!

## How to check sound

The easiest way to test whether you have sound working is to click on the volume buttons (right-hand side of the emulated phone).

Another way to check if something is wrong is the message "using stubbed audio hardware" in the startup log. My solution doesn't remove this line though.

## Failed attempt using symlinking

My pc runs Linux (Gentoo) with Alsa sound support. The emulator searches for `/dev/eac` which is not present on my system, so the first thing to do was to make a symlink to `/dev/dsp`. This failed, but I'm not excluding this method might work. Let me know if you succeeded.

## Solution using OSS audio

Start the emulator with the following options:

```
./emulator -audio oss
```

OSS is the older audio stack for Linux, I'm surprised it worked but hey, at least I can continue developing now!
