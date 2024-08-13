%% Punto 1
cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).
cree(juan, conejoDePascua).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

suenia(gabriel, loteria([5, 9])).
suenia(gabriel, futbolista(arsenal)).
suenia(juan, cantante(100000)).
suenia(macarena, cantante(10000)).

%% Punto 2
esAmbiciosa(Persona):-
    distinct(Persona, suenia(Persona, _)),
    findall(Dificultad, (suenia(Persona, Suenio), dificultad(Suenio, Dificultad)), Dificultades),
    sum_list(Dificultades, SumaDificultades),
    SumaDificultades > 20.

dificultad(cantante(Discos), Dificultad):-
    Discos > 500000,
    Dificultad is 6.
dificultad(cantante(_), 4).
dificultad(loteria(Numeros), Dificultad):-
    length(Numeros, Cantidad),
    Dificultad is 10 * Cantidad.
dificultad(futbolista(arsenal), 3).
dificultad(futbolista(aldosivi), 3).
dificultad(futbolista(_), 16).

%% Punto 3
tienenQuimica(Personaje, Persona):-
    cree(Persona, Personaje),
    quimica(Persona, Personaje).

quimica(Persona, campanita):-
    suenia(Persona, Suenio),
    dificultad(Suenio, X),
    X < 5.
quimica(Persona, Personaje):-
    Personaje \= campanita,
    not(esAmbiciosa(Persona)),
    forall(suenia(Persona, Suenio), esPuro(Suenio)).

esPuro(futbolista(_)).
esPuro(cantante(Discos)):-
    Discos < 200000.

%% Punto 4
amigo(campanita, reyesMagos).
amigo(campanita, conejoDePascua).
amigo(conejoDePascua, cavenaghi).

enfermo(campanita).
enfermo(reyesMagos).
enfermo(conejoDePascua).

alegra(Personaje, Persona):-
    distinct(Persona, suenia(Persona, _)),
    tienenQuimica(Personaje, Persona),
    puedeAlegrar(Personaje).

puedeAlegrar(Personaje):-
    not(enfermo(Personaje)).
puedeAlegrar(Personaje):-
    amigo(Personaje, Amigo),
    not(enfermo(Amigo)).
puedeAlegrar(Personaje):-
    amigo(Personaje, Amigo),
    amigo(Amigo, AmigoIndirecto),
    not(enfermo(AmigoIndirecto)).