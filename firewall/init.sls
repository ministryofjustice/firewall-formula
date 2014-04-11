
/etc/iptables.d:
  file.directory:
    - clean: True
    - user: root
    - group: root
    - dir_mode: 700
    - file_mode: 600

firewall-preamble:
  file.managed:
    - name: /etc/iptables.d/01-preamble
    - contents: |
        *filter
        :INPUT ACCEPT [0:0]
        :FORWARD ACCEPT [0:0]
        :OUTPUT ACCEPT [0:0]
        :logging - [0:0]
        -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    - user: root
    - group: root
    - require:
      - file: /etc/iptables.d


firewall-logging-create:
  file.managed:
    - name: /etc/iptables.d/98-logging
    - contents: |
        -A INPUT -j logging
        -A logging -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: "
        -A logging -j ACCEPT
        COMMIT
    - user: root
    - group: root
    - require:
      - file: /etc/iptables.d



firewall-apply:
  cmd.run:
    - name: 'cat /etc/iptables.d/* | /sbin/iptables-restore'
    - unless: diff -u -B <( iptables-save | sed -r 's/\[[0-9]+\:[0-9]+\]/[0:0]/' | grep -v '^#') <( cat /etc/iptables.d/* )

{% from 'firewall/lib.sls' import firewall_enable with context %}
{{ firewall_enable('ssh', 22 , 'tcp') }}

