#!/usr/bin/bash
timedatectl set-timezone $(timedatectl list-timezones|grep London)
