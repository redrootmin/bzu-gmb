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

#даем информацию в терминал какой модуль установливается
tput setaf 2; echo "Установка открытой утилиты Goverlay-v0.3.5 от benjamimgois [https://github.com/benjamimgois/goverlay]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
sudo -S killall goverlay || true
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
sudo -S rm -r "/usr/share/goverlay" || true
sudo -S rm "/usr/share/applications/goverlay.desktop" || true
sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp"|| let "error += 1"
sudo -S wget "https://drive.google.com/uc?export=download&id=1RrqIvii5qORDe7pPq7O0K-WWjY3uS9sY" -O goverlay.7z || let "error += 1"
sudo -S 7z x goverlay.7z -o/usr/share/ || let "error += 1"
sudo -S chmod +x /usr/share/goverlay/goverlay || let "error += 1"
sudo -S chmod +x /usr/share/goverlay/goverlay.desktop || let "error += 1"
sudo -S cp -ax /usr/share/goverlay/goverlay.desktop /usr/share/applications/ || let "error += 1"
cd
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true

#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2;echo "Установлен Goverlay-v0.3.5!"|| let "error += 1"
#сброс цвета текста в терминале
tput sgr0
/usr/share/goverlay/goverlay & sleep 5;sudo -S killall goverlay


#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
#Добавляем информацию о изменении флагов в файле настройки GRUB в лог установки
echo "ВНИМАНИЕ: Goverlay работает только с программами MangoHud и vkBasalt"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о командах и фукнциях тут: https://github.com/benjamimgois/goverlay"	 				  >> "${script_dir}/module_install_log"

#задержка вывода информации о итогах установки, что бы пользователь мог ознакомиться.
sleep 3
exit 0
