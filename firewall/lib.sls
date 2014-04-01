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

{% macro firewall_enable(service, port, proto='tcp', end_port=none, source_addr='any') -%}

# Set the iptables options based on port range or not.
# ufw allow from 192.168.0.4 to any port 22 proto tcp
{% if proto=="tcp" and end_port %}
  {% set grep_pattern = "dpts:" ~ port ~ ":" ~ end_port %}
  {% set dport = port ~ ":" ~ end_port %}
{% else %}
  {% set grep_pattern = "dpt:" ~ port %}
  {% set dport = port %}
{% endif %}

{% if grains['os'] == 'Ubuntu' %}

firewall-enable-{{service}}-{{proto}}-{{port}}:
  cmd:
    - run
    - name: 'ufw allow from {{source_addr}} to any port {{port}} proto {{proto}}'

{% elif grains['os'] == 'CentOS' %}
#TODO: change policy on ubuntu to be more secured as this is a hack

# Open the specified ports
firewall-enable-{{service}}-{{proto}}-{{port}}:
  cmd:
    - run
    - unless: 'iptables -L INPUT -n | grep {{grep_pattern}}'
{% if proto == 'udp' %}
    - name: 'iptables -I INPUT -p {{proto}} --dport {{dport}} -j ACCEPT && service iptables save'
{% elif proto == 'tcp' %}
    - name: 'iptables -I INPUT -m state --state NEW -p {{proto}} --dport {{dport}} -j ACCEPT && service iptables save'
{% endif %}

{% endif %}

{%- endmacro %}
