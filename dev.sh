#!/bin/bash
#creator by RedRoot(Yaciyna Mikhail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License

 #Проверка что существует папка bzu-gmb-utils, если нет, создаем ее
 if [ ! -d "/home/$USER/.local/share/bzu-gmb-utils" ]
 then
mkdir -p "/home/$USER/.local/share/bzu-gmb-utils"
ln -s /home/$USER/.local/share/bzu-gmb-utils /home/$USER/bzu-gmb-utils
echo "папки небыло создаем папку и ярлык"
 else
  if [ ! -d "/home/$USER/bzu-gmb-utils" ];then
ln -s /home/$USER/.local/share/bzu-gmb-utils /home/$USER/bzu-gmb-utils
echo "ярлыка небыло, создаем его"
  fi
fi








exit 0
