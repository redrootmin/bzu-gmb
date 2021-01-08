#!/bin/sh
#Данный набор графических тестов и бенчмарков поможет вам проверить работу: OpenGL 2.x\3.x\4.x API, Vulkan AP, Valve ACO, ZINK (OpenGL to Vulkan) 
sudo rm -rf /usr/share/test/ || true
sudo rm -rf /home/$USER/test.7z || true
zenity --text-info --title="BZU GameMod Boosting Installer beta1" --html --url="https://drive.google.com/uc?export=view&id=1rOcT4jk7Zhumc24_xdQ8rdzjKPwOOMlk" --width=640 --height=408
if [ "$?" -eq "0" ];then
      zenity --info --text="Если Вы видели картинку, значит интернет работает и мы продолжаем :)" --width=256 --height=128
else
       exit 0
fi
zenity --question --title="BZU GameMod Utils Installer beta1" --text="Данный скрипт установит на вашу GNU-Linux систему набор графических утилит, которые позволят произвести тестирование: OpenGL 2.x-3.x-4.x API, Vulkan API, Valve ACO, Mesa Zink(OpenGL to Vulkan), Feral GameMode.                     ВНИМАНИЕ: Скрипт поддерживает: Ubuntu 18.04,19.04,19.10 и Linux Mint 19.3. Установку вы совершаете на свой страх и риск, за любые негативные последствия для вашей GNU-Linux системы автор ответственность не несет !" --width=256 --height=128
if [ "$?" -eq "0" ];then
echo "Вы подтвердили установку, готовьтесь :)"
else exit 0
fi
sudo apt install -f -y p7zip-rar rar unrar unace arj cabextract python-tk glmark2 || true
sudo wget -P /usr/share/ "https://drive.google.com/uc?export=download&id=188SErZ2lT7tOWFiG97w1sLvXLON5_Ozi" -O test.7z
sudo 7z x test.7z -o/usr/share/
sudo chmod a+x /usr/share/test/glmark2-benchmark/glmark2-benchmark || true
sudo chmod a+x /usr/share/test/glmark2-benchmark/glmark2-benchmark.desktop || true
sudo chmod a+x /usr/share/test/glmark2-benchmark/glmark2-benchmark-zink.desktop || true
sudo chmod a+x /usr/share/test/glmark2-benchmark/glmark2-benchmark_zink || true
sudo chmod a+x /usr/share/test/glmark2-benchmark/OpenGL_logo.png || true
sudo chmod a+x /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark || true
sudo chmod a+x /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark.desktop || true
sudo chmod a+x /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark.png || true
sudo chmod a+x /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark_zink || true
sudo chmod a+x /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark_zink.desktop || true
sudo chmod a+x /usr/share/test/GpuTest_Linux_x64_0.7.0/GpuTest || true
sudo chmod a+x /usr/share/test/GpuTest_Linux_x64_0.7.0/gputest_gui-2.0.py || true
sudo chmod a+x /usr/share/test/GpuTest_Linux_x64_0.7.0/gputest_gui-3.0.py || true
sudo chmod a+x /usr/share/test/tfm-benhmark-linux64-opengl/benchmark-opengl || true
sudo chmod a+x /usr/share/test/tfm-benhmark-linux64-opengl/benchmark-opengl.desktop || true
sudo chmod a+x /usr/share/test/tfm-benhmark-linux64-opengl/Opengl-logo.svg.png || true
sudo chmod a+x /usr/share/test/tfm-benhmark-linux64-opengl/tfm10-linux64-opengl.x86_64 || true
sudo chmod a+x /usr/share/test/tfm-benhmark-linux64-vulkan/benchmark-vulkan || true
sudo chmod a+x /usr/share/test/tfm-benhmark-linux64-vulkan/benchmark-vulkan.desktop || true
sudo chmod a+x /usr/share/test/tfm-benhmark-linux64-vulkan/tfm10-linux64-vulkan.x86_64 || true
sudo chmod a+x /usr/share/test/tfm-benhmark-linux64-vulkan/vulkan-logo-png-transparent.png || true
sudo chmod a+x /usr/share/test/vulkan-smoketest-benchmark/vulkan-smoketest || true
sudo chmod a+x /usr/share/test/vulkan-smoketest-benchmark/vulkan-smoketest-benchmark || true
sudo chmod a+x /usr/share/test/vulkan-smoketest-benchmark/vulkan-smoketest-benchmark.desktop || true
sudo chmod a+x /usr/share/test/vulkan-smoketest-benchmark/vulkan-smoketest-benchmark.png || true
sudo rm -rf /home/$USER/test.7z || true
sudo cp /usr/share/test/glmark2-benchmark/glmark2-benchmark.desktop /usr/share/applications/ || true
sudo cp /usr/share/test/glmark2-benchmark/glmark2-benchmark-zink.desktop /usr/share/applications/ || true
sudo cp /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark.desktop /usr/share/applications/ || true
sudo cp /usr/share/test/GpuTest_Linux_x64_0.7.0/furmark_benchmark_zink.desktop /usr/share/applications/ || true
sudo cp /usr/share/test/tfm-benhmark-linux64-opengl/benchmark-opengl.desktop /usr/share/applications/ || true
sudo cp /usr/share/test/tfm-benhmark-linux64-vulkan/benchmark-vulkan.desktop /usr/share/applications/ || true
sudo cp /usr/share/test/vulkan-smoketest-benchmark/vulkan-smoketest-benchmark.desktop /usr/share/applications/ || true
zenity --info --width=512 --text "Установка BZU GameMod Utils Installer beta1 завершена успешно !"
#ВНИМАНИЕ: Данный скрипт исключительно для владельцев карт АМД и операционных систем базирующихся на Debian
#После долгих тестов смог найти репу mesa для Linux Mint\Ubuntu 19.10+
#Которая поддерживает:
#- mesa 20+
#- Valve ACO (RADV_PERFTEST=aco)
#- Mesa Vulkan Overlay (VK_INSTANCE_LAYERS=VK_LAYER_MESA_overlay VK_LAYER_MESA_OVERLAY_CONFIG=position=top-left)
#- И пока сыроватую и экспериментальную функцию ZINK, которая позволяет в драйвере mesa на прямую транслировать запросы OpenGL в Vulkan, пока работает поддержка только OpenGL 2.1 (MESA_LOADER_DRIVER_OVERRIDE=zink)
#По сути я ее и скорее всего Вы тоже знали и ранее, просто такой полной поддержки в ней ранее не было, был приятно удивлен. Для установки:

sudo rm -rf /home/$USER/gamemode || true
sudo rm -rf /home/$USER/corectrl || true
zenity --question --title="BZU GameMod Boosting Installer beta1" --text="Данный скрипт установит на вашу GNU-Linux систему, набор утилит,драйверов,программ, которые позволят оптимизировать систему для запуска компьютерных игр и мультимедиа программ, список установки: Mesa 20.x dev, Liquorix Kernel, Feral GameMode, CoreCtrl.                             После установки в вашей GNU-Linux системе будут задействованы следующие технологии: OpenGL 4.x API, Vulkan 1.x API, Valve ACO,Valve Fsync, Mesa Zink(OpenGL to Vulkan), Feral GameMode.                             ВНИМАНИЕ:Скрипт поддерживает: Ubuntu 18.04,19.04,19.10 и Linux Mint 19.3. Установку вы совершаете на свой страх и риск, за любые негативные последствия для вашей GNU-Linux системы автор ответственность не несет !" --width=400 --height=128
if [ "$?" -eq "0" ];then
echo "Вы снова подписались на это, теперь точно держитесь :)"
else exit 0
fi
sudo add-apt-repository ppa:oibaf/graphics-drivers -y
sudo apt update -y || true
sudo apt upgrade -y || true
sudo apt install -f -y --reinstall libvulkan1 libvulkan1:i386 libvulkan-dev libvulkan-dev:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 vulkan-utils || true
sudo apt install -f -y || true
#Для полного игрового буста вашей Linux OS рекомендую еще поставить оптимизированное ядро:
#СПЕЦИАЛЬНОЕ ЯДРО LIQUORIX KERNEL ОПТИМИЗИРОВАНО ДЛЯ МУЛЬТИМЕДИА В LINUX СИСТЕМАХ И С VALVE MFUTEX() [https://liquorix.net/]
sudo add-apt-repository ppa:damentz/liquorix -y
sudo apt update || true
sudo apt upgrade || true
sudo apt-get install --reinstall -f -y linux-image-liquorix-amd64 linux-headers-liquorix-amd64
sudo apt install -f -y || true
#для обнавления соответственно:
#sudo apt-get install —reinstall linux-image-liquorix-amd64 linux-headers-liquorix-amd64
#И собрать Feral gamemode:
#УТИЛИТА ОТ FERAL INTERACTIVE: GAMEMODE 1.5, ДЛЯ ОПТИМИЗАЦИИ LINUX СИСТЕМЫ ДЛЯ ЗАПУЩЕННОЙ ИГРЫ
#для установки нужно собрать утилиту из исходников, для этого сначала устанавливаем нужные программы, библиотеки и дополнения:
sudo apt install -f -y git meson libsystemd-dev pkg-config ninja-build git libdbus-1-dev || true
sudo apt install -f -y || true
#после скачиваем исходник:
git clone https://github.com/FeralInteractive/gamemode.git
#переходим в папку с утилитой для сборки:
cd
cd gamemode
#проверяем версию:
git checkout 1.5 || true
#теперь собираем:
yes Y | ./bootstrap.sh
#в конце компиляции задаст вопрос, отвечаем: y (тоесть да)
#если небыло ошибок, значит все хорошо.
#для использования в steam, зайдите в свойства игры в steam, потом нажмите на установить параметры запуска и добавьте в строку это:
#gamemoderun %command%
#если запускаете через терминал:
#gamemoderun ./game

#Выдержка из будущей версии БЗУ:
#5.0с УТИЛИТА CORECTRL ДЛЯ АВТОМАТИЧЕСКОГО УПРАВЛЕНИЯ ВЕНТИЛЯТОРАМИ И РАЗГОНОМ ВИДЕОКАРТ AMD
#CoreCtrl более продвинутая утилита чем radeon-profile и больше подходит для видеокарт VEGA 56\64: #https://gitlab.com/corectrl/corectrl
#ставить будем из исходников, перед установкой на 19.04 нужно установить дополнительные пакеты:
sudo apt install --reinstall -f -y extra-cmake-modules libqt5charts5 libqt5charts5-dev qttools5-dev libkf5auth-dev libkf5archive-dev libbotan-2-dev qtdeclarative5-dev qml-module-qtquick-controls hwdata qml-module-qt-labs-platform qml-module-qtcharts build-essential libgl1-mesa-dev mesa-common-dev freeglut3-dev freeglut3 build-essential cmake || true
ls -l /usr/lib/x86_64-linux-gnu/libEGL.so|| true
sudo rm /usr/lib/x86_64-linux-gnu/libEGL.so|| true
sudo ln /usr/lib/x86_64-linux-gnu/libEGL.so.1 /usr/lib/x86_64-linux-gnu/libEGL.so|| true
ls /usr/lib/x86_64-linux-gnu | grep -i libegl|| true
sudo apt install -f -y || true

##############если у вас ubuntu 18.04\ linux mint 19.x#############################
#нужно сначала настроить компилятор, поэтому ставим 8 версии из репы ниже
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt update -y || true
sudo apt upgrade -y || true
sudo apt install --reinstall -y gcc-8 g++-8
#после обновляем приоритеты, что бы 8 версия была основной
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7 || true
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8 || true
#после нужно проверить что теперь в приоритете 8 версия компилятора
#sudo update-alternatives —config gcc
#если это не так выбирайте этот пункт
#* 0 /usr/bin/gcc-8 800 auto mode
#все можно продолжить сборку
###################################################################################
#далее сборка
cd
git clone https://gitlab.com/corectrl/corectrl.git
cd corectrl
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF .. || zenity --info --width=512 --text "Ошибка Установки\Сборки CoreCtrl!"
make
sudo make install | zenity --info --width=512 --text "Установка BZU GameMod Boosting Installer beta1 завершена успешно!"
#В процессе первичной проверки перед сборкой cmake может ругнуться, что еще не хватает пакетов, гуглите что ему нужно
#для разгона VEGA 56\64 обязательно нужно выполнить пункт: 5.0b AMD GPU OVERCLOCKING / UNDERVOLTING (rx400\500+vega 56\64)
#По ссылке выше, на официальном вики есть видео с описанием функций.

exit 0
#Для создания скрипта использовались следующие ссылки
#https://techblog.sdstudio.top/blog/google-drive-vstavliaem-priamuiu-ssylku-na-izobrazhenie-sayta
#https://www.linuxliteos.com/forums/scripting-and-bash/preview-and-download-images-and-files-with-zenity-dialog/
#https://www.ibm.com/developerworks/ru/library/l-zenity/
#https://habr.com/ru/post/281034/
#https://webhamster.ru/mytetrashare/index/mtb0/20
