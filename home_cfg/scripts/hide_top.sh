#!/bin/sh

gnome-terminal -e "/usr/bin/gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'box=Main.panel.actor.get_parent();'"
sleep 3
gnome-terminal -e "/usr/bin/gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'box.visible=true;'"


