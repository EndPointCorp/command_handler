cmake_minimum_required(VERSION 2.8.3)
project(command_handler)

find_package(catkin REQUIRED COMPONENTS
  rospy
  message_generation
)


catkin_python_setup()

## Generate messages in the 'msg' folder
add_message_files(
  FILES
  Command.msg
)

generate_messages()

## Generate services in the 'srv' folder
# add_service_files(
#   FILES
#   Service1.srv
#   Service2.srv
# )

## Generate actions in the 'action' folder
# add_action_files(
#   FILES
#   Action1.action
#   Action2.action
# )

## Generate added messages and services with any dependencies listed here
# generate_messages(
#   DEPENDENCIES
#   std_msgs  # Or other packages containing msgs
# )

catkin_package(
  CATKIN_DEPENDS rospy message_runtime
)

include_directories(
  ${catkin_INCLUDE_DIRS}
)

catkin_install_python(PROGRAMS
  scripts/launcher.py
  scripts/launcher
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)
