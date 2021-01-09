#!/bin/bash
#creator by RedRoot(Yacyna Mehail) for GAMER STATION [on linux] and Gaming Community OS Linux
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
#загружаем данные о модули и файла конфигурации в массив
readarray -t module_conf < "${script_dir}/modules-temp/${name_script}/module_config"
#примеры считывания массива с данными
#version_kernel=${module_conf[*]} - Все записи в массиве
#version_kernel=${#module_conf[*]} - Количество записей в массиве, нумерания с нуля
#version_kernel=${module_conf[7]} - Определенная запись в массиве
version_proton=${module_conf[7]}
#получение пароля root пользователя
pass_user="$1"
#даем информацию в терминал какой модуль устанавливается
tput setaf 2; echo "Установка набора скриптов для изменения интерфейса и внешнего вида Ubuntu 20.04.1 LTS. Версия скрипта 1.0 beta, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
echo "${pass_user}" | sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
echo "${pass_user}" | sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
echo "${pass_user}" | sudo -S wget "https://drive.google.com/uc?export=download&id=1fJfn_IVipj9GrDpa-G2h9e_uZoPNUMXE" -O "${name_script}.tar.xz" || let "error += 1"
echo "${pass_user}" | sudo -S tar -xpJf "${name_script}.tar.xz"
cd "${script_dir}/modules-temp/${name_script}/temp/${name_script}"

# установка дополнительного ПО
echo "${pass_user}" | sudo -S apt install -f -y --reinstall gnome-session gnome-session-wayland gnome-tweak-tool chrome-gnome-shell gnome-shell-extensions numix-icon-theme-circle git libglib2.0-dev

# устаноавливаем черное logo ubuntu на заставку загрузки
rm -rf ubuntu-darwin | true
git clone https://github.com/ashutoshgngwr/ubuntu-darwin.git
echo "${pass_user}" | sudo -S mv ubuntu-darwin/ubuntu-darwin /usr/share/plymouth/themes/ubuntu-darwin
echo "${pass_user}" | sudo -S update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/ubuntu-darwin/ubuntu-darwin.plymouth 10
echo "${pass_user}" | sudo -S echo "2" | sudo update-alternatives --config default.plymouth

#включаем настройки окон и темы
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
#yara-full-dark  https://www.omgubuntu.co.uk/2020/04/enable-full-dark-mode-in-ubuntu-20-04
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
gsettings set org.gnome.desktop.wm.preferences theme Adwaita-dark
gsettings set org.gnome.desktop.interface icon-theme Numix-Circle
gsettings set  org.gnome.desktop.interface cursor-theme DMZ-White

# включаем свои обоя на рабочий стол и на экран входа в систему
echo "${pass_user}" | sudo -S cp -f 17.jpg /usr/share/backgrounds/
gsettings set org.gnome.desktop.background picture-uri file:////usr/share/backgrounds/17.jpg
# включаем свои обоя на экран входа в систему
echo "${pass_user}" | sudo -S ./focalgdm3 --set /usr/share/backgrounds/17.jpg

#установка коллекции дополнений
### dconf dump /org/gnome/shell/extensions/ > extensions.conf ###
### dconf reset -f /org/gnome/shell/extensions/ ###
### dconf load /org/gnome/shell/extensions/ < extensions.conf ###
### gnome-extensions list ###
rm -fr "/home/${user_run_script}/.local/share/gnome-shell/extensions" || true
tar -xpJf "extensions.tar.xz" -C "/home/${user_run_script}/.local/share/gnome-shell/"
cp -f user "/home/${user_run_script}/.config/dconf"
dconf reset -f /org/gnome/shell/extensions/
dconf load /org/gnome/shell/extensions/ < extensions.conf 
gsettings set org.gnome.shell disable-user-extensions true
gsettings set org.gnome.shell disable-user-extensions false
gnome-extensions enable bluetooth-quick-connect@bjarosze.gmail.com;gnome-extensions enable caffeine@patapon.info;gnome-extensions enable dash-to-panel@jderose9.github.com;gnome-extensions enable desktop-icons@csoriano;gnome-extensions enable disable-screenshield@lgpasquale.com;gnome-extensions enable drive-menu@gnome-shell-extensions.gcampax.github.com;gnome-extensions enable gamemode@christian.kellner.me;gnome-extensions enable gsconnect@andyholmes.github.io;gnome-extensions enable impatience@gfxmonk.net;gnome-extensions enable nohotcorner@azuri.free.fr;gnome-extensions enable panel-osd@berend.de.schouwer.gmail.com;gnome-extensions enable sound-output-device-chooser@kgshank.net;gnome-extensions enable tweaks-system-menu@extensions.gnome-shell.fifi.org;gnome-extensions enable ubuntu-appindicators@ubuntu.com;gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com;gnome-extensions enable hide-dash@xenatt.github.com;gnome-extensions enable horizontal-workspaces@gnome-shell-extensions.gcampax.github.com;gnome-extensions enable workspaces-thumbnails@fthx;gnome-extensions enable minimum-workspaces@philbot9.github.com;gnome-extensions enable blyr@yozoon.dev.gmail.com;gnome-extensions enable BringOutSubmenuOfPowerOffLogoutButton@pratap.fastmail.fm;gnome-extensions enable cpupower@mko-sl.de;gnome-extensions enable openweather-extension@jenslody.de;gnome-extensions enable set-columns@maestroschan.fr;gnome-extensions enable applications-overview-tooltip@RaphaelRochet;gnome-extensions enable arcmenu@arcmenu.com;gnome-extensions enable clock-override@gnomeshell.kryogenix.org

#Ubuntu 20.10
#https://extensions.gnome.org/extension/3193/blur-my-shell/
#https://extensions.gnome.org/extension/3872/workspaces-thumbnails-applet/

# for disable gnome-extension
#gnome-extensions disable hide-dash@xenatt.github.com

#включаем настройки дополнительной темы из дополнения
gsettings set org.gnome.shell.extensions.user-theme name Yaru-dark

echo "${pass_user}" | sudo -S pkill -9 ^gnome-shell
#выходим из временной папки и удаляем ее
cd
echo "${pass_user}" | sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true

tput setaf 2; echo "Установка завершена"
tput sgr0

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "Модуль ${name_script}, дата установки: ${date_install}, количество ошибок: ${error}"	 				  >> "${script_dir}/module_install_log"

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
