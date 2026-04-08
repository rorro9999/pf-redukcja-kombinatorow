#!/usr/bin/bash

if (($# != 2)); then
    echo "sposob uzycia: <program do generowania odpowiedzi> <nazwa folderu (bez znakow specjalnych, spacji itp, bo ciasteczkowy potwor wejdzie pod wasze lozko) gdzie zostana wygenerowane odpowiedzi, np \"jamnik\">"
    echo $#
    exit 1
fi

prog=$1
folder=$2

rm -rf $folder
cp -r tests $folder
find $folder -type f -name "*.in" -delete

toster --in tests/correct/small    --out $folder/correct/small    --generate $prog
toster --in tests/correct/medium   --out $folder/correct/medium   --generate $prog
toster --in tests/correct/large    --out $folder/correct/large    --generate $prog
toster --in tests/incorrect/small  --out $folder/incorrect/small  --generate $prog
toster --in tests/incorrect/medium --out $folder/incorrect/medium --generate $prog
toster --in tests/whitespace       --out $folder/whitespace       --generate $prog
