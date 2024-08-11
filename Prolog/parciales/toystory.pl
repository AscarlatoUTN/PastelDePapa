% Relaciona al duenio con el nombre del juguete y la cantidad de anios que lo ha tenido
duenio(andy, woody, 8).
duenio(sam, jessie, 3).
% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)
juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa, caraDePapa([original(pieIzquierdo), original(pieDerecho), repuesto(nariz)])).
% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, [sombrero])).
% Dice si una persona es coleccionista
esColeccionista(sam).

%% Punto 1
tematica(juguete(_, deTrapo(Tematica)), Tematica).
tematica(juguete(_, deAccion(Tematica, _)), Tematica).
tematica(juguete(_, miniFiguras(Tematica, _)), Tematica).
tematica(juguete(_, caraDePapa([_])), Tematica):-
    Tematica = caraDePapa.

esDePlastico(juguete(_, miniFiguras(_, _))).
esDePlastico(juguete(_, caraDePapa([_]))).

esDeColeccion(juguete(_, deTrapo(_))).
esDeColeccion(juguete(_, deAccion(Tematica, Partes))):-
    esRaro(deAccion(Tematica, Partes)).
esDeColeccion(juguete(_, caraDePapa(Partes))):-
    esRaro(caraDePapa(Partes)).

%% Punto 2
amigoFiel(Duenio, NombreJuguete):-
    distinct(Duenio, duenio(Duenio, _, _)),
    findall(Anio, noEsDePlastico(Duenio, _, Anio), Anios),
    masAntiguo(Duenio, Anios, NombreJuguete).

noEsDePlastico(Duenio, Nombre, Anio):-
    duenio(Duenio, Nombre, Anio),
    juguete(Nombre, Tipo),
    not(esDePlastico(juguete(_, Tipo))).

masAntiguo(Duenio, Anios, Nombre):-
    max_member(Maximo, Anios),
    duenio(Duenio, Nombre, Maximo).

%% Punto 3
superValioso(Nombre):-
    esDeColeccion(Juguete),
    nombreJuguete(Juguete, Nombre),
    tieneSusPartes(Juguete),
    esColeccionista(Coleccionista),
    not(duenio(Coleccionista, Nombre, _)).

nombreJuguete(juguete(_, Tipo), Nombre):-
    juguete(Nombre, Tipo).

tieneSusPartes(juguete(_, deAccion(_, Partes))):-
    findall(Parte, (member(Parte, Partes), esOriginal(Parte)), PartesOriginales),
    not(length(PartesOriginales, 0)).
tieneSusPartes(juguete(_, caraDePapa(Partes))):-
    findall(Parte, (member(Parte, Partes), esOriginal(Parte)), PartesOriginales),
    not(length(PartesOriginales, 0)).

tieneSusPartes(juguete(_, deTrapo(_))).
tieneSusPartes(juguete(_, miniFiguras(_, _))).

esOriginal(original(_)).

%% Punto 4
duoDinamico(Duenio, Nombre1, Nombre2):-
    duenio(Duenio, Nombre1, _),
    duenio(Duenio, Nombre2, _),
    Nombre1 \= Nombre2,
    hacenBuenaPareja(Nombre1, Nombre2).

hacenBuenaPareja(woody, buzz).
hacenBuenaPareja(buzz, woody).
hacenBuenaPareja(Nombre1, Nombre2):-
    juguete(Nombre1, Tipo1),
    juguete(Nombre2, Tipo2),
    tematica(juguete(_, Tipo1), Tematica1),
    tematica(juguete(_, Tipo2), Tematica2),
    Tematica1 == Tematica2.