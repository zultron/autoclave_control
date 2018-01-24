#!/bin/bash -e

if test "$1" = siminc; then
    (
	set -x
	halcmd sets temp-ext-incr $2
	halcmd sets heat-cool-incr $3
    )
    exit
elif test "$1" = simset; then
    set -x
    exec halcmd sets temp-ext $2
fi
