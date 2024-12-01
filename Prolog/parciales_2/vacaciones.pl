viaja(dodain, pehuenia).
viaja(dodain, sanMartin).
viaja(dodain, esquel).
viaja(dodain, sarmiento).
viaja(dodain, camarones).
viaja(dodain, playasDoradas).
viaja(alf, bariloche).
viaja(alf, sanMartin).
viaja(alf, elBolson).
viaja(nico, marDelPlata).
viaja(vale, calafate).
viaja(vale, elBolson).
viaja(martu, Lugar):-
    viaja(nico, Lugar).
viaja(martu, Lugar):-
    viaja(alf, Lugar).

% Punto 2

% parqueNacional(nombre)
% cerro(nombre, altura)
% cuerpoDeAgua(cuerpoAgua, puedePescar, temperatura)
% playa(marea)
% excursion(nombre)

atraccion(esquel, parqueNacional(losAlerces)).
atraccion(esquel, excursion(trochi)).
atraccion(esquel, excursion(trevel)).
atraccion(pehuenia, cerro(bateaMahuida, 2000)).
atraccion(pehuenia, cuerpoDeAgua(mequehue, puedePescar, 14)).
atraccion(pehuenia, cuerpoDeAgua(alumine, puedePescar, 19)).

vacacionesCopadas(Persona):-
    distinct(Persona, viaja(Persona, _)),
    forall(viaja(Persona, Lugar), tieneAtraccionCopada(Lugar)).

tieneAtraccionCopada(Lugar):-
    atraccion(Lugar, Atraccion),
    esCopada(Atraccion).

esCopada(cerro(_, Altura)):-
    Altura > 2000.
esCopada(cuerpoDeAgua(_, puedePescar, _)).
esCopada(cuerpoDeAgua(_, _, Temperatura)):-
    Temperatura > 20.
esCopada(playa(Marea)):-
    Marea < 5.
esCopada(excursion(Nombre)):-
    string_chars(Nombre, Chars),
    length(Chars, CantLetras),
    CantLetras > 7.
esCopada(parqueNacional(_)).

% Punto 3
noCoinciden(Persona1, Persona2):-
    distinct(Persona1, viaja(Persona1, _)),
    distinct(Persona2, viaja(Persona2, _)),
    Persona1 \= Persona2,
    forall(viaja(Persona1, Lugar), not(viaja(Persona2, Lugar))).

% Punto 4

costoDeVida(sarmiento, 100).
costoDeVida(esquel, 150).
costoDeVida(pehuenia, 180).
costoDeVida(sanMartin, 150).
costoDeVida(camarones, 135).
costoDeVida(playasDoradas, 170).
costoDeVida(bariloche, 140).
costoDeVida(calafate, 240).
costoDeVida(elBolson, 145).
costoDeVida(marDelPlata, 140).

vacacionesGasoleras(Persona):-
    distinct(Persona, viaja(Persona, _)),
    forall(viaja(Persona, Lugar), esGasolero(Lugar)).

esGasolero(Lugar):-
    costoDeVida(Lugar, Costo),
    Costo < 160.

% Punto 5
itinerarios(Persona, Itinerario):-
    distinct(Persona, viaja(Persona, _)),
    findall(Lugar, viaja(Persona, Lugar), Lugares),
    permutation(Lugares, Itinerario).    