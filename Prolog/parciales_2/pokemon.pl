tipo(pikachu, electrico).
tipo(charizard, fuego).
tipo(venusaur, planta).
tipo(blastoise, agua).
tipo(totodile, planta).
tipo(snorlax, normal).
tipo(rayquaza, dragon).
tipo(rayquaza, volador).

tiene(ash, pikachu).
tiene(ash, charizard).
tiene(brock, snorlax).
tiene(misty, blastoise).
tiene(misty, venusaur).
tiene(misty, arceus).

pokemon(Pokemon):-
    tipo(Pokemon, _).
pokemon(Pokemon):-
    tiene(_, Pokemon).

tipoMultiple(Pokemon):-
    tipo(Pokemon, Tipo1),
    tipo(Pokemon, Tipo2),
    Tipo1 \= Tipo2.

esLegendario(Pokemon):-
    distinct(Pokemon, tipoMultiple(Pokemon)),
    not(tiene(_, Pokemon)).

esMisterioso(Pokemon):-
    tipo(Pokemon, Tipo),
    not((tipo(Pokemon2, Tipo), Pokemon2 \= Pokemon)).
esMisterioso(Pokemon):-
    distinct(Pokemon, pokemon(Pokemon)),
    not(tiene(_, Pokemon)).

% Parte 2

% fisico(potencia)
% especial(potencia, tipo)
% defensivo(porcentajeReduccionDanio)

movimiento(mordedura, fisico(95)).
movimiento(impactrueno, especial(40, electrico)).
movimiento(garraDragon, especial(100, dragon)).
movimiento(proteccion, defensivo(0.9)).
movimiento(placaje, fisico(50)).
movimiento(alivio, defensivo(0)).

usa(pikachu, mordedura).
usa(pikachu, impactrueno).
usa(charizard, garraDragon).
usa(charizard, mordedura).
usa(blastoise, proteccion).
usa(blastoise, placaje).
usa(arceus, impactrueno).
usa(arceus, garraDragon).
usa(arceus, proteccion).
usa(arceus, placaje).
usa(arceus, alivio).

danioMovimiento(Movimiento, Danio):-
    movimiento(Movimiento, Tipo),
    danio(Tipo, Danio).

danio(fisico(Potencia), Potencia).
danio(defensivo(_), 0).
danio(especial(Potencia, Tipo), Danio):-
    tipoBasico(Tipo),
    Danio is Potencia * 1.5.
danio(especial(Potencia, dragon), Danio):-
    Danio is Potencia * 3.
danio(especial(Potencia, Tipo), Potencia):-
    Tipo \= dragon.

tipoBasico(fuego).
tipoBasico(agua).
tipoBasico(planta).
tipoBasico(normal).

capacidadOfensiva(Pokemon, Capacidad):-
    distinct(Pokemon, pokemon(Pokemon)),
    findall(Danio, (usa(Pokemon, Movimiento), danioMovimiento(Movimiento, Danio)), Danios),
    sum_list(Danios, Capacidad).

entrenadorPicante(Entrenador):-
    tiene(Entrenador, _),
    forall(tiene(Entrenador, Pokemon), cumplePicantez(Pokemon)).

cumplePicantez(Pokemon):-
    capacidadOfensiva(Pokemon, Capacidad),
    Capacidad > 200.
cumplePicantez(Pokemon):-
    esMisterioso(Pokemon).