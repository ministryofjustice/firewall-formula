
iptables:
  pkg.installed

{% from "firewall/map.jinja" import firewall with context %}

{%- if firewall.enabled %}

firewall-save:
  cmd.run:
    - name: iptables-save |sed -r 's/\[[0-9]+\:[0-9]+\]/[0:0]/' | grep -v '^#' > /etc/iptables.rules
    - unless: diff -u -B <( iptables-save | sed -r 's/\[[0-9]+\:[0-9]+\]/[0:0]/' | grep -v '^#') <( cat /etc/iptables.rules )
{%- endif %}

{% from 'firewall/lib.sls' import firewall_enable with context %}
{{ firewall_enable('ssh', 22 , 'tcp') }}
