Walpa -- A simple bash script to change Desktop Wallpaper for gnome3,unity,mate,cinnamon --

usage: 

##run interactive mode
./walpa

##run as daemon
./walpa -d

##stop
./walpa -q

requires: zenity (for GUI) - imageMagick (identify command tool) - feh (for cinnamon window manager)

-- CHANGE LOG --

0.3.1 - 10/05/2013
 - Added options to script (-d -q)

0.3 - 10/04/2013
 - Added support for cinnamon

0.2 - 10/04/2013
 - Added integration with identify to select the image based on the actual screen resolution
 - Notification via zenity on the system tray

0.1 - 09/25/2013
 - Basic functions
