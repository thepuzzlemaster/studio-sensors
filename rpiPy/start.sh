#!/bin/bash

sudo modprobe spi_bcm2708
sudo pigpiod
python studio_sensors.py > studio_sensors_log&
