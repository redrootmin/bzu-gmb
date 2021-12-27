#!/bin/bash
#creator by RedRoot(Yaciyna Mikhail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License

#проверяем что скрипт установки не запущен от пользователя root
if [ "$UID" -eq 0 ];then
tput setaf 1; echo "Этот скрипт не нужно запускать из под root!";tput sgr0;exit 1
else
tput setaf 2; echo "все хорошо этот скрипт не запущен из под root!"
fi
pass_user="$1"
#запрос пароля root для установки ПО необходимого для bzu-gmb
if [[ "${pass_user}" == "" ]]
then
read -sp 'Введите Пароль root:' pass_user
echo " "
else
echo "обнавляем bzu-gmb!"
if [ ! -d "/home/${USER}/bzu-gmb-dev" ];then
cd;rm -rf bzu-gmb*;rm -f bzu-gmb*;rm -f *bzu-gmb;wget https://github.com/redrootmin/bzu-gmb/archive/refs/heads/unstable.zip -O bzu-gmb-unstable.zip;unzip bzu-gmb-unstable.zip;cd ~/bzu-gmb-unstable;chmod +x mini_install.sh;cd;rm -f bzu-gmb*.zip
else
cd;rm -rf bzu-gmb*;rm -f bzu-gmb*;rm -f *bzu-gmb;wget https://github.com/redrootmin/bzu-gmb/archive/refs/heads/dev.zip -O bzu-gmb-dev.zip;unzip bzu-gmb-dev.zip;cd ~/bzu-gmb-dev;chmod +x mini_install.sh;cd;rm -f bzu-gmb*.zip
fi
fi

#проверяем ввел пользователь пароль или нет
if [[ "${pass_user}" == "" ]]
then
tput setaf 1; echo "требуется ввести пароль root!"
tput sgr0
sleep 5
exit 0
fi

#собираем данные о том в какой папке находиться bzu-gmb
script_dir=$(cd $(dirname "$0") && pwd);
version_bzu_gmb=`cat "${script_dir}/config/name_version"`
app_dir="${script_dir}/modules-temp"
name_desktop_file="bzu-gmb.desktop"
name_icon="icons/bzu-gmb-new320.png"
name_script_start="bzu-gmb-launcher.sh"
name_app="${version_bzu_gmb}"
exec_full="bash -c "${script_dir}"/"${name_script_start}""

#Определение расположениея папок для утилит и т.д.
utils_dir="${script_dir}/core-utils"

#Определение переменныех утилит и скриптов
YAD="${utils_dir}/yad"
zenity="${utils_dir}/zenity"
pv="${utils_dir}/pv"

#pass_user="$1"
#добовляем переменную с иминем пользователя от имини которого запущен скрипт, да это не обязательно, но не хочу переписывать код ниже :)
user_run_script="$USER"

# Проверка что существует папка applications, если нет, создаем ее
if [ ! -d "/home/${USER}/.local/share/applications" ]
then
mkdir -p "/home/${USER}/.local/share/applications"
fi

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
#echo "" > "${script_dir}/config/status"
tput sgr0

#функция для проверки пакетов на установку, если нужно установлевает
function install_package {
dpkg -s $1 | grep installed > /dev/null || echo "no installing $1 :(" | echo "$2" | sudo -S apt install -f -y $1
package_status=`dpkg -s $1 | grep -oh "installed"`
echo "$1:" $package_status
}

#Проверяем какая система запустила bzu-gmb, если Ubuntu\Linux Mint устанавливаем нужные пакеты
if echo "${linux_os}" | grep -ow "Ubuntu" > /dev/null || echo "${linux_os}" | grep -ow "Mint" > /dev/null
then
#загружаем список пакетов из файла в массив
readarray -t packages_list < "${script_dir}/config/packages-ubuntu-linux_mint"
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
fi

#Проверяем какая система запустила bzu-gmb, если Debian устанавливаем нужные пакеты
if echo "${linux_os}" | grep -ow "Debian GNU/Linux bookworm/sid" > /dev/null
then
echo "$pass_user" | sudo -S apt update -y;echo "$pass_user" | sudo -S apt upgrade -y
#загружаем список пакетов из файла в массив
readarray -t packages_list < "${script_dir}/config/packages-debian-book_worm"
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

#echo "$pass_user" | sudo -S apt install -f -y --reinstall  software-properties-common dirmngr apt-transport-https lsb-release ca-certificates  inxi gnome-tweaks
#echo "$pass_user" | sudo -S apt install -f firmware-linux firmware-linux-nonfree libdrm-amdgpu1 xserver-xorg-video-amdgpu
fi
# обнуляем статус утилиты, отключаем эксперементальный режим
echo "" > "${script_dir}/config/status"

#Создаем ярлык для скрипта
echo "[Desktop Entry]" > "${script_dir}/${name_desktop_file}"
echo "Version=1.0" >> "${script_dir}/${name_desktop_file}"
echo "Type=Application" >> "${script_dir}/${name_desktop_file}"
echo "Name=${name_app}" >> "${script_dir}/${name_desktop_file}"
echo "Comment=bzu-gmb is auto-installer linux gaming tools for debian-based distributions" >> "${script_dir}/${name_desktop_file}" 
echo "Categories=Utility;System;" >> "${script_dir}/${name_desktop_file}"
echo "Exec=${exec_full}" >> "${script_dir}/${name_desktop_file}"
echo "Terminal=true" >> "${script_dir}/${name_desktop_file}"
echo "Icon="${script_dir}/${name_icon}"" >> "${script_dir}/${name_desktop_file}"

#Копируем ярлыв в программы домашней папки пользователя
#sudo rm -f /usr/share/applications/bzu-gmb.desktop
echo "$pass_user" | sudo -S rm -f "/usr/share/applications/${name_desktop_file}" || true
cp -f "${script_dir}/${name_desktop_file}" "/home/${user_run_script}/.local/share/applications/"

#Даем права на запуск ярлыка в папке программы и копируем в папку с ярлыками пользователя
gio set "${script_dir}/${name_desktop_file}" "metadata::trusted" yes
gio set "/home/${user_run_script}/.local/share/applications/${name_desktop_file}" "metadata::trusted" yes
#gio info "${script_dir}/name_desktop_file" | grep "metadata::trusted"
echo "$pass_user" | sudo -S chmod +x "/home/${user_run_script}/.local/share/applications/${name_desktop_file}"

#Даем права на главные скрипты утилиты и core-utils
echo "$pass_user" | sudo -S chmod +x "${script_dir}/bzu-gmb-launcher.sh"
echo "$pass_user" | sudo -S chmod +x "${script_dir}/bzu-gmb-gui-beta4.sh"
echo "$pass_user" | sudo -S chmod +x "${script_dir}/core-utils/libMangoHud.so"
echo "$pass_user" | sudo -S chmod +x "${script_dir}/core-utils/libMangoHud_dlsym.so"
echo "$pass_user" | sudo -S chmod +x "${script_dir}/core-utils/yad"
echo "$pass_user" | sudo -S chmod +x "${script_dir}/core-utils/zenity"

#GTK_THEME="Adwaita-dark" yad --title="Back to Ubuntu Vanilla" --image-on-top --picture --size=fit --filename="${script_dir}/icons/ubuntu-logo-icon327.png" --width=327 --height=327 --center --inc=256  --text-align=center --text="ТРЕБУЕТСЯ ПЕРЕАГРУЗКА СИСТЕМЫ!" --timeout=5 --timeout-indicator=bottom 

#Уведомление пользователя, о том что он устанавил себе на ПК
GTK_THEME="Adwaita-dark" ${zenity} --text-info --html --url="https://drive.google.com/uc?export=view&id=1LZ_W8JSLBbVdppVHxUFnaXuhVpaszSYE" --title="Завершено обновление ${version_bzu_gmb}" --width=640 --height=408  --cancel-label="" --timeout=5 --timeout-indicator=bottom 

bash -c /usr/share/bzu-gmb/bzu-gmb/bzu-gmb-launcher.sh