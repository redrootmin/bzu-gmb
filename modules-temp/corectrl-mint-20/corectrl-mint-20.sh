#!/bin/bash
#creator by RedRoot(Yacyna Mehail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License 

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
#module_name_desktop=""
#module_name=""
module_name_arc="corectrl12-dev-ubuntu20.tar.xz"
#module_dir_install=""
module_link='https://drive.google.com/uc?export=download&id=1XW8TQMfG8DqrigToY1FsoQZx8tvtRcnH'

#даем информацию в терминал какой модуль устанавливается
tput setaf 2; echo "Установка утилиты CoreCtrl 1.2-dev от Juan Palacios [https://gitlab.com/corectrl/corectrl]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
sudo -S killall corectrl || true
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true
sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp"|| let "error += 1"
sudo -S wget "${module_link}" -O "${module_name_arc}" || let "error += 1"
sudo -S tar -xpJf "${script_dir}/modules-temp/${name_script}/temp/${module_name_arc}"
sudo -S add-apt-repository -y ppa:ernstp/mesarc  || let "error += 1"
sudo -S apt update
sudo -S aptitude -y install vulkan-tools libbotan-2-dev libfam0 libkf5archive5 libkf5auth-data libkf5authcore5 libkf5coreaddons-data libkf5coreaddons5 libpolkit-qt5-1-1 libqt5charts5 libqt5qml5 libqt5quick5 libqt5quickcontrols2-5 libqt5quicktemplates2-5 libtspi1 qml-module-qt-labs-platform qml-module-qtcharts qml-module-qtquick-controls2 qml-module-qtquick-layouts qml-module-qtquick-templates2 qml-module-qtquick-window2 qml-module-qtquick2
sudo -S dpkg -i *.deb
sudo -S rm /etc/apt/sources.list.d/ernstp*.list || let "error += 1"
sudo -S rm /etc/apt/sources.list.d/ernstp*.list.save || true
cd
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true
#sudo -S add-apt-repository -y ppa:ernstp/mesarc  || let "error += 1"
#sudo -S apt install -f -y corectrl || let "error += 1"
#sudo -S rm /etc/apt/sources.list.d/ernstp*.list || let "error += 1"
#sudo -S rm /etc/apt/sources.list.d/ernstp*.list.save || true
#sudo -S apt update -y || let "error += 1"
#sudo -S apt upgrade -y || let "error += 1"

#формируем информацию о том что в итоге установили и показываем в терминал
mesa_version=`inxi -G | grep "Mesa"`  || let "error += 1"
tput setaf 2; echo "Установлен драйвер ${mesa_version}, тестируем CoreCtrl!"  || let "error += 1"
sudo dpkg --list | echo "Установлена утилита "`grep "CoreCtrl" | sed s/"ii"//g`
#сброс цвета текста в терминале
tput sgr0
#тестовый запуск CoreCtrl
corectrl & sleep 5;sudo -S killall corectrl

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "Модуль ${name_script}, дата установки: ${date_install}, количество ошибок: ${error}"	 				  >> "${script_dir}/module_install_log"

#Добавляем информацию о том как использовать CoreCtrl лог установки
echo "Подробнее о запуске CoreCtrl без постоянного ввода пароля тут: https://gitlab.com/corectrl/corectrl/-/wikis/Setup"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о командах и функциях тут: https://gitlab.com/corectrl/corectrl/-/wikis/How-profiles-works"	 				  >> "${script_dir}/module_install_log"

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
