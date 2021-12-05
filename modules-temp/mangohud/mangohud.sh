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
tput setaf 2; echo "Установка открытой утилиты MangoHud 0.6.1 от flightlessmango [https://github.com/flightlessmango/MangoHud/releases]. Версия скрипта 1.1, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp"|| let "error += 1"
sudo -S wget https://github.com/flightlessmango/MangoHud/releases/download/v0.6.1/MangoHud-0.6.1.tar.gz || let "error += 1"
sudo -S tar xfvz MangoHud*.tar.gz || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp/MangoHud" || let "error += 1"
sudo -S sh mangohud-setup.sh uninstall || true
sudo -S sh mangohud-setup.sh install || let "error += 1"
cd
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true
#формируем информацию о том что в итоге установили и показываем в терминал
mesa_version=`inxi -G | grep "Mesa"`  || let "error += 1"
tput setaf 2; echo "Установлен драйвер:${mesa_version}, тестируем мониторинг!"  || let "error += 1"
#сброс цвета текста в терминале
tput sgr0
# 5 секунд теста mangohud
mangohud glxgears | sleep 5 | exit 0

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
#Добавляем информацию о изменении флагов в файле настройки GRUB в лог установки
echo "для использования MangoHud:"	 				  >> "${script_dir}/module_install_log"
echo "если OpenGL: mangohud /way/to/app"	 				  >> "${script_dir}/module_install_log"
echo "если Vulkan: MANGOHUD=1(либо mangohud) /way/to/app"	 				  >> "${script_dir}/module_install_log"
echo "например в steam:"	 				  >> "${script_dir}/module_install_log"
echo "MANGOHUD=1 MANGOHUD_CONFIG=cpu_temp,gpu_temp,vram,ram,position=top-right,font_size=22,vsync=3,arch %command%"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о командах и фукнциях тут: https://github.com/flightlessmango/MangoHud"	 				  >> "${script_dir}/module_install_log"

#задержка вывода информации о итогах установки, что бы пользователь мог ознакомиться.

exit 0
