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
script_dir_install=`cat "${script_dir}/config/script_dir_install"`
#объявляем нужные переменные для скрипта
date_install=`date`

#даем информацию в терминал какой модуль установливается
tput setaf 2; echo "Установка утилиты glances [https://github.com/nicolargo/glances]. Версия скрипта 1.0, автор: Mirthless D"
tput sgr0

#запуск основных команд модуля
sudo -S killall glances || true
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
sudo -S rm -r "/usr/share/${name_script}-start" || true
sudo -S rm "/usr/share/applications/${name_script}.desktop" || true
sudo -S apt install -f -y --reinstall glances
sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp"|| let "error += 1"
sudo -S wget "https://drive.google.com/uc?export=download&id=1V26WRjcQseoIjubwLXiKGRYDuAGLUSOs" -O "${name_script}.tar.xz" || let "error += 1"
sudo -S tar -xpJf "${name_script}.tar.xz" -C "${script_dir_install}"
sudo -S chmod +x "/usr/share/${name_script}-start/${name_script}.sh" || let "error += 1"
sudo -S chmod +x "/usr/share/${name_script}-start/${name_script}.desktop" || let "error += 1"
sudo -S cp -ax "/usr/share/${name_script}-start/${name_script}.desktop" "/usr/share/applications/" || let "error += 1"
cd
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true

#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2
sudo -S dpkg --list | echo "Установлена утилита:"`grep "${name_script}" | sed s/"ii"//g`
#сброс цвета текста в терминале
tput sgr0
bash -c "xterm -hold -maximized -e glances --enable-plugin sensors" & sleep 5;sudo -S killall glances xterm


#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
#Добавляем информацию о изменении флагов в файле настройки GRUB в лог установки
echo "ВНИМАНИЕ: что бы пользоваться утилитой glances в консоле, введите это: "	 				  >> "${script_dir}/module_install_log"
echo "glances --enable-plugin sensors"	 				  >> "${script_dir}/module_install_log"
echo "Также есть возможность запустить утилиту через ярлых, смотрите в меню программ"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о командах и фукнциях тут: https://github.com/nicolargo/glances"	 				  >> "${script_dir}/module_install_log"

exit 0
