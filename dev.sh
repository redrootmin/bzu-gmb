#!/bin/bash
#creator by RedRoot(Yaciyna Mikhail) for GAMER STATION [on linux] and Gaming Community OS Linux
# GPL-3.0 License

mangohud_install="no"

if [ -e /bin/mangohud ];then
mangohud vkcube& mangohud glxgears& sleep 5;killall vkcube;killall glxgears
mangohud_install="yes"
fi

if echo "$mangohud_install" | grep "yes" > /dev/null
then
tput setaf 2;echo "Mangohud установлен успешно!"
else
tput setaf 1;echo "Mangohud не установлен :("
fi








exit 0
