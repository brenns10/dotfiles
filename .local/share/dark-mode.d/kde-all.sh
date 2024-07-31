#!/usr/bin/env bash
# See the examples from darkman source repository.

## KDE Global Theme
lookandfeeltool -platform offscreen --apply "org.kde.breezedark.desktop"

## KDE GTK Theme
dbus-send --session --dest=org.kde.GtkConfig --type=method_call /GtkConfig org.kde.GtkConfig.setGtkTheme "string:Breeze-dark-gtk"

## Konsole

# KDE's default terminal emulator supports profiles, you can create one in
# Settings > Manage Profiles. You can select a dark or light theme in
# Appearance > Color scheme and font. The following script iterates over all
# instances of Konsole und changes the profile of all sessions. This is necessary,
# if there are multiple tabs in one of the Konsole instances.
# Reference: https://docs.kde.org/stable5/en/konsole/konsole/konsole.pdf

PROFILE='Dark'

# loop over all running konsole instances
for pid in $(pidof konsole); do
    # TODO: loop over all windows of the instance, instead of only the first
    qdbus "org.kde.konsole-$pid" "/Windows/1" setDefaultProfile "$PROFILE"
    # loop over all sessions in the current window
    for session in $(qdbus "org.kde.konsole-$pid" /Windows/1 sessionList); do
        # change profile through dbus message
        qdbus "org.kde.konsole-$pid" "/Sessions/$session" setProfile "$PROFILE"
    done
done

## Yakuake

# get number of sessions running within Yakuake
SESSIONIDS=$(qdbus org.kde.yakuake /Sessions org.freedesktop.DBus.Introspectable.Introspect | grep -o '<node name="[0-9]\+"/>' | grep -o '[0-9]\+')
for ID in $SESSIONIDS; do
	# change profile through dbus message
    qdbus org.kde.yakuake /Sessions/$ID setProfile "$PROFILE"
    qdbus org.kde.yakuake /Windows/$ID setDefaultProfile "$PROFILE"
done
