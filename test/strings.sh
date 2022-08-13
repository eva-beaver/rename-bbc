#!/usr/bin/env bash

strvar="05 ~ The Rolling Stones ~ Angie.mp3"

echo ${#strvar}
len=${#strvar}

echo $((len-3))

type=${strvar:$((len-3)):3}

echo "Type : $type"

name=${strvar:1:$((len-5))}

echo "Name : $name"