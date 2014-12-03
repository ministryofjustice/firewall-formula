=======
firewall
=======

This formula makes available the macros for setting up firewall rules.

TODO: Need to move from using macros to state module

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/topics/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``firewall``
----------
Example usage::

    include:
      - firewall


**Pillar variables used:**

firewall:default_policy: ``ACCEPT`` - default
  What to do with packets that are not otherwised handled by another rule.
  ``ACCEPT`` or ``DROP``

firewall:enabled: ``True`` - default
  To globally enable/disable firewall rules


``lib``
----------

Example usage::

    include:
      - firewall


    {# To configure the firewall rules in the nginx state file, you could do the following: #}

    {% from 'firewall/lib.sls' import firewall_enable with context %}
    {{ firewall_enable('nginx', nginx.port , 'tcp') }}


    {# to configure PREROUTING table #}

    {% from 'firewall/lib.sls' import firewall_nat with context %}
    {{ firewall_nat('port-hack'+source, '-A PREROUTING -s ' + source + ' -p tcp -m tcp --dport ' ~ https_port ~ ' -j DNAT --to-destination :' ~ https_port_hack) }}
