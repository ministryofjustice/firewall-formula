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

``lib``
----------



Example usage::

    To configure the firewall rules in the nginx state file, you could do the following:

    {% from 'firewall/lib.sls' import firewall_enable with context %}
    {{ firewall_enable('nginx', nginx.port , 'tcp') }}

  
