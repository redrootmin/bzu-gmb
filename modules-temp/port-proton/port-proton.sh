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
pass_root="$1"
#даем информацию в терминал какой модуль устанавливается

tput setaf 2; echo "Установка утилиты для игр PortProton от проекта PortWine [hhttps://portwine-linux.ru/port-proton-linux/]. Версия скрипта 1.1, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля

if echo "${linuxos_run_bzu_gmb}" | grep -ow "Ubuntu" > /dev/null || echo "${linuxos_run_bzu_gmb}" | grep -ow "Mint" > /dev/null
then
#запуск основных команд модуля
cd
wget -c "https://github.com/Castro-Fidel/PortWINE/raw/master/portwine_install_script/PortProton_1.0" && sh PortProton_1.0 -rus
#формируем информацию о том что в итоге установили и показываем в терминал
if [ ! -d "/home/${user_run_script}/PortWINE/PortProton" ];then
tput setaf 1;echo "PortProton не установился, либо поврежден!" || let "error += 1"
tput sgr0
else
tput setaf 2;echo "PortProton установилен успешно!"
tput sgr0
fi
fi

if echo "${linuxos_run_bzu_gmb}" | grep -ow "Debian GNU/Linux bookworm/sid" > /dev/null;then
#запуск основных команд модуля
cd
wget -c "https://github.com/Castro-Fidel/PortWINE/raw/master/portwine_install_script/PortProton_1.0" && sh PortProton_1.0 -rus
#формируем информацию о том что в итоге установили и показываем в терминал
if [ ! -d "/home/${user_run_script}/PortWINE/PortProton" ];then
tput setaf 1;echo "PortProton не установился, либо поврежден!" || let "error += 1"
tput sgr0
else
tput setaf 2;echo "PortProton установилен успешно!"
tput sgr0
fi
fi
#=====================================================================================

if echo "${linuxos_run_bzu_gmb}" | grep -ow "manjaro" > /dev/null
then
#запуск основных команд модуля
cd
wget -c "https://github.com/Castro-Fidel/PortWINE/raw/master/portwine_install_script/PortProton_1.0" && sh PortProton_1.0 -rus
#формируем информацию о том что в итоге установили и показываем в терминал
if [ ! -d "/home/${user_run_script}/PortWINE/PortProton" ];then
tput setaf 1;echo "PortProton не установился, либо поврежден!" || let "error += 1"
tput sgr0
else
tput setaf 2;echo "PortProton установилен успешно!"
tput sgr0
fi
fi
#=====================================================================================

#Проверяем какая система запустила bzu-gmb, если ROSA Fresh Desktop 12.2 устанавливаем нужные пакеты
if echo "${linux_os}" | grep -ow "ROSA Fresh Desktop 12.2" > /dev/null
then
echo "$pass_user" | sudo -S dnf install -y portproton
fi
#=====================================================================================


#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"

#Добавляем информацию о том как использовать CoreCtrl лог установки
#echo "Подробнее о том как запускать CoreCtrl без постоянного ввода пароля тут: https://gitlab.com/corectrl/corectrl/-/wikis/Setup"	 				  >> "${script_dir}/module_install_log"
#echo "Подробнее о командах и функциях тут: https://github.com/lutris/lutris/wiki" >> "${script_dir}/module_install_log"
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
