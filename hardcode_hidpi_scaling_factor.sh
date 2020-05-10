#!/bin/bash

echo
echo "Steps are as following"

echo "1. Open the file /usr/share/glib-2.0/schemas/org.gnome.desktop.interface.gschema.xml"

echo "2. Set the key name 'scaling-factor' to 2 (probably it's 0)."

echo "3. Run sudo glib-compile-schemas /usr/share/glib-2.0/schemas"

echo
echo "Should work with next reboot now!"

# EOF
