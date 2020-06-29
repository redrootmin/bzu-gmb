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
tput setaf 2; echo "Установка тестируемой версии, кастомного ядра Linux от XanMod [https://xanmod.org]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

#проверяем установлена утилита inxi - информация о низкоуровневом ПО и железе
#dpkg -s inxi | grep installed > /dev/null || echo 'no install inxi :(' | sudo -S apt install -f -y inxi
#inxistatus=`dpkg -s inxi | grep installed`
#echo "INXI" $inxistatus

#запуск основных команд модуля
echo 'deb http://deb.xanmod.org releases main' | sudo -S tee /etc/apt/sources.list.d/xanmod-kernel.list  && wget -qO - https://dl.xanmod.org/gpg.key | sudo -S apt-key add - || let "error += 1"
sudo -S apt update || let "error += 1"
sudo -S apt install -f -y linux-xanmod-edge || let "error += 1"
sudo -S update-grub || let "error += 1"
sudo -S update-initramfs -u || let "error += 1"

#формируем информацию о том что в итоге установили и показываем в терминал
kernel_installed=`dpkg --list | grep -E -m 1 'linux-image.*xanmod'` || let "error += 1"
tput setaf 2; echo "Установлено новое ядро:${kernel_installed}"  || let "error += 1"
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
