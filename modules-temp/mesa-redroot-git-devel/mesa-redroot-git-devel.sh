#!/bin/bash
#creator by RedRoot(Yaciyna Mikhail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License

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

#даем информацию в терминал какой модуль установливается
tput setaf 2; echo "Установка стабильного открытого драйвера Mesa 23.2+. Версия скрипта 1b, автор-скрипта: Яцына М.А."
tput sgr0

if echo "${linuxos_run_bzu_gmb}" | grep -ow "ROSA Fresh Desktop" > /dev/null || echo "${linuxos_run_bzu_gmb}" | grep -ow "ROSA Fresh Desktop 12.3" > /dev/null
then
 if [ -e /etc/yum.repos.d/mesa-redroot-stable.repo ];then
tput setaf 3;echo "Репозитарий: mesa-redroot-stable.repo, уже установлен, просто обнавляем систему";tput sgr0
echo "${pass_user}" | sudo -S dnf --refresh distrosync -y
echo "${pass_user}" | sudo -S dnf update -y
echo "${pass_user}" | sudo -S dnf autoremove -y
echo "${pass_user}" | sudo -S dnf clean packages
 else
#запуск основных команд модуля
echo "${pass_user}" | sudo -S rm -f /etc/yum.repos.d/mesa*
#echo "${pass_user}" | sudo -S rm -f "/etc/yum.repos.d/mesa-devel-fidel.repo"
echo "${pass_user}" | sudo -S dnf --refresh distrosync -y
echo "${pass_user}" | sudo -S dnf update -y
echo "${pass_user}" | sudo -S dnf autoremove -y
echo "${pass_user}" | sudo -S dnf clean packages
echo "[mesa-redroot-stable-x86_64]
name=mesa-redroot-stable-x86_64
baseurl=http://abf-downloads.rosalinux.ru/mesa_redroot_stable_personal/repository/rosa2021.1/x86_64/main/release/
gpgcheck=0
enabled=1
cost=999

[mesa-redroot-stable-i686]
name=mesa-redroot-stable-i686
baseurl=http://abf-downloads.rosalinux.ru/mesa_redroot_stable_personal/repository/rosa2021.1/i686/main/release/
gpgcheck=0
enabled=1
cost=1000" > /tmp/mesa-redroot-stable.repo
echo "${pass_user}" | sudo -S mv /tmp/mesa-redroot-stable.repo /etc/yum.repos.d
echo "${pass_user}" | sudo -S dnf --refresh distrosync
echo "${pass_user}" | sudo -S dnf update -y
echo "${pass_user}" | sudo -S dnf autoremove -y
echo "${pass_user}" | sudo -S dnf clean packages
 fi
cd
echo "${pass_user}" | sudo -S rm -f -r mesa
echo "${pass_user}" | sudo -S dnf install -y --allowerasing --skip-broken --nobest gcc* meson git flex bison gccmakedep lm_sensors-devel lib64elfutils-devel libllvm-devel expat libselinux-devel libatomic-devel python3-mako libdrm_amdgpu1 libdrm_intel1 libdrm_radeon1 libudev1 libglvnd lib64epoxy-devel gtk+3.0 libzstd1 libzstd-devel vulkan lib64xdamage-devel lib64xfixes-devel lib64xmu-devel lib64xxf86vm-devel lib64xv-devel lib64xvmc-devel valgrind lib64stdc++-static-devel libssl1 libclc lib64xvmc-devel lib64vdpau-drivers lib64vdpau-devel libva2 wayland-protocols-devel wayland*-devel glslang glslang-devel patchelf lib64xrandr-devel lib64d3dadapter9-devel libvulkan-devel lib64vulkan-devel lib64python3-devel libxrandr-devel libxxf86vm-devel lib64xshmfence-devel libxfixes-devel lib64wayland-devel lib64elf-devel lib64drm-devel libdrm-common lib64drm_amdgpu1 libxcb-devel libzstd-devel expat-devel libxshmfence-devel libomxil-bellagio-devel zlib-devel libvdpau-devel libdrm-devel pkgconf python-pkgconfig python3-pkgconfig lib64omxil-bellagio-devel lib64va-devel lib64zstd-devel lib64clang-devel lib64unwind-devel
git clone https://gitlab.freedesktop.org/mesa/mesa.git
cd mesa
meson build64 \
	-D microsoft-clc=disabled \
	-D shared-llvm=enabled \
	-D b_ndebug=true \
	-D c_std=c11 \
	-D cpp_std=c++17 \
	-D gallium-drivers=auto,radeonsi,virgl,zink \
	-D gallium-va=enabled \
	-D gallium-vdpau=enabled \
	-D gallium-xa=enabled \
	-D gallium-nine=true \
	-D glx=dri \
	-D platforms=wayland,x11 \
	-D egl-native-platform=wayland \
	-D vulkan-layers=device-select,overlay \
	-D vulkan-drivers=auto,amd,virtio-experimental \
	-D xlib-lease=auto \
	-D osmesa=true \
	-D glvnd=true \
	-D dri3=enabled \
	-D egl=enabled \
	-D gbm=enabled \
	-D gles1=disabled \
	-D gles2=enabled \
	-D glx-direct=true \
	-D llvm=enabled \
	-D lmsensors=enabled \
	-D opengl=true \
	-D shader-cache=enabled \
	-D shared-glapi=enabled \
	-D shared-llvm=enabled \
	-D prefix=/usr \
	-D video-codecs=vc1dec,h264dec,h264enc,h265dec,h265enc \
        -D sysconfdir=/etc
     
ulimit -n 4096 && echo "${pass_user}" | sudo -S ninja -C build64 install
cd
echo "${pass_user}" | sudo -S rm -f -r mesa
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
