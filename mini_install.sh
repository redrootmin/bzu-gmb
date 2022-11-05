#!/bin/bash
#creator by RedRoot(Yaciyna Mikhail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License

#проверяем что скрипт установки не запущен от пользователя root
if [ "$UID" -eq 0 ];then
tput setaf 1; echo "Этот скрипт не нужно запускать из под root!";tput sgr0;exit 1
else
tput setaf 2; echo "все хорошо этот скрипт не запущен из под root!"
fi
#собираем данные о том в какой папке находиться bzu-gmb
script_dir=$(cd $(dirname "$0") && pwd);



#запрос пароля root для установки ПО необходимого для bzu-gmb
read -sp 'Введите Пароль root:' pass_user
echo " "


#проверяем ввел пользователь пароль или нет
if [[ "${pass_user}" == "" ]]
then
tput setaf 1; echo "требуется ввести пароль root!"
tput sgr0
sleep 5
exit 0
fi

#системные переменные bzu-gmb
version_bzu_gmb=`cat "${script_dir}/config/name_version"`
app_dir="${script_dir}/modules-temp"
name_desktop_file="bzu-gmb.desktop"
name_icon="icons/bzu-gmb-new320.png"
name_script_start="bzu-gmb-launcher.sh"
name_app="${version_bzu_gmb}"
exec_full="bash -c "${script_dir}"/"${name_script_start}""


#Определение расположениея папок для утилит и т.д.
utils_dir="${script_dir}/core-utils"

#Определение переменныех утилит и скриптов
YAD="${utils_dir}/yad"
zenity="${utils_dir}/zenity"

#pass_user="$1"
#добовляем переменную с иминем пользователя от имини которого запущен скрипт, да это не обязательно, но не хочу переписывать код ниже :)
user_run_script="$USER"

# Проверка что существует папка applications, если нет, создаем ее
if [ ! -d "/home/${USER}/.local/share/applications" ]
then
mkdir -p "/home/${USER}/.local/share/applications"
fi

#загружаем список операционных систем из файла в массив
readarray -t linuxos_list < "${script_dir}/config/list-os"
#создаем цикл где будет проверяться согласно данных из файла в какой системе запущен скрипт
linuxos_number=${#linuxos_list[@]}
#задаем переменные, что бы отработал заглушка на неправильную ОС и очищаем переменную для цикла на всякий случай
linuxos_version=""
i=0
#проверяем на совпадение списка систем из файла и системы в которой запущен скрипт
#linux_os=`cat "/etc/os-release" | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/"//g'`
linux_os=`cat "/etc/os-release" | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/"//g'`
while [ $i -lt $linuxos_number ]
do
if [[ "${linux_os}" == "${linuxos_list[$i]}" ]]
then
export linuxos_version=${linuxos_list[$i]}
fi
i=$(($i + 1))
done
tput setaf 2
echo "your Linux OS:["$linuxos_version"]"
#echo "" > "${script_dir}/config/status"
tput sgr0

#функция для проверки пакетов на установку в dpkg, если нужно установлевает
function install_package {
dpkg -s $1 | grep installed > /dev/null || echo "no installing $1 :(" | echo "$2" | sudo -S apt install -f -y $1
package_status=`dpkg -s $1 | grep -oh "installed"`
tput setaf 3;echo -n "$1:";tput setaf 2;echo "$package_status";tput sgr 0
}
#=====================================================================================
#функция для проверки пакетов на установку в pacman, если нужно установлевает
function install_package_pamac {
pamac list -i | grep "$1" > /dev/null || echo "no installing $1 :(" | echo "$2" | sudo -S pamac install --no-confirm $1
package_status=`pamac list -i | grep "pv" > /dev/null | echo "installing"`
tput setaf 3;echo -n "$1:";tput setaf 2;echo "$package_status";tput sgr 0
}
#=====================================================================================
#функция для проверки пакетов на установку в rpm, если нужно установлевает
function install_package_rpm {
rpm -qa | grep "$1" > /dev/null || echo "no installing $1 :(" | echo "$2" | sudo -S dnf install -y $1
package_status=`rpm -qa | grep "$1" > /dev/null | echo "installing"`
tput setaf 3;echo -n "$1:";tput setaf 2;echo "$package_status";tput sgr 0
}

#Проверяем какая система запустила bzu-gmb, если ROSA Fresh Desktop 12.x устанавливаем нужные пакеты
if echo "${linux_os}" | grep -ow "ROSA Fresh Desktop" > /dev/null
then
###############################################################################
# проверка наличия системных папок bzu-gmb
# Проверка что существует папка applications, если нет, создаем ее
 if [ ! -d "/home/${USER}/.local/share/applications" ]
 then
mkdir -p "/home/${USER}/.local/share/applications"
 fi
# Проверка что существует папка autostart, если нет, создаем ее
 if [ ! -d "/home/${USER}/.config/autostart" ]
 then
mkdir -p "/home/${USER}/.config/autostart"
else
 if [ -e /home/${USER}/.config/autostart/gnome-desktop-icons-touch.desktop ] || [ -e /home/${USER}/.config/autostart/gnome-desktop-icons.desktop ];then
 rm -f /home/${USER}/.config/autostart/gnome-desktop-icons-touch.desktop
 rm -f /home/${USER}/.config/autostart/gnome-desktop-icons.desktop
 fi
fi
# Проверка что существует папка bzu-gmb-utils, если нет, создаем ее
 if [ ! -d "/home/${USER}/.local/share/bzu-gmb-utils" ]
 then
mkdir -p "/home/${USER}/.local/share/bzu-gmb-utils"
ln -s /home/$USER/.local/share/bzu-gmb-utils /home/$USER/bzu-gmb-utils
 else
   if [ ! -d "/home/$USER/bzu-gmb-utils" ];then
ln -s /home/$USER/.local/share/bzu-gmb-utils /home/$USER/bzu-gmb-utils
echo "ярлыка небыло, создаем его"
  fi
 fi
# Проверка что существует папка bzu-gmb-apps, если нет, создаем ее
 if [ ! -d "/home/${USER}/.local/share/bzu-gmb-apps" ]
 then
mkdir -p "/home/${USER}/.local/share/bzu-gmb-apps"
ln -s /home/$USER/.local/share/bzu-gmb-apps /home/$USER/bzu-gmb-apps
 else
   if [ ! -d "/home/$USER/bzu-gmb-apps" ];then
ln -s /home/$USER/.local/share/bzu-gmb-apps /home/$USER/bzu-gmb-apps
echo "ярлыка небыло, создаем его"
  fi
 fi
# Проверка что существует папка bzu-gmb-temp, если нет, создаем ее
 if [ ! -d "/home/${USER}/bzu-gmb-temp" ]
 then
mkdir -p "/home/${USER}/bzu-gmb-temp"
 fi
###############################################################################
# установка темы/иконок/обои для GNOME
 if [ -e /usr/bin/gnome-shell ];then
# Проверка что существует папка c темой Adwaita-dark , если нет, создаем ее
  if [ ! -d "/usr/share/themes/Adwaita-dark/gnome-shell" ]
  then
echo "${pass_user}" | sudo -S rm -rf "/usr/share/themes/Adwaita-dark"
cd "/home/$USER/bzu-gmb-temp"
wget "https://github.com/redrootmin/bzu-gmb-modules/releases/download/v1/Adwaita-dark.tar.xz"
cd "/usr/share/themes"
echo "${pass_user}" | sudo -S tar -xpJf "/home/$USER/bzu-gmb-temp/Adwaita-dark.tar.xz"
  fi

# Проверка что существует папка c иконки numix-icons , если нет, создаем ее
  if [ ! -d "/usr/share/icons/Numix" ]
  then
#echo "${pass_user}" | sudo -S rm -rf "/usr/share/themes/Adwaita-dark"
cd "/home/$USER/bzu-gmb-temp"
wget "https://github.com/redrootmin/bzu-gmb-modules/releases/download/v1/rosa-numix-icons.tar.xz"
cd "/usr/share/icons"
echo "${pass_user}" | sudo -S tar -xpJf "/home/$USER/bzu-gmb-temp/rosa-numix-icons.tar.xz"
  fi

# Проверка что существует папки c обоями redroot wallpapers , если нет, создаем ее
  if [ ! -d "/usr/share/backgrounds" ]
  then
#echo "${pass_user}" | sudo -S rm -rf "/usr/share/themes/Adwaita-dark"
cd "/home/$USER/bzu-gmb-temp"
wget "https://github.com/redrootmin/bzu-gmb-modules/releases/download/v1/rosa-gnome-wallpapers-v1.tar.xz"
cd "/usr/share"
echo "${pass_user}" | sudo -S tar -xpJf "/home/$USER/bzu-gmb-temp/rosa-gnome-wallpapers-v1.tar.xz"
  fi

fi

##################################################################################
# подключение игровой репы: rosa_gaming
echo "[rosa_gaming]
name=rosa_gaming
baseurl=http://abf-downloads.rosalinux.ru/rosa_gaming_personal/repository/rosa2021.1/x86_64/main/release/
gpgcheck=0
enabled=1
cost=998

[rosa_gaming-i686]
name=mesa-git-i686
baseurl=http://abf-downloads.rosalinux.ru/rosa_gaming_personal/repository/rosa2021.1/i686/main/release/
gpgcheck=0
enabled=1
cost=999" > /tmp/rosa_gaming.repo
echo "${pass_user}" | sudo -S mv -f /tmp/rosa_gaming.repo /etc/yum.repos.d
##################################################################################
# решение проблем с правами пользователей
#echo "${pass_user}" | sudo -S sed -i '0,/'%wheel'/ s//'#%wheel' /' /etc/sudoers
echo "${pass_user}" | sudo -S usermod -aG wheel $USER
##################################################################################
# установка  обновление системы
echo "${pass_user}" | sudo -S dnf --refresh distrosync -y
echo "${pass_user}" | sudo -S dnf update -y
 if [ -e /usr/bin/gnome-shell ];then
echo "${pass_user}" | sudo -S dnf remove -y gnome-robots four-in-a-row gnuchess aislerior gnome-chess gnome-mahjongg gnome-sudoku gnome-tetravex iagno lightsoff tail five-or-more gnome-klotski kmahjongg kmines klines kpat
 fi
echo "${pass_user}" | sudo -S dnf install -y inxi xow libusb-compat0.1_4 paprefs pavucontrol ananicy p7zip python3 zenity yad grub-customizer libfuse2-devel libfuse3-devel libssl1.1 neofetch git meson ninja gcc gcc-c++ cmake.i686 cmake glibc-devel dbus-devel glslang vulkan.x86_64 vulkan.i686 lib64vulkan-devel.x86_64 lib64vulkan-intel-devel.x86_64 lib64vulkan1.x86_64 libvulkan-devel.i686 libvulkan-intel-devel.i686 libvulkan1.i686
echo "${pass_user}" | sudo -S dnf autoremove -y
echo "${pass_user}" | sudo -S dnf clean packages
##################################################################################
#загружаем список пакетов из файла в массив
readarray -t packages_list < "${script_dir}/config/packages-rosa"
#задем переменной колличество пакетов в массиве
packages_number=${#packages_list[@]}
#обьявляем переменную числовой
i=0
#цикл проверки пакетов из массива
while [ $i -lt $packages_number ]
do
#вызов функции для проверки пакетов из массива
install_package_rpm ${packages_list[$i]} ${pass_user}
i=$(($i + 1))
done
echo "${pass_user}" | sudo -S systemctl enable xow && echo "${pass_user}" | sudo -S systemctl start xow
echo "${pass_user}" | sudo -S systemctl start ananicy
echo "${pass_user}" | sudo -S dnf clean packages

fi
#=====================================================================================

#Проверяем какая система запустила bzu-gmb, если Ubuntu\Linux Mint устанавливаем нужные пакеты
if echo "${linux_os}" | grep -ow "Ubuntu 20.04.4 LTS" > /dev/null || echo "${linux_os}" | grep -ow "Linux Mint 20.2" > /dev/null || echo "${linux_os}" | grep -ow "Ubuntu 21.10" > /dev/null || echo "${linux_os}" | grep -ow "Linux Mint 20.3" > /dev/null
then
# установка  обновление системы
echo "${pass_user}" | sudo -S apt update -y
echo "${pass_user}" | sudo -S apt upgrade -y
echo "${pass_user}" | sudo -S apt autoremove -y
echo "${pass_user}" | sudo -S apt clean -y

#загружаем список пакетов из файла в массив
readarray -t packages_list < "${script_dir}/config/packages-ubuntu-linux_mint"
#задем переменной колличество пакетов в массиве
packages_number=${#packages_list[@]}
#обьявляем переменную числовой
i=0
#цикл проверки пакетов из массива
while [ $i -lt $packages_number ]
do
#вызов функции для проверки пакетов из массива
install_package ${packages_list[$i]} ${pass_user}
i=$(($i + 1))
done
fi
#=====================================================================================

#Проверяем какая система запустила bzu-gmb, если Ubuntu22\Linux Mint21 устанавливаем нужные пакеты
if echo "${linux_os}" | grep -ow "Ubuntu 22.04 LTS" > /dev/null
then
cd;rm -rf bzu-gmb-temp*;rm -f bzu-gmb-temp*;wget https://github.com/redrootmin/bzu-gmb-modules/releases/download/v1/bzu-gmb-temp-v1.tar.xz -O bzu-gmb-temp.tar.xz;tar -xJf bzu-gmb-temp.tar.xz
# установка дополнительного ПО
echo "${pass_user}" | sudo -S apt update -y
echo "${pass_user}" | sudo -S apt upgrade -y

# установка пакетов которых нет в ppa (временно нет)
dpkg -s "libssl1.1:amd64" | grep installed > /dev/null || echo "no installing libssl1.1:amd64 :(" | echo "${pass_user}" | sudo -S apt install -f -y "/home/$USER/bzu-gmb-temp/libssl1.1_1.1.1l-1ubuntu1.2_amd64.deb"
dpkg -s "grub-customizer" | grep installed > /dev/null || echo "no installing grub-customizer :(" | echo "${pass_user}" | sudo -S apt install -f -y "/home/$USER/bzu-gmb-temp/grub-customizer_5.1.0-3_amd64.deb"

#загружаем список пакетов из файла в массив
readarray -t packages_list < "${script_dir}/config/packages-ubuntu2204"
#задем переменной колличество пакетов в массиве
packages_number=${#packages_list[@]}
#обьявляем переменную числовой
i=0
#цикл проверки пакетов из массива
while [ $i -lt $packages_number ]
do
#вызов функции для проверки пакетов из массива
install_package ${packages_list[$i]} ${pass_user}
i=$(($i + 1))
done
#FireFox deb
echo "${pass_user}" | sudo -S snap remove --purge firefox
echo "${pass_user}" | sudo -S add-apt-repository -y ppa:mozillateam/ppa
#ppa forece!
echo "${pass_user}" | sudo -S echo "Package: firefox*" > "mozillateamppa"
echo "${pass_user}" | sudo -S echo "Pin: release o=LP-PPA-mozillateam" >> "mozillateamppa"
echo "${pass_user}" | sudo -S echo "Pin-Priority: 501" >> "mozillateamppa"
echo "${pass_user}" | sudo -S cp -f mozillateamppa /etc/apt/preferences.d/
rm -f mozillateamppa
echo "${pass_user}" | sudo -S apt remove firefox -y
echo "${pass_user}" | sudo -S apt update -y
#sudo apt install firefox-esr
echo "${pass_user}" | sudo -S apt install -f -y --reinstall firefox
echo "${pass_user}" | sudo -S apt autoremove -y
echo "${pass_user}" | sudo -S apt clean -y
fi
#=====================================================================================

#Проверяем какая система запустила bzu-gmb, если Debian устанавливаем нужные пакеты
if echo "${linux_os}" | grep -ow "Debian GNU/Linux bookworm/sid" > /dev/null
then
echo "$pass_user" | sudo -S apt update -y;echo "$pass_user" | sudo -S apt upgrade -y
#загружаем список пакетов из файла в массив
readarray -t packages_list < "${script_dir}/config/packages-debian-book_worm"
#задем переменной колличество пакетов в массиве
packages_number=${#packages_list[@]}
#обьявляем переменную числовой
i=0
#цикл проверки пакетов из массива
while [ $i -lt $packages_number ]
do
#вызов функции для проверки пакетов из массива
install_package ${packages_list[$i]} ${pass_user}
i=$(($i + 1))
done
fi
#=====================================================================================

#Проверяем какая система запустила bzu-gmb, если Manjaro устанавливаем нужные пакеты
if echo "${linux_os}" | grep -ow "Manjaro" > /dev/null
then
echo "$pass_user" | sudo -S sudo sed -Ei '/EnableAUR/s/^#//' /etc/pamac.conf
echo "$pass_user" | sudo -S pamac upgrade -a --no-confirm
#echo "$pass_user" | sudo -S pamac install --no-confirm lib32-mesa vulkan-radeon mesa-vdpau lib32-vulkan-radeon lib32-mesa-vdpau libva-mesa-driver lib32-libva-mesa-driver
echo "$pass_user" | sudo -S pamac install --no-confirm lib32-mesa vulkan-radeon mesa-vdpau lib32-vulkan-radeon lib32-mesa-vdpau libva-mesa-driver lib32-libva-mesa-driver curl gamemode lib32-gamemode icoutils wget zenity bubblewrap zstd cabextract bc tar vulkan-tools lib32-p11-kit lib32-libcurl-gnutls libcurl-gnutls lib32-sdl2 lib32-freetype2 lib32-gtk2 lib32-alsa-plugins lib32-libpulse lib32-openal lib32-libudev0 lib32-systemd nss-mdns lib32-nss lib32-glu lib32-dbus libcurl-compat lib32-libcurl-compat libxcrypt-compat lib32-libxcrypt lib32-gconf gconf lib32-libldap
#загружаем список пакетов из файла в массив
readarray -t packages_list < "${script_dir}/config/packages-manjaro"
#задем переменной колличество пакетов в массиве
packages_number=${#packages_list[@]}
#обьявляем переменную числовой
i=0
#цикл проверки пакетов из массива
while [ $i -lt $packages_number ]
do
#вызов функции для проверки пакетов из массива
install_package_pamac ${packages_list[$i]} ${pass_user}
i=$(($i + 1))
done
fi
#=====================================================================================

# обнуляем статус утилиты, отключаем эксперементальный режим
echo "" > "${script_dir}/config/status"

#Создаем ярлык для скрипта
echo "[Desktop Entry]" > "${script_dir}/${name_desktop_file}"
echo "Version=1.0" >> "${script_dir}/${name_desktop_file}"
echo "Type=Application" >> "${script_dir}/${name_desktop_file}"
echo "Name=${name_app}" >> "${script_dir}/${name_desktop_file}"
echo "Comment=bzu-gmb is auto-installer linux gaming tools for debian-based distributions" >> "${script_dir}/${name_desktop_file}" 
echo "Categories=Utility;System;" >> "${script_dir}/${name_desktop_file}"
echo "Exec=${exec_full}" >> "${script_dir}/${name_desktop_file}"
echo "Terminal=true" >> "${script_dir}/${name_desktop_file}"
echo "Icon="${script_dir}/${name_icon}"" >> "${script_dir}/${name_desktop_file}"

#Копируем ярлыв в программы домашней папки пользователя
#sudo rm -f /usr/share/applications/bzu-gmb.desktop
echo "$pass_user" | sudo -S rm -f "/usr/share/applications/${name_desktop_file}" || true
cp -f "${script_dir}/${name_desktop_file}" "/home/${user_run_script}/.local/share/applications/"

#Даем права на запуск ярлыка в папке программы и копируем в папку с ярлыками пользователя
gio set "${script_dir}/${name_desktop_file}" "metadata::trusted" yes
gio set "/home/${user_run_script}/.local/share/applications/${name_desktop_file}" "metadata::trusted" yes
#gio info "${script_dir}/name_desktop_file" | grep "metadata::trusted"
chmod +x "/home/${user_run_script}/.local/share/applications/${name_desktop_file}"
chmod +x "${script_dir}/${name_desktop_file}"
#Даем права на главные скрипты утилиты и core-utils
chmod +x "${script_dir}/bzu-gmb-launcher.sh"
chmod +x "${script_dir}/bzu-gmb-gui-beta4.sh"
chmod +x "${script_dir}/core-utils/yad"
chmod +x "${script_dir}/core-utils/zenity"

#Уведомление пользователя, о том что нового в этой версии
update_log=`cat "${script_dir}/update_log"`
GTK_THEME="Adwaita-dark" ${YAD} --list --column=text --no-click --image-on-top --picture --size=fit --image="${script_dir}/image/bzu-gmb-wallpeper-2021-10.png" --width=640 --height=640 --center --inc=256  --text-align=center --title="Завершена установка ${version_bzu_gmb}" --separator=" " --search-column=1 --print-column=1 --wrap-width=560 "$update_log" --no-buttons
exit 0
