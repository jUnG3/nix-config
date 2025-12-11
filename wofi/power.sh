#!/usr/bin/env bash
choice=$(printf "Shutdown\nReboot\nLock\nLogout\nSuspend\nHibernate\n" | wofi --dmenu --prompt "Power")

case "$choice" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Lock) hyprlock ;;
    Logout) hyprctl dispatch exit ;;
    Suspend) systemctl suspend ;;
    Hibernate) systemctl hibernate ;;
esac

