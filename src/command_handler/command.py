#!/usr/bin/env python

import rospy
from command_handler.msg import Command
from subprocess import Popen

class CommandHandler:
    """
    Listen for commands from /command_handler TOPIC
    and run commands from config/*.rules
    """

    def __init__(self, config):
        self.commands = self.get_commands(config)

    def get_commands(self, config):
        """
        Grabs all command out of the config supplied
        """
        commands = {}
        for section in config.sections():
            # ignore general section
            print 'looking at section %s' % section
            if section == 'general':
                continue

            try:
                command = config.get(section, 'command')
                code = config.get(section, 'code')
                try:
                    run_dir = config.get(section, 'run_dir')
                except Exception:
                    run_dir = None
                try:
                    env = config.get(section, 'env', None)
                except Exception:
                    env = None

                env_args = {}
                if env:
                    for pair in env.split(':'):
                        kv = pair.split('=')
                        env_args[kv[0]] = kv[1]

                commands[code] = {
                    'execute': command,
                    'run_dir': run_dir,
                    'env'    : env_args
                }

            except Exception, e:
                print "Problem parsing the code or command, continuing"
                print "Current commands are: %s" % commands
                print e
                continue

        return commands


    def command_msg(self, msg):
        """
        Find command by msg and run
        """
        key = msg.command
        command = self.commands.get(key, None)
        if not command:
            rospy.loginfo('Command not found for key: (%s)' % key)
            return

        kwargs = {}
        if command.get('run_dir'):
            kwargs['cwd'] = command.get('run_dir')
        if command.get('env') and len(command.get('env')):
            kwargs['env'] = command.get('env')

        rospy.loginfo('Run: ' + key)
        rospy.loginfo('Command: %s' % command)

        p = Popen(command['execute'].split(), **kwargs)
        p.wait()

        rospy.loginfo('Done: ' + key)
