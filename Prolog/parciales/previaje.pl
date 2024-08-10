comercioAdherido(iguazu, grandHotelIguazu).
comercioAdherido(iguazu, gargantaDelDiabloTour).
comercioAdherido(bariloche, aerolineas).
comercioAdherido(iguazu, aerolineas).

factura(pablo, hotel(gguazu, 1000000)).
factura(pablo, carrera(motoGP)).
factura(pablo, carrera(formulaUno)).
factura(estanislao, hotel(grandHotelIguazu, 2000)).
factura(antonieta, excursion(gargantaDelDiabloTour, 5000, 4)).
factura(antonieta, vuelo(1515, antonietaPerez)).
valorMaximoHotel(5000).

registroVuelo(1515, iguazu, aerolineas, [estanislaoGarcia,
antonietaPerez, danielIto], 10000).

devolverMonto(Persona, Devolucion):-
    distinct(Persona, factura(Persona, _)),
    findall(Factura, distinct(Factura, facturaCheck(Persona, Factura)), Facturas),
    findall(Monto, (member(Evento, Facturas), calcularDevolucion(Evento, Monto)), Montos),
    sumlist(Montos, SumaMontos),
    distinct(Facturas, sumarAdicionales(Facturas, SumaMontos, SumaTotal)),
    distinct(Persona, penalizar(Persona, Facturas, SumaTotal, MontoFinal)),
    distinct(MontoFinal, limitarMonto(MontoFinal, Devolucion)).

facturaCheck(Persona, Factura):-
    factura(Persona, Factura),
    esValida(Factura).

esValida(hotel(Comercio, _)):-
    comercioAdherido(_, Comercio).
esValida(excursion(Comercio, _, _)):-
    comercioAdherido(_, Comercio).
esValida(vuelo(NroVuelo, _)):-
    registroVuelo(NroVuelo, Destino, Comercio, _, _), 
    comercioAdherido(Destino, Comercio).
esValida(hotel(_, Precio)):-
    valorMaximoHotel(PrecioMaximo),
    not(Precio > PrecioMaximo).
esValida(vuelo(NroVuelo, Persona)):-
    registroVuelo(NroVuelo, _, _, Personas, _),
    member(Persona1, Personas),
    string_chars(Persona1, NombreCompleto), 
    string_chars(Persona, Nombre),
    forall(member(Letra, Nombre), member(Letra, NombreCompleto)),
    length(NombreCompleto, X),
    length(Nombre, Y),
    X > Y.

calcularDevolucion(hotel(_, Precio), Monto):-
    Monto is Precio / 2.
calcularDevolucion(vuelo(_, buenosAires), 0).
calcularDevolucion(vuelo(NroVuelo, _), Monto):-
    registroVuelo(NroVuelo, _, _, _, Precio),
    Monto is Precio * (3/10).
calcularDevolucion(excursion(_, Precio, CantPersonas), Monto):-
    Monto is (Precio / CantPersonas) * (8/10).

sumarAdicionales(Facturas, SumaMontos, MontoTotal):-
    findall(Destino, (member(Factura, Facturas), destino(Factura, Destino)), Destinos),
    list_to_set(Destinos, DestinosUnicos),
    length(DestinosUnicos, Multiplicador),
    MontoTotal is SumaMontos + (1000 * Multiplicador).
sumarAdicionales(_, _, _).

destino(hotel(Lugar, _), Destino):-
    comercioAdherido(Destino, Lugar).
destino(excursion(Lugar, _, _), Destino):-
    comercioAdherido(Destino, Lugar).
destino(vuelo(NroVuelo, _), Destino):-
    registroVuelo(NroVuelo, Destino, _, _, _),
    comercioAdherido(Destino, _).

penalizar(Persona, FacturasValidas, Monto, MontoFinal):-
    findall(Factura, factura(Persona, Factura), FacturasTotales),
    length(FacturasTotales, X),
    length(FacturasValidas, X),
    MontoFinal is Monto.
penalizar(_, _, Monto, MontoFinal):-
    Monto > 15000,
    MontoFinal is Monto - 15000.
penalizar(_, _, _, 0).
    
limitarMonto(Monto, Devolucion):-
    not(Monto > 100000),
    Devolucion is Monto.
limitarMonto(_, 100000).

%% Punto 2
destinoDeTrabajo(Destino):-
    comercioAdherido(Destino, _),
    registroVuelo(_, Destino, _, _, _),
    esTrabajo(Destino).

esTrabajo(Destino):-
    forall(comercioAdherido(Destino, Lugar), not(factura(_, hotel(Lugar, _)))).
esTrabajo(Destino):-
    findall(Lugar, (comercioAdherido(Destino, Lugar), factura(_, hotel(Lugar, _))), Hoteles),
    length(Hoteles, 1).

%% Punto 3
esEstafador(Persona):-
    distinct(Persona, factura(Persona, _)),
    estafa(Persona).
    
estafa(Persona):-
    forall(factura(Persona, Factura), not(facturaCheck(Persona, Factura))).
estafa(Persona):-
    devolverMonto(Persona, 0).