% vocaloid(nombre, cancion(nombre, minutos))
vocaloid(megurineLuka, cancion(nightFever, 4)).
vocaloid(megurineLuka, cancion(foreverAlone, 5)).
vocaloid(hatsuneMiku, cancion(tellYourWorld, 4)).
vocaloid(gumi, cancion(foreverYoung, 4)).
vocaloid(gumi, cancion(tellYourWorld, 5)).
vocaloid(seeU, cancion(novemberRain, 6)).
vocaloid(seeU, cancion(nightFever, 5)).

% Punto 1
esNovedoso(Vocaloid):-
    distinct(Vocaloid, vocaloid(Vocaloid, _)),
    cantCanciones(Vocaloid, CantCanciones),
    CantCanciones >= 2,
    duracionTotalCanciones(Vocaloid, DuracionTotal),
    DuracionTotal < 15.

% Punto 2
esAcelerado(Vocaloid):-
    distinct(Vocaloid, vocaloid(Vocaloid, _)),
    findall(Minutos, vocaloid(Vocaloid, cancion(_, Minutos)), ListaMinutos),
    max_list(ListaMinutos, 4).

% concierto(nombre, pais, fama, tipo)
% concierto(nombre, pais, fama, gigante(minCanciones, duracionTotalMinima)).
% concierto(nombre, pais, fama, mediano(duracionTotalMaxima)).
% concierto(nombre, pais, fama, pequenio(duracionMinCancion)).

% Punto 2
concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

puedeParticipar(Vocaloid, Concierto):-
    distinct(Vocaloid, vocaloid(Vocaloid, _)),
    concierto(Concierto, _, _, TipoConcierto),
    cumpleRequisitoEvento(Vocaloid, TipoConcierto).

cumpleRequisitoEvento(hatsuneMiku, _).
cumpleRequisitoEvento(Vocaloid, gigante(MinCanciones, DuracionTotalMinima)):-
    cantCanciones(Vocaloid, CantCanciones),
    CantCanciones >= MinCanciones,
    duracionTotalCanciones(Vocaloid, DuracionTotal),
    DuracionTotal >= DuracionTotalMinima.
cumpleRequisitoEvento(Vocaloid, mediano(DuracionTotalMaxima)):-
    duracionTotalCanciones(Vocaloid, DuracionTotal),
    DuracionTotal < DuracionTotalMaxima.
cumpleRequisitoEvento(Vocaloid, pequenio(DuracionMinCancion)):-
    vocaloid(Vocaloid, cancion(_, Minutos)),
    Minutos > DuracionMinCancion.

cantCanciones(Vocaloid, CantCanciones):-
    findall(Cancion, vocaloid(Vocaloid, Cancion), Canciones),
    length(Canciones, CantCanciones).

duracionTotalCanciones(Vocaloid, DuracionTotal):-
    findall(Minutos, vocaloid(Vocaloid, cancion(_, Minutos)), TotalMinutos),    
    sum_list(TotalMinutos, DuracionTotal).

% Punto 3
masFamoso(Vocaloid):-
    findall(Fama, nivelFama(Vocaloid, Fama), Famosos),
    max_list(Famosos, FamaMaxima),
    nivelFama(Vocaloid, FamaMaxima).

nivelFama(Vocaloid, FamaVocaloid):-
    distinct(Vocaloid, vocaloid(Vocaloid, _)),
    findall(Fama, (puedeParticipar(Vocaloid, Concierto), fama(Concierto, Fama)), FamaPorConcierto),
    sum_list(FamaPorConcierto, FamaCantante),
    cantCanciones(Vocaloid, CantCanciones),
    FamaVocaloid is FamaCantante * CantCanciones.

fama(Concierto, Fama):-
    concierto(Concierto, _, Fama, _).

% Punto 4
conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(seeU, kaito).

unicoParticipante(Vocaloid, Concierto):-
    distinct(Vocaloid, vocaloid(Vocaloid, _)),
    concierto(Concierto, _, _, _),
    ningunConocidoParticipa(Vocaloid, Concierto).

ningunConocidoParticipa(Vocaloid, Concierto):-
    forall(conoce(Vocaloid, Conocido), (not(puedeParticipar(Conocido, Concierto)), (not(conoce(Conocido, _)) ; ningunConocidoParticipa(Conocido, Concierto)))).