# bzu-gmb
bzu-gmb is auto-installer linux gaming tools,  development, graphic\video editors for Ubuntu\Linux Mint and other debian-based distributions in experimental mode, written in bash using zenity and yad libraries
-----------
<img src="image/bzu-gmb-beta4-7.png" alt="My cool logo"/>

Options
-----------
Ready modules: XanMod, Xanmod-cacule, Mesa Oibaf, Mesa Kisak, Feral GameMode, MangoHud, vkBazalt, CoreCtrl, CoreCtrl 2.0, Psensor, inxi, Glances, cpu-x, xboxdrv, Steam Linux, ProtonGE, PortWINE adon, PortProton, Furmark_Pack(OpenGL Benchmark, ZINK), TFM_Vulkan(Benchmark), gdebi, GnomeExtensionsPack, mangohud-ppa, vkbasalt-ppa, Goverlay-ppa, obs-studio-ppa, Kdenlive-ppa, SimpleScreenRecorder-ppa, Lossless-Cut-appimage, Blender-ppa, vscodium-portable-1.61.1, visual-studio-code-ppa, godot-ppa, godot-portable, Kate-editor-ppa, Krita-ppa, Inkscape-ppa, GIMP-ppa, pinta-ppa, Celluloid-ppa, Audacity-ppa, Audacious-ppa, Thunderbird-ppa, Qpdf-tools-ppa, Simple-scan-ppa, BackToGnomeVanilla, GnomeExtensionsPack2 for Ubuntu 21.10\Debian-testing

Installation Ubuntu\Linux Mint:
-----------
Go to [Releases](https://github.com/redrootmin/bzu-gmb/releases)

latest version installing in user space
Go to terminal (CTRL+ALT+T)and copy commands:
```
cd;rm -rf bzu-gmb*;rm -f bzu-gmb*;rm -f *bzu-gmb;wget https://github.com/redrootmin/bzu-gmb/archive/refs/heads/dev.zip -O bzu-gmb-dev.zip;unzip bzu-gmb-dev.zip;cd ~/bzu-gmb-dev;chmod +x mini_install.sh;bash mini_install.sh
```
Installation Debian-testing:
-----------

latest version installing in user space
Go to terminal and copy commands:
```
su
```
```
/sbin/usermod -aG sudo $USER
```
```
echo "deb http://deb.debian.org/debian/ bookworm main" >> /etc/apt/sources.list;echo "deb-src http://deb.debian.org/debian/ bookworm main" > /etc/apt/sources.list;echo "deb http://security.debian.org/ bookworm/updates main contrib non-free" > /etc/apt/sources.list;echo "deb-src http://security.debian.org/ bookworm/updates main contrib non-free" > /etc/apt/sources.list;echo "deb http://ftp.debian.org/debian bookworm-backports main contrib non-free" > /etc/apt/sources.list;echo "deb http://security.debian.org/debian-security bookworm-security main contrib non-free" > /etc/apt/sources.list;sudo echo "deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free" > /etc/apt/sources.list
```
REBOOT!
-----------
```
cd;rm -rf bzu-gmb*;rm -f bzu-gmb*;rm -f *bzu-gmb;wget https://github.com/redrootmin/bzu-gmb/archive/refs/heads/dev.zip -O bzu-gmb-dev.zip;unzip bzu-gmb-dev.zip;cd ~/bzu-gmb-dev;chmod +x mini_install.sh;bash mini_install.sh
```

TODO:
-----------
- Add Experemintal Mode - DONE
- Add auto-update-system tools
- Add beta5  new functionality, new multimedia modules, customize Ubuntu  - DONE
- 
DONATE:
-----------
- [Юmoney] https://donate.stream/gamer-station-on-linux
