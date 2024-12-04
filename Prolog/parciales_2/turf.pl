% Punto 1
jockey(valdivieso, 155, 52).
jockey(leguisamo, 161, 49).
jockey(lezcano, 149, 50).
jockey(baratucci, 153, 55).
jockey(falero, 157, 52).

prefiere(botafogo, Jockey):-
    jockey(Jockey, _, Peso),
    Peso < 52.
prefiere(botafogo, baratucci).
prefiere(oldMan, Jockey):-
    jockey(Jockey, _, _),
    atom_length(Jockey, CantLetras),
    CantLetras > 7.       
prefiere(energica, Jockey):-
    jockey(Jockey, _, _),
    not(prefiere(botafogo, Jockey)).
prefiere(matBoy, Jockey):-
    jockey(Jockey, Altura, _),
    Altura > 170.

caballeriza(valdivieso, elTute).
caballeriza(falero, elTute).
caballeriza(lezcano, lasHormigas).
caballeriza(baratucci, elCharabon).
caballeriza(leguisamo, elCharabon).

gano(botafogo, granPremio(nacional)).
gano(botafogo, granPremio(republica)).
gano(oldMan, granPremio(republica)).
gano(oldMan, campeonato(palermoDeOro)).
gano(matBoy, granPremio(criadores)).

% Punto 2
prefierenJockeys(Caballo):-
    prefiere(Caballo, Jockey1),
    prefiere(Caballo, Jockey2),
    Jockey1 \= Jockey2.

% Punto 3
noLeAgradaNadie(Caballo, Caballeriza):-
    caballeriza(_, Caballeriza),
    forall(caballeriza(Jockey, Caballeriza), not(prefiere(Caballo, Jockey))).

% Punto 4
esPiolin(Jockey):-
    jockey(Jockey, _, _),
    forall(ganoPremioImportante(Caballo), prefiere(Caballo, Jockey)).

ganoPremioImportante(Caballo):-
    gano(Caballo, Premio),
    premioImportante(Premio).

premioImportante(granPremio(nacional)).
premioImportante(granPremio(republica)).

% Punto 5

resultaGanadora(posicion(Posicion, Caballo), Resultado):-
    between(1, 2, Posicion),
    prefiere(Caballo, _),
    member(posicion(Posicion, Caballo), Resultado).
resultaGanadora(exacta(posicion(1, Caballo1), posicion(2, Caballo2)), Resultado):-
    member(exacta(posicion(1, Caballo1)), Resultado),
    member(exacta(posicion(2, Caballo2)), Resultado),
resultaGanadora(imperfecta(Caballo1, Caballo2), Resultado):-
    member(posicion(Pos1, Caballo1), Resultado),
    member(posicion(Pos2, Caballo2), Resultado),
    between(1, 2, Pos1),
    between(1, 2, Pos2).

% Punto 6
color(botafogo, negro).
color(oldMan, marron).
color(energico, gris).
color(energico, negro).
color(matBoy, marron).
color(matBoy, blanco).
color(yatasto, blanco).
color(yatasto, marron).

puedeComprar(Preferencia, Caballos):-
    color(Caballo, _),
    findall(Caballo, color(Caballo, Preferencia), Caballos).