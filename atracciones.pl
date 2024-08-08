persona(nina, 22, 160).
persona(marcos, 8, 132).
persona(osvaldo, 13, 129).

atracciones(parqueDeLaCosta, [trenFantasma(12), montaniaRusa(130), maquinaTiquetera]).
atracciones(parqueAcuatico, [toboganGigante(22, 150), rioLento, piscinaOlas(5)]).

puedeSubir(Persona, Atraccion):-
    persona(Persona, Edad, Altura),
    atracciones(_, Atracciones),
    member(Atraccion, Atracciones),
    cumpleRequisitos(Edad, Altura, Atraccion).

cumpleRequisitos(_, _, maquinaTiquetera).
cumpleRequisitos(_, _, rioLento).
cumpleRequisitos(Edad, _, trenFantasma(EdadMinima)):-
    Edad >= EdadMinima.
cumpleRequisitos(_, Altura, montaniaRusa(AlturaMinima)):-
    Altura > AlturaMinima.
cumpleRequisitos(_, Altura, toboganGigante(_, AlturaMinima)):-
    Altura > AlturaMinima.
cumpleRequisitos(Edad, _, piscinaOlas(EdadMinima)):-
    Edad >= EdadMinima.

esParaElOElla(Persona, Parque):-
    persona(Persona, _, _),
    atracciones(Parque, Atracciones),   
    forall(member(Atraccion, Atracciones), puedeSubir(Persona, Atraccion)).

malaIdea(Personas, Parque):-
    forall(member(Persona, Personas), persona(Persona, _, _)),
    atracciones(Parque, Atracciones),

    findall(Atraccion, (member(Atraccion, Atracciones), todosJuegan(Atraccion, Personas)), AtraccionesParaTodos),
    length(AtraccionesParaTodos, 0).

todosJuegan(Atraccion, Personas):-
    forall(member(Persona, Personas), puedeSubir(Persona, Atraccion)).

programaLogico(Programa):-
    noHayDuplicados(Programa),
    atracciones(Parque, _),
    forall(member(Atraccion, Programa), (atracciones(Parque, Atracciones), member(Atraccion, Atracciones))).

noHayDuplicados([]).
noHayDuplicados([Atraccion|Atracciones]):-
    not(member(Atraccion, Atracciones)).

hastaAca(Persona, Programa, Subprograma):-
    persona(Persona, _, _),
    esPrograma(Programa),
    atraccionesDisponibles(Persona, Programa, Atracciones),
    reverse(Atracciones, Subprograma).

esPrograma(Programa):-
    atracciones(Parque, _),
    forall(member(Atraccion, Programa), (atracciones(Parque, Atracciones), member(Atraccion, Atracciones))).

atraccionesDisponibles(_, [], []).
atraccionesDisponibles(Persona, [Atraccion|Atracciones], Subprograma):-
    puedeSubir(Persona, Atraccion),
    atraccionesDisponibles(Persona, Atracciones, ListaAtracciones),
    append(ListaAtracciones, [Atraccion], Subprograma).
atraccionesDisponibles(_, _, []).
