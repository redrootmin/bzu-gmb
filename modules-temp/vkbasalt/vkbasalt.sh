#!/bin/bash

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
module_link="https://github.com/DadSchoorse/vkBasalt/releases/download/v0.3.2.1/vkBasalt-0.3.2.1.tar.gz"
module_name="vkBasalt-0.3.2.1"

#даем информацию в терминал какой модуль установливается
tput setaf 2; echo "Установка открытой утилиты ${module_name} от DadSchoorse [https://github.com/DadSchoorse/vkBasalt]. Версия скрипта 1.1, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
sudo -S aptitude install -y build-essential glslang-dev glslang-tools libx11-dev libvulkan-dev libvulkan-dev:i386
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
sudo -S mkdir -p "${script_dir}/modules-temp/${name_script}/temp" || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp"|| let "error += 1"
sudo -S wget "${module_link}" || let "error += 1"
sudo -S tar xfvz vkBasalt*.tar.gz || let "error += 1"
cd "${script_dir}/modules-temp/${name_script}/temp/${module_name}" || let "error += 1"
sudo -S meson --buildtype=release --prefix=/usr builddir || let "error += 1"
sudo -S ninja -C builddir install || let "error += 1"
sudo -S cp -f "${script_dir}/modules-temp/${name_script}/temp/${module_name}/config/vkBasalt.conf" /etc/vkBasalt.conf
cd
sudo -S rm -r "${script_dir}/modules-temp/${name_script}/temp" || true

#формируем информацию о том что в итоге установили и показываем в терминал
vkbasalt_version=`vulkaninfo | grep "VK_LAYER_VKBASALT"`  || let "error += 1"
echo "Установлен vkBasalt ";tput setaf 2; echo ${vkbasalt_version}  || let "error += 1"
#сброс цвета текста в терминале
tput sgr0

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "Модуль ${name_script}, дата установки: ${date_install}, количество ошибок: ${error}"	 				  >> "${script_dir}/module_install_log"
#Добавляем информацию о изменении флагов в файле настройки GRUB в лог установки
echo "ВНИМАНИЕ: vkBasalt работает только с программами, которые используют Vulkan API"	 				  >> "${script_dir}/module_install_log"
echo "Для использования vkBasalt:"	 				  >> "${script_dir}/module_install_log"
echo "ENABLE_VKBASALT=1 /way/to/Vulkan/app"	 				  >> "${script_dir}/module_install_log"
echo "Например, в Steam:"	 				  >> "${script_dir}/module_install_log"
echo "ENABLE_VKBASALT=1 %command%"	 				  >> "${script_dir}/module_install_log"
echo "Подробнее о командах и фукнциях тут: https://github.com/DadSchoorse/vkBasalt"	 				  >> "${script_dir}/module_install_log"

#задержка вывода информации о итогах установки, что бы пользователь мог ознакомиться.
sleep 3
exit 0
