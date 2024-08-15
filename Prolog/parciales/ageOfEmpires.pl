% jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).

% tiene(Nombre, QueTiene).
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)). % (Madera, Alimento, Oro)
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(carreta, 10)).

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).

%% Punto 1
esUnAfano(Jugador1, Jugador2):-
    jugador(Jugador1, Rating1, _),
    jugador(Jugador2, Rating2, _),
    abs(Rating1 - Rating2, Diferencia),
    Diferencia > 500.

%% Punto 2
esEfectivo(Unidad1, Unidad2):-
    tiene(_, unidad(Unidad1, _)),
    tiene(_, unidad(Unidad2, _)),
    militar(Unidad1, _, Categoria1),
    militar(Unidad2, _, Categoria2),
    ganador(Categoria1, Categoria2).

ganador(caballeria, arqueria).
ganador(arqueria, infanteria).
ganador(infanteria, piquero).
ganador(piquero, caballeria).
ganador(piquero, caballeria).
ganador(unica, unica).

%% Punto 3
alarico(Jugador):-
    jugador(Jugador, _, _),
    forall(tiene(Jugador, unidad(Unidad, _)), militar(Unidad, _, infanteria)).

%% Punto 4
leonidas(Jugador):-
    jugador(Jugador, _, _),
    forall(tiene(Jugador, unidad(Unidad, _)), militar(Unidad, _, piquero)).

%% Punto 5
nomada(Jugador):-
    jugador(Jugador, _, _),
    not(tiene(Jugador, edificio(casa, _))).

%% Punto 6
cuantoCuesta(Edificio, costo(Madera, Alimento, Oro)):-
    edificio(Edificio, costo(Madera, Alimento, Oro)).
cuantoCuesta(Unidad, costo(Madera, Alimento, Oro)):-
    tiene(_, unidad(Unidad, _)),
    cuesta(Unidad, costo(Madera, Alimento, Oro)).

cuesta(carreta, costo(100, 0, 50)). % Enunciado confuso, tengo que hacer la cuenta de unidades q tiene o solo una ?
cuesta(Militar, costo(Madera, Alimento, Oro)):-
    militar(Militar, costo(Madera, Alimento, Oro), _).
cuesta(Aldeano, costo(0, 50, 0)):-
    aldeano(Aldeano, _).

%% Punto 7
produccion(Unidad, produccion(Madera, Alimento, Oro)):-
    tiene(_, unidad(Unidad, _)),
    produce(Unidad, costo(Madera, Alimento, Oro)).

produce(carreta, produccion(0, 0, 32)).
produce(keshik, produccion(0, 0, 10)).
produce(Profesion, produccion(Madera, Alimento, Oro)):-
    aldeano(Profesion, produce(Madera, Alimento, Oro)).

%% Punto 8
produccionTotal(Jugador, Recurso, Produccion):-
    jugador(Jugador, _, _),
    findall(produccion(Madera, Alimento, Oro), (tiene(Jugador, unidad(Unidad, _)),
    produccion(Unidad, produccion(Madera, Alimento, Oro))), ProduccionTotal),
    obtenerRecursos(Recurso, ProduccionTotal, Produccion).

obtenerRecursos(madera, ProduccionTotal, Produccion):-
    findall(Madera, member(produccion(Madera, _, _), ProduccionTotal), Maderas),
    sum_list(Maderas, Produccion).
obtenerRecursos(alimento, ProduccionTotal, Produccion):-
    findall(Alimento, member(produccion(_, Alimento, _), ProduccionTotal), Alimentos),
    sum_list(Alimentos, Produccion).
obtenerRecursos(oro, ProduccionTotal, Produccion):-
    findall(Oro, member(produccion(_, _, Oro), ProduccionTotal), Oros),
    sum_list(Oros, Produccion).

%% Punto 9
estaPelado(Jugador1, Jugador2):-
    not(esUnAfano(Jugador1, Jugador2)),
    obtenerCantidades(Jugador1, Cantidad1),
    obtenerCantidades(Jugador2, Cantidad2),
    Cantidad1 == Cantidad2,
    obtenerValor(Jugador1, Valor1),
    obtenerValor(Jugador2, Valor2),
    abs(Valor1 - Valor2, Valor),
    Valor < 100.

obtenerCantidades(Jugador, Cantidad):-
    findall(Cant, tiene(Jugador, unidad(_, Cant)), Cantidades),
    sum_list(Cantidades, Cantidad).

obtenerValor(Jugador, Valor):-
    produccionTotal(Jugador, madera, Madera),
    produccionTotal(Jugador, alimento, Alimento),
    produccionTotal(Jugador, oro, Oro),
    Valor is Oro * 5 + Madera * 3 + Alimento * 2.