#!/bin/bash

#проверяем что скрипт установки не запущен от пользователя root
if [ "$UID" -eq 0 ];then
tput setaf 1
echo "Этот скрипт не нужно запускать из под root!"
tput sgr0
exit 1
else
tput setaf 2
echo "все хорошо этот скрипт не запущен из под root!"
tput sgr0
fi

app_dir=$(dirname $(readlink -f "$0"))
main_dir=`echo ${app_dir} | sed 's/\/app\>//g'`
utils_dir="${main_dir}/core-utils"
cd ${app_dir}
#переменные утилит и скриптов
YAD="${utils_dir}/yad"
mangohud="${utils_dir}/./mangohud_portable"
zenity="${utils_dir}/zenity"
test_array=(Furmark Pixmark_Piano)
mode_array=(Benchmark Stress_Test)
resolution_array=(640x480 800x600 1024x768 1280x1024 1440x900 1680x1050 1920x1200 2560x1600 3840x2400 960x540 1280x720 1600x900 1920x1080 2560×1440 3840x2160)
fullscreen_array=(off on)
api_array=(OpenGL Zink)

tput setaf 2
echo "Папка программы:[${app_dir}]"
echo "Общая папка программы и скриптов:[${main_dir}]"
echo "Папка утилит:[${utils_dir}]"
tput sgr0


furmark_conf=$(GTK_THEME="Adwaita-dark" $YAD --form --width=250 --posx=100 --posy=100 --title="FurMark-Linux" \
--image-on-top --image="${app_dir}/furmark-logo-new256.jpg" --window-icon="${app_dir}/furmark_benchmark.png" \
--field="TEST":CB \
$(IFS=! ; echo "${test_array[*]}") \
--field="MODE":CB \
$(IFS=! ; echo "${mode_array[*]}") \
--field="RESOLUTION":CB \
$(IFS=! ; echo "${resolution_array[*]}") \
--field="FULLSCREEN":CB \
$(IFS=! ; echo "${fullscreen_array[*]}") \
--field="API":CB \
$(IFS=! ; echo "${api_array[*]}"))

if [ "$?" -eq "0" ];then
#определение переменных по умолчанию
test_status="/test=fur"
mode_status="/benchmark /print_score"
resolution_width="/width=640"
resolution_height="/height=480"
fullscreen_status=""
api_status=""
mangohud_status="--dlsym"
else
tput setaf 1
echo "Отмена выполнения теста!"
tput sgr0
exit 0
fi

#echo $furmark_conf
#$mangohud vkcube



#ПРОВЕРКА И ПРИМЕНЕНИЕ ВВЕДЕННЫХ ДАННЫХ

#проверка какой выбран тест
if echo "$furmark_conf" | grep "Pixmark_Piano"> /dev/null;then
echo "Тестировать будем:[Pixmark_Piano]"
test_status="/test=pixmark_piano"
fi

#проверка режима теста
if echo "$furmark_conf" | grep "Stress_Test"> /dev/null;then
echo "Тестировать будем в режиме Стресс-теста!"
mode_status=""
fi


#проверка на включение полного экрана
if echo "$furmark_conf" | grep "on"> /dev/null;then
tput setaf 1
echo "Включен режим полного экрана и выбирается максимальное разрешение! "
fullscreen_status="/fullscreen"
tput sgr0
else
echo "Включен оконный режим"

#проверка и добавление выбранного разрешения изображения теста
if echo "$furmark_conf" | grep "640x480"> /dev/null;then
echo "Тестирование будет проводиться в разрешении:[640x480]"
else
resolution_width0=`echo "$furmark_conf" | egrep -o "[0-9]+x[0-9]+" | cut -d x -f 1`
resolution_height0=`echo "$furmark_conf" | egrep -o "[0-9]+x[0-9]+" | cut -d x -f 2`
echo "Тестировать будем:[$resolution_width0""x""$resolution_height0]"
resolution_width="/width=$resolution_width0"
resolution_height="/height=$resolution_height0"
fi

fi

#проверка на включение API Zink
if echo "$furmark_conf" | grep "Zink"> /dev/null;then
echo "Включен режим API Zink [OpenGL to Vulkan]!"
api_status="MESA_LOADER_DRIVER_OVERRIDE=zink"
mangohud_status=""
else
echo "Включен режим API OpenGL"
fi


# старт теста
runtest="${api_status} ${mangohud} ${mangohud_status} ${app_dir}/GpuTest ${test_status} ${resolution_width} ${resolution_height} ${fullscreen_status} ${mode_status}"
echo "Запуск Теста со следующими параметрами:[${runtest}]"
eval $runtest

exit 0


#100% work commands-pack
#MANGOHUD=1 VK_LAYER_PATH=/home/gamer/Refresh2025-Benchmark VK_INSTANCE_LAYERS=VK_LAYER_MANGOHUD_overlay LD_LIBRARY_PATH="/home/gamer/Refresh2025-Benchmark" LD_PRELOAD="libMangoHud.so" vkcube

#corrent display resolution
#xdpyinfo -display :0.0 | grep dimensions | egrep -o "[0-9]+x[0-9]+ pixels" | egrep -o "[0-9]+x[0-9]+"
