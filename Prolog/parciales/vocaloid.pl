cantante(megurineLuka, nightFever, 4).
cantante(megurineLuka, foreverYoung, 5).
cantante(hatsuneMiku, tellYourWorld, 4).
cantante(gumi, foreverYoung, 4).
cantante(gumi, tellYourWorld, 5).
cantante(seeU, novemberRain, 6).
cantante(seeU, nightFever, 5).

%% Punto 1
esNovedoso(Cantante):-
    distinct(Cantante, cantante(Cantante, _, _)),
    findall(Cancion, cantante(Cantante, Cancion, _), Canciones),
    length(Canciones, Cant),
    Cant > 1,
    findall(Duracion, cantante(Cantante, _, Duracion), Duraciones),
    sum_list(Duraciones, DuracionTotal),
    DuracionTotal < 15.

%% Punto 2
esAcelerado(Cantante):-
    distinct(Cantante, cantante(Cantante, _, _)),
    findall(Cancion, (cantante(Cantante, Cancion, Duracion), Duracion > 4), CancionesLargas),
    length(CancionesLargas, 0).

%%%% Parte 2

%% Punto 1
% concierto(Nombre, Pais, Fama, Tipo).
concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

%% Punto 2
puedeParticipar(hatsuneMiku, Concierto):-
    concierto(Concierto, _, _, _).
puedeParticipar(Cantante, Concierto):-
    distinct(Cantante, cantante(Cantante, _, _)),
    Cantante \= hatsuneMiku,
    concierto(Concierto, _, _, Tipo),
    cumpleCondiciones(Cantante, Tipo).

cumpleCondiciones(Cantante, gigante(MinCanciones, MinDuracion)):-
    findall(Cancion, cantante(Cantante, Cancion, _), Canciones),
    length(Canciones, Cant),
    Cant > MinCanciones,
    findall(Duracion, cantante(Cantante, _, Duracion), Duraciones),
    sum_list(Duraciones, DuracionTotal),
    DuracionTotal > MinDuracion.
cumpleCondiciones(Cantante, mediano(MaxDuracion)):-
    findall(Duracion, cantante(Cantante, _, Duracion), Duraciones),
    sum_list(Duraciones, DuracionTotal),
    DuracionTotal < MaxDuracion.
cumpleCondiciones(Cantante, pequenio(MinDuracion)):-
    not(forall(cantante(Cantante, _, Duracion), Duracion =< MinDuracion)).

%% Punto 3
masFamoso(MasFamoso):-
    findall(Fama, famaPorCantante(_, Fama), Famas),
    max_member(MayorFama, Famas),
    famaPorCantante(MasFamoso, MayorFama).

famaPorCantante(Cantante, FamaTotal):-
    distinct(Cantante, cantante(Cantante, _, _)),
    findall(Fama, (puedeParticipar(Cantante, Concierto), concierto(Concierto, _, Fama, _)), Famas),
    sum_list(Famas, FamaTotal).

%% Punto 4
conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).

unicoParticipe(Cantante, Concierto) :-
    distinct(Cantante, cantante(Cantante, _, _)),
    concierto(Concierto, _, _, _),
    puedeParticipar(Cantante, Concierto),
    todosLosConocidos(Cantante, TodosLosConocidos),
    forall(member(Conocido, TodosLosConocidos), not(puedeParticipar(Conocido, Concierto))).

todosLosConocidos(Cantante, TodosLosConocidos) :-
    findall(Conocido, conocidoRecursivo(Cantante, Conocido), Conocidos),
    list_to_set(Conocidos, TodosLosConocidos).

conocidoRecursivo(Cantante, Conocido):-
    conoce(Cantante, Conocido).
conocidoRecursivo(Cantante, Conocido):-
    conoce(Cantante, Intermediario),
    conocidoRecursivo(Intermediario, Conocido).

%% Punto 5
/*
Tendríamos que mantener la estructura concierto(Nombre, Pais, Fama, Tipo), donde lo que va a variar es el Tipo de concierto, al tratarse de functores, no hay problema alguno en añadir otro tipo nuevo, dado que no modifica la estructura en sí.
*/