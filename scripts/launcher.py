#!/usr/bin/env python

import rospy, ConfigParser

from command_handler.msg import Command
from std_msgs.msg import String
from command_handler import CommandHandler

def main():
    rospy.init_node('command_handler')

    def get_config(config_location):
        config = ConfigParser.RawConfigParser()
        config.read(config_location)
        return config
    config = get_config(rospy.get_param('~config_file', '/home/galadmin/etc/keywatch.conf'))

    handler = CommandHandler(config)
    rospy.Subscriber('/command', Command, handler.command_msg)
    rospy.Subscriber('/command_string', String, handler.command_string_msg)
    rospy.spin()

if __name__ == '__main__':
    main()
