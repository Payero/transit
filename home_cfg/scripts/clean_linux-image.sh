#!/bin/bash

echo ""
echo "First We need to find out which linux image we are running by executing:"
echo "uname -r"
echo ""
uname -r 
echo ""
echo ""

echo ""
echo "Now, we find out how many we have by running:"
echo "dpkg --list | grep linux-image"
echo ""
dpkg --list | grep linux-image
echo ""
echo ""

echo ""
echo "\hen we need to remove all of the images lower than the current one using:"
echo "sudo apt-get purge linux-image-x.x.x.x-generic"
echo ""

echo ""
echo "\nFinally, we upgrade grub2:"
echo "sudo update-grub2"

