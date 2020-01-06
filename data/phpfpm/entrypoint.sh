#!/bin/sh
service blackfire-agent start
/usr/bin/supervisord
tail -f /dev/null
