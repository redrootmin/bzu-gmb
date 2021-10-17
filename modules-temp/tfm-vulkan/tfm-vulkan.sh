#!/bin/bash
#creator by RedRoot(Yacyna Mehail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License 

#проверяем что модуль запущен от пользователя root
[ "$UID" -eq 0 ] || { zenity --error --text="Этот скрипт нужно запускать из под root!"; exit 1;}

# определение имени файла, папки где находиться скрипт и версию скрипта
name_script0=`basename "$0"`
name_script=`echo ${name_script0} | sed "s|.sh||g"`
script_dir0=$(cd $(dirname "$0") && pwd); name_cut="/modules-temp/${name_script}"
script_dir=`echo ${script_dir0} | sed "s|${name_cut}||g"`
version0=`cat "${script_dir}/config/name_version"`
version="${version0}"

#объявляем нужные переменные для скрипта
date_install=`date`
module_name_desktop="benchmark-vulkan.desktop"
module_name="tfm-benhmark-linux64-vulkan"
module_name_arc="tfm-benhmark-linux64-vulkan11.tar.xz"
module_dir_install="/usr/share/test/"
module_link='https://drive.google.com/uc?export=download&id=10ihaa3SQUtGkiRCveE9122jH5yXr5nof'


#даем информацию в терминал какой модуль установливается
tput setaf 2; echo "Установка утилиты Tyler's Frame Machine [Vulkan] от Tylemagne [https://github.com/Tylemagne/TFM]. Версия скрипта 1.1, автор: Яцына М.А."
tput sgr0

# Проверка что существует папка /usr/share/test, если нет, создаем ее
if [ ! -d "/usr/share/test" ]
then
sudo -S mkdir -p "/usr/share/test" || let "error += 1"
sudo chmod -R 755 /usr/share/test || let "error += 1"
fi

#запуск основных команд модуля
sudo -S killall tfm10-linux64-vulkan.x86_64 || true
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true
sudo -S rm -r "/usr/share/test/${module_name}" || true
sudo -S rm "/usr/share/applications/benchmark-vulkan.desktop" || true
sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp"|| let "error += 1"
sudo -S wget "${module_link}" -O "${module_name_arc}" || let "error += 1"
sudo -S tar -xpJf "${script_dir}/modules-temp/${name_script}/temp/${module_name_arc}" -C "${module_dir_install}" || let "error += 1"
sudo -S chmod +x "/usr/share/test/${module_name}/tfm10-linux64-vulkan.x86_64" || let "error += 1"
sudo -S chmod +x "/usr/share/test/${module_name}/benchmark-vulkan" || let "error += 1"
sudo -S chmod +x "/usr/share/test/${module_name}/${module_name_desktop}" || let "error += 1"
sudo -S cp -axf "/usr/share/test/${module_name}/${module_name_desktop}" /usr/share/applications/ || let "error += 1"
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

#Для создания скрипта использовались следующие ссылки
#https://techblog.sdstudio.top/blog/google-drive-vstavliaem-priamuiu-ssylku-na-izobrazhenie-sayta
#https://www.linuxliteos.com/forums/scripting-and-bash/preview-and-download-images-and-files-with-zenity-dialog/
#https://www.ibm.com/developerworks/ru/library/l-zenity/
#https://habr.com/ru/post/281034/
#https://webhamster.ru/mytetrashare/index/mtb0/20
#https://itfb.com.ua/kak-prisvoit-rezultat-komandy-peremennoj-obolochki/
#https://tproger.ru/translations/bash-cheatsheet/
#https://mirivlad.ru/2017/11/20-primerov-ispolzovaniya-potokovogo-tekstovogo-redaktora-sed/
#https://www.opennet.ru/docs/RUS/bash_scripting_guide/c1833.html
#https://losst.ru/massivy-bash
#https://www.shellhacks.com/ru/grep-or-grep-and-grep-not-match-multiple-patterns/
#https://techrocks.ru/2019/01/21/bash-if-statements-tips/






