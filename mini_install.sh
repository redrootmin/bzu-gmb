#!/bin/bash
#creator by RedRoot(Yaciyna Mikhail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License

#проверяем что скрипт установки не запущен от пользователя root
if [ "$UID" -eq 0 ];then
tput setaf 1; echo "Этот скрипт не нужно запускать из под root!";tput sgr0;exit 1
else
tput setaf 2; echo "все хорошо этот скрипт не запущен из под root!"
fi

#запрос пароля root для установки ПО необходимого для bzu-gmb
read -sp 'Введите Пароль root:' pass_user
echo " "


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

#pass_user="$1"
#добовляем переменную с иминем пользователя от имини которого запущен скрипт, да это не обязательно, но не хочу переписывать код ниже :)
user_run_script="$USER"

# Проверка что существует папка applications, если нет, создаем ее
if [ ! -d "/home/${USER}/.local/share/applications" ]
then
mkdir -p "/home/${USER}/.local/share/applications"
fi

#функция для проверки пакетов на установку, если нужно установлевает
function install_package {
dpkg -s $1 | grep installed > /dev/null || echo "no installing $1 :(" | echo "$2" | sudo -S apt install -f -y $1
package_status=`dpkg -s $1 | grep -oh "installed"`
echo "$1:" $package_status
}

#загружаем список пакетов из файла в массив
readarray -t packages_list < "${script_dir}/config/packages-for-bzu-gmb"
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


#Даем права на главные скрипты утилиты
echo "$pass_user" | sudo -S chmod +x "${script_dir}/bzu-gmb-launcher.sh"
echo "$pass_user" | sudo -S chmod +x "${script_dir}/bzu-gmb-gui-beta4.sh"

#Уведомление пользователя, о том что он устанавил себе на ПК
GTK_THEME="Adwaita-dark" zenity --text-info --html --url="https://drive.google.com/uc?export=view&id=1LZ_W8JSLBbVdppVHxUFnaXuhVpaszSYE" --title="Завершена установка ${version_bzu_gmb}" --width=640 --height=408  --cancel-label=""

#busctl --user call "org.gnome.Shell" "/org/gnome/Shell" "org.gnome.Shell" "Eval" "s" 'Meta.restart("Restarting…")';
exit 0
