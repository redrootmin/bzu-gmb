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

#объявляем нужные переменные для скрипта
date_install=`date`

#даем информацию в терминал какой модуль устанавливается
tput setaf 2; echo "Установка утилиты CoreCtrl 1.х-dev от Juan Palacios [https://gitlab.com/corectrl/corectrl]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
sudo -S killall corectrl || true
sudo -S add-apt-repository -y ppa:ernstp/mesarc  || let "error += 1"
#sudo -S apt update -y 
sudo -S apt install -f -y corectrl || let "error += 1"
sudo -S rm /etc/apt/sources.list.d/ernstp-ubuntu-mesarc*.list || let "error += 1"
sudo -S rm /etc/apt/sources.list.d/ernstp-ubuntu-mesarc*.list.save || true
sudo -S apt update -y || let "error += 1"
sudo -S apt upgrade -y || let "error += 1"

#формируем информацию о том что в итоге установили и показываем в терминал
mesa_version=`inxi -G | grep "Mesa"`  || let "error += 1"
tput setaf 2; echo "Установлен драйвер:${mesa_version}, тестируем CoreCtrl!"  || let "error += 1"
sudo dpkg --list | echo "Установлена утилита:"`grep "CoreCtrl" | sed s/"ii"//g`
#сброс цвета текста в терминале
tput sgr0
#тестовый запуск CoreCtrl
corectrl & sleep 5;sudo -S killall corectrl

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"

#Добавляем информацию о том как использовать CoreCtrl лог установки
echo "Подробнее о том как запускать CoreCtrl без постоянного ввода пароля тут: https://gitlab.com/corectrl/corectrl/-/wikis/Setup"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о командах и функциях тут: https://gitlab.com/corectrl/corectrl/-/wikis/How-profiles-works"	 				  >> "${script_dir}/module_install_log"



exit 0
