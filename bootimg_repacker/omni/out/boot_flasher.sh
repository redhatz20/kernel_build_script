#!/bin/bash

fastboot flash boot boot.img
wait
fastboot erase cache
wait
fastboot reboot
wait
exit
