% resultado(UnPais, GolesDeUnPais, OtroPais, GolesDeOtroPais).
resultado(paises_bajos, 3, estados_unidos, 1).
resultado(australia, 1, argentina, 2).
resultado(polonia, 1, francia, 1).
resultado(inglaterra, 3, senegal, 0).

pronostico(juan, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(juan, gano(argentina, australia, 3, 0)).
pronostico(juan, empataron(inglaterra, senegal, 0)).
pronostico(gus, gano(estados_unidos, paises_bajos, 1, 0)).
pronostico(gus, gano(japon, croacia, 2, 0)).
pronostico(lucas, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(lucas, gano(argentina, australia, 2, 0)).
pronostico(lucas, gano(croacia, japon, 1, 0)).

%% Punto 1
jugaron(Pais1, Pais2, Diferencia):-
    resultado(Pais1, Goles1, Pais2, Goles2),
    abs((Goles1 - Goles2), Diferencia).
jugaron(Pais1, Pais2, Diferencia):-
    resultado(Pais2, Goles2, Pais1, Goles1),
    abs((Goles1 - Goles2), Diferencia).

gano(Pais1, Pais2, Ganador):-
    resultado(Pais1, Goles1, Pais2, Goles2),
    Goles1 > Goles2,
    Ganador = Pais1.
gano(Pais1, Pais2, Ganador):-
    resultado(Pais1, Goles1, Pais2, Goles2),
    Goles2 > Goles1,
    Ganador = Pais2.
gano(Pais2, Pais1, Ganador):-
    resultado(Pais1, Goles1, Pais2, Goles2),
    Goles1 > Goles2,
    Ganador = Pais1.
gano(Pais2, Pais1, Ganador):-
    resultado(Pais1, Goles1, Pais2, Goles2),
    Goles2 > Goles1,
    Ganador = Pais2.

%% Punto 2 (no del todo inversible, hay que ignorar el caso default, pero anda bien)
puntosPronostico(Pronostico, Puntos):-
    pronostico(_, Pronostico),
    pegoResultado(Pronostico, Puntos).

pegoResultado(gano(Pais1, Pais2, Goles1, Goles2), Puntos):-
    gano(Pais1, Pais2, Ganador),
    Ganador == Pais1,
    pegoGoles(gano(Pais1, Pais2, Goles1, Goles2), Puntaje),
    Puntos is Puntaje + 100.
pegoResultado(empataron(Pais1, Pais2, Goles), Puntos):-
    resultado(Pais1, Goles1, Pais2, Goles2),
    Goles1 == Goles2,
    pegoGoles(empataron(Pais1, Pais2, Goles), Puntaje),
    Puntos is Puntaje + 100.
pegoResultado(_, 0).
    
pegoGoles(gano(Pais1, Pais2, Goles1, Goles2), Puntos):-
    resultado(Pais1, Goles1, Pais2, Goles2),
    Puntos = 100.
pegoGoles(empataron(Pais1, Pais2, Goles), Puntos):-
    resultado(Pais1, Goles, Pais2, Goles),
    Puntos = 100.
pegoGoles(_, 0).

%% Punto 3
invicto(Jugador):-
    pronostico(Jugador, _),
    findall(Pronostico, (pronostico(Jugador, Pronostico), seJugo(Pronostico)), Pronosticos),
    forall(member(Pronostico, Pronosticos), esInvicto(Pronostico)).

seJugo(gano(Pais1, Pais2, _, _)):-
    jugaron(Pais1, Pais2, _).
seJugo(empataron(Pais1, Pais2, _)):-
    jugaron(Pais1, Pais2, _).

esInvicto(Pronostico):-
    puntosPronostico(Pronostico, Puntos),
    Puntos >= 100.

%% Punto 4
puntaje(Jugador, Puntaje):-
    pronostico(Jugador, _),
    findall(Pronostico, pronostico(Jugador, Pronostico), Pronosticos),
    obtenerPuntaje(Pronosticos, Puntaje).

obtenerPuntaje([], 0).
obtenerPuntaje([Pronostico|Pronosticos], Puntaje):-
    puntosPronostico(Pronostico, Puntos),
    obtenerPuntaje(Pronosticos, Puntuacion),
    Puntaje is Puntuacion + Puntos.

%% Punto 5
favorito(Pais):-
    forall(jugaron(Pais, _, Diferencia), Diferencia >= 3).
favorito(Pais):-
    findall(Pronostico, pronostico(_, Pronostico), Pronosticos),
    forall(member(Pronostico, Pronosticos), esFavorito(Pais, Pronostico)).
    
esFavorito(Pais, gano(Pais, _, _, _)).
esFavorito(Pais, gano(Pais1, Pais2, _, _)):-
    Pais \= Pais1,
    Pais \= Pais2.
esFavorito(Pais, empataron(Pais1, Pais2, _)):-
    Pais \= Pais1,
    Pais \= Pais2.