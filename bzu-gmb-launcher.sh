#!/bin/bash

# определение папки где находиться скрипт и версию скрипта
export script_dir="$(cd $(dirname "$0") && pwd)"
export version="$(cat "${script_dir}/config/name_version")"

# запрос пароля супер пользователя, который дальше будет поставляться где требуется в качестве глобальной переменной, до конца работы скрипта
pass_user=$(zenity --entry --title="Для работы скрипта ${version} требуется пароль root" --text="Введите пароль:" \
 --entry-text="пароль" --hide-text --width=460 --height=128)
if [ -z "${pass_user} " ]; then
  zenity --error --text="Пароль не введён"
exit 1
fi
checkpkg() {
apt-mark showmanual | grep -x $1 &>/dev/null || { echo "$1 is not installed :(" ; echo "${pass_user}" | sudo -S apt install -f -y ${@:1} ; }
dpkgstatus="$(dpkg -s $1 | grep installed)"; echo "$1" "$dpkgstatus"
}
checkpkg yad # аналог zenity
checkpkg inxi # низкоуровневое ПО для вывода информации о железе
checkpkg meson # система сборки
checkpkg ninja-build # система сборки
checkpkg p7zip-rar rar unrar unace arj # архиватор
checkpkg python-tk # python toolkit
checkpkg xosd-bin # X On-Screen Display library 

# проверка что за система запустила скрипт
eval $(source /etc/os-release; echo linuxos="$PRETTY_NAME";)

#загружаем список операционных систем из файла в массив
#readarray -t linuxos_list < "${script_dir}/config/list-os"

# узнаём текущую версию OS
if [ "$(cat ${script_dir}/config/list-os | grep -x "$linuxos")" ]; then
start0="bash ${script_dir}/bzu-gmb-${linuxos}-beta4.sh"
echo "Linux OS: ${linuxos}"; else
osnotsupported=1; fi

#Топорная заглушка на случай если бета версия Ubuntu
#echo $linuxos | grep "Ubuntu Focal Fossa" > /dev/null
#if [ $? = 0 ];then
#start0=`echo $start0 | sed 's/Ubuntu Focal Fossa (development branch)/Ubuntu 20.04/g'`
#export linuxos_version=`echo ${linuxos_version0} | sed 's/Ubuntu Focal Fossa (development branch)/Ubuntu 20.04/g'`
#linuxos_status="4"
#fi
#echo "$start0"
#sleep 60
#exit 0
#заменяем пробелы в команде запуска скрипта на знак -, что бы не замарачиваться с жалобой системы на пробелы в имени файла
start=`echo $start0 | sed 's/ /-/2g'`
#echo "start:" $start
#exit 0
if [ $osnotsupported = 1 ]; then
echo "$linuxos is not supported OS"
zenity --error --ellipsize --text="данная операционная система $linuxos не поддерживается bzu-gmb"
exit 0
fi
#запуск скрипта согласно системы в которой он находиться
#echo $start
eval $start
#заглушка на вывод ошибки если система не совместима со скриптом

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
