%% Punto 1
vacaciona(dodain, pehuenia).
vacaciona(dodain, sanMartin).
vacaciona(dodain, esquel).
vacaciona(dodain, sarmiento).
vacaciona(dodain, camarones).
vacaciona(dodain, playasDoradas).
vacaciona(alf, bariloche).
vacaciona(alf, sanMartin).
vacaciona(alf, elBolson).
vacaciona(nico, marDelPlata).
vacaciona(vale, calafate).
vacaciona(vale, elBolson).
vacaciona(martu, Vacaciones):-
    vacaciona(nico, Vacaciones).
vacaciona(martu, Vacaciones):-
    vacaciona(vale, Vacaciones).
vacaciona(juan, Vacaciones):-
    random_member(Vacaciones, [villaGesell, federacion]).

%% Punto 2 (quitar todas las listas y pasarlas a hechos)
turismo(esquel, 150, parqueNacional(losAlerces)).
turismo(esquel, 150, excursion(trochita)).
turismo(esquel, 150, excursion(trevelin)).
turismo(pehuenia, 180, cerro(bateaMahuida, 2000)).
turismo(pehuenia, 180, cuerpoDeAgua(moheque, puedePescar, 14)).
turismo(pehuenia, 180, cuerpoDeAgua(alumine, puedePescar, 19)).
%turismo(sanMartin, 150, excursion(lagoLolog)).
%turismo(sanMartin, 150, excursion(quetraHue)).
%turismo(sanMartin, 150, excursion(chimehuin)).
%turismo(sarmiento, 100, excursion(cuevaDeLasManos)).
%turismo(sarmiento, 100, parqueNacional(bosquesPetrificados)).
%turismo(camarones, 135, cuerpoDeAgua(playa, 3)).
%turismo(camarones, 135, excursion(bosquePetrificado)).
%turismo(playasDoradas, 170, playa(4)).
%turismo(playasDoradas, 170, excursion(faroQuerandi)).
%turismo(bariloche, 140, excursion(circuitoChico)).
%turismo(bariloche, 140, excursion(islaVictoria)).
%turismo(bariloche, 140, excursion(bosqueArrayanes)).
%turismo(elBolson, 145, excursion(rioAzul)).
%turismo(elBolson, 145, excursion(cerroAmigo)).
%turismo(elBolson, 145, excursion(lagoPuelo)).
%turismo(marDelPlata, 140, cuerpoDeAgua(playa, 5)).
%turismo(marDelPlata, 140, excursion(faro, 2)).
%turismo(calafate, 240, excursion(glaciarPeritoMoreno)).
%turismo(calafate, 240, excursion(lagoArgentino)).
%turismo(calafate, 240, excursion(chalten)).
%turismo(villaGesell, 60, cuerpoDeAgua(playa, 6)).
%turismo(villaGesell, 60, excursion(faroQuerandi)).
%turismo(federacion, 40, cuerpoDeAgua(termas, 25)).
%turismo(federacion, 40, excursion(saltoDelTabaquillo)).

vacacionesCopadas(Persona, Lugar):-
    vacaciona(Persona, Lugar),
    findall(Vacacion, (turismo(Lugar, _, Vacacion), esCopado(Vacacion)), Vacaciones), 
    not(length(Vacaciones, 0)).

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
    distinct(Persona1, vacaciona(Persona1, _)),
    distinct(Persona2, vacaciona(Persona2, _)),
    Persona1 \= Persona2,
    findall(Lugar1, vacaciona(Persona1, Lugar1), Lugares1),
    findall(Lugar2, vacaciona(Persona2, Lugar2), Lugares2),
    intersection(Lugares1, Lugares2, []).

%% Punto 4
vacacionesGasoleras(Persona):- % Ejemplo del parcial lo tienen mal
    distinct(Persona, vacaciona(Persona, _)),
    findall(Destino, distinct(Destino, vacaciona(Persona, Destino)), Destinos),
    forall((member(Destino, Destinos), turismo(Destino, CostoDeVida, _)), CostoDeVida < 160).

%% Punto 5
itinerariosPosibles(Persona, Itinerarios):-
    findall(Destino, vacaciona(Persona, Destino), Destinos),
    permutation(Destinos, Itinerarios). % Te re cabió