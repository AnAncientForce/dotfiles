#!/bin/bash
# Github > @AnAncientForce

Color_Off='\033[0m'
BBlack='\033[1;30m' BRed='\033[1;31m' BGreen='\033[1;32m' BYellow='\033[1;33m'
BBlue='\033[1;34m' BPurple='\033[1;35m' BCyan='\033[1;36m' BWhite='\033[1;37m'

# vars
user_home=""
restore_pth=""
gap="   "
valid_flag=false

if [ "$EUID" -eq 0 ]; then
    user_home="/home/$SUDO_USER"
else
    user_home="/home/$(whoami)"
fi
restore_pth="$user_home/.restore"

function trap_ctrlc() {
    echo -e ${BRed}"\n[!] The current operation has been stopped.\n" ${Color_Off}
    exit 2
}
trap "trap_ctrlc" 2

# echo -e ${BBlue}"\n[*] A" ${Color_Off}
# echo -e ${BYellow}"[*] B\n" ${Color_Off}
# echo -e ${BPurple}"[*] C" ${Color_Off}
# echo -e ${BBlue}"[*] D" ${Color_Off}
# echo -e ${BGreen}"[*] E\n" ${Color_Off}
# echo -e ${BRed}"[!] F\n" ${Color_Off}

# ----------------------------- Flag Logic
help() {
    echo -e ${BPurple}"Available flags\n" ${Color_Off}
    echo -e ${BGreen}"[*] yt [URL]       : Downloads a youtube video" ${Color_Off}
    echo -e ${BGreen}"[*] bt-c           : Connects all bluetooth devices" ${Color_Off}
    echo -e ${BGreen}"[*] bt-d           : Disconnects all bluetooth devices" ${Color_Off}
    echo -e ${BGreen}"[*] autostart      : Launches autostart.sh file" ${Color_Off}
    exit 0
}
if [ "$1" = "h" ]; then
    help
fi
for arg in "$@"; do
    case "$arg" in
    yt)
        VIDEO_URL="$1"
        echo -e "${BBlue}yt-dlp\n${Color_Off}"
        if [[ -n "$VIDEO_URL" && "$VIDEO_URL" == https://* ]]; then
            echo -e "${BBlue}yt-dlp\n${Color_Off}"
            yt-dlp -f mp4 -o "~/Downloads/%(title)s.%(ext)s" "$VIDEO_URL"
            VIDEO_FILENAME=$(yt-dlp -e -o "~/Downloads/%(title)s.%(ext)s" "$VIDEO_URL")
            wl-copy <"$HOME/Downloads/$VIDEO_FILENAME.mp4"
            echo "$HOME/Downloads/$VIDEO_FILENAME.mp4"
            valid_flag=true
        else
            echo -e "${BRed}[!] No video linked.\n${Color_Off}"
            exit 1
        fi
        ;;
    autostart)
        echo -e "${BBlue}Autostart file loaded\n${Color_Off}"
        sh $user_home/main/autostart.sh &
        valid_flag=true
        ;;
    bt-d)
        bluetoothctl disconnect AC:BF:71:91:31:D5
        bluetoothctl disconnect DC:F4:CA:CB:93:A1
        valid_flag=true
        ;;
    bt-c)
        bluetoothctl connect AC:BF:71:91:31:D5
        bluetoothctl connect DC:F4:CA:CB:93:A1
        valid_flag=true
        ;;
    lock)
        playerctl pause
        playerctl -p spotify pause
        pactl set-sink-mute @DEFAULT_SINK@ 1
        swaylock -c 000000FF
        valid_flag=true
        ;;
    unlock)
        playerctl play
        playerctl -p spotify play
        pactl set-sink-mute @DEFAULT_SINK@ 0
        valid_flag=true
        ;;
    vm)
        # sudo virsh list --all
        # virsh start win10
        # virsh net-start default
        # sudo virsh net-start default
        # https://serverfault.com/questions/803283/how-do-i-list-virsh-networks-without-sudo
        alacritty -e virsh --connect qemu:///system start win10
        looking-glass-client &
        valid_flag=true
        ;;
    waydroid)
        waydroid prop set persist.waydroid.width ""
        waydroid prop set persist.waydroid.height ""
        waydroid session stop
        echo "About to launch full ui... (3 secs waiting)"
        sleep 3
        waydroid show-full-ui &
        valid_flag=true
        ;;
    vpn-c)
        # protonvpn-cli ks --permanent
        # To disconnect : nmcli c show
        # To disconnect : nmcli c delete pvpn-ipv6leak-protection
        # nmcli c delete pvpn-killswitch
        # nmcli c delete pvpn-routed-killswitch
        # nmcli c delete pvpn-ipv6leak-protection
        # protonvpn-cli d
        # echo "2 secs to cancel"
        # sleep 2
        protonvpn-cli c --cc "NL"
        valid_flag=true
        ;;
    vpn-d)
        protonvpn-cli d
        nmcli c delete pvpn-killswitch
        nmcli c delete pvpn-routed-killswitch
        nmcli c delete pvpn-ipv6leak-protection
        valid_flag=true
        ;;
    mount)
        sh $user_home/main/mount.sh m
        valid_flag=true
        ;;
    dismount)
        sh $user_home/main/mount.sh d
        valid_flag=true
        ;;
    bk-pkgs)
        pacman -Qet >$restore_pth/arch-pkgs.txt
        pacman -Qqm >$restore_pth/aur-pkgs.txt
        valid_flag=true
        ;;
    reinstall)
        sudo pacman -S --needed - <$restore_pth/arch-pkgs.txt
        yay -S --needed - <$restore_pth/aur-pkgs.txt
        valid_flag=true
        ;;
    wolf)
        librewolf --profile /mnt/veracrypt1/AppData/libre-dev-profile &
        valid_flag=true
        ;;
    push)
        cp $user_home/.config/hypr/hyprland.conf $user_home/hyprZ/
        cp $user_home/cmd.sh $user_home/hyprZ/
        valid_flag=true
        ;;
    *) ;;
    esac
done
if ! $valid_flag; then
    # echo -e ${BRed}"\n[!] Incorrect or misspelled flag.\n\nProceeding with default...\n" ${Color_Off}
    if [ $# -eq 0 ]; then
        echo -e "${BRed}[!] No flags were supplied.\n${Color_Off}"
    else
        echo -e ${BRed}"[!] Incorrect or misspelled flag.\n" ${Color_Off}
    fi
    echo -e ${BBlue}"[?] Usage: cmd h" ${Color_Off}
    exit 2
fi
