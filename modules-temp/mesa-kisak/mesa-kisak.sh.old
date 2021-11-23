#!/bin/bash
#creator by RedRoot(Yacyna Mehail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License 

#проверяем что модуль запущен от пользователя root
[ "$UID" -eq 0 ] || { zenity --error --text="Этот скрипт нужно запускать из под root!"; exit 1;}

# определение имени файла, папки где находиться скрипт и версию скрипта
name_script0=`basename "$0"`
name_script=`echo ${name_script0} | sed "s|.sh||g"`
#echo ${name_script}
script_dir0=$(cd $(dirname "$0") && pwd); name_cut="/modules-temp/${name_script}"
#echo ${name_cut}
#echo ${script_dir0}
script_dir=`echo ${script_dir0} | sed "s|${name_cut}||g"`
version0=`cat "${script_dir}/config/name_version"`
version="${version0}"

#объявляем нужные переменные для скрипта
date_install=`date`

#даем информацию в терминал какой модуль установливается
tput setaf 2; echo "Установка стабильного открытого драйвера Mesa 20.1+ от kisak [https://launchpad.net/~kisak/+archive/ubuntu/kisak-mesa]. Версия скрипта 1.1, автор: Яцына М.А."
tput sgr0

#проверяем установлена утилита inxi - информация о низкоуровневом ПО и железе
#dpkg -s inxi | grep installed > /dev/null || echo 'no install inxi :(' | sudo -S apt install -f -y inxi
#inxistatus=`dpkg -s inxi | grep installed`
#echo "INXI" $inxistatus

#запуск основных команд модуля
sudo -S add-apt-repository -y ppa:kisak/kisak-mesa || let "error += 1"
sudo -S aptitude -y update || error+=1 # нужно только для linuxMint
sudo -S aptitude -y install libegl-mesa0:amd64 libgbm1:amd64 libgl1-mesa-dri:amd64 libglapi-mesa:amd64 libglu1-mesa:amd64 libglx-mesa0:amd64 libllvm10:amd64 libllvm10:i386 libxatracker2:amd64 mesa-utils  mesa-va-drivers:amd64 mesa-vdpau-drivers:amd64 mesa-vulkan-drivers:amd64 mesa-vulkan-drivers:i386 xserver-xorg-video-amdgpu || let "error += 1"
sudo -S aptitude -y upgrade || let "error += 1"
#sudo -S apt-get autoremove -y || let "error += 1"
#sudo -S apt-get clean -y || let "error += 1"
#sudo -S apt-get install -f -y || let "error += 1"
#sudo -S apt install -f -y --reinstall libvulkan1 libvulkan-dev mesa-vulkan-drivers vulkan-utils || let "error += 1"

#формируем информацию о том что в итоге установили и показываем в терминал
mesa_version=`inxi -G | grep "Mesa"`  || let "error += 1"
tput setaf 2; echo "Установлен драйвер:${mesa_version}"  || let "error += 1"
#сброс цвета текста в терминале
tput sgr0

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
#Добавляем информацию о изменении флагов в файле настройки GRUB в лог установки
echo "для использования функции Valve ACO(fast work high shaders)"	 				  >> "${script_dir}/module_install_log"
echo "нужно использовать следующий флаг:"	 				  >> "${script_dir}/module_install_log"
echo "для Vavle ACO: RADV_PERFTEST=aco"	 				  >> "${script_dir}/module_install_log"
#echo "для zink: MESA_LOADER_DRIVER_OVERRIDE=zink"	 				  >> "${script_dir}/module_install_log"
echo "например в steam:"	 				  >> "${script_dir}/module_install_log"
echo "RADV_PERFTEST=aco %command%"	 				  >> "${script_dir}/module_install_log"

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
