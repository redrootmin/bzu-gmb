#!/bin/bash

#проверяем что модуль запущен от пользователя root
[ "$UID" -eq 0 ] || { zenity --error --text="Этот скрипт нужно запускать из под root!"; exit 1;}

# определение имени файла, папки где находиться скрипт и версию скрипта
name_script0=`basename "$0"`
name_script=`echo ${name_script0} | sed "s|.sh||g"`
#echo ${name_script}
script_dir0=$(cd $(dirname "$0") && pwd); name_cut="/modules-temp/${name_script}"
#echo ${name_cut}
#echo ${script_dir0}
script_dir=`echo ${script_dir0} | sed "s|${name_cut}||g"`
version0=`cat "${script_dir}/config/name_version"`
version="${version0}"
user_run_script=`cat "${script_dir}/config/user"`
# Проверка что существует папка .steam/root/compatibilitytools.d/, если нет, создаем ее
if [ ! -d "/home/${user_run_script}/.steam/root/compatibilitytools.d/" ]
then
mkdir -p "/home/${user_run_script}/.steam/root/compatibilitytools.d/" || let "error += 1"
chmod -R 777 "/home/${user_run_script}/.steam/root/compatibilitytools.d/" || let "error += 1"
fi
script_dir_install="/home/${user_run_script}/.steam/root/compatibilitytools.d"
#echo "${script_dir_install}"
#exit 0
name_download_arh="Proton-5.21-GE-1.tar.gz"
name_dir_installing="Proton-5.21-GE-1"
#объявляем нужные переменные для скрипта
date_install=`date`


#даем информацию в терминал какой модуль установливается
tput setaf 2; echo "Установка кастомной версии ProtonGE [https://github.com/GloriousEggroll/proton-ge-custom]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля

sudo -S killall steam || true
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
sudo -S rm -r "${script_dir_install}/${name_dir_installing}" || true
#sudo -S rm "/usr/share/applications/${name_script}.desktop" || true
sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp"|| let "error += 1"
sudo -S wget "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/5.21-GE-1/${name_download_arh}" || let "error += 1" 
tar xfvz "${name_download_arh}" -C "${script_dir_install}"
sudo -S chmod -R 777 "${script_dir_install}/${name_dir_installing}"
#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2
echo "Установлен ${name_download_arh}"
#сброс цвета текста в терминале
tput sgr0
# Installing Proton-5.11-GE-2-MF
name_download_arh="Proton-5.11-GE-2-MF.tar.gz"
name_dir_installing="Proton-5.11-GE-2-MF"
sudo -S rm -r "${script_dir_install}/${name_dir_installing}" || true
sudo -S wget "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/5.11-GE-2-MF/${name_download_arh}" || let "error += 1" 
tar xfvz "${name_download_arh}" -C "${script_dir_install}"
sudo -S chmod -R 777 "${script_dir_install}/${name_dir_installing}"
cd
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true

#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2
echo "Установлен ${name_download_arh}"
#сброс цвета текста в терминале
tput sgr0



#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "Модуль ${name_script}, дата установки: ${date_install}, количество ошибок: ${error}"	 				  >> "${script_dir}/module_install_log"
#Информация о том как использовать утилиту\программу
echo "Внимание! Для запуска Windows-игр в Steam через ProtonGE Вам обязательно нужно включить фукнцию Steam Play и выбирать нужную версию Proton в играх"	 				  >> "${script_dir}/module_install_log"
echo "Сайт, где можно посмотреть, какие Windows игры работают в Steam и в каком качестве: https://www.protondb.com/"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о командах и фукнциях ProtonGE тут: https://github.com/GloriousEggroll/proton-ge-custom#modification"	 				  >> "${script_dir}/module_install_log"

exit 0
