#!/bin/bash

cat data/HD_100/labels.wrd > /home/Workspace/kenlm/labels.HD100.wrd

# install kenLM before run this script
cd /home/Workspace/kenlm

./build/bin/lmplz --discount_fallback -o 4 < labels.HD100.wrd > 4gram.arpa

./build/bin/build_binary 4gram.arpa 4gram.bin