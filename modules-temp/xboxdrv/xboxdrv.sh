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
tput setaf 2; echo "Установка утилиты xboxdrv [https://gitlab.com/xboxdrv/xboxdrv]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
sudo -S killall xboxdrv || true
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
sudo -S rm -r "/usr/share/${name_script}" || true
sudo -S rm "/usr/share/applications/${name_script}.desktop" || true
sudo -S apt install -f -y --reinstall xboxdrv
sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp"|| let "error += 1"
sudo -S wget "https://drive.google.com/uc?export=download&id=12P9aCmSYgXbtWbXuIDP6bUcu5G0xT0wo" -O "${name_script}.tar.xz" || let "error += 1"
sudo -S tar -xpJf "${name_script}.tar.xz" -C "${script_dir_install}"
sudo -S chmod +x "/usr/share/${name_script}/${name_script}.sh" || let "error += 1"
sudo -S chmod +x /usr/share/${name_script}/${name_script}.desktop || let "error += 1"
sudo -S cp -ax /usr/share/${name_script}/${name_script}.desktop /usr/share/applications/ || let "error += 1"
cd
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true

#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2
sudo -S dpkg --list | echo "Установлена утилита "`grep "${name_script}" | sed s/"ii"//g`
#сброс цвета текста в терминале
tput sgr0
bash -c "${script_dir_install}${name_script}/${name_script}.sh" & sleep 5;sudo -S killall xboxdrv-qt-5.6-rc


#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "Модуль ${name_script}, дата установки: ${date_install}, количество ошибок: ${error}"	 				  >> "${script_dir}/module_install_log"
#Добавляем информацию о изменении флагов в файле настройки GRUB в лог установки
echo "ВНИМАНИЕ: xboxdrv-qt-5.6-rc является неофицальным GUI для драйвера xboxdrv, поэтому разработчики рекомендуют пользоваться утилитой в консоли, пример: "	 				  >> "${script_dir}/module_install_log"
echo "cat /proc/bus/input/devices | grep "ipega media gamepad controller" -A 4 | grep -oh "event[1-9]*[1-9]""	 				  >> "${script_dir}/module_install_log"
echo "sudo xboxdrv --evdev /dev/input/event** --evdev-absmap ABS_X=x1,ABS_Y=y1,ABS_Z=x2,ABS_RZ=y2,ABS_HAT0X=dpad_x,ABS_HAT0Y=dpad_y --axismap -Y1=Y1,-Y2=Y2 --evdev-keymap BTN_A=a,BTN_B=b,BTN_X=x,BTN_Y=y,BTN_TL=lb,BTN_TR=rb,BTN_TL2=lt,BTN_TR2=rt,BTN_THUMBL=tl,BTN_THUMBR=tr,BTN_SELECT=back,BTN_START=start --silent &"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о командах и функциях тут: https://xboxdrv.gitlab.io/xboxdrv.html"	 				  >> "${script_dir}/module_install_log"

exit 0
