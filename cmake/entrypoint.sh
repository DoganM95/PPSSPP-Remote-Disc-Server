#!/bin/bash

# Vars
run_log="/root/.config/ppsspp/run_log.txt"
ppsspp_ini_file="/root/.config/ppsspp/PSP/SYSTEM/ppsspp.ini"
volume_file_list="/root/.config/ppsspp/PSP/SYSTEM/volume_file_list.txt"
volume_game_list="/root/.config/ppsspp/PSP/SYSTEM/volume_game_list.txt"
recents_game_list="/root/.config/ppsspp/PSP/SYSTEM/recents_game_list.txt"
game_matching_regex=".*\.(chd|CHD|cso|CSO|dax|DAX|iso|ISO)"

success_output_1_identifier="loading control pad mappings from gamecontrollerdb.txt"
success_output_2_identifier="ALSA: Couldn't open audio device"
failure_output_1_identifier="Unable to initialize SDL"

update_interval=10 # The higher the interval, the faster it updates the lib on change, but also increases cpu usage

function main() {
    # Start PPSSPP app initially to initialize a default ppsspp.ini file
    restart_ppsspp_successfully

    # Main loop
    while true; do
        file_counter=0

        sed -Ei "s|(MaxRecent =) (.*)|\1 10000000|" $ppsspp_ini_file         # MaxRecent
        sed -Ei "s|(RemoteISOManualConfig =) (.*)|\1 True|" $ppsspp_ini_file # RemoteISOManualConfig
        sed -Ei "s|(RemoteISOPort =) (.*)|\1 8300|" $ppsspp_ini_file         # RemoteISOPort
        sed -Ei "s|(RemoteShareOnStartup =) (.*)|\1 True|" $ppsspp_ini_file  # RemoteShareOnStartup
        sed -Ei "s|(RunCount =) (.*)|\1 1337|" $ppsspp_ini_file              # RunCount

        sed -ir '/^\s*$/d' $ppsspp_ini_file # Remove all empty lines

        # Preperations for library updates
        grep -E "^FileName.*" $ppsspp_ini_file >$recents_game_list                  # Copy recent games from ppsspp.ini to a new file
        sed -Ei "s|(FileName.* = )(.*)|\2|" $recents_game_list                      # Remove "FileNameX = " prefixes in said file
        find "/root/.config/ppsspp/PSP/GAME/" -maxdepth 1 -print >$volume_file_list # Create a list of files in mounted volume (game folder)
        grep -E "$game_matching_regex" "$volume_file_list" >$volume_game_list       # Copy lines matching game-names to a new file

        while read -d $'\n' recent_game; do # Iterate over games listed under [Recent] in ppsspp.ini
            # if recent games contain a file not contained in games volume, delete all recent games to trigger a recreation
            if [ $(grep -Fc "$recent_game" "$volume_game_list") -eq 0 ]; then
                echo "DETECTED DELETEDD GAME: '$recent_game'"
                settings_changed_flag=1
            fi
        done <$recents_game_list

        while read -d $'\n' file; do # Iterate over games contained in mounted volume (folder) by docker
            # Add current file to ppsspp.ini if not existing already
            if [ $(fgrep -c "$file" $ppsspp_ini_file) -eq 0 ]; then
                echo "DETECTED NEW GAME: $file"
                settings_changed_flag=1
            fi
        done <$volume_game_list

        if [[ "$settings_changed_flag" -eq 1 ]]; then # Actions on game addition/removal
            echo "Updating game library..."
            delete_gamelist
            create_gamelist "$volume_game_list"
            restart_ppsspp_successfully # Restart PPSSPP to apply game library update
            settings_changed_flag=0     # Reset flag
            echo "Done."
        fi

        if [[ $(cat $run_log | tail -n 1) == "Segmentation fault" || $(cat $run_log | tail -n 1) == "Aborted" ]]; then
            echo "Detected a 'Segmentation fault' in PPSSPP application. Restarting PPSSPP.."
            restart_ppsspp_successfully
        fi

        sleep $update_interval
    done
}

function create_gamelist() {
    while read -d $'\n' file; do
        escaped_filename=$(echo "$file" | awk '{ sub("&", "\\\&"); print }')                      # Escape "&" (Ampersand) in game names
        sed -i "s|MaxRecent = .*|&\nFileName$file_counter = $escaped_filename|g" $ppsspp_ini_file # Add game to ppsspp-ini recents
        file_counter=$((file_counter + 1))                                                        # counter++ for next game to be added
    done <$1
}

function delete_gamelist() {
    sed -iq "s|FileName.*||g" $ppsspp_ini_file # Removing any existing recent games (FileNameX) from ppsspp.ini
    sed -ir '/^\s*$/d' $ppsspp_ini_file        # Remove all empty lines
}

function kill_ppsspp() {
    # echo "Killing PPSSPP (xvfb & PPSSPPSDL)"
    pkill Xvfb
    pkill PPSSPPSDL
    while [[ $(pgrep -fi "xvfb") || $(pgrep -fi "PPSSPPSDL") ]]; do # Wait for PPSSPP process to terminate
        # echo "Waiting for PPSSPPSDL and xvfb to terminate.."
        sleep 1
    done
    rm -f /tmp/.X99-lockS # Remove any file-locks of Xvfb
}

function restart_ppsspp() {
    # Kill PPSSPP process
    kill_ppsspp

    # Restart PPSSPP
    # echo "Restarting PPSSPP (xvfb & PPSSPPSDL)"
    echo "" >$run_log # Clear log of previous run results
    nohup xvfb-run --server-args="-screen 0, 1024x680x24" "/usr/src/app/build/PPSSPPSDL" >$run_log &# Start PPSSPP asynchronously

    # Wait until PPSSPP startup finishes (by waiting for log to contain an identifier)
    # echo "Waiting for log to contain an identifier.."
    while [[ ! $(grep -F "$success_output_1_identifier" $run_log) && ! $(grep -F "$success_output_2_identifier" $run_log) && ! $(grep -F "$failure_output_1_identifier" $run_log) ]]; do
        sleep 1
    done

    # echo "Log contains an identifier: $(cat $run_log | tail -n 1)"

    if [[ $(grep -F "$success_output_1_identifier" $run_log) || $(grep -F "$success_output_2_identifier" $run_log) ]]; then
        echo "Successfully (re)started ppsspp."
        ppsspp_start_result=1
    fi
    if [[ $(grep -F "$failure_output_1_identifier" $run_log) ]]; then
        # echo "Failed to start ppsspp, restarting..."
        ppsspp_start_result=0
    fi
}

# Starting PPSSPP gives 3 possible outputs, 2 indicate a successful start, 1 does not.
# Wether the app starts successfully or not seems random, so it may take a couple restarts to startup successfully
function restart_ppsspp_successfully() {
    restart_ppsspp
    while [[ $ppsspp_start_result != 1 ]]; do
        restart_ppsspp
        sleep 1
    done
}

main "$@" # Run main process (enables putting functions at the bottom of this file)
