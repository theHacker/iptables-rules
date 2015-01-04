#!/bin/bash

iptables -F
ip6tables -F

addRulesFromFile () {
    echo "Reading ruleset $1 ..."

    while read line
    do
        if [[ "$line" == "#"* ]]; then
            continue
        fi

        cmd=$([[ "$line" == *":"* ]] && echo "ip6tables" || echo "iptables")
        net=$line

        echo "  Blocking $net with $cmd"
        $cmd -A INPUT -s $net -j DROP
        $cmd -A OUTPUT -d $net -j REJECT
    done < $1

    echo "OK"
}

for file in rulesets/*
do
    if [[ -f $file ]]; then
        addRulesFromFile $file
    fi
done
