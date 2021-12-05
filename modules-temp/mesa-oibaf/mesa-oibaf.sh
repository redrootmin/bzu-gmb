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
tput setaf 2; echo "Установка тестового, открытого драйвера Mesa 20.2+ от Oibaf [https://launchpad.net/~oibaf/+archive/ubuntu/graphics-drivers]. Версия скрипта 2.0, автор: Яцына М.А."
tput sgr0

if echo "${linuxos_run_bzu_gmb}" | grep -ow "Ubuntu" > /dev/null || echo "${linuxos_run_bzu_gmb}" | grep -ow "Mint" > /dev/null
then
#запуск основных команд модуля
echo "${pass_user}" | sudo -S add-apt-repository -y ppa:oibaf/graphics-drivers || let "error += 1"
echo "${pass_user}" | sudo -S aptitude -y update || error+=1 # нужно только для linuxMint
echo "${pass_user}" | sudo -S aptitude -y install libegl-mesa0:amd64 libgbm1:amd64 libgl1-mesa-dri:amd64 libglapi-mesa:amd64 libglu1-mesa:amd64 libglx-mesa0:amd64 libllvm10:amd64 libllvm10:i386 libxatracker2:amd64 mesa-utils  mesa-va-drivers:amd64 mesa-vdpau-drivers:amd64 mesa-vulkan-drivers:amd64 mesa-vulkan-drivers:i386 xserver-xorg-video-amdgpu || let "error += 1"
echo "${pass_user}" | sudo -S aptitude -y upgrade || let "error += 1"
fi

if echo "${linuxos_run_bzu_gmb}" | grep -ow "Debian GNU/Linux bookworm/sid" > /dev/null
then
echo "${pass_user}" | sudo -S apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 5ABCE68FF4633EA42E219156957D2708A03A4626
echo "${pass_user}" | sudo -S chmod -Rf 777 /etc/apt/sources.list.d/;echo "${pass_user}" | sudo -S echo "deb http://ppa.launchpad.net/oibaf/graphics-drivers/ubuntu focal main" > /etc/apt/sources.list.d/oibaf-ubuntu-graphics-drivers.list;echo "${pass_user}" | sudo -S echo "deb-src http://ppa.launchpad.net/oibaf/graphics-drivers/ubuntu focal main" >> /etc/apt/sources.list.d/oibaf-ubuntu-graphics-drivers.list;echo "${pass_user}" | sudo -S chmod -Rf 755 /etc/apt/sources.list.d/
#запуск основных команд модуля
echo "${pass_user}" | sudo -S aptitude -y update || error+=1 # нужно только для linuxMint
echo "${pass_user}" | sudo -S aptitude -y install libegl-mesa0:amd64 libgbm1:amd64 libgl1-mesa-dri:amd64 libglapi-mesa:amd64 libglu1-mesa:amd64 libglx-mesa0:amd64 libllvm10:amd64 libllvm10:i386 libxatracker2:amd64 mesa-utils  mesa-va-drivers:amd64 mesa-vdpau-drivers:amd64 mesa-vulkan-drivers:amd64 mesa-vulkan-drivers:i386 xserver-xorg-video-amdgpu || let "error += 1"
echo "${pass_user}" | sudo -S aptitude -y upgrade || let "error += 1"
fi


#формируем информацию о том что в итоге установили и показываем в терминал
mesa_version=`inxi -G | grep "Mesa"`  || let "error += 1"
tput setaf 2; echo "Установлен драйвер:${mesa_version}"  || let "error += 1"
#сброс цвета текста в терминале
tput sgr0

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
#Добавляем информацию о изменении флагов в файле настройки GRUB в лог установки
echo "для использования функци zink(render OpenGL to Vulkan) "	 				  >> "${script_dir}/module_install_log"
echo "нужно использовать следующий флаг:"	 				  >> "${script_dir}/module_install_log"
echo "для zink: MESA_LOADER_DRIVER_OVERRIDE=zink"	 				  >> "${script_dir}/module_install_log"
echo "например в steam:"	 				  >> "${script_dir}/module_install_log"
echo "MESA_LOADER_DRIVER_OVERRIDE=zink %command%"	 				  >> "${script_dir}/module_install_log"
#задержка вывода информации о итогах установки, что бы пользователь мог ознакомиться.
sleep 3

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
