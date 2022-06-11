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
version_proton=${module_conf[7]}
#получение пароля root пользователя
pass_user0="$1"
export pass_user="${pass_user0}"

#даем информацию в терминал какой модуль устанавливается
tput setaf 2; echo "Установка тестируемой версии, кастомного ядра Linux от XanMod [https://xanmod.org]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

#Проверяем какая система запустила bzu-gmb, если ROSA Fresh Desktop 12.2 устанавливаем нужные пакеты
if echo "${linuxos_run_bzu_gmb}" | grep -ow "ROSA Fresh Desktop 12.2" > /dev/null
then
# установка  обновление системы
echo "${pass_user}" | sudo -S dnf update -y
echo "${pass_user}" | sudo -S dnf autoremove -y
echo "${pass_user}" | sudo -S dnf clean -y
echo "[kernel-xanmod-x86_64]
name=kernel with XanMod patch
baseurl=http://abf-downloads.rosalinux.ru/kelpee_personal/repository/rosa2021.1/x86_64/kernel_xanmod/release/
enabled=1
skip_if_unavailable=1
gpgcheck=0
priority=0" > /tmp/kernel-xanmod-x86_64.repo
echo "${pass_user}" | sudo -S mv /tmp/kernel-xanmod-x86_64.repo /etc/yum.repos.d
echo "${pass_user}" | sudo -S dnf update -y && echo "${pass_user}" | sudo -S dnf install -y task-kernel-xanmod

#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2;echo "В вашу систему установлены следующие linux ядра Xanmod:";tput sgr0;rpm -qa | grep "kernel-xanmod-rosa"
#сброс цвета текста в терминале
tput sgr0
fi
#=====================================================================================

#Проверяем какая система запустила bzu-gmb, если Ubuntu\Linux Mint устанавливаем нужные пакеты
if echo "${linuxos_run_bzu_gmb}" | grep -ow "Ubuntu 20.04.4 LTS" > /dev/null || echo "${linuxos_run_bzu_gmb}" | grep -ow "Linux Mint 20.2" > /dev/null || echo "${linuxos_run_bzu_gmb}" | grep -ow "Ubuntu 21.10" > /dev/null || echo "${linuxos_run_bzu_gmb}" | grep -ow "Ubuntu 22.04 LTS" > /dev/null || echo "${linuxos_run_bzu_gmb}" | grep -ow "Linux Mint 20.3" > /dev/null
then
#запуск основных команд модуля
echo "${pass_user}" | sudo -S echo 'deb http://deb.xanmod.org releases main' > /etc/apt/sources.list.d/xanmod-kernel.list && wget -qO - https://dl.xanmod.org/gpg.key | echo "${pass_user}" | sudo -S apt-key add - || let "error += 1"
echo "${pass_user}" | sudo -S apt update -y || let "error += 1"
echo "${pass_user}" | sudo -S apt install -f -y  linux-xanmod-edge || let "error += 1"
echo "${pass_user}" | sudo -S update-grub || let "error += 1"
echo "${pass_user}" | sudo -S update-initramfs -u || let "error += 1"

#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2;echo "В вашу систему установлены следующие linux ядра Xanmod:";tput sgr0;dpkg --list | grep "xanmod"  | grep -oP 'linux-image(.*)' | grep -Eo '^[^ ]+'
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
