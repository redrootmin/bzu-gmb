#!/bin/sh
#Данный скрипт объединяет в себе набор утилит и программ который помогут Вам 
#получить максимум возможностей и производительности от вашей linux системы 
# тут ссылки на все пути для скрипта

#export script_dir=$(cd $(dirname "$0") && pwd);

#version=`cat ${script_dir}/config/name_version`
#export script_dir1="${script_dir}"
#export version1="${version}"
iconway1="${script_dir}/icons/"
imageway1="${script_dir}/image/"
icon1="$iconway1""bzu-gmb48.png"
image1="$imageway1""bzu-gmb-gls1024.png"

readarray -t module_base < "${script_dir}/config/module-base"
let "module_base_num = ${#module_base[@]} - 10"
select_install='yad  --center --window-icon="$icon1" --image="$image1" --image-on-top --title="${version}-${linuxos_version}"  --center --on-top --list --wrap-width=560 --width=256 --height=840 --checklist  --separator=" " --search-column=6 --print-column=3 --column=выбор --column=лого:IMG --column=название:TEXT --column=категория:TEXT --column=описание:TEXT --column=автор:TEXT --button="Выход:1" --button="Установка:0" '

for (( i=0; i <= $module_base_num; i=i+10 ))
do
echo ${module_base[$i+6]} | grep "${linuxos_version}" > /dev/null
if [ $? = 0 ];then
select_install+="FALSE"" "'"'"${script_dir}/icons/${module_base[$i]}"'"'" "'"'"<b>${module_base[$i+1]}</b>"'"'" "'"'"${module_base[$i+2]}"'"'" "'"'"${module_base[$i+3]}"'"'" "'"'"${module_base[$i+4]}"'"'" "
fi
#echo "${module_base[$i+6]}"
done

export modules_select=`eval ${select_install}`
echo "$modules_select"

#zenity --info --text="${modules_select}"

#сбрасываем log установки в файле: module_install_log
date_install=`date`
echo "Лог установки модулей из ${version}, дата установки:${date_install}"	 				  > "${script_dir}/module_install_log"

#сбрасываем глобальную ошибку
global_error=0
global_error0=0

# основной цикл проверки выброных модулей и запуска их скриптов на установку
for (( i=0; i <= $module_base_num; i=i+10 ))
do
echo ${modules_select} | grep "${module_base[$i+1]}" > /dev/null
if [ $? = 0 ];then
run_module="${script_dir}/modules-temp/${module_base[$i+5]}/${module_base[$i+5]}.sh"
chmod +x ${run_module}
echo "$pass_user" | sudo -S bash ${run_module} || let "global_error += 1"

#проверяем есть ли глобальная ошибка в модуле при установке, если да, пишем об этом в логе, логика не срабатывает повторно, для это используется дополнительная переменная global_error0
if (($global_error > $global_error0));then
 echo "в модуле ${module_base[$i+1]}, Критическая ошибка, дата установки:${date_install}"	 				  >> "${script_dir}/module_install_log"
let "global_error0 += 1" 
fi

#zenity --error --width=460 --height=128 --text="Критическая ошибка при установке модуля:${module_base[$i+1]} " | global_error=1 | exit 0
#for p in `seq 0 40`;do echo $p;echo '#'$p'%';sleep 1;done | yad --progress --enable-log --log-height=128 --log-expanded --button=Cancel:1 --pulsate --auto-close 
#| (echo 10; sleep 2; echo 20; sleep 2; echo 50; sleep 2;echo 60; sleep 2;echo 70; sleep 2; echo 80; sleep 2;echo 90; sleep 2; echo 100; sleep 2) | yad --progress --pulsate --auto-close --auto-kill --button gtk-cancel:1 --on-top
#zenity --info --text="${module_base[$i+1]}"
fi

done

#проверка на глобальные ошибки в модулях, например он вобще не запустился или файлов таких нет.
#echo ${global_error}
if (($global_error > 0));then
echo "Количество критических ошибок в модулях:${global_error}, дата установки:${date_install}"	 				  >> "${script_dir}/module_install_log"
fi

#проверка как завершилась работа установки модулей, если были ошибки, то логи показывать не нужно
zenity --text-info --width=480 --height=680 --title="Лог установки модулей ${version} " --filename="${script_dir}/module_install_log" --editable

exit 0

# тут ссылки на все иконки и картинки для установки
#furmark_icon1="$iconway1""furmark48.png"
#tfm_vulkan_icon1="$iconway1""vulkan48.png"
#tfm_opengl_icon1="$iconway1""OpenGL248.png"
#vulkan_smoketest_icon1="$iconway1""vulkan48.png"
#glmark2_icon1="$iconway1""OpenGL248.png"
#mesa_icon1="$iconway1""mesa48.png"

#echo $icon1 $image1

# проверяем что стоят все нужные пакеты
#yadstatus="$(dpkg --get-selections | grep -o yad)"
#echo $yadstatus
#if [ "$yadstatus" -eq "yad" ];then
#echo "yad установлен, все хорошо, пока хорошо :)"
#else 
#sudo apt install -f -y $yadstatus | echo "yad устанавливается, важный компонент скрипта!"
#fi

# памятка
#yad --center --progress --image="/home/gamer/bzu-gmb-v2/image/bzugmb640.png" --image-on-top

# переменная для списка всех устанавливаемых утилит\программ и их описания

#select_install='yad  --center --window-icon="$icon1" --image="$image1" --image-on-top --title="${version}-${linuxos_version}"  --center --on-top --list --width=640 --height=640 --checklist  --separator=" " --search-column=3 --print-column=3 --column=выбор --column=лого:IMG --column=название:TEXT --column=категория:TEXT --column=описание:TEXT --button="Выход:1" --button="Установка:0" \ '
#select_install1='FALSE $furmark_icon1 "<b>Furmark_Pack</b>" "Benchmark" "Набор утилит для тестирования
#OpenGL 2.x/3.x/4.x" \ '
#select_install2='FALSE $tfm_vulkan_icon1 "<b>tfm_vulkan</b>" "Benchmark" "Простой тест Vulkan API на Unity3D"'

#run_script_install+=$select_install0
#run_script_install+=$select_install1
#run_script_install+=$select_install2

#echo "$run_script_install"
#eval $run_script_install
#sleep 60
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
