#!/bin/bash
#проверяем что модуль запущен от пользователя root
[ "$UID" -eq 0 ] || { zenity --error --text="Этот скрипт нужно запускать из под root!"; exit 1;}
#объявляем нужные переменные для скрипта
script_name=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));
script_dir=$(cd $(dirname "$0") && pwd);
version=`cat "${script_dir}/config/name_version"`\
date_install=`date`
#даем информацию в терминал какой модуль установливается
tput setaf 2; echo "Установка репозитория с актуальной версией драйвера Mesa, версия скрипта 1.0, автор: Яцына М.А."
tput sgr0
#проверяем установлена утилита inxi - информация о низкоуровневом ПО и железе
dpkg -s inxi | grep installed > /dev/null || echo 'inxi is not installed :(' | sudo -S apt install -f -y inxi
inxistatus=`dpkg -s inxi | grep installed`
echo "INXI" $inxistatus

#запуск основных команд модуля
sudo -S add-apt-repository ppa:oibaf/graphics-drivers -y || error+=1
#sudo -S apt-get update -y
sudo -S apt-get upgrade -y  || error+=1
sudo -S apt-get install -f -y  || error+=1
yes Y | sudo -S apt-get autoremove  || error+=1
yes Y | sudo -S apt-get clean  || error+=1
#формируем информацию о том что в итоге установили и показываем в терминал
mesa_version=`inxi -G | grep "Mesa"`  || error+=1
tput setaf 2; echo "Установлен драйвер ${mesa_version}"  || error+=1
#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "Модуль ${script_name}, дата установки: ${date_install}, количество ошибок: ${error}"	 				  >> "${script_dir}/module_install_log"
#сброс цвета текста в терминале
tput sgr0
#задержка вывода информации о итогах установки, что бы пользователь мог ознакомиться.
sleep 6

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
