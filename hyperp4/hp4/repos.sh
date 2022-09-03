#!/bin/bash

wmctrl -r "Node: h2" -e 0,1434,0,-1,-1
sleep 0.5
wmctrl -r "Node: h1" -e 0,0,418,-1,-1
sleep 0.5
wmctrl -r "Node: h3" -e 0,560,418,-1,-1
sleep 0.5
wmctrl -r "Node: h5" -e 0,0,782,-1,-1
sleep 0.5
wmctrl -r "Node: h6" -e 0,560,782,-1,-1
