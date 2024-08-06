%% Punto 1
vacaciona(dodain, [pehuenia, sanMartin, esquel, sarmiento, camarones, playasDoradas]).
vacaciona(alf, [bariloche, sanMartin, elBolson]).
vacaciona(nico, [marDelPlata]).
vacaciona(vale, [calafate, elBolson]).
vacaciona(martu, Vacaciones):-
    vacaciona(nico, Vacas1),
    vacaciona(vale, Vacas2),
    append(Vacas1, Vacas2, Vacaciones).
vacaciona(juan, Vacaciones):-
    random_member([Vacaciones], [villaGesell, federacion]).

%% Punto 2
turismo(esquel, 150, [parqueNacional(losAlerces), excursion(trochita), excursion(trevelin)]).
turismo(pehuenia, 180, [cerro(bateaMahuida, 2000), cuerpoDeAgua(moheque, puedePescar, 14), cuerpoDeAgua(alumine, puedePescar, 19)]).
turismo(sanMartin, 150, [excursion(lagoLolog), excursion(quetraHue), excursion(chimehuin)]).
turismo(sarmiento, 100, [excursion(cuevaDeLasManos), parqueNacional(bosquesPetrificados)]).
turismo(camarones, 135, [cuerpoDeAgua(playa, 3), excursion(bosquePetrificado)]).
turismo(playasDoradas, 170, [playa(4), excursion(faroQuerandi)]).
turismo(bariloche, 140, [excursion(circuitoChico), excursion(islaVictoria), excursion(bosqueArrayanes)]).
turismo(elBolson, 145, [excursion(rioAzul), excursion(cerroAmigo), excursion(lagoPuelo)]).
turismo(marDelPlata, 140, [cuerpoDeAgua(playa, 5), excursion(faro, 2)]).
turismo(calafate, 240, [excursion(glaciarPeritoMoreno), excursion(lagoArgentino), excursion(chalten)]).
turismo(villaGesell, 60, [cuerpoDeAgua(playa, 6), excursion(faroQuerandi)]).
turismo(federacion, 40, [cuerpoDeAgua(termas, 25), excursion(saltoDelTabaquillo)]).

vacacionesCopadas(Persona, Vacaciones):-
    vacaciona(Persona, Lugares),
    findall(Vacacion, (atraccion(Lugares, Vacacion), esCopado(Vacacion)), Vacaciones).

atraccion(Lugares, Vacacion):-
    member(Lugar, Lugares),
    turismo(Lugar, _, Vacaciones),
    member(Vacacion, Vacaciones).

esCopado(cerro(_, 2000)).
esCopado(cuerpoDeAgua(puedePescar, _)).
esCopado(cuerpoDeAgua(_, Temperatura)):-
    Temperatura > 20.
esCopado(playa(MareaPromedio)):-
    MareaPromedio < 5.
esCopado(excursion(Nombre)):-
    atom_chars(Nombre, Caracteres),
    length(Caracteres, Cant),
    Cant > 7.
esCopado(parqueNacional(_)).

%% Punto 3
noSeCruzan(Persona1, Persona2):-
    vacaciona(Persona1, Lugares1),
    vacaciona(Persona2, Lugares2),
    Persona1 \= Persona2,
    intersection(Lugares1, Lugares2, []).

%% Punto 4
vacacionesGasoleras(Persona):- % Ejemplo del parcial lo tienen mal
    vacaciona(Persona, Destinos),
    forall((turismo(Destino, CostoDeVida, _), member(Destino, Destinos)), CostoDeVida < 160).

%% Punto 5
itinerariosPosibles(Persona, Itinerarios):-
    vacaciona(Persona, Destinos),
    permutation(Destinos, Itinerarios). % Te re cabió