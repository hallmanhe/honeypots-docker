#!/bin/bash
#
#COMMAND="s#magic-file: /usr/share/file/misc/magic#magic-file: /usr/share/file/magic#;"

# disable all the rules then enable just the local.rules
COMMAND+="s/^( - .*\.rules)/#\1/;  s/rule-files:/rule-files:\n - local.rules/"

sed -i -r "$COMMAND" suricata.yaml
