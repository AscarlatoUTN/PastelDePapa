personaje(pumkin,     ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).

pareja(marsellus, mia).
pareja(pumkin,    honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

% Punto 1
esPeligroso(Personaje):-
    personaje(Personaje, Actividad),
    actividadPeligrosa(Actividad).
esPeligroso(Personaje):-
    trabajaPara(Personaje, Empleado),
    esPeligroso(Empleado).

actividadPeligrosa(ladron(_)).
actividadPeligrosa(mafioso(maton)).

% Punto 2
amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

duoTemible(Personaje1, Personaje2):-
    personaje(Personaje1, _),
    esPeligroso(Personaje1),
    personaje(Personaje2, _),
    Personaje2 \= Personaje1,
    esPeligroso(Personaje2),
    seConocen(Personaje1, Personaje2).

seConocen(Personaje1, Personaje2):-
    pareja(Personaje1, Personaje2).
seConocen(Personaje1, Personaje2):-
    amigo(Personaje1, Personaje2).

% Punto 3
% encargo(Solicitante, Encargado, Tarea). 
% las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

estaEnProblemas(Personaje):-
    personaje(Personaje, _),
    enProblemas(Personaje).

enProblemas(butch).
enProblemas(Personaje):-
    trabajaPara(Jefe, Personaje),
    esPeligroso(Jefe),
    pareja(Jefe, Pareja),
    encargo(Jefe, Personaje, cuidar(Pareja)).
enProblemas(Personaje):-
    encargo(_, Personaje, buscar(Persona, _)),
    personaje(Persona, boxeador).

% Punto 4
sanCayetano(Personaje):-
    personaje(Personaje, _),
    forall(tieneCerca(Personaje, Persona), encargo(Personaje, Persona, _)).

tieneCerca(Personaje, Persona):-
    amigo(Personaje, Persona).
tieneCerca(Personaje, Persona):-
    trabajaPara(Personaje, Persona).

% Punto 5
masAtareado(Personaje):-
    findall(persona(Personaje, CantEncargos), encargosPorPersona(Personaje, CantEncargos), Encargos),
    max_member(persona(_, CantMaxEncargos), Encargos),
    member(persona(Personaje, CantMaxEncargos), Encargos).
    
encargosPorPersona(Personaje, CantEncargos):-
    distinct(Personaje, encargo(_, Personaje, _)),
    findall(Encargo, encargo(_, Personaje, Encargo), Encargos),
    length(Encargos, CantEncargos).

% Punto 6
personajesRespetables(Personajes):-
    personaje(Personaje, _),
    findall(Personaje, esRespetable(Personaje), Personajes).

esRespetable(Personaje):-
    personaje(Personaje, Actividad),
    respeto(Actividad, Respeto),
    Respeto > 9.

respeto(actriz(Peliculas), Respeto):-
    length(Peliculas, CantPeliculas),
    Respeto is CantPeliculas / 10.
respeto(mafioso(resuelveProblemas), 10).
respeto(mafioso(maton), 1).
respeto(mafioso(capo), 20).

% Punto 7
hartoDe(Personaje, HartoDe):-
    encargo(_, Personaje, _),
    personaje(HartoDe, _),
    forall(encargo(_, Personaje, Actividad), dependeDe(Actividad, HartoDe)).

dependeDe(cuidar(HartoDe), HartoDe).
dependeDe(buscar(HartoDe, _), HartoDe).
dependeDe(ayudar(HartoDe), HartoDe).
dependeDe(Actividad, HartoDe):-
    amigo(HartoDe, Amigo),
    dependeDe(Actividad, Amigo).

% Punto 8
caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

duoDiferenciable(Personaje1, Personaje2):-
    caracteristicas(Personaje1, Caracteristicas1),
    caracteristicas(Personaje2, Caracteristicas2),
    seConocen(Personaje1, Personaje2),
    caracteristicaUnica(Caracteristicas1, Caracteristicas2).

caracteristicaUnica(Caracteristicas1, Caracteristicas2):-
    member(Caracteristica1, Caracteristicas1),
    not(member(Caracteristica1, Caracteristicas2)).
caracteristicaUnica(Caracteristicas1, Caracteristicas2):-
    member(Caracteristica2, Caracteristicas2),
    not(member(Caracteristica2, Caracteristicas1)).