#!/usr/bin/env bash

string="Billion_Dollar_Deals_and_How_They_Changed_Your_World_Series_1_-_3._Work_b0990xks_original.mp4"

IFS='_ ' read -r -a array <<< "$string"

echo "------"

echo "${array[0]}"

echo "------"

echo "${array[@]}"

echo "------"

for index in "${!array[@]}"
do
    echo "$index ${array[index]}"
done

echo "------"


string='Paris, France, Europe';
readarray -td, a <<<"$string"; declare -p a;
## declare -a a=([0]="Paris" [1]=" France" [2]=$' Europe\n')

string="1:2:3:4:5"
set -f                      # avoid globbing (expansion of *).
array=(${string//:/ })
for i in "${!array[@]}"
do
    echo "$i=>${array[i]}"
done

string="1_2_3_4_5"
set -f                      # avoid globbing (expansion of *).
array=(${string//_/ })
for i in "${!array[@]}"
do
    echo "$i=>${array[i]}"
done