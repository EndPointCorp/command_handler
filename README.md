command\_handler
----------------

## Nodes

### launcher

This node launches the command handler. It listens in on the topic `/command`
and then searches for that command in a configuration file and Popens the
command if it is found.

#### Parameters

* `~config_file`: Path to the config file. Default:
  `/home/galadmin/etc/keywatch.conf`


#### Config file
```
# the confi file is set up as follows

[name of section]
code = 12345
command = touch /foobar

[name of another section]
code = weather
command = curl http://wttr.in/

# and so on
```
