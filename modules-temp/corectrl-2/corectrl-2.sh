#!/bin/bash
#creator by RedRoot(Yacyna Mehail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License 

#проверяем что модуль запущен от пользователя root
[ "$UID" -eq 0 ] || { zenity --error --text="Этот скрипт нужно запускать из под root!"; exit 1;}

# определение имени файла, папки где находиться скрипт и версию скрипта
name_script0=`basename "$0"`
name_script=`echo ${name_script0} | sed "s|.sh||g"`
script_dir0=$(cd $(dirname "$0") && pwd); name_cut="/modules-temp/${name_script}"
script_dir=`echo ${script_dir0} | sed "s|${name_cut}||g"`
version0=`cat "${script_dir}/config/name_version"`
version="${version0}"
#объявляем нужные переменные для скрипта
user_run_script=`cat "${script_dir}/config/user"`
polkit_version=`pkaction --version | grep -Eo '[0-9*'.']{1,}'`
#echo "polkit version=${polkit_version}"
if [[ "${polkit_version}" == "0.105" ]]
then
rule_dir_install="/etc/polkit-1/localauthority/50-local.d"
rule_file_install="90-corectrl.pkla"
else
rule_dir_install="/etc/polkit-1/rules.d"
rule_file_install="90-corectrl.rules"
fi
sudo -S cat "${rule_dir_install}/${rule_file_install}" > /dev/null || rule_file_create="yes"
export dir_grub_file="/etc/default"
export grub_file_name="grub"
readarray -t grub_flag_base < "${script_dir}/modules-temp/${name_script}/grub-flag-base"
cp -p -f "/etc/default/grub" "/etc/default/grub.bak"
echo "сделан бикап файла grub /etc/default/grub.bak"

function install_flags_grub_kernel {
flag_status=`cat "${dir_grub_file}/${grub_file_name}" | grep -oh "$2"`
if [[ "${flag_status}" == "$2" ]];then
tput setaf 3
echo "флаг $2 уже добавлен в grub" 
tput sgr0 
cat "${dir_grub_file}/${grub_file_name}" | grep "$2"
else
sed -i '0,/'$1'="/ s//'$1'="'$2' /' ${dir_grub_file}/${grub_file_name}
tput setaf 2
echo "флаг ${amd_full_gpu_control} добавлен в grub"
tput sgr0
cat ${dir_grub_file}/${grub_file_name} | grep "$1"

fi
}

#echo "install in ${rule_dir_install}"
#загружаем данные о модули и файла конфигурации в массив
#readarray -t module_conf < "${script_dir}/modules-temp/${name_script}/module_config"
#примеры считывания массива с данными
#version_kernel=${module_conf[*]} - Все записи в массиве
#version_kernel=${#module_conf[*]} - Количество записей в массиве, нумерания с нуля
#version_kernel=${module_conf[7]} - Определенная запись в массиве

date_install=`date`

#даем информацию в терминал какой модуль устанавливается
tput setaf 2; echo "Установка утилиты CoreCtrl 1.х-dev от Juan Palacios [https://gitlab.com/corectrl/corectrl]. Версия скрипта 2.0, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
sudo -S killall corectrl || true
sudo -S add-apt-repository -y ppa:ernstp/mesarc  || let "error += 1"
sudo -S apt install -f -y corectrl || let "error += 1"
sudo -S rm /etc/apt/sources.list.d/ernstp*.list || let "error += 1"
sudo -S rm /etc/apt/sources.list.d/ernstp*.list.save || true
sudo -S apt update -y || let "error += 1"

#создание файла с правилом запуска corectrl без запроса пароля
if [[ "${polkit_version}" == "0.105" ]]
then
if [[ "${rule_file_create}" == "yes" ]]
then
cd "${script_dir}/modules-temp/${name_script}"
echo "[User permissions]" > ${rule_file_install}
echo "Identity=unix-group:${user_run_script}" >> ${rule_file_install}
echo "Action=org.corectrl.*" >> ${rule_file_install}
echo "ResultActive=yes" >> ${rule_file_install}
sudo -S mv "${rule_file_install}" "${rule_dir_install}"
tput setaf 2
echo "файл правила запуска corectrl без sudo создан!"
tput sgr0
cat "${rule_dir_install}/${rule_file_install}"
else
tput setaf 3
echo "файл правила запуска corectrl без sudo уже создан"
tput sgr0
cat "${rule_dir_install}/${rule_file_install}"
fi
fi

#добовление маски в файл grub для полного управления питанием и частотами в драйвере amdgpu
install_flags_grub_kernel ${grub_flag_base[0]} ${grub_flag_base[1]}

sudo -S update-grub
#формируем информацию о том что в итоге установили и показываем в терминал
mesa_version=`inxi -G | grep "Mesa"`  || let "error += 1"
tput setaf 2; echo "Установлен драйвер:${mesa_version}, тестируем CoreCtrl!"  || let "error += 1"
sudo -S dpkg --list | echo "Установлена утилита:"`grep "CoreCtrl" | sed s/"ii"//g`
#сброс цвета текста в терминале
tput sgr0
#тестовый запуск CoreCtrl
corectrl & sleep 5;sudo -S killall corectrl

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"

#Добавляем информацию о том как использовать CoreCtrl лог установки
echo "Подробнее о том как запускать CoreCtrl без постоянного ввода пароля тут: https://gitlab.com/corectrl/corectrl/-/wikis/Setup"	 				  >> "${script_dir}/module_install_log"
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
#https://habr.com/ru/post/511608/
#https://techrocks.ru/2019/01/21/bash-if-statements-tips/
