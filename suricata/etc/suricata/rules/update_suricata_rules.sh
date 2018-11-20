#!/bin/bash
#auto update rules from mhn
mkdir -p /opt/mhn/rules
rm -f /opt/mhn/rules/mhn.rules.tmp

echo "[`date`] Updating suricata signatures ..."
wget  http://106.75.178.69/static/mhn.rules -O /opt/mhn/rules/mhn-suricata.rules.tmp && \
	mv /opt/mhn/rules/mhn-suricata.rules.tmp /opt/suricata/etc/suricata/rules/local.rules && \
	(supervisorctl update ; supervisorctl restart suricata ) && \
	echo "[`date`] Successfully updated suricata signatures" && \
	exit 0

echo "[`date`] Failed to update suricata signatures"
exit 1
