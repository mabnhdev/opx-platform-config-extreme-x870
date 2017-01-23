#!/bin/bash

# Copyright (c) 2015 Dell Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED ON AN  *AS IS* BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT
# LIMITATION ANY IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS
# FOR A PARTICULAR PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT.
#
# See the Apache Version 2.0 License for specific language governing
# permissions and limitations under the License.
#


# platform specific script file which could be
# triggered from systemd service file
export PYTHONPATH=/usr/lib:/usr/lib/python

# /usr/bin/bcm_mod_init.sh

modprobe i2c_dev

modprobe -v i2c-mux-pca954x
if [ ! -e /sys/bus/i2c/devices/i2c-2 ] ; then
    echo "pca9548 0x70" >> /sys/bus/i2c/devices/i2c-0/new_device
fi
if [ ! -e /sys/bus/i2c/devices/i2c-10 ] ; then
    echo "pca9545 0x71" >> /sys/bus/i2c/devices/i2c-6/new_device
fi
if [ ! -e /sys/bus/i2c/devices/i2c-14 ] ; then
    echo "pca9548 0x72" >> /sys/bus/i2c/devices/i2c-8/new_device
fi
if [ ! -e /sys/bus/i2c/devices/i2c-22 ] ; then
    echo "pca9548 0x73" >> /sys/bus/i2c/devices/i2c-21/new_device
fi
modprobe -v lm75
if [  ! -e /sys/bus/i2c/devices/0-004f ] ; then
    echo "g751 0x4f" >> /sys/bus/i2c/devices/i2c-0/new_device
fi
if [  ! -e /sys/bus/i2c/devices/5-004c ] ; then
    echo "lm75 0x4c" >> /sys/bus/i2c/devices/i2c-5/new_device
fi
if [  ! -e /sys/bus/i2c/devices/4-004d ] ; then
    echo "lm75 0x4d" >> /sys/bus/i2c/devices/i2c-4/new_device
fi


# Now create a file to hold the firmware versions.
FIRMWARE_VERSION_FILE=/var/log/firmware_versions
rm -rf ${FIRMWARE_VERSION_FILE}
echo "BIOS: `dmidecode -s bios-vendor ` `dmidecode -s bios-version `" > $FIRMWARE_VERSION_FILE
echo "System CPLD: $((`i2cget -y 9 0x5f 0` & 0xf))" >> $FIRMWARE_VERSION_FILE
echo "Power CPLD: $((`i2cget -y 0 0x5e 0` & 0xf)) $((`i2cget -y 0 0x5e 1`))" >> $FIRMWARE_VERSION_FILE
echo "Port CPLD0: $((`i2cget -y 14 0x5f 0` & 0xf))" >> $FIRMWARE_VERSION_FILE
echo "Port CPLD1: $((`i2cget -y 15 0x5f 0` & 0xf))" >> $FIRMWARE_VERSION_FILE
echo "Port CPLD2: $((`i2cget -y 16 0x5f 0` & 0xf))" >> $FIRMWARE_VERSION_FILE
echo "Port CPLD3: $((`i2cget -y 17 0x5f 0` & 0xf))" >> $FIRMWARE_VERSION_FILE
