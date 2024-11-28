cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).
cree(juan, conejoDePascua).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

% suenio(cantante(discos))
% suenio(futbolista(equipo))
% suenio(loteria([numeros]))

suenia(gabriel, loteria([5, 9])).
suenia(gabriel, futbolista(arsenal)).
suenia(juan, cantante(100000)).
suenia(macarena, cantante(10000)).

% Punto 2

persona(Persona):- suenia(Persona, _).

esAmbiciosa(Persona):-
    distinct(Persona, persona(Persona)),
    findall(Dificultad, (suenia(Persona, Suenio), dificultad(Suenio, Dificultad)), Dificultades),
    sum_list(Dificultades, NivelDificultad),
    NivelDificultad > 20.

dificultad(cantante(Discos), 6):-
    Discos > 500000.
dificultad(cantante(_), 4).
dificultad(loteria(Numeros), Dificultad):-
    length(Numeros, CantNumeros),
    Dificultad is CantNumeros * 10.
dificultad(futbolista(arsenal), 3).
dificultad(futbolista(aldosivi), 3).
dificultad(futbolista(_), 16).

% Punto 3

tienenQuimica(Personaje, Persona):-
    cree(Persona, Personaje),
    quimicaEntre(Persona, Personaje).

quimicaEntre(Persona, campanita):-
    suenia(Persona, Suenio),
    dificultad(Suenio, Dificultad),
    Dificultad < 5.
quimicaEntre(Persona, Personaje):-
    Personaje \= campanita,
    not(esAmbiciosa(Persona)),
    forall(suenia(Persona, Suenio), esPuro(Suenio)).

esPuro(futbolista(_)).
esPuro(cantante(Discos)):-
    Discos < 200000.

% Punto 4

amigo(campanita, reyesMagos).
amigo(campanita, conejoDePascua).
amigo(conejoDePascua, cavenaghi).

estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoDePascua).

puedeAlegrar(Personaje, Persona):-
    distinct(Persona, suenia(Persona, _)),
    distinct(Personaje, cree(_, Personaje)),
    quimicaEntre(Persona, Personaje),
    (not(estaEnfermo(Personaje)) ; tieneAmigosSanos(Personaje)).

tieneAmigosSanos(Personaje):-
    amigo(Personaje, Amigo),
    (not(estaEnfermo(Amigo)) ; tieneAmigosSanos(Amigo)).