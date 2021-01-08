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
version=`cat "${script_dir}/config/name_version"`
script_dir_install=`cat "${script_dir}/config/script_dir_install"`
user_run_script=`cat "${script_dir}/config/user"`
#объявляем нужные переменные для скрипта
date_install=`date`

#даем информацию в терминал какой модуль установливается
tput setaf 2; echo "Установка клиента steam для Linux [https://store.steampowered.com/]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
sudo -S apt install -f -y --reinstall steam

#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2
sudo -S dpkg --list | echo "Установлена утилита:"`grep "${name_script}" | sed s/"ii"//g`
#сброс цвета текста в терминале
tput sgr0

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
#Добавляем информацию о изменении флагов в файле настройки GRUB в лог установки
echo "ВНИМАНИЕ: для запуска игр вам нужно обнавить steam до beta версии и велючить функцию steamplay"	 				  >> "${script_dir}/module_install_log"
echo "сайт где можно посмотреть какие windows игры работаю в steam и в каком качестве:https://www.protondb.com/"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о командах и фукнциях Proton тут: https://github.com/ValveSoftware/Proton"	 				  >> "${script_dir}/module_install_log"

exit 0
