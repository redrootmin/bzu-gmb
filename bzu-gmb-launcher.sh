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

# проверка установлен ли пакет
is_installed()
{
  dpkg -s $1 &> /dev/null
}

# устанавливаем пакет
install()
{
  echo "$pass_user" | sudo -S apt install -fy $1
}

# проверяем пакет и ставим, в конце выводим статус
check_and_install()
{
  is_installed $1 || echo "no installing $1 :(" && install $1
  status=`dpkg -s $1 | grep installed`
  echo `$1 $status`
}

packages=(
  yad # вывод диалоговых окон
  inxi # информация о низкоуровневом ПО и железе
  meson # система сборки из исходников 
  ninja-build # ещё одна сборочная система
  p7zip-rar # архиватор
  python-tk # графическая библиотека для построения интерфейсов
  xosd-bin # ???
  aptitude # система управления пакетами
)

for pkg_name in ${packages[*]}
do
  check_and_install pkg_name
done

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
#echo $linuxos | grep "Ubuntu 20.04.1 LTS" > /dev/null
#if [ $? = 0 ];then
#start0=`echo $start0 | sed 's/Ubuntu 20.04.1 LTS/Ubuntu 20.04 LTS/g'`
#export linuxos_version=`echo ${linuxos_version0} | sed 's/Ubuntu 20.04.1 LTS/Ubuntu 20.04 LTS/g'`
#inuxos_status="4"
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
