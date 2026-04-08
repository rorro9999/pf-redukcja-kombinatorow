#!/usr/bin/bash

echo "jesli program sie wywala, to nalezy uzupelnic petle w skrypcie"
echo "i tak musicie otworzyc ten skrypt, ze ustawic program do testowania

prog=test.e

for folder in ; do
    toster --in tests/correct/small    --out $folder/correct/small     $prog
    toster --in tests/correct/medium   --out $folder/correct/medium    $prog
    toster --in tests/correct/large    --out $folder/correct/large     $prog
    toster --in tests/incorrect/small  --out $folder/incorrect/small   $prog
    toster --in tests/incorrect/medium --out $folder/incorrect/medium  $prog
    toster --in tests/whitespace       --out $folder/whitespace        $prog
done


