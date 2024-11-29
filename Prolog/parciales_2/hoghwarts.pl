% mago(nombre, caracteristica, sangre, casaQueOdia)
mago(harry, corajudo, mestiza, slytherin).
mago(harry, amistoso, mestiza, slytherin).
mago(harry, orgulloso, mestiza, slytherin).
mago(harry, inteligente, mestiza, slytherin).
mago(draco, inteligente, pura, hufflepuff).
mago(draco, orgulloso, pura, hufflepuff).
mago(hermione, inteligente, impura, ninguna).
mago(hermione, orgulloso, impura, ninguna).
mago(hermione, responsable, impura, ninguna).

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).

% Punto 1
permiteEntrar(Mago, Casa):-
    distinct(Mago, mago(Mago, _, _, _)),
    puedeEntrar(Mago, Casa).

puedeEntrar(Mago, slytherin):-
    mago(Mago, _, Sangre, _),
    Sangre \= impura.
puedeEntrar(_, Casa):-
    casa(Casa),
    Casa \= slytherin.

% Punto 2
caracterApropiado(Mago, Casa):-
    distinct(Mago, mago(Mago, _, _, _)),
    cumpleCaracteristicas(Mago, Casa).

cumpleCaracteristicas(Mago, gryffindor):-
    mago(Mago, corajudo, _, _).
cumpleCaracteristicas(Mago, slytherin):-
    mago(Mago, orgulloso, _, _),
    mago(Mago, inteligente, _, _).
cumpleCaracteristicas(Mago, ravenclaw):-
    mago(Mago, responsable, _, _),
    mago(Mago, inteligente, _, _).
cumpleCaracteristicas(Mago, hufflepuff):-
    mago(Mago, amistoso, _, _).

% Punto 3
puedeQuedar(hermione, gryffindor).
puedeQuedar(Mago, Casa):-
    caracterApropiado(Mago, Casa),
    permiteEntrar(Mago, Casa),
    not(mago(Mago, _, _, Casa)).

% Punto 4
cadenaDeAmistades([Mago]):-   
    mago(Mago, amistoso, _, _).
cadenaDeAmistades([Mago1, Mago2 | Magos]):-
    mago(Mago1, amistoso, _, _),
    puedeQuedar(Mago2, Casa),
    puedeQuedar(Mago1, Casa),
    cadenaDeAmistades([Mago2 | Magos]).

%% Parte 2

% accion(visitarLugarProhibido(lugar, puntaje)).

accion(hermione, mala, visitarLugarProhibido(tercerPiso)).
accion(hermione, mala, visitarLugarProhibido(seccionRestringidaBiblioteca)).
accion(harry, mala, andarDeNoche).
accion(harry, mala, visitarLugarProhibido(bosque)).
accion(harry, mala, visitarLugarProhibido(tercerPiso)).

accion(ron, buena, ganarAjedrez).
accion(hermione, buena, salvarAmigos).
accion(harry, buena, ganarVoldemort).

puntos(andarDeNoche, -50).
puntos(visitarLugarProhibido(seccionRestringidaBiblioteca), -10).
puntos(visitarLugarProhibido(bosque), -50).
puntos(visitarLugarProhibido(tercerPiso), -75).
puntos(ganarAjedrez, 50).
puntos(salvarAmigos, 50).
puntos(ganarVoldemort, 60).

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% Punto 1
buenAlumno(Mago):-
    accion(Mago, _, _),
    not(accion(Mago, mala, _)),
    accion(Mago, buena, _).

esRecurrente(Accion):-
    accion(Mago1, _, Accion),
    accion(Mago2, _, Accion),
    Mago1 \= Mago2.

% Punto 2
puntaje(Casa, Puntaje):-
    casa(Casa),
    findall(PuntosPorMago, (esDe(Mago, Casa), puntosDe(Mago, PuntosPorMago)), PuntosPorMago),
    sum_list(PuntosPorMago, Puntaje).
     
puntosDe(Mago, PuntosPorMago):-
    findall(Puntaje, (accion(Mago, _, Accion), puntos(Accion, Puntaje)), PuntosPorAccion),
    sum_list(PuntosPorAccion, PuntosAcciones),
    responderPreguntas(Mago, PuntosPreguntas),
    PuntosPorMago is PuntosAcciones + PuntosPreguntas.

% Punto 3
casaGanadora(Casa):-
    findall(Puntaje, puntaje(Casa, Puntaje), Puntajes),
    max_list(Puntajes, PuntajeMaximo),
    puntaje(Casa, PuntajeMaximo).

% Punto 4

% respuesta(pregunta, dificultad, profesor).
respuesta(hermione, ubicacionBezoar, 20, snape).
respuesta(hermione, levitarPluma, 25, flitwick).

responderPreguntas(Mago, Puntos):-
    distinct(Mago, respuesta(Mago, _, _, _)),
    findall(Puntaje, (respuesta(Mago, _, Dificultad, Profesor), puntajeRespuesta(Dificultad, Profesor, Puntaje)), Puntajes),
    sum_list(Puntajes, Puntos).

puntajeRespuesta(Dificultad, snape, Dificultad / 2).
puntajeRespuesta(Dificultad, _, Dificultad).
