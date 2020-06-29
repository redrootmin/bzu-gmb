#!/bin/bash

# определение папки где находиться скрипт и версию скрипта
script_dir0=$(cd $(dirname "$0") && pwd);
export script_dir="${script_dir0}"
version0=`cat "${script_dir}/config/name_version"`
export version="${version0}"

# запрос пароля супер пользователя, который дальше будет поставляться где требуется в качестве глобальной переменной, до конца работы скрипта
if pass_user0=$(zenity --entry --title="Для работы скрипта ${version} требуется пароль root" --text="Введите пароль:" \
 --entry-text="пароль" --hide-text --width=460 --height=128)
then
export pass_user=${pass_user0}
#echo "pass:${pass_user}"
else
  zenity --error --text="Пароль не введён"
exit 0
fi

#проверка установлен или нет yad и другое необходимое ПО для bzu-gmb
dpkg -s yad | grep installed > /dev/null || echo 'no installing yad :(' | echo "$pass_user" | sudo -S apt install -f -y yad
YadStatus=`dpkg -s yad | grep installed`
echo "YAD" $YadStatus

#проверяем установлена утилита inxi - информация о низкоуровневом ПО и железе
dpkg -s inxi | grep installed > /dev/null || echo 'no install inxi :(' | sudo -S apt install -f -y inxi
inxistatus=`dpkg -s inxi | grep installed`
echo "INXI" $inxistatus

#проверяем установлена утилита meson - она необходима для сборки многих программ из исходников
dpkg -s meson | grep installed > /dev/null || echo 'no install meson :(' | sudo -S apt install -f -y meson
inxistatus=`dpkg -s inxi | grep installed`
echo "meson" $inxistatus

#проверяем установлена утилита ninja-build - она необходима для сборки многих программ из исходников
dpkg -s ninja-build | grep installed > /dev/null || echo 'no install ninja-build :(' | sudo -S apt install -f -y ninja-build
inxistatus=`dpkg -s ninja-build | grep installed`
echo "ninja-build" $inxistatus

#проверяем установлена утилита p7zip-rar - она необходима для установки многих программ
dpkg -s p7zip-rar | grep installed > /dev/null || echo 'no install p7zip-rar :(' | sudo -S apt install -f -y p7zip-rar rar unrar unace arj
inxistatus=`dpkg -s ninja-build | grep installed`
echo "p7zip-rar" $inxistatus

#проверяем установлена утилита python-tk - она необходима для установки многих программ
dpkg -s python-tk | grep installed > /dev/null || echo 'no install p7zip-rar :(' | sudo -S apt install -f -y python-tk
inxistatus=`dpkg -s python-tk | grep installed`;echo "python-tk" $inxistatus

#проверяем установлена утилита xosd-bin - она необходима для работы многих программ
dpkg -s xosd-bin | grep installed > /dev/null || echo 'no install xosd-bin :(' | sudo -S apt install -f -y xosd-bin
inxistatus=`dpkg -s xosd-bin | grep installed`;echo "xosd-bin" $inxistatus

# проверка что за система запустила скрипт
linuxos=`grep '^PRETTY_NAME' /etc/os-release`

#загружаем список операционных систем из файла в массив
readarray -t linuxos_list < "${script_dir}/config/list-os"

#создаем цикл где будет проверяться согласно данных из файла в какой системе запущен скрипт
linuxos_num=${#linuxos_list[@]}
#задаем переменные, что бы отработал заглушка на неправильную ОС и очищаем переменную для цикла на всякий случай
linuxos_status=0
i=0

while [ $i -lt $linuxos_num ]
do
#проверяем на совпадение списка систем из файла и системы в которой запущен скрипт
echo $linuxos | grep "${linuxos_list[$i]}" > /dev/null
if [ $? = 0 ];then
#если есть совпадение формируем команду запуска главного модуля для нужной системы
start0="bash ${script_dir}/bzu-gmb-${linuxos_list[$i]}-beta4.sh"
echo "Linux OS:${linuxos_list[$i]}"
export linuxos_version=${linuxos_list[$i]}
#присваиваем значение переменной что бы заглушка на не поддерживаемую ОС отключилась, при отмене установки
linuxos_status=$i
#echo "start0:$start0"
fi
i=$(($i + 1))
done

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

#запуск скрипта согласно системы в которой он находиться
#echo $start
eval $start
#заглушка на вывод ошибки если система не совместима со скриптом
if [ $linuxos_status = 0 ];then
linux=`echo $linuxos | sed 's/PRETTY_NAME=/ /g'`
echo $linux "No support OS"
zenity --error --ellipsize --text="данная операционная система $linux не поддерживается bzu-gmb"
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
