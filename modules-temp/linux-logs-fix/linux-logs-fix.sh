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
tput setaf 2; echo "Уменьшание размера всех логов в системе до 100М [https://ubuntuhandbook.org/index.php/2020/12/clear-systemd-journal-logs-ubuntu/]. Версия скрипта 1.0b, автор: Яцына М.А."
tput sgr0


#Уменьшение размера всех логов в системе до 50М
echo "${pass_user}" | sudo -S echo "" > /var/log/kern.log
echo "${pass_user}" | sudo -S echo "" > /var/log/syslog
echo "${pass_user}" | sudo -S service syslog restart
echo "${pass_user}" | sudo -S journalctl --vacuum-size=100M
echo "${pass_user}" | sudo -S sed -i 's/#SystemMaxUse=/SystemMaxUse=100M/g'  /etc/systemd/journald.conf
echo "${pass_user}" | sudo -S systemctl daemon-reload

#формируем информацию о том что в итоге установили и показываем в терминал
tput setaf 2; echo "${pass_user}" | sudo -S cat /etc/systemd/journald.conf | grep "SystemMaxUse"
tput sgr0

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о настройке логов [https://ubuntuhandbook.org/index.php/2020/12/clear-systemd-journal-logs-ubuntu/]"	 				  >> "${script_dir}/module_install_log"

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
