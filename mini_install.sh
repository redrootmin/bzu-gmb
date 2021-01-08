#! /bin/bash
#script_name=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));
script_dir=$(cd $(dirname "$0") && pwd);
version=`cat ${script_dir}/config/name_version`
echo ${version}

if [ ! -d "/home/${USER}/.local/share/applications" ]
then
	mkdir -p "/home/${USER}/.local/share/applications"
fi

if [ ! -d "/home/${USER}/.local/share/applications/bzu-gmb.desktop" ]
then
name_desktop="${version}"
Exec_full="gnome-terminal -- bash "${script_dir}"/bzu-gmb-launcher.sh" 
echo "[Desktop Entry]"	 				  > "${script_dir}/bzu-gmb.desktop"
echo "Name=${name_desktop}" 				 >> "${script_dir}/bzu-gmb.desktop"
echo "Exec="${Exec_full}""	                         >> "${script_dir}/bzu-gmb.desktop"
echo "Type=Application" 				 >> "${script_dir}/bzu-gmb.desktop"
echo "Categories=Game;System"	                         >> "${script_dir}/bzu-gmb.desktop"
echo "StartupNotify=true" 	    			  >> "${script_dir}/bzu-gmb.desktop"
echo "Path="${script_dir}""	                	  >> "${script_dir}/bzu-gmb.desktop"
echo "Icon="${script_dir}/icons/bzu-gmb512.png""         >> "${script_dir}/bzu-gmb.desktop"
chmod u+x "${script_dir}/bzu-gmb.desktop"
cp -f "${script_dir}/bzu-gmb.desktop" /home/${USER}/.local/share/applications/ 
fi
chmod +x ~/.local/share/bzu-gmb/bzu-gmb-launcher.sh
chmod +x ~/.local/share/bzu-gmb/bzu-gmb-Ubuntu-20.04-LTS-beta4.sh
chmod +x ~/.local/share/bzu-gmb/bzu-gmb-Ubuntu-20.04.1-LTS-beta4.sh
chmod +x ~/.local/share/bzu-gmb/bzu-gmb-Linux-Mint-20-beta4.sh
chmod +x ~/.local/share/bzu-gmb/bzu-gmb-Ubuntu-19.10-beta4.sh
chmod +x ~/.local/share/bzu-gmb/bzu-gmb-Linux-Mint-19.3-beta4.sh

