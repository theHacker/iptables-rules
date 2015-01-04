#!/bin/bash

NETS_TO_BLOCK=(
  # Facebook
  31.13.24.0/21
  31.13.64.0/18
  66.220.144.0/20
  69.63.176.0/20
  69.171.224.0/19
  74.119.76.0/22
  173.252.64.0/19
  173.252.64.0/19
  185.60.216.0/22
  199.201.64.0/22
  204.15.20.0/22
  2620:0000:1c00::/40
  2620:010d:c080::/41
  2a03:2880::/32
)

iptables -F
ip6tables -F
for net in "${NETS_TO_BLOCK[@]}"
do
    CMD=$([[ "$net" == *":"* ]] && echo "ip6tables" || echo "iptables")

    echo "Blocking $net with $CMD"
    $CMD -A INPUT -s $net -j DROP
    $CMD -A OUTPUT -d $net -j REJECT
done

