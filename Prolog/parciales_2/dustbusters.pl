% cazafantasma(peter).
% cazafantasma(egon).
% cazafantasma(ray).
% cazafantasma(winston).

% herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
% herramientasRequeridas(limpiarTecho, [escoba, pala]).
% herramientasRequeridas(cortarPasto, [bordedadora]).
% herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
% herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

% % Punto 1
% tiene(egon, aspiradora(200)).
% tiene(egon, trapeador).
% % tiene(egon, sopapa).
% tiene(peter, trapeador).
% tiene(winston, varitaDeNeutrones).

% % Punto 2
% satisfaceNecesidad(Persona, Tarea):-
%     cazafantasma(Persona),
%     herramientasRequeridas(Tarea, Herramientas),
%     forall(member(Herramienta, Herramientas), tieneHerramienta(Persona, Herramienta)).

% tieneHerramienta(Persona, aspiradora(PotenciaRequerida)):-
%     tiene(Persona, aspiradora(PotenciaActual)),
%     PotenciaActual > PotenciaRequerida.
% tieneHerramienta(Persona, Herramienta):-
%     tiene(Persona, Herramienta).

% % Punto 3

% puedeRealizarTarea(Persona, Tarea):-
%     cazafantasma(Persona),
%     herramientasNecesarias(Persona, Tarea).

% herramientasNecesarias(Persona, Tarea):-
%     (tiene(Persona, varitaDeNeutrones) ; satisfaceNecesidad(Persona, Tarea)).

% % Punto 4

% % tareaPedida(Cliente, tarea(Tarea, CantMetros), Precio):-
% %     herramientasNecesarias(Tarea, _),
% %     precio(CantMetros, PrecioInicial),
% %     PrecioInicial * CantMetros

% % precio(Tarea, Precio):-

% % Punto 5

% aceptaPedido(Pedido, Persona):-
%     forall(member(Tarea, Pedido), satisfaceNecesidad(Persona, Tarea)),
%     loAcepta(Persona, Pedido).

% loAcepta(ray, Pedido):-
%     not(member(limpiarTecho, Pedido)).
% loAcepta(winston, Pedido):-
%     cobrarPedido(Pedido, Costo),
%     Costo > 500.
% loAcepta(egon, Pedido):-
%     forall(member(Tarea, Pedido), not(esCompleja(Tarea))).

% esCompleja(limpiarTecho).
% esCompleja(Tarea):-
%     herramientasNecesarias(Tarea, Herramientas),
%     length(Herramientas, Size),
%     Size > 2.