#!/bin/sh
unset COLORTERM
bat -pp --line-range=:500 --color=always "$1"
