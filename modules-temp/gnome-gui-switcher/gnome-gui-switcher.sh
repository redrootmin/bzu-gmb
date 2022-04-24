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
tput setaf 2; echo "Установка [GGS]gnome-gui-switcher - это утилита для настройки\изменения интерфейса в ubuntu 22.04 LTS c рабочим столом gnome42+ с помощью готовых профилей:Ubuntu,macos,windows,RedRoot. Версия скрипта 1.0 beta, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
version_app="[GGS]gnome-gui-switcher"
# Проверка установлен [GGS]gnome-gui-switcher или нет в папке пользователя
if [ ! -d "/home/${user_run_script}/[GGS]gnome-gui-switcher" ]
then
tput setaf 2; echo "Утилита ${version_app} не установлена в папку пользователя ${user_run_script}, поэтому можно устанавливать :)"
tput sgr0
cd
rm -f [GGS]gnome-gui-switcher*
wget https://github.com/redrootmin/bzu-gmb-modules/releases/download/v1/GGS.gnome-gui-switcher-dev.tar.xz -O [GGS]gnome-gui-switcher-dev.tar.xz
tar -xJf [GGS]gnome-gui-switcher-dev.tar.xz
chmod +x "/home/${user_run_script}/[GGS]gnome-gui-switcher/mini_install.sh"
bash "/home/${user_run_script}/[GGS]gnome-gui-switcher/mini_install.sh"
tput setaf 2; echo "Установка утилиты ${version_app} завершена :)"
tput sgr0
else
tput setaf 1; echo "Утилита ${version_app} уже установлена в папку пользователя ${user_run_script}, что бы не стереть ваши важные данные, установка прирывается!"
tput sgr0
fi

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
