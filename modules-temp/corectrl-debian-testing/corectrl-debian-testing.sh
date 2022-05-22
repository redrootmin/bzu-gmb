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
user_run_script_group=$(id -gn)
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
tput setaf 2; echo "Установка утилиты CoreCtrl 1.х-dev от Juan Palacios [https://gitlab.com/corectrl/corectrl]. Версия скрипта 2.0, автор: Яцына М.А."
tput sgr0

#объявляем нужные переменные для скрипта
polkit_version=`pkaction --version | grep -Eo '[0-9*'.']{1,}'`

if [[ "${polkit_version}" == "0.105" ]]
then
rule_dir_install="/etc/polkit-1/localauthority/50-local.d"
rule_file_install="90-corectrl.pkla"
else
rule_dir_install="/etc/polkit-1/rules.d"
rule_file_install="90-corectrl.rules"
fi
echo "${pass_user}" | sudo -S cat "${rule_dir_install}/${rule_file_install}" > /dev/null || rule_file_create="yes"

export dir_grub_file="/etc/default"
export grub_file_name="grub"
readarray -t grub_flag_base < "${script_dir}/modules-temp/${name_script}/grub-flag-base"
echo "${pass_user}" | sudo -S cp -p -f "/etc/default/grub" "/etc/default/grub.bak"
echo "сделан бикап файла grub /etc/default/grub.bak"

function install_flags_grub_kernel {
flag_status=`cat "${dir_grub_file}/${grub_file_name}" | grep -oh "$2"`
if [[ "${flag_status}" == "$2" ]];then
tput setaf 3
echo "флаг $2 уже добавлен в grub" 
tput sgr0 
echo "${pass_user}" | sudo -S cat "${dir_grub_file}/${grub_file_name}" | grep "$2"
else
echo "${pass_user}" | sudo -S sed -i '0,/'$1'="/ s//'$1'="'$2' /' ${dir_grub_file}/${grub_file_name}
tput setaf 2
echo "флаг $2 добавлен в grub"
tput sgr0
echo "${pass_user}" | sudo -S cat ${dir_grub_file}/${grub_file_name} | grep "$1"
fi
}

function install_flags_grub_kernel_rosa {
flag_status=`cat "${dir_grub_file}/${grub_file_name}" | grep -oh "$2"`
if [[ "${flag_status}" == "$2" ]];then
tput setaf 3
echo "флаг $2 уже добавлен в grub" 
tput sgr0 
echo "${pass_user}" | sudo -S cat "${dir_grub_file}/${grub_file_name}" | grep "$2"
else
echo "${pass_user}" | sudo -S sed -i '0,/'$1'=\x27/ s//'$1'=\x27'$2' /' ${dir_grub_file}/${grub_file_name}
tput setaf 2
echo "${pass_user}" | sudo -S cat "${dir_grub_file}/${grub_file_name}" | grep -oh "$2" > /dev/null | echo "флаг $2 добавлен в grub" | tput sgr0 | echo "${pass_user}" | sudo -S cat ${dir_grub_file}/${grub_file_name} | grep "$1"
fi
}
#Проверяем какая система запустила bzu-gmb, если ROSA Fresh Desktop 12.2 устанавливаем нужные пакеты
if echo "${linuxos_run_bzu_gmb}" | grep -ow "ROSA Fresh Desktop 12.2" > /dev/null
then
# установка  обновление системы
echo "${pass_user}" | sudo -S dnf install -y corectrl

#добовление маски в файл grub для полного управления питанием и частотами в драйвере amdgpu
install_flags_grub_kernel_rosa ${grub_flag_base[0]} ${grub_flag_base[1]}
echo "${pass_user}" | sudo -S grub2-mkconfig -o "$(readlink -e /etc/grub2.cfg)"
#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2
corectrl_status="В вашу систему установлены следующие версия CoreCtrl:";rpm -qa | grep "corectrl" > /dev/null || corectrl_status="ОШИБКА: CoreCtrl не установлен!" | tput setaf 3; echo "$corectrl_status"; rpm -qa | grep "corectrl"
#сброс цвета текста в терминале
tput sgr0

#создание файла с правилом запуска corectrl без запроса пароля
rule_dir_install="/etc/polkit-1/localauthority/50-local.d"
rule_file_install="90-corectrl.pkla"
echo "${pass_user}" | sudo -S cat "${rule_dir_install}/${rule_file_install}" > /dev/null || rule_file_create="yes"
if [[ "${rule_file_create}" == "yes" ]]
then
cd "${script_dir}/modules-temp/${name_script}"
echo "[User permissions]" > ${rule_file_install}
echo "Identity=unix-group:$user_run_script_group" >> ${rule_file_install}
echo "Action=org.corectrl.*" >> ${rule_file_install}
echo "ResultActive=yes" >> ${rule_file_install}
echo "${pass_user}" | sudo -S mv "${rule_file_install}" "${rule_dir_install}"
tput setaf 2
echo "файлы правила запуска corectrl без sudo были созданы!"
echo "${rule_dir_install}/${rule_file_install}"
tput sgr0
echo "${pass_user}" | sudo -S cat "${rule_dir_install}/${rule_file_install}"

rule_dir_install="/etc/polkit-1/rules.d"
rule_file_install="90-corectrl.rules"
echo 'polkit.addRule(function(action, subject) {
    if ((action.id == "org.corectrl.helper.init" ||
         action.id == "org.corectrl.helperkiller.init") &&
        subject.local == true &&
        subject.active == true &&
        subject.isInGroup("'$user_run_script_group'")) {
            return polkit.Result.YES;
    }
});' > ${rule_file_install}
echo "${pass_user}" | sudo -S mv "${rule_file_install}" "${rule_dir_install}"
tput setaf 2
echo "${rule_dir_install}/${rule_file_install}"
tput sgr0
echo "${pass_user}" | sudo -S cat "${rule_dir_install}/${rule_file_install}"
else
tput setaf 3
echo "файл правила запуска corectrl без sudo уже создан"
tput sgr0
echo "${pass_user}" | sudo -S cat "${rule_dir_install}/${rule_file_install}"
fi

fi
#=====================================================================================

#Проверяем какая система запустила bzu-gmb, если Ubuntu\Linux Mint устанавливаем нужные пакеты
if echo "${linuxos_run_bzu_gmb}" | grep -ow "Debian GNU/Linux bookworm/sid" > /dev/null || echo "${linux_os}" | grep -ow "Linux Mint 20.3" > /dev/null
then
#запуск основных команд модуля
echo "${pass_user}" | sudo -S killall corectrl || true
echo "${pass_user}" | sudo -S add-apt-repository -y ppa:ernstp/mesarc  || let "error += 1"
echo "${pass_user}" | sudo -S aptitude -y install vulkan-tools libbotan-2-dev libfam0 libkf5archive5 libkf5auth-data libkf5authcore5 libkf5coreaddons-data libkf5coreaddons5 libpolkit-qt5-1-1 libqt5charts5 libqt5qml5 libqt5quick5 libqt5quickcontrols2-5 libqt5quicktemplates2-5 libtspi1 qml-module-qt-labs-platform qml-module-qtcharts qml-module-qtquick-controls2 qml-module-qtquick-layouts qml-module-qtquick-templates2 qml-module-qtquick-window2 qml-module-qtquick2 || let "error += 1"
echo "${pass_user}" | sudo -S rm /etc/apt/sources.list.d/ernstp*.list || let "error += 1"
echo "${pass_user}" | sudo -S rm /etc/apt/sources.list.d/ernstp*.list.save || true
echo "${pass_user}" | sudo -S apt update -y || let "error += 1"

module_link='https://github.com/redrootmin/bzu-gmb-modules/releases/download/v1/corectrl-debian-deb.tar.xz'
module_name_arc="corectrl-debian-deb.tar.xz"
rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
wget "${module_link}" -O "${module_name_arc}" || let "error += 1"
tar -xpJf "${module_name_arc}"
echo "${pass_user}" | sudo -S apt install -f -y ./*.deb
cd
echo "${pass_user}" | sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"

#добовление маски в файл grub для полного управления питанием и частотами в драйвере amdgpu
install_flags_grub_kernel ${grub_flag_base[0]} ${grub_flag_base[1]}
echo "${pass_user}" | sudo -S update-grub
#формируем информацию о том что в итоге установили и показываем в терминал
mesa_version=`inxi -G | grep "Mesa"`  || let "error += 1"
tput setaf 2; echo "Установлен драйвер:${mesa_version}, тестируем CoreCtrl!"  || let "error += 1"
echo "${pass_user}" | sudo -S dpkg --list | echo "Установлена утилита:"`grep "CoreCtrl" | sed s/"ii"//g`
#сброс цвета текста в терминале
tput sgr0

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
echo "${pass_user}" | sudo -S mv "${rule_file_install}" "${rule_dir_install}"
tput setaf 2
echo "файл правила запуска corectrl без sudo создан!"
tput sgr0
cat "${rule_dir_install}/${rule_file_install}"
else
tput setaf 3
echo "файл правила запуска corectrl без sudo уже создан"
tput sgr0
echo "${pass_user}" | sudo -S cat "${rule_dir_install}/${rule_file_install}"
fi
else
if [[ "${rule_file_create}" == "yes" ]]
then
cd "${script_dir}/modules-temp/${name_script}"
echo "polkit.addRule(function(action, subject) {
    if ((action.id == "org.corectrl.helper.init" ||
         action.id == "org.corectrl.helperkiller.init") &&
        subject.local == true &&
        subject.active == true &&
        subject.isInGroup("$user_run_script_group")) {
            return polkit.Result.YES;
    }
});" > ${rule_file_install}
echo "${pass_user}" | sudo -S mv "${rule_file_install}" "${rule_dir_install}"
tput setaf 2
echo "файл правила запуска corectrl без sudo создан!"
tput sgr0
echo "${pass_user}" | sudo -S cat "${rule_dir_install}/${rule_file_install}"
fi
fi

fi
#=====================================================================================




#тестовый запуск CoreCtrl
corectrl & sleep 5;sudo -S killall corectrl

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"

#Добавляем информацию о том как использовать CoreCtrl лог установки
#echo "Подробнее о том как запускать CoreCtrl без постоянного ввода пароля тут: https://gitlab.com/corectrl/corectrl/-/wikis/Setup"	 				  >> "${script_dir}/module_install_log"
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
