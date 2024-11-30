% Punto 1
atiendeEl(dodain, lunes, 9, 15).
atiendeEl(dodain, miercoles, 9, 15).
atiendeEl(dodain, viernes, 9, 15).
atiendeEl(lucas, martes, 10, 20).
atiendeEl(juanC, sabado, 18, 22).
atiendeEl(juanC, domingo, 18, 22).
atiendeEl(juanFdS, jueves, 10, 20).
atiendeEl(juanFdS, viernes, 12, 20).
atiendeEl(leoC, lunes, 14, 18).
atiendeEl(leoC, miercoles, 14, 18).
atiendeEl(martu, miercoles, 23, 24).
atiendeEl(vale, Dia, HoraInicio, HoraFin):-
    atiendeEl(dodain, Dia, HoraInicio, HoraFin).
atiendeEl(vale, Dia, HoraInicio, HoraFin):-
    atiendeEl(juanC, Dia, HoraInicio, HoraFin).

% Punto 2
atiende(Persona, Dia, Hora):-
    atiendeEl(Persona, Dia, HoraInicio, HoraFin),
    between(HoraInicio, HoraFin, Hora).

% Punto 3
atiendeSolo(Persona, Dia, Horario):-
    atiende(Persona, Dia, Horario),
    atiende(OtraPersona, Dia, Horario),
    not(OtraPersona \= Persona).

% Punto 4
seCruzan(Personas, Dia):-
    between(0, 24, Horario),
    findall(Persona, atiende(Persona, Dia, Horario), Personas).

% Punto 5
vendio(dodain, fecha(10, 08), golosina(1200)).
vendio(dodain, fecha(10, 08), golosina(50)).
vendio(dodain, fecha(10, 08), cigarrillo([jockey])).
vendio(dodain, fecha(12, 08), bebida(alcoholica, 8)).
vendio(dodain, fecha(12, 08), bebida(noAlcoholica, 1)).
vendio(dodain, fecha(12, 08), golosina(10)).
vendio(martu, fecha(12, 08), golosina(1000)).
vendio(martu, fecha(12, 08), cigarrillo([chesterfield, colorado, parisiennes])).
vendio(lucas, fecha(11, 08), golosina(600)).
vendio(lucas, fecha(18, 08), bebida(noAlcoholica, 2)).
vendio(lucas, fecha(18, 08), cigarrillo([derby])).

vendedorSuertudo(Persona):-
    distinct(Persona, vendio(Persona, _, Venta)),
    primerVenta(Persona, Venta),
    ventaImportante(Venta).

primerVenta(Persona, Venta):-
    findall(Fecha, vendio(Persona, Fecha, _), Fechas),
    fechaPrimerVenta(Fechas, Fecha),
    vendio(Persona, Fecha, Venta).

fechaPrimerVenta(Fechas, fecha(Dia, Mes)):-
    min_member(fecha(_, Mes), Fechas),
    min_member(fecha(Dia, Mes), Fechas).

ventaImportante(golosina(Valor)):-
    Valor > 100.
ventaImportante(cigarrillo(Marcas)):-
    length(Marcas, CantMarcas),
    CantMarcas > 2.
ventaImportante(bebida(alcoholica, _)).
ventaImportante(bebida(_, Cantidad)):-
    Cantidad > 5.