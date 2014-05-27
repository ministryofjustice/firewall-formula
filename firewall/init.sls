
iptables:
  pkg.installed

{% from "firewall/map.jinja" import firewall with context %}

{%- if firewall.enabled %}

/etc/iptables-rules:
  file.managed:
    - source: salt://firewall/templates/iptables-rules
    - template: jinja
    - user: root
    - group: root


firewall-apply:
  cmd.run:
    - name: 'cat /etc/iptables-rules | /sbin/iptables-restore'
    - unless: diff -u -B <( iptables-save | sed -r 's/\[[0-9]+\:[0-9]+\]/[0:0]/' | grep -v '^#') <( cat /etc/iptables-rules )

{%- endif %}

{% from 'firewall/lib.sls' import firewall_enable with context %}
{{ firewall_enable('ssh', 22 , 'tcp') }}
