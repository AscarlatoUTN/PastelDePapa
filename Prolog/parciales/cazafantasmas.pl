%% Punto 1
% Cazafantasmas
cazafantasma(peter).
cazafantasma(egon).
cazafantasma(ray).
cazafantasma(winston).

% Herramientas
herramienta(egon, aspiradora(200)).
herramienta(egon, trapeador).
herramienta(peter, trapeador).
herramienta(winston, varitaDeNeutrones).

herramientasRequeridas(ordenarCuarto, alternativas([aspiradora(100), trapeador, plumero], [aspiradora(100), escoba])).
herramientasRequeridas(limpiarTecho, alternativas([escoba, pala], [aspiradora(200)])).
herramientasRequeridas(cortarPasto, alternativas([bordedadora], [bordeadora])).
herramientasRequeridas(limpiarBanio, alternativas([sopapa, trapeador], [sopapa])).
herramientasRequeridas(encerarPisos, alternativas([lustradpesora, cera, aspiradora(300)], [trapeador, escoba])).

%% Punto 2
tieneLoRequerido(Persona, Herramienta):-
    cazafantasma(Persona),
    controlDeAspiradora(Persona, Herramienta).

controlDeAspiradora(Persona, aspiradora(Y)):-
    herramienta(Persona, aspiradora(X)),
    X >= Y.
controlDeAspiradora(Persona, Herramienta):-
    herramienta(Persona, Herramienta).

%% Punto 3
realizarTarea(Persona, Tarea):-
    cazafantasma(Persona),
    herramientasRequeridas(Tarea, _),
    puedeRealizarla(Persona, Tarea).

puedeRealizarla(Persona, _):-
    herramienta(Persona, varitaDeNeutrones).
puedeRealizarla(Persona, Tarea):-
    findall(Herramienta, herramientasRequeridas(Tarea, alternativas(_, Herramienta)), HerramientasRequeridas),
    tieneLoRequerido(Persona, Herramienta),
    member(Herramienta, HerramientasRequeridas).
puedeRealizarla(Persona, Tarea):-
    findall(Herramienta, herramientasRequeridas(Tarea, alternativas(Herramienta, _)), HerramientasRequeridas),
    forall(member(Herramienta, HerramientasRequeridas), tieneLoRequerido(Persona, Herramienta)).

%% Punto 4 
% tarea(Tarea, Valor).
tarea(limpiarTecho, 15).
tarea(cortarPasto, 20).
tarea(ordenarCuarto, 10).
tarea(limpiarBanio, 5).
tarea(encerarPisos, 10).

% tareaPedida(Cliente, Tareas, Metros).
tareaPedida(ale, [limpiarTecho, cortarPasto], [15, 10]).

precio(tareaPedida(_, [], []), 0).
precio(tareaPedida(_, [Tarea|Tareas], [Metro|Metros]), PrecioTotal) :-
    tarea(Tarea, Valor),
    precio(tareaPedida(_, Tareas, Metros), PrecioRestante),
    PrecioTotal is PrecioRestante + Valor * Metro.

%% Punto 5
aceptaPedido(Persona, tareaPedida(Cliente, Tareas, Metros)):-
    cazafantasma(Persona),
    herramientasRequeridas(Tareas, alternativas(_, _)),
    forall(tareaPedida(Cliente, Tareas, _), realizarTarea(Persona, Tareas)),
    acepta(Persona, tareaPedida(Cliente, Tareas, Metros)).

acepta(peter, _).
acepta(ray, tareaPedida(_, Tareas, _)):-
    not(member(limpiarTecho, Tareas)).
acepta(winston, tareaPedida(_, Tareas, Metros)):-
    precio(tareaPedida(_, Tareas, Metros), Precio),
    Precio > 500.
acepta(egon, Tareas):-
    not(member(limpiarTecho, Tareas)),
    forall(member(Tarea, Tareas), (herramientasRequeridas(Tarea, Herramientas), length(Herramientas, X), X < 3)).

%% Punto 6
/*
Es fácil de incorporar en caso de poder aplicar este modelo a todas las tareas. Caso contrario, deberiamos verificar cuáles soportan este tipo de agregados y recién ahí determinar de que manera proceder.
*/