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
tput setaf 2; echo "Установка утилиты cpu-x для вывода информации о процессоре, материнской платы, оперативной памяти, графического процессора и о самой операционной системе [https://x0rg.github.io/CPU-X/]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
sudo -S dnf install -y cpu-x || let "error += 1"

app_name="cpu-x"
rpm -qa | grep -ow "${app_name}" > /dev/null
if [ $? = 0 ];then
tput setaf 2; echo "${app_name}:installed"
tput sgr0
echo "Testing:${app_name}"
# 5 секунд теста программы
sudo -S cpu-x & sleep 3;sudo -S killall cpu-x
tput setaf 2; echo "Установка ${app_name} завершена :)"
tput sgr0
else tput setaf 1;echo "${name_script}:not installing!"
fi
tput sgr0
fi


#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"

#Добавляем информацию о изменении флагов в файле настройки GRUB в лог установки
#echo "для использования Feral GameMode:"	 				  >> "${script_dir}/module_install_log"
#echo "gamoderun /way/to/app"	 				  >> "${script_dir}/module_install_log"

#echo "например в steam:"	 				  >> "${script_dir}/module_install_log"
#echo "gamemoderun %command%"	 				  >> "${script_dir}/module_install_log"
#echo "Подробнее о командах и функциях тут: https://github.com/FeralInteractive/gamemode"	 				  >> "${script_dir}/module_install_log"


#задержка вывода информации о итогах установки, что бы пользователь мог ознакомиться.

exit 0
