#!/bin/bash
## FILE: Walpa
##
## DESCRIPTION: Walpa -- Change Desktop Wallpaper for gnome3,unity,mate
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

DIR=`zenity --file-selection --text="Select Image Folder" --directory --title "Walpa"`
dir_choosen_ret=$?

if [ "$dir_choosen_ret" -ne 0 ]; then
  zenity --warning --title="Walpa" --text="No Folder choosen...Exit!"
  exit 1
else
  SLEEP_INTERVAL=$(zenity --scale --title "Walpa" --min-value=5 --max-value=1800 --value=5 --step 1 --text="Enter an interval for changing the wallpaper.\n\n Values are in seconds.")
  if [ -n "$SLEEP_INTERVAL" ]
   then
    echo ""
  else
   echo ""
   exit 1
  fi
  while true;do
   PIC=$(ls $DIR/*.jpg | shuf -n1)
   case $DESKTOP_SESSION in "mate") gsettings set org.mate.background picture-filename $PIC;;
   "gnome-classic") gconftool-2 --type string --set /desktop/gnome/background/picture_filename $PIC;;
   "gnome") gsettings set org.gnome.desktop.background picture-uri $PIC;;
   "gnome-shell") gsettings set org.gnome.desktop.background picture-uri $PIC;;
   "ubuntu") gsettings set org.gnome.desktop.background picture-uri $PIC;;
   *) exit 1;;
   esac
   sleep $SLEEP_INTERVAL
  done
fi
