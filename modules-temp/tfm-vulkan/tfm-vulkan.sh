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
tput setaf 2; echo "Установка утилиты Tyler's Frame Machine [Vulkan] от Tylemagne [https://github.com/Tylemagne/TFM]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
sudo -S killall tfm10-linux64-vulkan.x86_64 || true
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true
sudo -S rm -r "/usr/share/test/tfm-benhmark-linux64-vulkan" || true
sudo -S rm "/usr/share/applications/benchmark-vulkan.desktop" || true
sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp"|| let "error += 1"
sudo -S wget "https://drive.google.com/uc?export=download&id=1IDjdw1ieQeK-DaeTrP6g9Q9GawKakObS" -O tfm-benhmark-linux64-vulkan.7z || let "error += 1"
sudo -S sudo 7z x tfm-benhmark-linux64-vulkan.7z -o/usr/share/test/ || let "error += 1"
sudo -S chmod +x /usr/share/test/tfm-benhmark-linux64-vulkan/tfm10-linux64-vulkan.x86_64 || let "error += 1"
sudo -S chmod +x /usr/share/test/tfm-benhmark-linux64-vulkan/benchmark-vulkan || let "error += 1"
sudo -S chmod +x /usr/share/test/tfm-benhmark-linux64-vulkan/benchmark-vulkan.desktop || let "error += 1"
sudo -S cp -axf /usr/share/test/tfm-benhmark-linux64-vulkan/benchmark-vulkan.desktop /usr/share/applications/ || let "error += 1"
cd
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true

#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2;echo "Установлен Tyler's Frame Machine [Vulkan]!"|| let "error += 1"
#сброс цвета текста в терминале
tput sgr0

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о командах и фукнциях тут: https://github.com/Tylemagne/TFM"	 				  >> "${script_dir}/module_install_log"

exit 0

#sudo wget "https://drive.google.com/uc?export=download&id=1IDjdw1ieQeK-DaeTrP6g9Q9GawKakObS" -O tfm-benhmark-linux64-vulkan.7z
#sudo 7z x tfm-benhmark-linux64-vulkan.7z -o/usr/share/test/
#sudo chmod +x /usr/share/test/tfm-benhmark-linux64-vulkan/tfm10-linux64-vulkan.x86_64
#sudo chmod +x /usr/share/test/tfm-benhmark-linux64-vulkan/benchmark-vulkan
#sudo chmod +x /usr/share/test/tfm-benhmark-linux64-vulkan/benchmark-vulkan.desktop
#sudo cp -axf /usr/share/test/tfm-benhmark-linux64-vulkan/benchmark-vulkan.desktop /usr/share/applications/





