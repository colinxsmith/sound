#!/bin/bash
raspivid -vf -hf -t 0 -w 1280 -h 720 -o - | netcat 192.168.0.21 5000
