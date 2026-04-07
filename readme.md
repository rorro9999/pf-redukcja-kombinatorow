genTest 1[seed] 2[ilosc_kombinatorow] 3[prawdopdobienstwo_kombinatora_main(ulamek)] 4[max_ilosc_argumentow_kombinatora] 5[bias_ilosci_argumentow] 6[max_ilosc_wynikow_kombinatora] 7[bias_ilosci_wynikow] 8[prawdopodobienstwo_nawiasu_otwierajacego (ulamek)] 9[prawdopodobienstwo_nawiasu_zamykajacego (ulamek)] 10[dlugos_main] 11[zmus_powtorzenie_nazwy_kombinatora(krotnosc)] 12[zezwalaj_na_niepoprawne_definicje (wolne zmienne, argumenty o tych samych nazwach)(ulamek)] 13[kombinatory_jak_bardzo_definiowane_innymi_kombinatorami(ulamek)(szacowanie z dolu)] 14[losowe_biale_znaki(0/1)(ugly)]

ulamek znaczy zakres [0,1]

ukryte zalozenia(wszystkie sa ukryte, bo to moje testy):
  - 1e6 >= n >= 2
  - tylko alfabet angielski
  - stale z wielkiej litery, kombinatory z malej
  - kombinatory sa z listy posortowanej leksykograficznie, a, b, c, d, ... aa, ab, ac, ..., wolne zmienne analogicznie A, B, C, ...
  - kombinator x nie moze uzyc siebie w definicji, np. i x = x i sie NIE pojawi, bo kombinator 'i', uzywa kombinatora 'i' w swojej definicji. ale k x y = x, s x y z = x z (y z), to wtedy moze byc i x = s k k x (co jest rowne k x (k x) -> x)
  - main nie jest w definicji innych kombinatorow
  - moga wystepowac dodatkowe zbedne spacje pomiedzy rzeczami, moze byc ((A)) (co i guess oznacza to samo co A)
  - znak '=' nie styka sie z argumentami/zmiennymi/nawiasami
  - niepoprawne testy bede niepoprawne wg definicji z zadania, tych trzech warunkow, nie zawieraja znakow specjalnych itp, sa stricte w formacie [nazwa kombinatora] [zmienne] = [kombinacje zmiennych_i_innych_redeksow(tylko zmiennych i redeksow(poza main), nie ma wyrazow wolnych itp)] [nowa linia], nie bedzie np. inwokacji pana tadeusza
  - main nie musi byc ostatnim kombinatorem
  - dystrybucja najprostsza mozliwa (tworzenie testu przez tworzenie napisow, nie drzew, latwiej w ten sposob uzyskac malo nawiasow -> duzo redukcji, prawdopodobienstwo kombinatora jest z prawdopobienstwa pozostalego po niewylosowania nawiasow)
  - main moze sie zaczac od kombinatora lub stalej (ale nigdy od '(', chociaz moga sie konczyc na ')'). na koncu zadnej linii nie ma zbednych bialych znakow

