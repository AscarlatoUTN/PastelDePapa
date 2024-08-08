%% Punto 1
jerarquia(0, autorrealizacion).
jerarquia(1, reconocimiento).
jerarquia(2, social).
jerarquia(3, seguridad).
jerarquia(4, fisiologico).

% necesidad(Jerarquia, Necesidad).
necesidad(autorrealizacion, autoestima).
necesidad(reconocimiento, exito).
necesidad(reconocimiento, respeto).
necesidad(reconocimiento, confianza).
necesidad(social, intimidad).
necesidad(social, afecto).
necesidad(social, amistad).
necesidad(seguridad, salud).
necesidad(seguridad, empleo).
necesidad(seguridad, integridad).
necesidad(fisiologico, reproduccion).
necesidad(fisiologico, descanso).
necesidad(fisiologico, respiracion).
necesidad(fisiologico, alimentacion).

%% Punto 2
diferenciaDeNivel(Necesidad1, Necesidad2, Diferencia):-
    necesidad(Jerarquia1, Necesidad1),
    necesidad(Jerarquia2, Necesidad2),
    jerarquia(Nivel1, Jerarquia1),
    jerarquia(Nivel2, Jerarquia2),
    Diferencia is abs(Nivel1 - Nivel2).

%% Punto 3
necesita(carla, alimentacion).
necesita(carla, descanso).
necesita(carla, empleo).
necesita(juan, afecto).
necesita(juan, exito).
necesita(roberto, amistad).
necesita(manuel, libertad).
necesita(charly, afecto).
necesita(charly, aseo).

necesidadMasJerarquica(Persona, Necesidad):-   
    findall(Necesidad, necesita(Persona, Necesidad), Necesidades),
    buscarNecesidad(Necesidades, 0, Necesidad).

buscarNecesidad(Necesidades, I, Necesidad):-
    cumpleCondicion(Necesidades, I, Necesidad).
buscarNecesidad(Necesidades, I, Necesidad):-
    I < 4,
    J is I + 1,
    buscarNecesidad(Necesidades, J, Necesidad).

cumpleCondicion(Necesidades, I, Necesidad):-
    member(Necesidad, Necesidades), 
    necesidad(Jerarquia, Necesidad), 
    jerarquia(I, Jerarquia).

% Punto 5
completoNivel(Persona, Nivel):-
    necesita(Persona, _),
    jerarquia(Posicion, Nivel),
    findall(Necesidad, necesita(Persona, Necesidad), Necesidades),
    findall(Necesidad, cumpleCondicion(Necesidades, Posicion, Necesidad), NecesidadesAltas),
    length(NecesidadesAltas, 0).