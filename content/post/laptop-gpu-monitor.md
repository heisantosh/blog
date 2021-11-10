---
title: "Linux, Laptop Nvidia GPU and External Monitor"
date: 2021-10-26T11:41:02+05:30
draft: false
---

I have a laptop, an Acer Predator model. When I bought it, Windows 10 Home was installed by default. Linux has been a mainstay in the systems I have owned. In the beginning I kept a dualboot setup of - Windows 10 and Archcraft. It was a much easier Arch distro to start with. I enjoyed it for a while. I used it for work and playing games. This laptop has an NVIDIA GeForce GTX 1650 GPU. I was able to run games like No Man's Sky and Biomutant.

I have an external monitor. One of my gripes with this setup was the desktop was visible on the external monitor only when I'm logged in. Before that I had to open the laptop, do the login, close it and see the desktop show up on the external monitor. I wanted to see the login screen on the external monitor.

Adding to this I see that the polybar scripts that I used was using more CPU than I expected. There were too many updates everyday. And after a certain period the updates keep breaking the rofi themes that I was using. Some of the network modules was not showing the Wifi connection states correctly many times. So, I started looking for a more mainstream Arch distro - with a bigger community and wiki. I didn't want to spend more of my time fixing these issues.

So, I switched to Manjaro GNOME edition. The default setup works fine with the external monitor. But I noticed that on the external monitor it appears a bit janky with the animations. To fix it I planned to use the GPU all the time. After some check on the Arch and Manjaro wiki I found that the option would be install missing Nvidia drivers and use the optimus-manager tool.

One of the things I found out was the HDMI port was directly connected to the GPU. It means to connect to an external monitor the GPU needs to be enabled. The optimus-manager is a tool that allows one to choose the GPU modes - integrated, nvidia and hybrid. If we use the integrated mode (use Intel's integrated GPU) then using the external monitor is not possible. Using the hybrid mode works but there is a significant latency in the GUI, 2/3 seconds of lag. So the only option is to use the nvidia mode.

If we switch the mode, it requires a login and logout of the session to take effect. But the mode switch is not permanent. It resets on reboot. As per the documentation of the [optimus-manager](https://github.com/Askannz/optimus-manager) project, we can specify a kernel param to persist the config- `optimus-manager.startup=nvidia`. And we also need to disable Wayland in the GDM(GNOME Display Manager) configuration.

So, here are the steps.

1. Install propietary Nvidia drivers, on Manjaro this can be done using the "Toolbox"
2. Disable Wayland in GDM config. Set `WaylandEnable` to `false`.
```Bash
❯ cat /etc/gdm/custom.conf       
# GDM configuration storage

[daemon]
# Uncomment the line below to force the login screen to use Xorg
WaylandEnable=false

[security]

[xdmcp]

[chooser]

[debug]
# Uncomment the line below to turn on debugging
#Enable=true

```
3. Add the kernel parameter `optimus-manager.startup=nvidia`. Edit the file `/etc/default/grub` and append the parameter to the `GRUB_CMDLINE_LINUX_DEFALULT`. Then generate the GRUB config.
```Bash
❯ head /etc/default/grub
GRUB_DEFAULT=saved
GRUB_TIMEOUT=5
GRUB_TIMEOUT_STYLE=hidden
GRUB_DISTRIBUTOR="Manjaro"
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash apparmor=1 security=apparmor resume=UUID=11c5fe60-c62c-42f7-95b8-e782c03da6bb udev.log_priority=3 optimus-manager.startup=nvidia"
GRUB_CMDLINE_LINUX=""

# If you want to enable the save default function, uncomment the following
# line, and set GRUB_DEFAULT to saved.
GRUB_SAVEDEFAULT=true
❯ sudo grub-mkconfig -o /boot/grub/grub.cfg
```

4. Reboot.

Now, on the external monitor the GUI is much smoother and I do not see the jankiness anymore.

# 🧈
