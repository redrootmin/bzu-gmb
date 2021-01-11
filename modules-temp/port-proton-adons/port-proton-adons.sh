#!/bin/bash
#creator by RedRoot(Yacyna Mehail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License 

#проверяем что модуль запущен от пользователя root
[ "$UID" -eq 0 ] || { zenity --error --text="Этот скрипт нужно запускать из под root!"; exit 1;}

# определение имени файла, папки где находиться скрипт и версию скрипта
name_script0=`basename "$0"`
name_script=`echo ${name_script0} | sed "s|.sh||g"`
script_dir0=$(cd $(dirname "$0") && pwd); name_cut="/modules-temp/${name_script}"
script_dir=`echo ${script_dir0} | sed "s|${name_cut}||g"`
version0=`cat "${script_dir}/config/name_version"`
version="${version0}"
#объявляем нужные переменные для скрипта
date_install=`date`
#загружаем данные о модули и файла конфигурации в массив
readarray -t module_conf < "${script_dir}/modules-temp/${name_script}/module_config"
#примеры считывания массива с данными
#version_kernel=${module_conf[*]} - Все записи в массиве
#version_kernel=${#module_conf[*]} - Количество записей в массиве, нумерания с нуля
#version_kernel=${module_conf[7]} - Определенная запись в массиве

#даем информацию в терминал какой модуль устанавливается
tput setaf 2; echo "Установка дополнительных пакетов и утилит для портов проекта PortWINE https://portwine-linux.ru/portwine-faq/]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
sudo -S sudo dpkg --add-architecture i386 || true
sudo -S apt update -y || true
sudo -S sudo apt upgrade -y || true
sudo -S sudo add-apt-repository -y multiverse || true
sudo -S apt install -y freetds-common gpm:i386 icoutils lib32gcc1 lib32stdc++6 lib32z1 libaa1:i386 libatk1.0-0:i386 libc6-i386 libclc-amdgcn libclc-dev libclc-r600 libcurl4:i386 libdatrie1:i386 libegl-mesa0:i386 libegl1:i386 libgbm1:i386 libgd-tools:i386 libgdk-pixbuf2.0-0:i386 libgnutlsxx28 libgnutlsxx28:i386 libgraphite2-3:i386 libharfbuzz0b:i386 libice6:i386 libjpeg62 libjpeg62:i386 libmikmod3 libnghttp2-14:i386 libnspr4:i386 libnss3:i386 libpango-1.0-0:i386 libpangocairo-1.0-0:i386 libpangoft2-1.0-0:i386 libpopt0:i386 libportaudio2:i386 libpq5 libpq5:i386 libpsl5:i386 librtmp1:i386 libsdl-net1.2 libsdl-sound1.2 libsdl2-2.0-0 libsdl2-2.0-0:i386 libsdl2-image-2.0-0:i386 libslang2:i386 libsm6:i386 libthai0:i386 libwxbase3.0-0v5 libxcb-xfixes0:i386 libxkbcommon0:i386 libxss1:i386 winbind fonts-wine gcc-8-base:i386 gstreamer1.0-plugins-base:i386 libasn1-8-heimdal:i386  libasound2:i386 libasound2-plugins:i386 libasyncns0:i386 libatomic1:i386 libavahi-client3:i386 libavahi-common-data:i386 libavahi-common3:i386 libblkid1:i386 libbsd0:i386 libc6:i386 libcairo2:i386 libcap2:i386 libcapi20-3 libcapi20-3:i386 libcdparanoia0:i386 libcom-err2:i386 libcups2:i386 libdb5.3:i386 libdbus-1-3:i386 libdrm-amdgpu1:i386 libdrm-intel1:i386 libdrm-nouveau2:i386 libdrm-radeon1:i386 libdrm2:i386 libedit2:i386 libelf1:i386 libexif12:i386 libexpat1:i386 libflac8:i386 libfontconfig1:i386 libfreetype6:i386 libgcrypt20:i386 libgd3:i386 libgl1:i386 libgl1-mesa-dri:i386 libglapi-mesa:i386 libglib2.0-0:i386 libglu1-mesa:i386 libglvnd0:i386 libglx-mesa0:i386 libglx0:i386 libgmp10:i386 libgnutls30:i386 libgpg-error0:i386 libgphoto2-6:i386 libgphoto2-port12:i386 libgpm2:i386 libgsm1:i386 libgssapi-krb5-2:i386 libgssapi3-heimdal:i386 libgstreamer-plugins-base1.0-0:i386 libgstreamer1.0-0:i386 libhcrypto4-heimdal:i386 libheimbase1-heimdal:i386 libheimntlm0-heimdal:i386 libhx509-5-heimdal:i386 libidn2-0:i386 libieee1284-3:i386 libjack-jackd2-0:i386 libjbig0:i386 libjpeg-turbo8:i386 libjpeg8:i386 libk5crypto3:i386 libkeyutils1:i386 libkrb5-26-heimdal:i386 libkrb5-3:i386 libkrb5support0:i386 liblcms2-2:i386 libldap-2.4-2:i386 libltdl7:i386 liblz4-1:i386 liblzma5:i386 libmount1:i386 libmpg123-0:i386 libncurses5:i386 libogg0:i386 libopenal-data libopenal1 libopenal1:i386 libopus0:i386 liborc-0.4-0:i386 libosmesa6 libosmesa6:i386 libp11-kit0:i386 libpcap0.8:i386 libpciaccess0:i386 libpcre3:i386 libpixman-1-0:i386 libpng16-16:i386 libpulse0:i386 libroken18-heimdal:i386 libsamplerate0:i386 libsane1:i386 libsasl2-2:i386 libsasl2-modules:i386 libsasl2-modules-db:i386 libselinux1:i386 libsndfile1:i386 libspeexdsp1:i386 libsqlite3-0:i386  libstdc++6:i386 libsystemd0:i386 libtasn1-6:i386 libtheora0:i386 libtiff5:i386 libtinfo5:i386 libudev1:i386 libunistring2:i386 libusb-1.0-0:i386 libuuid1:i386 libv4l-0:i386 libv4lconvert0:i386 libvisual-0.4-0:i386 libvorbis0a:i386 libvorbisenc2:i386 libwebp6:i386 libwind0-heimdal:i386 libwrap0:i386 libx11-6:i386 libx11-xcb1:i386 libxau6:i386 libxcb-dri2-0:i386 libxcb-dri3-0:i386 libxcb-glx0:i386 libxcb-present0:i386 libxcb-render0:i386 libxcb-shm0:i386 libxcb-sync1:i386 libxcb1:i386 libxcomposite1:i386 libxcursor1:i386 libxdamage1:i386 libxdmcp6:i386 libxext6:i386 libxfixes3:i386 libxi6:i386 libxinerama1:i386 libxml2:i386 libxpm4:i386 libxrandr2:i386 libxrender1:i386 libxshmfence1:i386 libxslt1.1:i386 libxxf86vm1:i386 ocl-icd-libopencl1 ocl-icd-libopencl1:i386 zlib1g:i386 xterm curl wget aria2 p7zip p7zip-full cabextract ocl-icd-libopencl1 ocl-icd-libopencl1:i386 libvulkan1 libvulkan1:i386 mesa-utils mesa-vulkan-drivers mesa-vulkan-drivers:i386 glib-networking:i386 gstreamer1.0-plugins-good:i386 gstreamer1.0-x:i386 libavc1394-0:i386 libcaca0:i386 libcairo-gobject2:i386 libdv4:i386 libgstreamer-plugins-good1.0-0:i386 libgudev-1.0-0:i386 libiec61883-0:i386 libmp3lame0:i386 libncursesw6:i386 libproxy1v5:i386 libraw1394-11:i386 libshout3:i386 libsoup2.4-1:i386 libspeex1:i386 libtag1v5:i386 libtag1v5-vanilla:i386 libtwolame0:i386 libvkd3d1 libvkd3d1:i386 libvpx6:i386 libwavpack1:i386 libxv1:i386 gstreamer1.0-plugins-bad libfaudio0 libfaudio0:i386 gamemode libwine libwine:i386 xterm zenity vulkan-tools || true
sudo -S sudo apt autoremove || true
#формируем информацию о том что в итоге установили и показываем в терминал
#module_installing=`dpkg -s lutris | grep installed` || true
#if [[ "${module_installing}" == "" ]]
#then
#tput setaf 1; echo "При установки Lutris произошла ошибка!"  || let "error += 1"
#tput sgr0
#else
tput setaf 2; echo "Установка зависимостей PortWINE завершена"
tput sgr0
#тестовый запуск Lutris
#lutris & sleep 5;sudo -S killall lutris
#fi

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "Модуль ${name_script}, дата установки: ${date_install}, количество ошибок: ${error}"	 				  >> "${script_dir}/module_install_log"

#Добавляем информацию о том как использовать CoreCtrl лог установки
#echo "Подробнее о том как запускать CoreCtrl без постоянного ввода пароля тут: https://gitlab.com/corectrl/corectrl/-/wikis/Setup"	 				  >> "${script_dir}/module_install_log"
#echo "Подробнее о командах и функциях тут: https://github.com/lutris/lutris/wiki" >> "${script_dir}/module_install_log"
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
