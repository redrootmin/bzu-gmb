#!/bin/bash

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
linuxos_run_bzu_gmb0=`cat "${script_dir}/config/os-run-script"`
export linuxos_run_bzu_gmb="${linuxos_run_bzu_gmb0}"

#загружаем данные о модули и файла конфигурации в массив
readarray -t module_conf < "${script_dir}/modules-temp/${name_script}/module_config"
#примеры считывания массива с данными
#version_kernel=${module_conf[*]} - Все записи в массиве
#version_kernel=${#module_conf[*]} - Количество записей в массиве, нумерания с нуля
#version_kernel=${module_conf[7]} - Определенная запись в массиве
version_proton=${module_conf[7]}

#получение пароля root пользователя
pass_user0="$1"
export pass_user="${pass_user0}"

#даем информацию в терминал какой модуль устанавливается
tput setaf 2; echo "Установка утилиты Psensor для мониторинга оборудования [https://wpitchoune.net/psensor/]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

if echo "${linuxos_run_bzu_gmb}" | grep -ow "Ubuntu" > /dev/null || echo "${linuxos_run_bzu_gmb}" | grep -ow "Mint" > /dev/null
then
#запуск основных команд модуля
sudo -S apt install -f -y --reinstall psensor || let "error += 1"
fi

if echo "${linuxos_run_bzu_gmb}" | grep -ow "Debian GNU/Linux bookworm/sid" > /dev/null
then
module_link='https://github.com/redrootmin/bzu-gmb-modules/releases/download/v1/psensor-debian-deb.tar.xz'
module_name_arc="psensor-debian-deb.tar.xz"
rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
wget "${module_link}" -O "${module_name_arc}" || let "error += 1"
tar -xpJf "${module_name_arc}"
echo "${pass_user}" | sudo -S apt install -f -y ./*.deb
cd
echo "${pass_user}" | sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
fi

#формируем информацию о том что в итоге установили и показываем в терминал
app_name="psensor"
dpkg -s ${app_name} | grep -ow "installed" > /dev/null
if [ $? = 0 ];then
tput setaf 2; echo "${app_name}:installed"
tput sgr0
echo "Testing:${app_name}"
# 5 секунд теста программы
psensor & sleep 5;echo "${pass_user}" | sudo -S killall psensor
tput setaf 2; echo "Установка ${app_name} завершена :)"
tput sgr0
else tput setaf 1;echo "${name_script}:не установлено!"
fi
tput sgr0

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"


exit 0
