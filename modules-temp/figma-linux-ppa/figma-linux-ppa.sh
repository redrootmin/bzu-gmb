#!/bin/bash
#creator by RedRoot(Yaciyna Mikhail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License

#проверяем что модуль запущен от пользователя root
#[ "$UID" -eq 0 ] || { zenity --error --text="Этот скрипт нужно запускать из под root!"; exit 1;}

# определение имени файла, папки где находиться скрипт и версию скрипта
name_script0=`basename "$0"`
name_script=`echo ${name_script0} | sed 's/\.sh\>//g'`
script_dir0=$(cd $(dirname "$0") && pwd); name_cut="/modules-temp/${name_script}"
script_dir=`echo ${script_dir0} | sed "s|${name_cut}||g"`
version0=`cat "${script_dir}/config/name_version"`
version="${version0}"
user_run_script=`cat "${script_dir}/config/user"`

#Определение расположениея папок для утилит и т.д.
utils_dir="${script_dir}/core-utils"

#Определение переменныех утилит и скриптов
YAD="${utils_dir}/yad"
zenity="${utils_dir}/zenity"
pv="${utils_dir}/pv"

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
tput setaf 2; echo "Установка Figma лучшего инструмента для проектирования интерфейсов и прототипирования с возможностью организации совместной работы в режиме реального времени [https://github.com/Figma-Linux/figma-linux , https://launchpad.net/~chrdevs/+archive/ubuntu/figma]. Версия скрипта 1.0b, автор: Яцына М.А."
tput sgr0

if echo "${linuxos_run_bzu_gmb}" | grep -ow "Ubuntu" > /dev/null || echo "${linuxos_run_bzu_gmb}" | grep -ow "Mint" > /dev/null
then
#запуск основных команд модуля
echo "${pass_user}" | sudo -S apt-key adv --recv-key --keyserver keyserver.ubuntu.com 70F3445E637983CC || let "error += 1"
echo "${pass_user}" | sudo -S add-apt-repository -y  ppa:chrdevs/figma || let "error += 1"
if echo "${linuxos_run_bzu_gmb}" | grep -ow "Mint" > /dev/null ;then
echo "${pass_user}" | sudo -S apt update -y || let "error += 1"
fi
echo "${pass_user}" | sudo -S apt install -f -y --reinstall figma-linux || let "error += 1"
echo "${pass_user}" | sudo -S chmod +x /opt/figma-linux/figma-linux || let "error += 1"
fi

if echo "${linuxos_run_bzu_gmb}" | grep -ow "Debian GNU/Linux bookworm/sid" > /dev/null
then
module_link='https://github.com/redrootmin/bzu-gmb-modules/releases/download/v1/figma-linux_0.9.3_linux_amd64.deb.tar.xz'
module_name_arc="figma-linux_0.9.3_linux_amd64.deb.tar.xz"
rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
wget "${module_link}" -O "${module_name_arc}" || let "error += 1"
${pv} "${module_name_arc}" | tar -xJ 
echo "${pass_user}" | sudo -S apt install -f -y ./*.deb
cd
echo "${pass_user}" | sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
fi


#формируем информацию о том что в итоге установили и показываем в терминал
app_name="figma-linux"
dpkg -s ${app_name} | grep -ow "installed" > /dev/null
if [ $? = 0 ];then
tput setaf 2; echo "${app_name}:установлен!"
tput sgr0
echo "Тестируем:${app_name}"
# 5 секунд теста программы
figma-linux & sleep 5;echo "${pass_user}" | sudo -S killall "figma-linux"
tput setaf 2; echo "Установка ${app_name} завершена :)"
tput sgr0
else tput setaf 1;echo "${name_script}:не установлен :("
fi
tput sgr0

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
#Добавляем информацию о изменении флагов в файле настройки GRUB в лог установки

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
