#!/bin/bash
#creator by RedRoot(Yacyna Mehail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License 

#проверяем что скрипт установки не запущен от пользователя root
if [ "$UID" -eq 0 ];then
zenity --error --text="Этот скрипт не нужно запускать из под root!"; exit 1
else
echo "все хорошо этот скрипт не запущен из под root!"
fi

#Уведомление пользователя, о том что он устанавливает себе на ПК
zenity --question --title="BZU GameMod Boosting Installer beta4-4" --text="Данный скрипт установит на вашу OC GNU\Linux утилиту BZU-GMB-BETA4, она поможет вам быстро и без сложностей установить все, что требуется для оптимизации и ускорения системы для игр и программ которые активно используют 3Д графику. ВНИМАНИЕ: Скрипт пока поддерживает только: Ubuntu 19.10, Ubuntu 20.04 и оптимизирован под видеокарты компании AMD. Но в любом случае, установку Вы совершаете на свой страх и риск, за любые негативные последствия для вашей OC GNU\Linux, автор ответственность не несет. Утилита будит остановлена в папку:[/usr/share/bzu-gmb]. Нажмите ДА, если готовы продолжить установку." --width=560 --height=128
if [ "$?" -eq "0" ];then

# запрос пароля супер пользователя, который дальше будет поставляться где требуется в качестве глобальной переменной, до конца работы скрипта
if pass_user0=$(zenity --entry --title="Для работы скрипта установки bzu-gmb-beta4 требуется пароль root" --text="Введите пароль:" \
 --entry-text="пароль" --hide-text --width=560 --height=128)
then
export pass_user=${pass_user0}
else
  zenity --error --text="Пароль не введён"
exit 0
fi

else exit 0
fi

#объявляем нужные переменные для скрипта
script_dir="/usr/share/bzu-gmb"
script_ext_dir="/usr/share/"
name_desktop_file="bzu-gmb.desktop"
name_script=`basename "$0"`
script_dir_install=$(cd $(dirname "$0") && pwd)
bzu_gmb_name_arc="bzu-gmb-beta4-installer"



#проверка установлен или нет yad и другое необходимое ПО для bzu-gmb
dpkg -s yad | grep installed > /dev/null || echo 'no installing yad :(' | echo "$pass_user" | sudo -S apt install -f -y yad
YadStatus=`dpkg -s yad | grep installed`
echo "YAD" $YadStatus

#проверяем установлена утилита inxi - информация о низкоуровневом ПО и железе
dpkg -s inxi | grep installed > /dev/null || echo 'no install inxi :(' | echo "$pass_user" | sudo -S apt install -f -y inxi
inxistatus=`dpkg -s inxi | grep installed`
echo "INXI" $inxistatus

#проверяем установлена утилита meson - она необходима для сборки многих программ из исходников
dpkg -s meson | grep installed > /dev/null || echo 'no install meson :(' | echo "$pass_user" | sudo -S apt install -f -y meson
inxistatus=`dpkg -s inxi | grep installed`
echo "meson" $inxistatus

#проверяем установлена утилита ninja-build - она необходима для сборки многих программ из исходников
dpkg -s ninja-build | grep installed > /dev/null || echo 'no install ninja-build :(' | echo "$pass_user" | sudo -S apt install -f -y ninja-build
inxistatus=`dpkg -s ninja-build | grep installed`
echo "ninja-build" $inxistatus

#проверяем установлена утилита p7zip-rar - она необходима для установки многих программ
dpkg -s p7zip-rar | grep installed > /dev/null || echo 'no install p7zip-rar :(' | echo "$pass_user" | sudo -S apt install -f -y p7zip-rar rar unrar unace arj
inxistatus=`dpkg -s ninja-build | grep installed`
echo "p7zip-rar" $inxistatus

#проверяем установлена утилита python-tk - она необходима для установки многих программ
dpkg -s python-tk | grep installed > /dev/null || echo 'no install p7zip-rar :(' | echo "$pass_user" | sudo -S apt install -f -y python-tk
inxistatus=`dpkg -s python-tk | grep installed`;echo "python-tk" $inxistatus

#проверяем установлена утилита xosd-bin - она необходима для работы многих программ
dpkg -s xosd-bin | grep installed > /dev/null || echo 'no install xosd-bin :(' | echo "$pass_user" | sudo -S apt install -f -y xosd-bin
inxistatus=`dpkg -s xosd-bin | grep installed`;echo "xosd-bin" $inxistatus

#проверяем установлена утилита aptitude - она необходима для работы многих программ
dpkg -s aptitude | grep installed > /dev/null || echo 'no install aptitude :(' | echo "$pass_user" | sudo -S apt install -f -y aptitude
inxistatus=`dpkg -s aptitude | grep installed`;echo "aptitude" $inxistatus

# Проверка что существует папка applications, если нет, создаем ее
#if [ ! -d "/home/${USER}/.local/share/applications" ]
#then
#	mkdir -p "/home/${USER}/.local/share/applications"
#fi

# Проверка что существует папка /usr/share/test, если нет, создаем ее
if [ ! -d "/usr/share/test" ]
then
echo "$pass_user" | sudo -S mkdir -p "/usr/share/test" || let "error += 1"
echo "$pass_user" | sudo -S chmod -R 755 /usr/share/test || let "error += 1"
fi


#Основные команды установки
echo "$pass_user" | sudo -S rm -rf "${script_dir}" || let "error += 1"
echo "$pass_user" | sudo -S rm -rf "/home/$USER/.local/share/bzu-gmb" || let "error += 1"
echo "$pass_user" | sudo -S rm -f "${script_ext_dir}applications/${name_desktop_file}" || let "error += 1"
echo "$pass_user" | sudo -S tar -xpJf "${script_dir_install}/${bzu_gmb_name_arc}.tar.xz" -C "${script_ext_dir}" || let "error += 1"

#объявляем нужные переменные для скрипта
version=`cat ${script_dir}/config/name_version` || let "error += 1"
name_desktop="${version}" || let "error += 1"

#Создаем ярлык для скрипта
Exec_full="bash -c"${script_dir}"/bzu-gmb-launcher.sh" 
echo "$pass_user" | sudo -S echo "[Desktop Entry]"	 				  > "${script_dir}/${name_desktop_file}" || let "error += 1"
echo "$pass_user" | sudo -S echo "Name=${name_desktop}" 				 >> "${script_dir}/${name_desktop_file}"
echo "$pass_user" | sudo -S echo "Exec="${Exec_full}""	                         >> "${script_dir}/${name_desktop_file}"
echo "$pass_user" | sudo -S echo "Type=Application" 				 >> "${script_dir}/${name_desktop_file}"
echo "$pass_user" | sudo -S echo "Categories=Game;System"	                         >> "${script_dir}/${name_desktop_file}"
echo "$pass_user" | sudo -S echo "StartupNotify=true" 	    			  >> "${script_dir}/${name_desktop_file}"
echo "$pass_user" | sudo -S echo "Path="${script_dir}""	                	  >> "${script_dir}/${name_desktop_file}"
echo "$pass_user" | sudo -S echo "Icon="${script_dir}/icons/bzu-gmb512.png""         >> "${script_dir}/${name_desktop_file}"
echo "$pass_user" | sudo -S echo "Terminal=true"         >> "${script_dir}/${name_desktop_file}"

#переносим ярлык в папку программ
echo "$pass_user" | sudo -S cp -f "${script_dir}/${name_desktop_file}" /usr/share/applications/ || let "error += 1"

#даем права на главные скрипты утилиты
chmod +x "${script_dir}/bzu-gmb-launcher.sh" || let "error += 1"
chmod +x "${script_dir}/bzu-gmb-Ubuntu-20.04-LTS-beta4.sh" || let "error += 1"
chmod +x "${script_dir}/bzu-gmb-Ubuntu-20.04.1-LTS-beta4.sh" || let "error += 1"
chmod +x "${script_dir}/bzu-gmb-Linux-Mint-20-beta4.sh" || let "error += 1"
chmod +x "${script_dir}/bzu-gmb-Ubuntu-19.10-beta4.sh" || let "error += 1"
chmod +x "${script_dir}/bzu-gmb-Linux-Mint-19.3-beta4.sh" || let "error += 1"



if ((error > 3));then
zenity --error --width=512 --text="Установка BZU GameMod Boosting Installer beta4 завершена c ошибками!"
else
zenity --info --width=512 --text="Установка BZU GameMod Boosting Installer beta4 завершена успешно."
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
#https://www.shellhacks.com/ru/grep-or-grep-and-grep-not-match-multiple-patterns/
#https://techrocks.ru/2019/01/21/bash-if-statements-tips/
