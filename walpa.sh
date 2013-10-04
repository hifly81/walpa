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

#get screen resolution
Xaxis=$(xrandr --current | grep '*' | uniq | awk '{print $1}' |  cut -d 'x' -f1)
Yaxis=$(xrandr --current | grep '*' | uniq | awk '{print $1}' |  cut -d 'x' -f2)
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
   PICS=$(ls $DIR/{*.jpg,*.jpeg,*.png,*.bmp,*.tif} 2>/dev/null| sort -R)
   for PIC in $PICS
    do
     #get pic dimensions
     Xpic=$(identify $PIC | awk '{print $3}' | tr "x" " " | awk '{print $1}')
     Ypic=$(identify $PIC | awk '{print $3}' | tr "x" " " | awk '{print $1}')
     if (( $Xpic > $Xaxis )) && (( $Ypic > $Yaxis )); then
      case $DESKTOP_SESSION in "mate") gsettings set org.mate.background picture-filename $PIC;;
   	"gnome-classic") gconftool-2 --type string --set /desktop/gnome/background/picture_filename $PIC;;
   	"gnome") gsettings set org.gnome.desktop.background picture-uri $PIC;;
   	"gnome-shell") gsettings set org.gnome.desktop.background picture-uri $PIC;;
   	"ubuntu") gsettings set org.gnome.desktop.background picture-uri $PIC;;
	"cinnamon") feh --bg-fill $PIC;;
   	*) exit 1;;
      esac
      echo 'message:wallpa --> '$(basename $PIC) | zenity --notification --listen
      break
     fi
    done
   #start transition
   sleep $TRANSITION_INTERVAL
  done
fi
