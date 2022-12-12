#!/bin/bash

#проверяем что модуль запущен от пользователя root
#[ "$UID" -eq 0 ] || { zenity --error --text="Этот скрипт нужно запускать из под root!"; exit 1;}

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
#version_proton=${module_conf[7]}
#получение пароля root пользователя
pass_user0="$1"
export pass_user="${pass_user0}"

#даем информацию в терминал какой модуль устанавливается
tput setaf 2; echo "Установка оригинального ядра Linux 5.18 для Rosa fresh desktop [https://www.rosalinux.ru/rosa-linux-download-links/]. Версия скрипта 1b, автор: Яцына М.А."
tput sgr0

#Проверяем какая система запустила bzu-gmb, если ROSA Fresh Desktop 12.x устанавливаем нужные пакеты
if echo "${linuxos_run_bzu_gmb}" | grep -ow "ROSA Fresh Desktop" > /dev/null
then
# установка  обновление системы
echo "${pass_user}" | sudo -S dnf update -y
echo "${pass_user}" | sudo -S dnf autoremove -y
echo "${pass_user}" | sudo -S dnf clean packages
echo "[linux-xanmod-stable]
name=linux-xanmod-stable
baseurl=http://abf-downloads.rosalinux.ru/rosa_gaming_system_apps_personal/repository/rosa2021.1/x86_64/main/release/
enabled=1
skip_if_unavailable=1
gpgcheck=0
priority=0" > /tmp/kernel-xanmod-stable.repo
echo "${pass_user}" | sudo -S mv /tmp/kernel-xanmod-stable.repo /etc/yum.repos.d
echo "${pass_user}" | sudo -S dnf update -y && echo "${pass_user}" | sudo -S dnf install -y kernel-5.18-generic-devel kernel-5.18-generic kernel-5.18-generic-uml kernel-5.18-generic-uml-modules kernel-5.18-rosa-flow-abi

#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2;echo "В вашу систему установлены следующие linux ядра Xanmod:";tput sgr0;rpm -qa | grep "kernel-xanmod-rosa"
#сброс цвета текста в терминале
tput sgr0
fi
#=====================================================================================

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
