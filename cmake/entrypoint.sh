#!/bin/bash

# Start PPSSPP app initially to initialize a a default ppsspp.ini
nohup xvfb-run --server-args="-screen 0, 1024x680x24" "/usr/src/app/build/PPSSPPSDL" >/root/.config/ppsspp/run_log.txt &

# Create a fresh ppsspp.ini with necessery settings
touch "/root/.config/ppsspp/PSP/SYSTEM/ppsspp.ini"
echo "[General]
FirstRun = False
RunCount = 1
Enable Logging = True
AutoRun = True
IgnoreBadMemAccess = True
CacheFullIsoInRam = False
RemoteISOPort = 8300
LastRemoteISOServer = localhost
LastRemoteISOPort = 8300
RemoteISOManualConfig = True
RemoteShareOnStartup = True
RemoteISOSubdir = /
RemoteDebuggerOnStartup = False
PauseOnLostFocus = False
PauseWhenMinimized = False
[SystemParam]
PSPModel = 1
PSPFirmwareVersion = 660
NickName = PPSSPP - Docker Server
WlanPowerSave = False
[Recent]
MaxRecent = 1000
" >"/root/.config/ppsspp/PSP/SYSTEM/ppsspp.ini"

cd "/root/.config/ppsspp/PSP/"

# Preperations
ppsspp_ini_file="/root/.config/ppsspp/PSP/SYSTEM/ppsspp.ini" # TODO: use

# touch "/root/.config/ppsspp/PSP/GAME/gameList.txt"
regex=".*\.(iso|ISO|cso|CSO|dax|DAX)"

# Create filenames for iso's found in docker-bound volume

while true; do
    settings_changed_flag=0
    file_counter=0

    echo "looping"
    sleep 2s

    # RemoteIsoPort [General]
    sed -i "s/RemoteISOPort.*/RemoteISOPort = 8300/" ./SYSTEM/ppsspp.ini
    # RemoteShareOnStartup [General]
    sed -i "s/RemoteShareOnStartup.*/RemoteShareOnStartup = True/" ./SYSTEM/ppsspp.ini
    # MaxRecents [Recent]
    sed -i "s/MaxRecent = .*/MaxRecent = 1000/" ./SYSTEM/ppsspp.ini

    # Remove any existing FileNames
    sed -i "s/FileName.*//g" ./SYSTEM/ppsspp.ini

    # Remove all empty lines
    sed -ir '/^\s*$/d' ./SYSTEM/ppsspp.ini

    find "/root/.config/ppsspp/PSP/GAME/" -print0 -maxdepth 1 | while read -d $'\0' file; do

        # # Update game inventory
        if [[ $file =~ $regex ]]; then

            # add current file to ppsspp.ini if not existing
            if [ $(fgrep -c "FileName\d* = $file" "/root/.config/ppsspp/PSP/SYSTEM/ppsspp.ini") -eq 0 ]; then
                fgrep -c "$file" "/root/.config/ppsspp/PSP/SYSTEM/ppsspp.ini"
                grep -P -- "FileName\d+ = $file" "/root/.config/ppsspp/PSP/SYSTEM/ppsspp.ini"

                echo "adding: $file"
                sed -i "s|MaxRecent = .*|&\nFileName$file_counter = $file|g" $ppsspp_ini_file

                file_counter=$((file_counter + 1))
                settings_changed_flag=1
            fi

        fi

    done

    # if [ $settings_changed_flag -eq 1 ]; then
    sleep 30
    echo "Restarting PPSSPP.."

    # Kill PPSSPP process
    pkill Xvfb
    pkill PPSSPPSDL
    rm /tmp/.X99-lock
    sleep 30

    # Restart PPSSPP
    xvfb-run --server-args="-screen 0, 1024x680x24" "/usr/src/app/build/PPSSPPSDL" &
    # fi

done

# sed -i "s#;lastFileName#FileName$file_counter/ = $pwd./GAME/$file\n;lastFileName#" "/root/.config/ppsspp/PSP/SYSTEM/ppsspp.ini"
# sed -i 's/\[Recent\](.*|\r|\n)([^\[])*/\[Recent\]\nMaxRecent = 1000000\n; End of recents/g' ./SYSTEM/ppsspp.ini
# sed -i ':begin;$!N;s/\[Recent\]/\[Recent\]\n/;tbegin;P;D' ./SYSTEM/ppsspp.ini
# sed -i 's/\[Recent\]/\[Recent\]\n/g' ./SYSTEM/ppsspp.ini
# sed -i ':begin;$!N;s/\[Recent\](.*|\r|\n)([^\[])*/\[Recent\]\n/;tbegin;P;D' ./SYSTEM/ppsspp.ini

# cat "/root/.config/ppsspp/PSP/SYSTEM/ppsspp.ini"
