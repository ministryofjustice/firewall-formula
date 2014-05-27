# Open ports using iptables.ACCEPT
#
# service:     A name for the rule.
# port:        The port to open. If end_port is specified then 'port' is the
#              first port of a range.
# proto:       The protocol to open, defaults to 'tcp'. 'udp' may be used if
#              end_port is not.
# end_port:    The end_port of a port range to open.
#
# Limitations: UDP range will opnly open the first port; port-range is a
#              tcp-match option of iptables and a different approach would make
#              for a messy sls. Consider switching to something like
#              lokkit -p 22:tcp -p 4505:tcp -p 4506:tcp

{% from "firewall/map.jinja" import firewall with context %}

{% macro firewall_enable(service, port, proto='tcp', end_port=none, source_addr='0.0.0.0/0') -%}

{%- if firewall.enabled %}
# Set the iptables options based on port range or not.
# ufw allow from 192.168.0.4 to any port 22 proto tcp
{% if proto=="tcp" and end_port %}
  {% set dport = port ~ ":" ~ end_port %}
{% else %}
  {% set dport = port %}
{% endif %}

firewall-file-{{service}}-{{proto}}-{{port}}:
  file.accumulated:
    - name: iptables-rules
    - filename: /etc/iptables-rules
{% if source_addr=="0.0.0.0/0" %}
    - text: "-A INPUT -p {{proto}} -m {{proto}} --dport {{dport}} -m comment --comment {{service}}-{{proto}}-{{port}} -j ACCEPT\n"
{% else %}
    - text: "-A INPUT --source {{source_addr}} --p {{proto}} -m {{proto}} --dport {{dport}} -m comment --comment {{service}}-{{proto}}-{{port}} -j ACCEPT\n"
{% endif %}
    - require_in:
      - cmd: firewall-apply
      - file: /etc/iptables-rules

{%- endif %}
{%- endmacro %}

