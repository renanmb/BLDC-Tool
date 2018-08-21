#!/bin/bash
# Build the Qt gui control for the custom VESC BLDC controller
# Note that this is different from the actual VESC firmware itself, though
# compiled versions of the firmware are contained within the bldc-tool source tree
# Also grabs the VESC configuration files from the mit-racecar hardware repository
# This is for Jetson L4T 28.1

echo "Installing BLDC Tool prerequisites"
# sudo apt-get install qtcreator qt-sdk libudev-dev libqt5serialport5-dev -y
# Do we need qtcreator?
sudo apt-get install qt5-default libudev-dev libqt5serialport5-dev -y
# Build version 5.6 of qtserialport as workaround to segmentation fault on VESC reboot
echo "Building version 5.6 of qtserial port"
git clone https://github.com/qt/qtserialport.git
cd qtserialport
sudo apt-get install qtbase5-private-dev -y
git checkout 5.6
mkdir qtserialport-build
cd qtserialport-build
qmake -qt=qt5 ../qtserialport.pro
make
sudo make install

# Fix up libGL
cd /usr/lib/aarch64-linux-gnu/
sudo ln -sf tegra/libGL.so libGL.so
cd $ROOT
echo "Fetching bldc-tool source code"
git clone https://github.com/racecarj/bldc-tool
cd bldc-tool
echo "Building bldc-tool from source"
qmake -qt=qt5
make clean && make
cd $ROOT
git clone https://github.com/racecarj/vesc-firmware
echo "You should now be able to run BLDC_Tool from the ~/bldc-tool directory"
echo "The VESC firmware is in ~/vesc-firmware/firmware"
echo "The RACECAR VESC configuration files are in ~/vesc-firmware/VESC-Configuration"


