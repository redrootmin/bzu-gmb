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
#объявляем нужные переменные для скрипта
date_install=`date`
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
date_install=`date`

#даем информацию в терминал какой модуль устанавливается
tput setaf 2; echo "Данный скрипт задействует опцию TearFree в видеокартах АМД для Х11, которая контролирует предотвращение разрывов (anti tearing) [https://github.com/GPUOpen-Drivers/AMDVLK#turn-on-dri3-and-disable-modesetting-x-driver]. Версия скрипта 1.0b, автор: Яцына М.А."
tput sgr0

#объявляем нужные переменные для скрипта
<<<<<<< HEAD
export dir_x11_file="/etc/X11/xorg.conf.d"
export x11_file_name="10-amdgpu.conf"
readarray -t x11_commands_all < "${script_dir}/modules-temp/${name_script}/x11-commands"
echo "$pass_user" | sudo -S chmod 777 "${dir_x11_file}/${x11_file_name}" || true
echo "$pass_user" | sudo -S chmod -Rf 777 "${dir_x11_file}" || true

# Проверка что существует папка /etc/X11/xorg.conf.d, если нет, создаем ее
if [ ! -d "${dir_x11_file}" ]
then
echo "$pass_user" | sudo -S mkdir -p "${dir_x11_file}"
echo "$pass_user" | sudo -S chmod -Rf 777 "${dir_x11_file}"
=======
export dir_x11_file="/usr/share/X11/xorg.conf.d"
export x11_file_name="10-amdgpu.conf"
readarray -t x11_commands_all < "${script_dir}/modules-temp/${name_script}/x11-commands"
echo "$pass_user" | sudo -S chmod 777 "/usr/share/X11/xorg.conf.d/10-amdgpu.conf" || true
echo "$pass_user" | sudo -S chmod -Rf 777 "/usr/share/X11/xorg.conf.d" || true

# Проверка что существует папка /usr/share/X11/xorg.conf.d, если нет, создаем ее
if [ ! -d "/usr/share/X11/xorg.conf.d" ]
then
echo "$pass_user" | sudo -S mkdir -p "/usr/share/X11/xorg.conf.d"
echo "$pass_user" | sudo -S chmod -Rf 777 "/usr/share/X11/xorg.conf.d"
>>>>>>> add new module
fi



# Проверка создан файл 10-amdgpu.conf или нет
if [ -e "${dir_x11_file}/${x11_file_name}" ];then
echo "${pass_user}" | sudo -S cp -p -f "${dir_x11_file}/${x11_file_name}" "${dir_x11_file}/${x11_file_name}.bak"
<<<<<<< HEAD
tput setaf 2;echo "сделан бикап файла ${x11_file_name} в ${dir_x11_file}/${x11_file_name}.bak"
tput sgr0
tput setaf 3; echo "Файл ${x11_file_name} уже создан, проверяем его на наличе опции: Option  "TearFree" "true""
=======
tput setaf 2;echo "сделан бикап файла 10-amdgpu.conf в /usr/share/X11/xorg.conf.d/10-amdgpu.conf.bak"
tput sgr0
tput setaf 3; echo "Файл 10-amdgpu.conf уже создан, проверяем его на наличе опции: Option  "TearFree" "true""
>>>>>>> add new module
tput sgr0
full_data_10_amdgpu=`cat ${dir_x11_file}/${x11_file_name}`
if echo "${full_data_10_amdgpu}" | grep -ow 'Option  "TearFree" "true"' > /dev/null;then
tput setaf 3; echo "В файле 10-amdgpu.conf есть опция: Option  "TearFree" "true", изменения не требуются"
tput sgr0
tput setaf 2
echo "$pass_user" | sudo -S cat ${dir_x11_file}/${x11_file_name}
tput sgr0
else
<<<<<<< HEAD
tput setaf 1; echo "В файле ${x11_file_name} нет опции: Option  "TearFree" "true", поэтому создаем его заново"
=======
tput setaf 1; echo "В файле 10-amdgpu.conf нет опции: Option  "TearFree" "true", поэтому создаем его заново"
>>>>>>> add new module
tput sgr0
#задем переменной колличество пакетов в массиве
packages_number=${#x11_commands_all[@]}
#добобвляем первый флаг в файл стераем все значания что были в нем
echo "$pass_user" | sudo -S echo "${x11_commands_all[0]}" > "${dir_x11_file}/${x11_file_name}"
#обьявляем переменную числовой
i=1
#цикл проверки пакетов из массива
while [ $i -lt $packages_number ]
do
#добобвляем новый флаг в файл к существующем
echo "$pass_user" | sudo -S echo "${x11_commands_all[$i]}" >> "${dir_x11_file}/${x11_file_name}"
i=$(($i + 1))
done
fi
<<<<<<< HEAD
tput setaf 2;echo "файл ${x11_file_name} создан:"
echo "$pass_user" | sudo -S cat ${dir_x11_file}/${x11_file_name}
tput sgr0
else
tput setaf 1; echo "Файл ${x11_file_name}  не существует, поэтому создаем его"
=======
tput setaf 2;echo "файл создан:"
echo "$pass_user" | sudo -S cat ${dir_x11_file}/${x11_file_name}
tput sgr0
else
tput setaf 1; echo "Файл 10-amdgpu.conf не существует, поэтому создаем его"
>>>>>>> add new module
tput sgr0
#задем переменной колличество пакетов в массиве
packages_number=${#x11_commands_all[@]}
#добобвляем первый флаг в файл стераем все значания что были в нем
echo "$pass_user" | sudo -S echo "${x11_commands_all[0]}" > "${dir_x11_file}/${x11_file_name}"
#обьявляем переменную числовой
i=1
#цикл проверки пакетов из массива
while [ $i -lt $packages_number ]
do
#добобвляем новый флаг в файл к существующем
echo "$pass_user" | sudo -S echo "${x11_commands_all[$i]}" >> "${dir_x11_file}/${x11_file_name}"
i=$(($i + 1))
done
<<<<<<< HEAD
tput setaf 2;echo "файл ${x11_file_name} создан:"
echo "$pass_user" | sudo -S cat ${dir_x11_file}/${x11_file_name}
tput sgr0
fi
echo "$pass_user" | sudo -S chmod 744 "${dir_x11_file}/${x11_file_name}" || true
echo "$pass_user" | sudo -S chmod -Rf 755 "${dir_x11_file}" || true
=======
tput setaf 2;echo "файл создан:"
echo "$pass_user" | sudo -S cat ${dir_x11_file}/${x11_file_name}
tput sgr0
fi
echo "$pass_user" | sudo -S chmod 744 /usr/share/X11/xorg.conf.d/10-amdgpu.conf || true
echo "$pass_user" | sudo -S chmod -Rf 755 "/usr/share/X11/xorg.conf.d" || true
>>>>>>> add new module
#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
#echo "Подробнее на [https://unix.stackexchange.com/questions/554908/disable-spectre-and-meltdown-mitigations/565516#565516]"	 				  >> "${script_dir}/module_install_log"

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
