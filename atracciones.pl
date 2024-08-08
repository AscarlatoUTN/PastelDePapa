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