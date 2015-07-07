#!/bin/bash

PORT=:1

#meant for dell screen
#vncserver :1 -name ZAL_left -geometry 1900x975

#meant for dell screen, full screen
#vncserver $PORT -name ZAL_left -geometry 1900x1080
vncserver $PORT -name HOME_left -geometry 1900x1040

echo to kill this vncserver:
echo vncserver -kill $PORT

