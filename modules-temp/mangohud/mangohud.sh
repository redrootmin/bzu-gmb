#!/bin/bash
#проверяем что скрипт установки не запущен от пользователя root
if [ "$UID" -eq 0 ];then
tput setaf 1; echo "Этот скрипт не нужно запускать из под root!";tput sgr0;exit 1
else
tput setaf 2; echo "все хорошо этот скрипт не запущен из под root!"
fi

# определение имени файла, папки где находиться скрипт и версию скрипта
name_script0=`basename "$0"`
name_script=`echo ${name_script0} | sed "s|.sh||g"`
script_dir0=$(cd $(dirname "$0") && pwd); name_cut="/modules-temp/${name_script}"
script_dir=`echo ${script_dir0} | sed "s|${name_cut}||g"`
version0=`cat "${script_dir}/config/name_version"`
version="${version0}"

#примеры считывания массива с данными
#version_kernel=${module_conf[*]} - Все записи в массиве
#version_kernel=${#module_conf[*]} - Количество записей в массиве, нумерания с нуля
#version_kernel=${module_conf[7]} - Определенная запись в массиве
version_mangohud=${module_conf[7]}

#объявляем нужные переменные для скрипта
date_install=`date`
linuxos_run_bzu_gmb0=`cat "${script_dir}/config/os-run-script"`
export linuxos_run_bzu_gmb="${linuxos_run_bzu_gmb0}"
#получение пароля root пользователя
pass_user0="$1"
export pass_user="${pass_user0}"

#даем информацию в терминал какой модуль устанавливается
tput setaf 2; echo "Установка открытой утилиты $version_mangohud от flightlessmango [https://github.com/flightlessmango/MangoHud/releases]. Версия скрипта 1.2, автор: Яцына М.А."
tput sgr0

Проверяем какая система запустила bzu-gmb, если ROSA Fresh Desktop 12.2 устанавливаем нужные пакеты
if echo "${linuxos_run_bzu_gmb}" | grep -ow "ROSA Fresh Desktop 12.2" > /dev/null
then
# Проверка что существует папка bzu-gmb-temp, если нет, создаем ее
 if [ ! -d "/home/${USER}/bzu-gmb-temp" ]
 then
mkdir -p "/home/${USER}/bzu-gmb-temp"
 fi
 rm -f -r "/home/${USER}/bzu-gmb-temp/MangoHud" || true
cd "/home/${USER}/bzu-gmb-temp/"
echo "${pass_user}" | sudo -S dnf install -y inxi xow libusb-compat0.1_4 paprefs pavucontrol ananicy p7zip python3 zenity yad grub-customizer libfuse2-devel libfuse3-devel libssl1.1 neofetch git meson ninja gcc gcc-c++ cmake.i686 cmake glibc-devel dbus-devel glslang vulkan.x86_64 vulkan.i686 lib64vulkan-devel.x86_64 lib64vulkan-intel-devel.x86_64 lib64vulkan1.x86_64 libvulkan-devel.i686 libvulkan-intel-devel.i686 libvulkan1.i686
git clone --recurse-submodules https://github.com/flightlessmango/MangoHud.git
cd MangoHud
meson build -Dwith_xnvctrl=disabled
echo "${pass_user}" | sudo -S ninja -C build install

# Проверка что существует папка MangoHud, если нет, создаем ее
 if [ ! -d "/home/${USER}/.config/MangoHud" ]
 then
mkdir -p "/home/${USER}/.config/MangoHud"
 fi
cp -f "${script_dir}/adds/MangoHud.conf" "/home/${USER}/.config/MangoHud"
#формируем информацию о том что в итоге установили и показываем в терминал
mangohud_install="no"
    if [ -e /bin/mangohud ];then
     mangohud vkcube& mangohud glxgears& sleep 5;killall vkcube;killall glxgears
     mangohud_install="yes"
    fi
        if echo "$mangohud_install" | grep "yes" > /dev/null;then
         tput setaf 2;echo "Mangohud установлен успешно!";tput sgr0
        else
         tput setaf 1;echo "Mangohud не установлен :(";tput sgr0
        fi
rm -f -r "/home/${USER}/bzu-gmb-temp/MangoHud" || true
fi
#=====================================================================================

#Проверяем какая система запустила bzu-gmb, если Ubuntu\Linux Mint устанавливаем нужные пакеты
if echo "${linuxos_run_bzu_gmb}" | grep -ow "Ubuntu 20.04.4 LTS" > /dev/null || echo "${linuxos_run_bzu_gmb}" | grep -ow "Mint" > /dev/null || echo "${linuxos_run_bzu_gmb}" | grep -ow "Ubuntu 21.10" > /dev/null || echo "${linuxos_run_bzu_gmb}" | grep -ow "Ubuntu 22.04 LTS" > /dev/null
then
#запуск основных команд модуля
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp"|| let "error += 1"
sudo -S wget https://github.com/flightlessmango/MangoHud/releases/download/v0.6.1/MangoHud-0.6.1.tar.gz || let "error += 1"
sudo -S tar xfvz MangoHud*.tar.gz || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp/MangoHud" || let "error += 1"
sudo -S sh mangohud-setup.sh uninstall || true
sudo -S sh mangohud-setup.sh install || let "error += 1"
cd
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true
#формируем информацию о том что в итоге установили и показываем в терминал
mesa_version=`inxi -G | grep "Mesa"`  || let "error += 1"
tput setaf 2; echo "Установлен драйвер:${mesa_version}, тестируем мониторинг!"  || let "error += 1"
#сброс цвета текста в терминале
tput sgr0
# 5 секунд теста mangohud
mangohud glxgears | sleep 5 | exit 0
fi
#=====================================================================================








#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
#Добавляем информацию о изменении флагов в файле настройки GRUB в лог установки
echo "для использования MangoHud:"	 				  >> "${script_dir}/module_install_log"
echo "если OpenGL: mangohud /way/to/app"	 				  >> "${script_dir}/module_install_log"
echo "если Vulkan: MANGOHUD=1(либо mangohud) /way/to/app"	 				  >> "${script_dir}/module_install_log"
echo "например в steam:"	 				  >> "${script_dir}/module_install_log"
echo "MANGOHUD=1 MANGOHUD_CONFIG=cpu_temp,gpu_temp,vram,ram,position=top-right,font_size=22,vsync=3,arch %command%"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о командах и фукнциях тут: https://github.com/flightlessmango/MangoHud"	 				  >> "${script_dir}/module_install_log"

#задержка вывода информации о итогах установки, что бы пользователь мог ознакомиться.

exit 0
