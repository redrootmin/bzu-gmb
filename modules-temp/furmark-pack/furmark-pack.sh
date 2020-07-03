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
tput setaf 2; echo "Установка набора утилит GpuTest 0.7.0 от Geeks3D [https://www.geeks3d.com/gputest/]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

# Проверка что существует папка /usr/share/test, если нет, создаем ее
if [ ! -d "/usr/share/test" ]
then
sudo -S mkdir -p "/usr/share/test" || let "error += 1"
sudo chmod -R 755 /usr/share/test || let "error += 1"
fi

#запуск основных команд модуля
sudo -S killall GpuTest || true
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
sudo -S rm -r "/usr/share/test/GpuTest_Linux_x64_0.7.0" || true
sudo -S rm "/usr/share/applications/furmark_benchmark.desktop" || true
sudo -S rm "/usr/share/applications/[zink]furmark_benchmark.desktop" || true
sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp"|| let "error += 1"
sudo -S wget "https://drive.google.com/uc?export=download&id=1FQpPUWbreyIGJ3ClQL8Yg5a9_eEE-LN9" -O GpuTest_Linux_x64_0.7.0.7z || let "error += 1"
sudo -S 7z x GpuTest_Linux_x64_0.7.0.7z -o/usr/share/test/ || let "error += 1"
sudo -S chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/GpuTest || let "error += 1"
sudo -S chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/gputest_gui-2.0.py || let "error += 1"
sudo -S chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/gputest_gui-3.0.py || let "error += 1"
sudo -S chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark || let "error += 1"
sudo -S chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark_zink || let "error += 1"
sudo -S chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark.desktop || let "error += 1"
sudo -S chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/[zink]furmark_benchmark.desktop || let "error += 1"
sudo -S chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/start_furmark_windowed_1024x640.sh || let "error += 1"
sudo -S cp -axf /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark.desktop /usr/share/applications/ || let "error += 1"
sudo -S cp -axf /usr/share/test/GpuTest_Linux_x64_0.7.0/[zink]furmark_benchmark.desktop /usr/share/applications/ || let "error += 1"
cd
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true

#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2;echo "Установлен GpuTest 0.7.0!"|| let "error += 1"
#сброс цвета текста в терминале
tput sgr0
cd /usr/share/test/GpuTest_Linux_x64_0.7.0/
./GpuTest /test=fur /width=1024 /height=640 & sleep 5;sudo -S killall GpuTest

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о командах и фукнциях тут: https://www.geeks3d.com/gputest/"	 				  >> "${script_dir}/module_install_log"

exit 0

#https://drive.google.com/file/d/1FQpPUWbreyIGJ3ClQL8Yg5a9_eEE-LN9/view?usp=sharing
#sudo wget "https://drive.google.com/uc?export=download&id=1FQpPUWbreyIGJ3ClQL8Yg5a9_eEE-LN9" -O GpuTest_Linux_x64_0.7.0.7z
#sudo 7z x GpuTest_Linux_x64_0.7.0.7z -o/usr/share/test/
#sudo chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/GpuTest
#sudo chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/gputest_gui-2.0.py
#sudo chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/gputest_gui-3.0.py
#sudo chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark
#sudo chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark_zink
#sudo chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark.desktop
#sudo chmod +x /usr/share/test/GpuTest_Linux_x64_0.7.0/[zink]furmark_benchmark.desktop
#cp -axf /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark.desktop /usr/share/applications/
#cp -axf /usr/share/test/GpuTest_Linux_x64_0.7.0/[zink]furmark_benchmark.desktop /usr/share/applications/
