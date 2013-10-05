#!/bin/bash
## FILE: Walpa
##
## DESCRIPTION: Walpa -- Change Desktop Wallpaper for gnome3,gnome2,unity,mate,cinnamon --
##
## AUTHOR: 
##
## DATE: 2013-09-11
## 
## VERSION: 1.0
##
## Requires: zenity 
##
## USAGE: walpa
##

ps -elf | grep walpa | grep -v "grep" | awk '{print $4}'


case "$1" in
    -d|--daemon)
        $0 < /dev/null &> /dev/null & disown
        exit 0
        ;;
    -q|--quit)
        PID=$(ps -elf | grep walpa | grep -v "grep" | awk '{print $4}')
        kill -9 $PID
        exit 0
        ;;
    *)
        ;;
esac

#get screen resolution
Xaxis=$(xrandr --current | grep '*' | head -n 1 | uniq | awk '{print $1}' |  cut -d 'x' -f1)
Yaxis=$(xrandr --current | grep '*' | head -n 1 | uniq | awk '{print $1}' |  cut -d 'x' -f2)
#select local folder for images
DIR=`zenity --file-selection --text="Select Image Folder" --directory --title "Walpa"`
dir_choosen_ret=$?

if [ "$dir_choosen_ret" -ne 0 ]; then
  zenity --warning --title="Walpa" --text="No Folder choosen...Exit!"
  exit 1
else
  #select transition interval
  TRANSITION_INTERVAL=$(zenity --scale --title "Walpa" --min-value=5 --max-value=1800 --value=5 --step 1 --text="Enter an interval for changing the wallpaper.\n\n Values are in seconds.")
  if [ -z "$TRANSITION_INTERVAL" ]
   then
    exit 1
  fi
  while true;do
   cd "$DIR" 
   pwd
   PICS=$(ls {*.JPG,*.jpg,*.JPEG,*.jpeg,*.PNG*,.png,*.BMP,*.bmp,*.TIF,*.tif} 2>/dev/null| sort -R)
   if [ -z "$PICS" ]; then
    zenity --warning --title="Walpa" --text="No Pics found...Exit!"
    exit 1
   fi
   PIC_COUNTER=0
   for PIC in $PICS
    do
     #get pic dimensions
     Xpic=$(identify $PIC | awk '{print $3}' | tr "x" " " | awk '{print $1}')
     Ypic=$(identify $PIC | awk '{print $3}' | tr "x" " " | awk '{print $1}')
     if (( $Xpic > $Xaxis )) && (( $Ypic > $Yaxis )); then
      #values could be: "centered" "stretched" "zoom" "spanned" "scaled" "wallpaper"
      case $DESKTOP_SESSION in "mate") gsettings set org.mate.background picture-filename "$DIR"/$PIC && gsettings set org.mate.background picture-options "zoom";;
   	"gnome-classic") gconftool-2 --type string --set /desktop/gnome/background/picture_filename "$DIR"/$PIC;;
   	"gnome") gsettings set org.gnome.desktop.background picture-uri "$DIR"/$PIC && gsettings set org.gnome.desktop.background picture-options "zoom";;
   	"gnome-shell") gsettings set org.gnome.desktop.background picture-uri "$DIR"/$PIC && gsettings set org.gnome.desktop.background picture-options "zoom";;
   	"ubuntu") gsettings set org.gnome.desktop.background picture-uri "$DIR"/$PIC && gsettings set org.gnome.desktop.background picture-options "zoom";;
	"cinnamon") feh --bg-fill $PIC;;
   	*) exit 1;;
      esac
      echo 'message:wallpa --> '$(basename $PIC) | zenity --notification --listen
      PIC_COUNTER=`expr $PIC_COUNTER + 1`
      break
    fi
    done
   #start transition
   if [[ $PIC_COUNTER -eq 0 ]]; then
    zenity --warning --title="Walpa" --text="No suitable pics found...Exit!"
    exit 1
   fi
   sleep $TRANSITION_INTERVAL
  done
fi
