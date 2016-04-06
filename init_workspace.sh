#!/usr/bin/env bash
if [ ! -e catkin/src ]; then
  mkdir -p catkin/src
fi
if [ ! -e catkin/src/command_handler ]; then
  ln -s ~+/ catkin/src/command_handler
fi
