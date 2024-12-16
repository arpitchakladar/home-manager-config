#!/bin/sh
sudo ip link set $1 down
sudo ip link set $1 up
