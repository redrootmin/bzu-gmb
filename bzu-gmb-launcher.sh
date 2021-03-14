#!/bin/bash
#creator by RedRoot(Yacyna Mehail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License 
# определение папки где находиться скрипт и версию скрипта
script_dir0=$(cd $(dirname "$0") && pwd);
export script_dir="${script_dir0}"
version0=`cat "${script_dir}/config/name_version"`
export version="${version0}"
# получение имени пользователя, который запустил скрипт, что бы в будущем модули могли его использовать
echo "$USER" > "${script_dir}/config/user"
# проверка что за система запустила скрипт
#linuxos=`grep '^PRETTY_NAME' /etc/os-release`

# запрос пароля супер пользователя, который дальше будет поставляться где требуется в качестве глобальной переменной, до конца работы скрипта
pass_user0=$(zenity --entry --width=128 --height=128 --title="Запрос пароля" --text="Для работы скрипта ${version} требуется Ваш пароль суперпользователя:" --hide-text)

if [[ "${pass_user0}" == "" ]]
then
zenity --error --text="Пароль не введён"
exit 0
else 
export pass_user=${pass_user0}
fi


#функция для проверки пакетов на установку, если нужно установлевает
function install_package {
dpkg -s $1 | grep installed > /dev/null || echo "no installing $1 :(" | echo "$2" | sudo -S apt install -f -y $1
package_status=`dpkg -s $1 | grep -oh "installed"`
echo "$1:" $package_status
}

#загружаем список пакетов из файла в массив
readarray -t packages_list < "${script_dir}/config/packages-for-bzu-gmb"
#задем переменной колличество пакетов в массиве
packages_number=${#packages_list[@]}
#обьявляем переменную числовой
i=0
#цикл проверки пакетов из массива
while [ $i -lt $packages_number ]
do
#вызов функции для проверки пакетов из массива
install_package ${packages_list[$i]} ${pass_user}
i=$(($i + 1))
done


#загружаем список операционных систем из файла в массив
readarray -t linuxos_list < "${script_dir}/config/list-os"
#создаем цикл где будет проверяться согласно данных из файла в какой системе запущен скрипт
linuxos_number=${#linuxos_list[@]}
#задаем переменные, что бы отработал заглушка на неправильную ОС и очищаем переменную для цикла на всякий случай
linuxos_version=""
i=0
#проверяем на совпадение списка систем из файла и системы в которой запущен скрипт
#linux_os=`cat "/etc/os-release" | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/"//g'`
linux_os=`cat "/etc/os-release" | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/"//g'`
while [ $i -lt $linuxos_number ]
do
if [[ "${linux_os}" == "${linuxos_list[$i]}" ]]
then
export linuxos_version=${linuxos_list[$i]}
fi
i=$(($i + 1))
done
tput setaf 2
echo "your Linux OS:["$linuxos_version"]"
tput sgr0

#
if [[ $linuxos_version == "" ]]
then
if experemental_os=$(zenity --question --width=256 --height=128 --title='экперементальный режим' --text="Ваша операныонная система [$linux_os] не поддерживается ${version}. Включить эксперементальный режим совместимости с Ubuntu?") 
then
echo "experimental" > "${script_dir}/config/status"
echo $linux_os >> "${script_dir}/config/list-os"
cd ${script_dir}
./bzu-gmb-gui-beta4.sh
else 
zenity --error --ellipsize  --timeout=5 --text="Данная операционная система $linux_os не совместима с ${version}"
fi

else
#echo "normal" > "${script_dir}/config/status"
cd ${script_dir}
./bzu-gmb-gui-beta4.sh
fi

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
