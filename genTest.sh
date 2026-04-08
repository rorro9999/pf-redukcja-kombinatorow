#!/usr/bin/bash

rm -f genTest.e
make genTest.e

if ! test -f genTest.e; then
    echo "generatorka sie nie skompilowala"
    exit -1
fi

rm -rf tests

mkdir -vp tests/correct/small
mkdir -vp tests/correct/medium
mkdir -vp tests/correct/large
mkdir -vp tests/incorrect/small
mkdir -vp tests/incorrect/medium
mkdir -vp tests/whitespace/

#genTest 1[seed] 2[ilosc_kombinatorow] 3[prawdopdobienstwo_kombinatora_main(ulamek)] 4[max_ilosc_argumentow_kombinatora] 5[bias_ilosci_argumentow] 6[max_ilosc_wynikow_kombinatora] 7[bias_ilosci_wynikow] 8[prawdopodobienstwo_nawiasu_otwierajacego (ulamek)] 9[prawdopodobienstwo_nawiasu_zamykajacego (ulamek)] 10[dlugos_main] 11[zmus_powtorzenie_nazwy_kombinatora(krotnosc)] 12[zezwalaj_na_niepoprawne_definicje (wolne zmienne, argumenty o tych samych nazwach)(ulamek)] 13[kombinatory_jak_bardzo_definiowane_innymi_kombinatorami(ulamek)(szacowanie z dolu)] 14[losowe_biale_znaki(0/1)(ugly)]

./genTest.e 0 3 0.7  3 0 5 0 0.2  0.3  10 0 -1 0.15 0 || exit 1;
#t=5
#t=3
t=2000
for ((i = 0; i < t; i++)); do
    #correct tests
    ./genTest.e $((i))     3 0.7  3 0 5 0 0.2  0.3  10 0 -1 0.15 0 > tests/correct/small/$((i)).in & #basic small
    ./genTest.e $((i+t))   4 0.7  4 1 6 1 0.25 0.35 15 0 -1 0.25 0 > tests/correct/small/$((i+t)).in & #basic small
    ./genTest.e $((i+2*t)) 5 0.75 4 2 7 2 0.2  0.3  15 0 -1 0.25 1 > tests/correct/small/$((i+2*t)).in & #basic small
    ./genTest.e $((i))     30 0.8 6 0 10 0 0.2 0.3 100 0 -1 0.15 0 > tests/correct/medium/$((i)).in & #basic medium
    ./genTest.e $((i+t))   40 0.8 7 0 13 1 0.2 0.3 100 0 -1 0.10 1 > tests/correct/medium/$((i+t)).in & #basic medium
    ./genTest.e $((i+2*t)) 50 0.8 8 1 16 2 0.2 0.3 100 0 -1 0.15 0 > tests/correct/medium/$((i+2*t)).in & #basic medium
    ./genTest.e $((i+3*t)) 30 0.75 6 0 18 1 0.7 0.20 100 0 -1 0.05 0 > tests/correct/medium/$((i+3*t)).in & #parenthesis hell, very left heavy ((((a) b) c) d (((( ..
    ./genTest.e $((i+4*t)) 30 0.75 6 0 18 1 0.5 0.15 100 0 -1 0.05 0 > tests/correct/medium/$((i+4*t)).in & #parenthesis hell, very right heavy ((((a) b) c) d (((( ..
    wait
    #incorrect tests, same distributions as the correct ones, but, uuh, not correct
    ./genTest.e $((i))     3 0.7  3 0 5 0 0.2  0.3  10 1 0.1 0.15 0 > tests/incorrect/small/$((i)).in & #basic small
    ./genTest.e $((i+t))   4 0.7  4 1 6 1 0.25 0.35 15 1 0.1 0.25 0 > tests/incorrect/small/$((i+t)).in & #basic small
    ./genTest.e $((i+2*t)) 5 0.75 4 2 7 2 0.2  0.3  15 1 0.1 0.25 1 > tests/incorrect/small/$((i+2*t)).in & #basic small
    ./genTest.e $((i))     30 0.8 6 0 10 0 0.2 0.3 100 3 0.1 0.15 0 > tests/incorrect/medium/$((i)).in & #basic medium
    ./genTest.e $((i+t))   40 0.8 7 0 13 1 0.2 0.3 100 3 0.1 0.10 1 > tests/incorrect/medium/$((i+t)).in & #basic medium
    ./genTest.e $((i+2*t)) 50 0.8 8 1 16 2 0.2 0.3 100 4 0.1 0.15 0 > tests/incorrect/medium/$((i+2*t)).in & #basic medium
    ./genTest.e $((i+3*t)) 30 0.75 6 0 18 1 0.7 0.20 100 4 0.04 0.05 0 > tests/incorrect/medium/$((i+3*t)).in & #parenthesis hell, very left heavy ((((a) b) c) d (((( ..
    ./genTest.e $((i+4*t)) 30 0.75 6 0 18 1 0.5 0.15 100 4 0.1 0.05 0 > tests/incorrect/medium/$((i+4*t)).in & #parenthesis hell, very right heavy ((((a) b) c) d (((( ..
    wait
    ./genTest.e $((i))     3 0.7  3 0 5 0 0.2  0.3  10 1 0.1 0.15 4 > tests/whitespace/$((i)).in & #basic small
    ./genTest.e $((i+t))   4 0.7  4 1 6 1 0.25 0.35 15 1 0.1 0.25 4 > tests/whitespace/$((i+t)).in & #basic small
    ./genTest.e $((i+2*t)) 5 0.75 4 2 7 2 0.2  0.3  15 1 0.1 0.25 4 > tests/whitespace/$((i+2*t)).in & #basic small
    ./genTest.e $((i))     30 0.8 6 0 10 0 0.2 0.3 100 3 0.1 0.15 4 > tests/whitespace/$((i)).in & #basic medium
    ./genTest.e $((i+t))   40 0.8 7 0 13 1 0.2 0.3 100 3 0.1 0.10 4 > tests/whitespace/$((i+t)).in & #basic medium
    wait
done
echo "small and medium tests done"

<<comment
cat tests/correct/small/0.in | grep "(("
cat tests/correct/small/1.in | grep "(("
cat tests/correct/small/2.in | grep "(("
cat tests/correct/small/3.in | grep "(("
cat tests/correct/small/4.in | grep "(("
cat tests/correct/medium/0.in | grep "(("
cat tests/correct/medium/1.in | grep "(("
cat tests/correct/medium/2.in | grep "(("
cat tests/correct/medium/3.in | grep "(("
cat tests/correct/medium/4.in | grep "(("
comment

t=200
for ((i = 0; i < t; i++)); do
    ./genTest.e $((i))     1000 0.8 20 0 20 0 0.05 0.1 400 0 -1 0.001 0 > tests/correct/large/$((i)).in &
    ./genTest.e $((i+t))   20000 0.8 3 0 5 -1 0.1 0.3 400 0 -1 0.001 0 > tests/correct/large/$((i+t)).in &
    ./genTest.e $((i+2*t)) 40 0.8 300 2 300 1 0.005 0.03 4000 0 -1 0.0005 0 > tests/correct/large/$((i+2*t)).in &
    wait
done
