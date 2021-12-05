#!/bin/bash

#проверяем что модуль запущен от пользователя root
[ "$UID" -eq 0 ] || { zenity --error --text="Этот скрипт нужно запускать из под root!"; exit 1;}

# определение имени файла, папки где находиться скрипт и версию скрипта
name_script0=`basename "$0"`
name_script=`echo ${name_script0} | sed "s|.sh||g"`

script_dir0=$(cd $(dirname "$0") && pwd); name_cut="/modules-temp/${name_script}"
script_dir=`echo ${script_dir0} | sed "s|${name_cut}||g"`
version0=`cat "${script_dir}/config/name_version"`
version="${version0}"
user_run_script=`cat "${script_dir}/config/user"`
#загружаем данные о модули и файла конфигурации в массив
readarray -t module_conf < "${script_dir}/modules-temp/${name_script}/module_config"
#echo ${module_conf[*]}

#узнаем в системе какое lowlatency ядро доступно и записываем в переменную
version_kernel=`apt-cache search linux-lowlatency | grep "image" | sed -r 's/(.+lowlatency).+/\1/' | sed 's/unsigned-//g'`

#объявляем нужные переменные для скрипта
date_install=`date`


#даем информацию в терминал какой модуль установливается
tput setaf 2; echo "Установка стабильной версии оригинального ядра Linux "${version_kernel}" для Ubuntu 20.04\21.10, Linux Mint 20.2 с низкими задержками. Версия скрипта 1.1, автор: Яцына М.А."
tput sgr0
#запуск основных команд модуля
sudo -S apt-get update -y
sudo -S apt-get upgrade -y
echo "пробуем установить ядро:" ${version_kernel}
sudo -S apt install -f -y --reinstall linux-lowlatency


#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2;echo "В вашу систему установлены следующие linux-lowlatency:";tput sgr0;dpkg --list | grep "lowlatency"  | grep -oP 'linux-image(.*)' | grep -Eo '^[^ ]+'
#сброс цвета текста в терминале
tput sgr0

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
#Добавляем информацию о изменении флагов в файле настройки GRUB в лог установки
echo "для отображения списка ядер при загрузке GRUB "	 				  >> "${script_dir}/module_install_log"
echo "нужно добавить флаги в файл: /etc/default/grub"	 				  >> "${script_dir}/module_install_log"
echo "для этого в консоле запускаем:sudo nano /etc/default/grub"	 				  >> "${script_dir}/module_install_log"
echo "далее редактируем либо создаем эти строки в файле:"	 				  >> "${script_dir}/module_install_log"
echo "GRUB_DEFAULT="saved""	 				  >> "${script_dir}/module_install_log"
echo "GRUB_SAVEDEFAULT=true"	 				  >> "${script_dir}/module_install_log"
echo "GRUB_HIDDEN_TIMEOUT="120""	 				  >> "${script_dir}/module_install_log"
echo "GRUB_TIMEOUT="5""	 				  >> "${script_dir}/module_install_log"
echo "GRUB_TIMEOUT_STYLE="menu""	 				  >> "${script_dir}/module_install_log"

#задержка вывода информации о итогах установки, что бы пользователь мог ознакомиться.
sleep 3

exit 0
