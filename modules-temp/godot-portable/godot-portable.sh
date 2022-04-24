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
tput setaf 2; echo "Установка Godot Engine - открытого кроссплатформенного 2D и 3D игрового движка под лицензией MIT [https://godotengine.org/]. Установка Godot Engine производиться в формате Portable. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0


#echo "${pass_user}" | sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
#echo "${pass_user}" | sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
#cd "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
#echo "${pass_user}" | sudo -S add-apt-repository -y   || let "error += 1"
# переходим в папку пользователя
#cd
#echo "${pass_user}" | sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true
# УСТАНОВКА ПЛАГИНА OBS-LINUXBROWSER
#echo "${pass_user}" | sudo -S apt install cmake libgconf-2-4
#скачиваем архив с плагином и распаковываем его
#wget https://github.com/bazukas/obs-linuxbrowser/releases/download/0.6.1/linuxbrowser0.6.1-obs23.0.2-64bit.tgz
#создаем папку плагины в конфигурации OBS-studio
#mkdir -p "/home/${user_run_script}/.config/obs-studio/plugins"
#далее распаковываем архив в папку с плагинами OBS-studio
#tar xfvz linuxbrowser*.tgz -C "/home/${user_run_script}/.config/obs-studio/plugins/"
#после запускаем OBS, он запуститься не сразу, так как подключает первый раз плагин.
#как запуститься, в источниках появится Linux Browser, настройки такие же как у obs-qtwebkit
#echo "${pass_user}" | sudo -S apt install -f -y --reinstall --install-recommends kate breeze || let "error += 1"
#формируем информацию о том что в итоге установили и показываем в терминал
#app_status=`dpkg -s kate | grep -ow "installed"`  || tput setaf 1 | echo "${name_script} no installed" | tput sgr0; echo "${name_script}:${app_status}"
#tput setaf 2; echo "Установлен драйвер:${mesa_version}, тестируем запуск!"  || let "error += 1"


#запуск основных команд модуля
# Проверка что существует папка applications, если нет, создаем ее
if [ ! -d "/home/${user_run_script}/.local/share/applications" ]
then
mkdir -p "/home/${user_run_script}/.local/share/applications"
fi

# Проверка установлен vscodium или нет в папке пользователя
if [ ! -d "/home/${user_run_script}/godot-portable" ]
then
tput setaf 2; echo "Игровой движек ${version_app} не установлен в папку пользователя ${user_run_script}, поэтому можно устанавливать :)"
tput sgr0
cd
name_app="godot-portable-3-4-4.tar.xz"
rm -f godot-portable*
wget "https://github.com/redrootmin/bzu-gmb-modules/releases/download/v1/$name_app"
tar -xpJf "$name_app"
rm -f "$name_app"
cd ~/godot-portable;chmod +x mini_install.sh
bash mini_install.sh

# 5 секунд теста программы
app_name="godot-portable"
echo "Testing:${version_app}"
cd "/home/${user_run_script}/${name_script}"
echo "Папка установки:/home/${user_run_script}/${name_script}"
bash -c "/home/${user_run_script}/${name_script}/app/godot_starter.sh" & sleep 5;echo "${pass_user}" | sudo -S killall "${app_name}"
tput setaf 2; echo "Установка Игрового движка ${version_app} завершена :)"
tput sgr0
else
tput setaf 1; echo "Игровой движек ${version_app} уже установлен в папку пользователя ${user_run_script}, что бы не стереть ваши важные данные, установка прирывается!"
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
