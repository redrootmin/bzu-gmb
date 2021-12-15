#!/bin/bash
#creator by RedRoot(Yaciyna Mikhail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License 

iconway1="${script_dir}/icons/"
imageway1="${script_dir}/image/"
icon1="$iconway1""bzu-gmb-new48.png"
image1="$imageway1""new-panel-logo1080.png"

#загружаем статус buz-gmb
bzu_gmb_status=`cat "${script_dir}/config/status"`

#меняем версию операционной системы на эксперементальную, что бы отобразить все модули Ubuntu
if [[ "${bzu_gmb_status}" == "experimental" ]]
then
linuxos_version="experimental"
GTK_THEME="Adwaita-dark" ${zenity} --error --ellipsize  --timeout=2 --text="${version} запущен в эксперементальном режиме!"
image1="$imageway1""new-panel-logo-exp-1080.png"
fi

readarray -t module_base < "${script_dir}/config/module-base"
let "module_base_num = ${#module_base[@]} - 10"
select_install='GTK_THEME="Adwaita-dark" ${YAD} --center --window-icon="$icon1" --image="$image1" --image-on-top --title="${version}-${linuxos_version}" --center --list --wrap-width=560 --width=256 --height=840 --checklist  --separator=" " --search-column=6 --print-column=3 --column=выбор --column=лого:IMG --column=название:TEXT --column=категория:TEXT --column=описание:TEXT --column=автор:TEXT --button="Выход:1" --button="Установка:0" '

for (( i=0; i <= $module_base_num; i=i+10 ))
do
echo ${module_base[$i+6]} | grep -ow "${linuxos_version}" > /dev/null
if [ $? = 0 ];then
select_install+="FALSE"" "'"'"${script_dir}/icons/${module_base[$i]}"'"'" "'"'"<b>${module_base[$i+1]}</b>"'"'" "'"'"${module_base[$i+2]}"'"'" "'"'"${module_base[$i+3]}"'"'" "'"'"${module_base[$i+4]}"'"'" "
fi
#echo "${module_base[$i+6]}"
done
# создаем файл с полной конфигурацией yad
echo "${select_install}" >> ${script_dir}/config/yad-module-form

export modules_select=`eval ${select_install}`
#echo "$modules_select"

#сбрасываем log установки в файле: module_install_log
date_install=`date`
echo "$pass_user" | sudo -S echo "Лог установки модулей из ${version}, дата установки:${date_install}" > "${script_dir}/module_install_log"
echo "$pass_user" | sudo -S echo "=========================================" >> "${script_dir}/module_install_log"
#сбрасываем глобальную ошибку
global_error=0
global_error0=0

# основной цикл проверки выброных модулей и запуска их скриптов на установку
for (( i=0; i <= $module_base_num; i=i+10 ))
do
echo ${modules_select} | grep -ow "${module_base[$i+1]}" > /dev/null
if [ $? = 0 ];then
run_module="${script_dir}/modules-temp/${module_base[$i+5]}/${module_base[$i+5]}.sh"
chmod +x ${run_module}

# дублируем информацию о модуле в конфиг файл в папку модуля где его скрипт
echo "$pass_user" | sudo -S echo "${module_base[$i]}" > "${script_dir}/modules-temp/${module_base[$i+5]}/module_config"
module_name="${module_base[$i+5]}"
let "module_num=(${i}+1)"
for (( m=${module_num}; m <= (${module_num}+8); m=m+1 ))
do
echo "${module_base[$m]}" >> "${script_dir}/modules-temp/${module_name}/module_config"
#echo "${module_base[$m]}"
done

# запуск модуля с правами root в отдельном процессе bash что бы изолировать его от переменной $pass_user где храниться root-пароль пользователя
echo "$pass_user" | sudo -S echo "==========[${module_name}]==========" >> "${script_dir}/module_install_log"
if [[ "${module_base[$i+9]}" == "noroot" ]];then
# даем право за на запуск модуля как скрипт
#запуск модуля с передачей пароля root пользователя
echo "$pass_user" | sudo -S chmod +x "${run_module}"
bash ${run_module} ${pass_user} || let "global_error += 1"
# удаляем файл конфигурации созданный специально для модуля
echo "$pass_user" | sudo -S rm "${script_dir}/modules-temp/${module_base[$i+5]}/module_config" || true
#проверяем есть ли глобальная ошибка в модуле при установке, если да, пишем об этом в логе, логика не срабатывает повторно, для это используется дополнительная переменная global_error0
if (($global_error > $global_error0));then
echo "$pass_user" | sudo -S echo "в модуле ${module_base[$i+1]}, Критическая ошибка, дата установки:${date_install}" >> "${script_dir}/module_install_log"
let "global_error0 += 1" 
fi
else
# даем право за на запуск модуля как скрипт
echo "$pass_user" | sudo -S chmod +x "${run_module}"
# запуск модуля с правами root пользователя
echo "$pass_user" | sudo -S bash ${run_module} || let "global_error += 1"
# удаляем файл конфигурации созданный специально для модуля
echo "$pass_user" | sudo -S rm "${script_dir}/modules-temp/${module_base[$i+5]}/module_config" || true
#проверяем есть ли глобальная ошибка в модуле при установке, если да, пишем об этом в логе, логика не срабатывает повторно, для это используется дополнительная переменная global_error0
if (($global_error > $global_error0));then
echo "$pass_user" | sudo -S echo "в модуле ${module_base[$i+1]}, Критическая ошибка, дата установки:${date_install}" >> "${script_dir}/module_install_log"
let "global_error0 += 1" 
fi
fi
fi

done

#проверка на глобальные ошибки в модулях, например он вобще не запустился или файлов таких нет.
#echo ${global_error}
if (($global_error > 0));then
echo "$pass_user" | sudo -S echo "[[[[[[[[[[[[[[[[CRITICAL ERRORS]]]]]]]]]]]]]]]]" >> "${script_dir}/module_install_log"
echo "$pass_user" | sudo -S echo "Количество критических ошибок в модулях:${global_error}, дата установки:${date_install}" >> "${script_dir}/module_install_log"
fi

#проверка как завершилась работа установки модулей, если были ошибки, то логи показывать не нужно
GTK_THEME="Adwaita-dark" zenity --text-info --width=480 --height=680 --title="Лог установки модулей ${version} " --filename="${script_dir}/module_install_log" --editable
echo "" > "${script_dir}/module_install_log" 
echo "" > "${script_dir}/config/user"
echo "" > "${script_dir}/config/yad-module-form"

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
