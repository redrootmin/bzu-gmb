#!/bin/bash
#creator by RedRoot(Yacyna Mehail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License 

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
#получение пароля root пользователя
pass_user="$1"
# Проверка что существует папка .steam/root/compatibilitytools.d/, если нет, создаем ее
if [ ! -d "/home/${user_run_script}/.steam/debian-installation/compatibilitytools.d/" ]
then
mkdir -p "/home/${user_run_script}/.steam/debian-installation/compatibilitytools.d/" || let "error += 1"
#chmod -R 777 "/home/${user_run_script}/.steam/root/compatibilitytools.d/" || let "error += 1"
fi
script_dir_install="/home/${user_run_script}/.steam/debian-installation/compatibilitytools.d"
#echo "${script_dir_install}"
#exit 0

#объявляем нужные переменные для скрипта
date_install=`date`


#даем информацию в терминал какой модуль установливается
tput setaf 2; echo "Установка установка кастумной версии ProtonGE [https://github.com/GloriousEggroll/proton-ge-custom]. Версия скрипта 1.1, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля

echo "${pass_user}" | sudo -S killall steam || true
name_download_arh="Proton-6.19-GE-2.tar.gz"
name_dir_installing="Proton-6.19-GE-2"
cd
rm -rf "${script_dir_install}/${name_dir_installing}" || true
rm -f"${name_download_arh}" || true
wget "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/6.19-GE-2/${name_download_arh}" || let "error += 1"
tar xfvz "${name_download_arh}" -C "${script_dir_install}"
#sudo -S chmod -R 777 "${script_dir_install}/${name_dir_installing}"
rm "${name_download_arh}" || true
#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2
echo "Установлен ${name_download_arh}"
#сброс цвета текста в терминале
tput sgr0
# Installing Proton-5.11-GE-2-MF
name_download_arh="Proton-5.11-GE-2-MF.tar.gz"
name_dir_installing="Proton-5.11-GE-2-MF"
rm -fr "${script_dir_install}/${name_dir_installing}" || true
rm -f "${name_download_arh}" || true
wget "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/5.11-GE-2-MF/${name_download_arh}" || let "error += 1" 
tar xfvz "${name_download_arh}" -C "${script_dir_install}"
#sudo -S chmod -R 777 "${script_dir_install}/${name_dir_installing}"
rm "${name_download_arh}" || true

#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2
echo "Установлен ${name_download_arh}"
#сброс цвета текста в терминале
tput sgr0



#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
#Информация о том как использовать утилиту\программу
echo "ВНИМАНИЕ: для запуска Windows-игр в steam через PorotnGE, вам обязательно нужно включить фукнцию steamplay и в играх выбирать нужную версию Proton"	 				  >> "${script_dir}/module_install_log"
echo "сайт где можно посмотреть какие windows игры работаю в steam и в каком качестве: https://www.protondb.com/"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о командах и фукнциях ProtonGE тут: https://github.com/GloriousEggroll/proton-ge-custom#modification"	 				  >> "${script_dir}/module_install_log"

exit 0

