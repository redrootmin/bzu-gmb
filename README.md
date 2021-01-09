# bzu-gmb
bzu-gmb is an auto-installer of GNU/Linux gaming tools for Debian-based distributions, written in bash using zenity and yad libraries
-----------
<img src="image/bzu-gmb-beta4-7.png" alt="My cool logo"/>

Options
-----------
Ready modules for Ubuntu: XanMod, Xanmod-cacule, Liquorix, Low-Latency kernel, Mesa Oibaf, Mesa Kisak, Feral GameMode, MangoHud, vkBazalt, CoreCtrl, Psensor, Inxi, Glances, CPU-X, Xboxdrv, Steam, ProtonGE, PortProton, Furmark_Pack (OpenGL Benchmark), TFM_Vulkan (Benchmark), Gdebi.

Not ready modules for Linux Mint 19.3: Feral GameMode, CoreCtrl.

Installation:
-----------
Go to [Releases](https://github.com/redrootmin/bzu-gmb/releases)

Download the latest bzu-gmb version to user space (/home/user/)

Go to terminal and type the following commands:
```
tar -xpJf bzu-gmb-beta4-installer.tar.xz

cd ~/bzu-gmb

chmod +x bzu-gmb-beta4-installer.sh

./bzu-gmb-beta4-installer.sh
```

TODO:
-----------
- Add modules: psensor + config, new benchmarks, proton-rdr2, portwine ports

- Add REOS support (testing)

- Add Pop!_OS support (testing)

- Add new modules and update old ones

- Test new modules from other authors (if they are)

- Add beta5 version: fix bugs, add new functionality, test new multimedia modules, customize Ubuntu
