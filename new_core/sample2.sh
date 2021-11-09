#!/bin/bash
#creator by RedRoot(Yaciyna Mikhail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License 

#собираем данные о том в какой папке  находиться редактор
script_dir=$(cd $(dirname "$0") && pwd);
app_dir="${script_dir}/app"
name_desktop_file1="furmark-Linux.desktop"
#name_desktop_file2="refresh2025[Vulkan]benchmark.desktop"
name_script_start1="furmark_starter.sh"
#name_script_start2="refresh2025[vulkan]starter.sh"
name_app1="FurMark Linux"
#name_app2="[Vulkan]Refresh2025-Benchmark"
name_app_file="GpuTest"
name_icons1="furmark_benchmark.png"
#name_icons2="refresh2025-vulkan150.png"
list_categories="Utility;Games;"
exec_full1="bash -c "${app_dir}"/"${name_script_start1}""
#exec_full2="bash -c "${app_dir}"/"${name_script_start2}""
 
# Проверка что существует папка applications, если нет, создаем ее
if [ ! -d "/home/${USER}/.local/share/applications" ]
then
mkdir -p "/home/${USER}/.local/share/applications"
fi

#Создаем ярлык для скрипта запускающего тест FurMark
echo "[Desktop Entry]" > "${script_dir}/${name_desktop_file1}"
echo "Version=1.0" >> "${script_dir}/${name_desktop_file1}"
echo "Type=Application" >> "${script_dir}/${name_desktop_file1}"
echo "Name=${name_app1}" >> "${script_dir}/${name_desktop_file1}"
echo "Comment=Furmark Linux is tester API: OpenGL, Zink(OpenGL to Vulkan)" >> "${script_dir}/${name_desktop_file1}"
echo "Categories=${list_categories}" >> "${script_dir}/${name_desktop_file1}"
echo "Exec=${exec_full1}" >> "${script_dir}/${name_desktop_file1}"
echo "Terminal=true" >> "${script_dir}/${name_desktop_file1}"
echo "Icon=${script_dir}/${name_icons1}" >> "${script_dir}/${name_desktop_file1}"
cp -f "${script_dir}/${name_desktop_file1}" "/home/$USER/.local/share/applications/"

#Создаем ярлык для скрипта запускающего тест
#echo "[Desktop Entry]" > "${script_dir}/${name_desktop_file2}"
#echo "Version=1.0" >> "${script_dir}/${name_desktop_file2}"
#echo "Type=Application" >> "${script_dir}/${name_desktop_file2}"
#echo "Name=${name_app2}" >> "${script_dir}/${name_desktop_file2}"
#echo "Comment=Comment=Refresh2025-Benchmark is Freesync, Gsync, All The Syncs Tester (DX11, DX12, Vulkan)" >> "${script_dir}/${name_desktop_file2}"
#echo "Categories=${list_categories}" >> "${script_dir}/${name_desktop_file2}"
#echo "Exec=${exec_full2}" >> "${script_dir}/${name_desktop_file2}"
#echo "Terminal=true" >> "${script_dir}/${name_desktop_file2}"
#echo "Icon=${script_dir}/${name_icons2}" >> "${script_dir}/${name_desktop_file2}"
#cp -f "${script_dir}/${name_desktop_file2}" "/home/$USER/.local/share/applications/"

#Даем права на запуск ярлыка в папке программы и копируем в папку с ярлыками пользователя
gio set "${script_dir}/${name_desktop_file1}" "metadata::trusted" yes
gio set "/home/$USER/.local/share/applications/${name_desktop_file1}" "metadata::trusted" yes
#gio set "${script_dir}/${name_desktop_file2}" "metadata::trusted" yes
#gio set "/home/$USER/.local/share/applications/${name_desktop_file2}" "metadata::trusted" yes
chmod +x "${script_dir}/${name_desktop_file1}"
chmod +x "/home/$USER/.local/share/applications/${name_desktop_file1}"
#chmod +x "${script_dir}/${name_desktop_file2}"
#chmod +x "/home/$USER/.local/share/applications/${name_desktop_file2}"

#gio info "${script_dir}/name_desktop_file" | grep "metadata::trusted"

#даем права на запуск программы и ее скриптов
chmod +x "${app_dir}/${name_script_start1}"
#chmod +x "${app_dir}/${name_script_start2}"
chmod +x "${app_dir}/${name_app_file}"
chmod +x "${script_dir}/core-utils/mangohud_portable"
chmod +x "${script_dir}/core-utils/libMangoHud_dlsym.so"
chmod +x "${script_dir}/core-utils/libMangoHud.so"

#chmod +x "${app_dir}/resources/app/extensions/git/dist/askpass-empty.sh"
#chmod +x "${app_dir}/resources/app/extensions/git/dist/askpass.sh"
exit 0


#[Desktop Entry]
#Version=1.0
#Type=Application
#Name=Godot_portable
#Comment=Godot Engine is an open source cross-platform 2D and 3D game engine licensed by MIT that is being developed by the Godot Engine Community
#Categories=Utility;TextEditor;Development;IDE;
#Exec=bash -c /home/interselt/Yandex.Disk/bzu-gmb_temp/VSCodium/VSCodium_starter.sh
#Terminal=true
#Icon=/home/interselt/Yandex.Disk/bzu-gmb_temp/VSCodium/codium.png
#Name[ru_RU]=Godot_portable
