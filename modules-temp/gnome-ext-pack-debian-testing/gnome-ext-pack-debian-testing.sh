#!/bin/bash
#creator by RedRoot(Yacyna Mehail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License 

#проверяем что модуль запущен от пользователя root
#[ "$UID" -eq 0 ] || { zenity --error --text="Этот скрипт нужно запускать из под root!"; exit 1;}

# определение имени файла, папки где находиться скрипт и версию скрипта
name_script0=`basename "$0"`
name_script=`echo ${name_script0} | sed 's/\.sh\>//g'`
script_dir0=$(cd $(dirname "$0") && pwd); name_cut="/modules-temp/${name_script}"
script_dir=`echo ${script_dir0} | sed "s|${name_cut}||g"`
version0=`cat "${script_dir}/config/name_version"`
version="${version0}"
user_run_script=`cat "${script_dir}/config/user"`

#объявляем нужные переменные для скрипта
date_install=`date`

#Определение переменныех утилит и скриптов
YAD0="${utils_dir}/yad"
mangohud0="${utils_dir}/./mangohud_portable"
zenity0="${utils_dir}/zenity"
export YAD=${YAD0}
export mangohud=${mangohud0}
export zenity=${zenity0}

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
tput setaf 2; echo "Установка набора скриптов для изменения интерфейса и внешнего вида ubuntu 21.10 . Версия скрипта 1.0 beta, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
echo "${pass_user}" | sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
echo "${pass_user}" | sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
echo "${pass_user}" | sudo -S wget "https://github.com/redrootmin/bzu-gmb-modules/releases/download/v1/gnome-ext-pack-debian-testing.tar.xz" -O "${name_script}.tar.xz" || let "error += 1"
echo "${pass_user}" | sudo -S tar -xpJf "${name_script}.tar.xz"
cd "${script_dir}/modules-temp/${name_script}/temp/${name_script}"

# установка дополнительного ПО
echo "${pass_user}" | sudo -S apt update
echo "${pass_user}" | sudo -S apt upgrade
echo "${pass_user}" | sudo -S apt install -f -y --reinstall chrome-gnome-shell gnome-shell-extensions numix-icon-theme-circle git libglib2.0-dev grub-customizer plymouth-themes-solar paprefs pavucontrol

# устаноавливаем черное logo ubuntu на заставку загрузки

#echo "${pass_user}" | sudo -S cp -r debian-darwin/debian-darwin /usr/share/plymouth/themes/debina-darwin
splash_status=`cat /etc/default/grub | grep -ow "splash"`
if [[ "${splash_status}" == "" ]]
then
echo "${pass_user}" | sudo -S sed -i 's/quiet/quiet splash/g' /etc/default/grub
echo "${pass_user}" | sudo -S update-grub
#echo "$pass_user" | sudo -S chmod +x plymouth-set-default-theme
#bash plymouth-set-default-theme -R debian-darwin
fi


#echo "${pass_user}" | sudo -S update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/ubuntu-darwin/ubuntu-darwin.plymouth 10
#echo "${pass_user}" | sudo -S echo "2" | sudo update-alternatives --config default.plymouth
#rm -rf ubuntu-darwin | true


# включаем свои обоя на рабочий стол и на экран входа в систему
#echo "${pass_user}" | sudo -S cp -f 17.jpg /usr/share/backgrounds/
#gsettings set org.gnome.desktop.background picture-uri file:////usr/share/backgrounds/17.jpg
# включаем свои обоя на экран входа в систему
#echo "${pass_user}" | sudo -S ./focalgdm3 --set /usr/share/backgrounds/17.jpg

#установка коллекции дополнений GNOME 40
### dconf dump /org/gnome/shell/extensions/ > extensions.conf ###
### dconf dump / > dconf_full.conf ###
### dconf reset -f /org/gnome/shell/extensions/ ###
### dconf load /org/gnome/shell/extensions/ < extensions.conf ###
### gnome-extensions list ###
### for disable gnome-extension ###
rm -fr "/home/${user_run_script}/.local/share/gnome-shell/extensions" || true
tar -xpJf "extensions.tar.xz" -C "/home/${user_run_script}/.local/share/gnome-shell/"
#dconf reset -f /org/gnome/shell/extensions/
cp -f user "/home/${user_run_script}/.config/dconf"
sleep 5
dconf load / < dconf_full.conf
#финально перезагружем окружение gnome
echo "${pass_user}" | sudo -S pkill -9 ^gnome-shell

#выходим из временной папки и удаляем ее
cd
echo "${pass_user}" | sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true
sleep 5
tput setaf 2; echo "Установка ${name_script} завершена!"
tput sgr0

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
GTK_THEME="Adwaita-dark" ${YAD} --title="Back to Ubuntu Vanilla" --image-on-top --picture --size=fit --filename="${script_dir}/icons/debian-logo-icon327.png" --width=327 --height=327 --center --inc=256  --text-align=center --text="ТРЕБУЕТСЯ ПЕРЕАГРУЗКА СИСТЕМЫ!" --timeout=5 --timeout-indicator=bottom 
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
