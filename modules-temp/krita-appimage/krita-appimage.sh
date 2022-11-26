#!/bin/bash
#creator by RedRoot(Yaciyna Mikhail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License

#проверяем что модуль запущен от пользователя root
#[ "$UID" -eq 0 ] || { zenity --error --text="Этот скрипт нужно запускать из под root!"; exit 1;}

# определение имени файла, папки где находиться скрипт и версию скрипта
name_script0=`basename "$0"`
name_script=`echo ${name_script0} | sed "s|.sh||g"`
script_dir0=$(cd $(dirname "$0") && pwd); name_cut="/modules-temp/${name_script}"
script_dir=`echo ${script_dir0} | sed "s|${name_cut}||g"`
version0=`cat "${script_dir}/config/name_version"`
version="${version0}"
user_run_script=`cat "${script_dir}/config/user"`
#объявляем нужные переменные для скрипта
date_install=`date`
#загружаем данные о модули и файла конфигурации в массив
readarray -t module_conf < "${script_dir}/modules-temp/${name_script}/module_config"
#примеры считывания массива с данными
#version_kernel=${module_conf[*]} - Все записи в массиве
#version_kernel=${#module_conf[*]} - Количество записей в массиве, нумерания с нуля
#version_kernel=${module_conf[7]} - Определенная запись в массиве
version_app=${module_conf[7]}
#получение пароля root пользователя
pass_user="$1"

#даем информацию в терминал какой модуль устанавливается
tput setaf 2; echo "Установка Krita  популярного графического редактора с открытым исходным кодом [https://krita.org/]. Установка Krita осуществлыется в формате Appimage. Версия скрипта 1.0b, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
# Проверка что существует папка applications, если нет, создаем ее
if [ ! -d "/home/${user_run_script}/.local/share/applications" ]
then
mkdir -p "/home/${user_run_script}/.local/share/applications"
fi

# Проверка установлен vscodium или нет в папке пользователя
if [ ! -d "/home/${user_run_script}/bzu-gmb-apps/krita-appimage" ];then
tput setaf 2; echo "Графический редактор ${version_app} не установлен в папку пользователя ${user_run_script}, поэтому можно устанавливать :)"
tput sgr0
cd "/home/${user_run_script}/bzu-gmb-apps"
rm -f krita-appimage*.tar.xz
wget "https://github.com/redrootmin/bzu-gmb-modules/releases/download/v1/krita-appimage-5-1-3.tar.xz"
pv "krita-appimage-5-1-3.tar.xz" | tar -xJ
rm -f krita-appimage-5-1-3.tar.xz
cd "/home/${user_run_script}/bzu-gmb-apps/krita-appimage";chmod +x mini_install.sh
bash mini_install.sh

# 5 секунд теста программы
#script_dir=$(cd $(dirname "$0") && pwd);
#name_app=`cat "${script_dir}/version"`
#echo "Testing:${version_app}"
#cd "${script_dir}"
#echo "Папка установки:${script_dir}"
#bash -c "${script_dir}/app/krita_starter.sh" & sleep 5;echo "${pass_user}" | sudo -S killall "${name_app}"
#tput setaf 2; echo "Установка Игрового движка ${version_app} завершена :)"
#tput sgr0
else
tput setaf 1; echo "Графический редактор ${version_app} уже установлен в папку пользователя ${user_run_script}, что бы не стереть ваши важные данные, установка прирывается!"
tput sgr0
fi


#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
#Добавляем информацию о том как использовать CoreCtrl лог установки
#echo "Подробнее о том как запускать CoreCtrl без постоянного ввода пароля тут: https://gitlab.com/corectrl/corectrl/-/wikis/Setup"	 				  >> "${script_dir}/module_install_log"
#echo "Подробнее о командах и функциях тут: https://github.com/lutris/lutris/wiki" >> "${script_dir}/module_install_log"
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
#https://habr.com/ru/post/511608/
#https://techrocks.ru/2019/01/21/bash-if-statements-tips/
