#!/bin/bash
#creator by RedRoot(Yaciyna Mikhail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License

#проверяем что модуль запущен от пользователя root
#[ "$UID" -eq 0 ] || { zenity --error --text="Этот скрипт нужно запускать из под root!"; exit 1;}

# определение имени файла, папки где находиться скрипт и версию скрипта
name_script0=`basename "$0"`
name_script=`echo ${name_script0} | sed "s|.sh||g"`
script_dir0=$(cd $(dirname "$0") && pwd); name_cut="/modules-temp/${name_script}"
script_dir=`echo ${script_dir0} | sed "s|${name_cut}||g"`
version0=`cat "${script_dir}/config/name_version"`
version="${version0}"
user_run_script=`cat "${script_dir}/config/user"`
#объявляем нужные переменные для скрипта
date_install=`date`
linuxos_run_bzu_gmb0=`cat "${script_dir}/config/os-run-script"`
export linuxos_run_bzu_gmb="${linuxos_run_bzu_gmb0}"
#загружаем данные о модули и файла конфигурации в массив
readarray -t module_conf < "${script_dir}/modules-temp/${name_script}/module_config"
#примеры считывания массива с данными
#version_kernel=${module_conf[*]} - Все записи в массиве
#version_kernel=${#module_conf[*]} - Количество записей в массиве, нумерания с нуля
#version_kernel=${module_conf[7]} - Определенная запись в массиве
version_proton=${module_conf[7]}

#получение пароля root пользователя
pass_user0="$1"
export pass_user="${pass_user0}"

#даем информацию в терминал какой модуль устанавливается
tput setaf 2; echo "Установка клиента steam для Linux [https://store.steampowered.com/]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
#Проверяем какая система запустила bzu-gmb, если ROSA Fresh Desktop 12.x устанавливаем нужные пакеты
if echo "${linuxos_run_bzu_gmb}" | grep -ow "ROSA Fresh Desktop" > /dev/null
then
# установка  обновление системы
#echo "${pass_user}" | sudo -S dnf update -y
#echo "${pass_user}" | sudo -S dnf distro-sync -y
#echo "${pass_user}" | sudo -S dnf autoremove -y
#echo "${pass_user}" | sudo -S dnf clean packages
echo "${pass_user}" | sudo -S dnf install -y steam

#формируем информацию о том что в итоге установили и показываем в терминал
app="steam"
tput setaf 2
package_status="-y install $app"
rpm -qa | grep "$app" > /dev/null || package_status="-y reinstall $app" | tput setaf 3
echo "${pass_user}" | sudo -S dnf $package_status;package_info="Пакет $app установлен!"
rpm -qa | grep "$app" > /dev/null || tput setaf 3 | package_info="ВНИМАНИЕ: пакет $app не получилось установить :(";tput sgr0

fi
#=====================================================================================

#Проверяем какая система запустила bzu-gmb, если Ubuntu/Linux Mint устанавливаем нужные пакеты
if echo "${linuxos_run_bzu_gmb}" | grep -ow "Ubuntu" > /dev/null || echo "${linuxos_run_bzu_gmb}" | grep -ow "Mint" > /dev/null
then
#запуск основных команд модуля
echo "${pass_user}" | sudo -S apt install -f -y --reinstall steam || let "error += 1"
fi
#=====================================================================================

#Проверяем какая система запустила bzu-gmb, если Debian GNU/Linux bookworm/sid устанавливаем нужные пакеты
if echo "${linuxos_run_bzu_gmb}" | grep -ow "Debian GNU/Linux bookworm/sid" > /dev/null;then
cd
wget https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb
echo "${pass_user}" | sudo -S apt install -f -y ./steam.deb  || let "error += 1"
echo "${pass_user}" | sudo -S rm -f "steam.deb" || let "error += 1"
echo "${pass_user}" | sudo -S apt install -f -y --reinstall libc6:amd64 libc6:i386 libegl1:amd64 libegl1:i386 libgbm1:amd64 libgbm1:i386 libgl1-mesa-dri:amd64 libgl1-mesa-dri:i386 libgl1:amd64 libgl1:i386 steam-libs-amd64:amd64 steam-libs-i386:i386
fi
#=====================================================================================

#Проверяем какая система запустила bzu-gmb, если Manjaro устанавливаем нужные пакеты
if echo "${linuxos_run_bzu_gmb}" | grep -ow "manjaro" > /dev/null
then
echo "$pass_user" | sudo -S pamac upgrade -a --no-confirm
echo "$pass_user" | sudo -S pamac install --no-confirm steam steam-native steam-native-runtime
echo "$pass_user" | sudo -S pamac install --no-confirm lib32-mesa vulkan-radeon mesa-vdpau lib32-vulkan-radeon lib32-mesa-vdpau libva-mesa-driver lib32-libva-mesa-driver curl gamemode lib32-gamemode icoutils wget zenity bubblewrap zstd cabextract bc tar vulkan-tools lib32-p11-kit lib32-libcurl-gnutls libcurl-gnutls lib32-sdl2 lib32-freetype2 lib32-gtk2 lib32-alsa-plugins lib32-libpulse lib32-openal lib32-libudev0 lib32-systemd nss-mdns lib32-nss lib32-glu lib32-dbus libcurl-compat lib32-libcurl-compat libxcrypt-compat lib32-libxcrypt lib32-gconf gconf lib32-libldap
fi
#=====================================================================================

#формируем информацию о том что в итоге установили и показываем в терминал
#app_name="steam"
#dpkg -s ${app_name} | grep -ow "installed" > /dev/null
#if [ $? = 0 ];then
#tput setaf 2; echo "${app_name}:installed"
#tput sgr0
#tput setaf 2; echo "Установка ${app_name} завершена :)"
#tput sgr0
#else tput setaf 1;echo "${name_script}:not installing!"
#fi
#tput sgr0


#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"

exit 0


#Для создания скрипта использовались следующие ссылки
#https://techblog.sdstudio.top/blog/google-drive-vstavliaem-priamuiu-ssylku-na-izobrazhenie-sayta
#https://www.linuxliteos.com/forums/scripting-and-bash/preview-and-download-images-and-files-with-zenity-dialog/
#https://www.ibm.com/developerworks/ru/library/l-zenity/
#https://habr.com/ru/post/281034/
#https://webhamster.ru/mytetrashare/index/mtb0/20
#https://itfb.com.ua/kak-prisvoit-rezultat-komandy-peremennoj-obolochki/
#https://tproger.ru/translations/bash-cheatsheet/
#https://mirivlad.ru/2017/11/20-primerov-ispolzovaniya-potokovogo-tekstovogo-redaktora-sed/
#https://www.opennet.ru/docs/RUS/bash_scripting_guide/c1833.html
#https://losst.ru/massivy-bash
#https://www.shellhacks.com/ru/grep-or-grep-and-grep-not-match-multiple-patterns/
#https://techrocks.ru/2019/01/21/bash-if-statements-tips/
#https://habr.com/ru/post/511608/
#https://techrocks.ru/2019/01/21/bash-if-statements-tips/
