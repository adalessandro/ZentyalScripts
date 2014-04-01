#! /usr/bin/env python
# -*- coding: utf-8 -*-

"""
    nextfreeip.py
    Toma un argumeno por línea de comandos: rango de ip a escanear.
    Por entrada estandar toma la salida de listobj.pl
    Ej: ./listobj.pl | ./nextfreeip.py 19.54.3.0/24
"""

import sys
from netaddr import IPNetwork  # IPAddress


def nextfreeip(ip_net):
    ip_net_obj = IPNetwork(ip_net)

    list = []
    while True:
        line = sys.stdin.readline()
        if not line:
            break
        line = line.rstrip('\n')
        line = line.replace('\t', '')
        words = line.split(' ')
        if words[0] == 'HOST:':
            ip_addr = words[2]
            ip_addr_obj = IPNetwork(ip_addr)
            if ip_addr_obj in ip_net_obj:
                list.append(ip_addr_obj)
    list = sorted(list)
    list = map(lambda x: x.ip, list)
    nextip = None
    for t in ip_net_obj:
        if t not in list and not t == ip_net_obj.ip:
            nextip = t
            break
    if nextip is not None:
        print "Siguiente IP libre: " + str(nextip)
    else:
        print "No se encontró IP libre en el rango."

if len(sys.argv) == 2:
    nextfreeip(sys.argv[1])
else:
    print "Debe ingresar una rango"
