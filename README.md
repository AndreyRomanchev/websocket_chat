WebSocket chat
==============

Simple web-chat written in Erlang
and based on WebSockets as transport layer.

Extra goal (not done): do it without cowboy. :)


Deploy using Vagrant & Docker
=============================

Prerequisites
--------------

1. [Vagrant](http://vagrantup.com)
1. (Optional) `vagrant plugin install vagrant-cachier` to speed-up deploy by sharing package cache among Vagrant VMs


Deploy
------

1. `vagrant up --provision` to setup and provision `master` and `minion` VMs with Salt
1. Open http://localhost:8080


Wipe out
--------

1. `vagrant destroy`


Docker development VM
---------------------

The optional `dev` VM with Docker can be added if you do `export USE_DEV_VM=1` before running Vagrant. This VM may be used to debug Docker image builds on machines that don't support Docker natively (e.g. pre-2010 MacBook Pro).
