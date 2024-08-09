%% Punto 1
atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).
atiende(lucas, martes, 10, 20).
atiende(juanC, sabado, 18, 22).
atiende(juanC, domingo, 18, 22).
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).
atiende(martu, miercoles, 23, 24).
atiende(vale, Dia, Inicio, Fin):-
    atiende(dodain, Dia, Inicio, Fin).
atiende(vale, Dia, Inicio, Fin):-
    atiende(juanC, Dia, Inicio, Fin).

%% Punto 2
quienAtiende(Persona, Dia, Hora):-
    atiende(Persona, Dia, Inicio, Fin),
    between(Inicio, Fin, Hora).

%% Punto 3
foreverAlone(Persona, Dia, Hora):- % No funca con dodain y vale
    distinct(Persona, atiende(Persona, _, _, _)),
    findall(Alguien, quienAtiende(Alguien, Dia, Hora), Personas),
    not(length(Personas, 0)),
    subtract(Personas, [Persona], []).

%% Punto 4
quienAtiendeHoy(Dia, Personas):-
    between(0, 24, Hora),
    findall(Persona, distinct(Persona, quienAtiende(Persona, Dia, Hora)), Personas).

%% Punto 5
% venta(golosina(Valor)).
% venta(cigarrillo(Marca)).
% venta(bebida(Alcoholica, Cantidad)).

venta(dodain, fecha(lunes, 10, agosto), golosina(1200)).
venta(dodain, fecha(lunes, 10, agosto), cigarrillo([jockey])).
venta(dodain, fecha(lunes, 10, agosto), golosina(50)).
venta(dodain, fecha(miercoles, 12, agosto), bebida(alcoholica, 8)).
venta(dodain, fecha(miercoles, 12, agosto), bebida(noAlcoholica, 1)).
venta(dodain, fecha(miercoles, 12, agosto), golosina(10)).
venta(martu, fecha(miercoles, 12, agosto), golosina(1000)).
venta(martu, fecha(miercoles, 12, agosto), cigarrillo([chesterfield, colorado, parisiennes])).
venta(lucas, fecha(martes, 11, agosto), golosina(600)).
venta(lucas, fecha(martes, 18, agosto), bebida(noAlcoholica, 2)).
venta(lucas, fecha(martes, 18, agosto), cigarrillo([derby])).

esSuertudo(Persona):-
    distinct(Persona, venta(Persona, _, _)),
    findall(Venta, distinct(Fecha, venta(Persona, Fecha, Venta)), VentasFinal),
    forall(member(Venta, VentasFinal), esImportante(Venta)).

esImportante(golosina(Precio)):-
    Precio > 100.
esImportante(cigarrillo(Marcas)):-
    length(Marcas, Cant),
    Cant > 2.
esImportante(bebida(alcoholica, _)).
esImportante(bebida(_, Cant)):-
    Cant > 5.