mago(harry, mestiza, slytherin, [corajudo, amistoso, orgulloso, inteligente]).
mago(draco, pura, hufflepuff, [inteligente, orgulloso]).
mago(hermione, impura, ninguna, [inteligente, orgulloso, responsable]).

sombreroElije(gryffindor, Caracteristicas):-
    member(corajudo, Caracteristicas).
sombreroElije(slytherin, Caracteristicas):-
    member(orgulloso, Caracteristicas),
    member(inteligente, Caracteristicas).
sombreroElije(ravenclaw, Caracteristicas):-
    member(inteligente, Caracteristicas),
    member(responsable, Caracteristicas).
sombreroElije(hufflepuff, Caracteristicas):-
    member(amistoso, Caracteristicas).

%% Punto 1
esPermitido(Mago, Casa):-
    mago(Mago, _, _, _),
    sombreroElije(Casa, _),
    acepta(Mago, Casa).

acepta(_, gryffindor).
acepta(_, ravenclaw).
acepta(_, hufflepuff).
acepta(Mago, slytherin):-
    not(mago(Mago, impura, _, _)).

%% Punto 2
caracterApropiado(Mago, Casa):-
    mago(Mago, _, _, Caracteristicas),
    sombreroElije(Casa, Caracteristicas).

%% Punto 3
podriaQuedar(hermione, gryffindor).
podriaQuedar(Mago, Casa):-
    not(mago(Mago, _, Casa, _)),
    caracterApropiado(Mago, Casa),
    esPermitido(Mago, Casa).

%% Punto 4
cadenaDeAmistades(Magos):-
    forall((member(Mago, Magos), mago(Mago, _, _, Caracteristicas)), member(amistoso, Caracteristicas)),
    loAcepta(Magos).

loAcepta([_]).
loAcepta([Mago1, Mago2|Magos]):-
    podriaQuedar(Mago1, Casa),
    podriaQuedar(Mago2, Casa),
    loAcepta([Mago2|Magos]).

%%%% Parte 2

%% Punto 1
accion(mala, caminaDeNoche, -50).
accion(mala, bosque, -50).
accion(mala, seccionRestringida, -10).
accion(mala, tercerPiso, -75).
accion(buena, ganarAjedrez, 50).
accion(buena, usarIntelecto, 50).
accion(buena, ganarVoldemort, 60).

acciones(harry, [caminaDeNoche, bosque, tercerPiso]).
acciones(hermione, [tercerPiso, seccionRestringida]).
acciones(draco, [bosque]). % mazmorras
acciones(ron, [ganarAjedrez]).

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

%% Punto 1
buenAlumno(Mago):-
    acciones(Mago, Acciones),
    not(length(Acciones, 0)),
    forall(member(Accion, Acciones), accion(buena, Accion, _)).

esRecurrente(Accion):-
    acciones(Mago, _),
    findall(Mago, (acciones(Mago, Acciones), member(Accion, Acciones)), Magos),
    length(Magos, X),
    X > 1.

%% Punto 2
puntajeTotal(Casa, Puntuacion):-
    findall(Acciones, (esDe(Mago, Casa), acciones(Mago, Acciones)), AccionesCasa),
    flatten(AccionesCasa, AccionesTotales),    
    findall(Puntaje, (member(Accion, AccionesTotales), accion(_, Accion, Puntaje)), Puntajes),
    findall(Puntos, (esDe(Mago, Casa), ganarPuntos(Mago, Puntos)), PuntajesAdicionales),
    append(Puntajes, PuntajesAdicionales, PuntajesTotales),
    sum_list(PuntajesTotales, Puntuacion).

%% Punto 3
casaGanadora(Ganador):-
    findall(Casa, acepta(_, Casa), Casas),
    findall(Puntaje, puntajeTotal(Casa, Puntaje), Puntajes),
    max_member(Puntuacion, Puntajes),
    puntajeTotal(Ganador, Puntuacion).

%% Punto 4
respondio(hermione, bezoar, 20, snape).
respondio(hermione, pluma, 25, flitwick).

ganarPuntos(Mago, Puntaje):-
    findall(Puntos, (respondio(Mago, _, Dificultad, Profesor), calcularPuntos(Dificultad, Profesor, Puntos)), Puntajes),
    sum_list(Puntajes, Puntaje).

calcularPuntos(Dificultad, snape, Puntos):-
    Puntos is Dificultad / 2.
calcularPuntos(Dificultad, _, Dificultad).