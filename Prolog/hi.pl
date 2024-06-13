% Definir relaciones de parentesco
padre(juan, maria).
padre(pablo, juan).
padre(pablo, annette).

% Regla para determinar si alguien es abuelo de alguien
abuelo(X, Y) :-
    padre(X, Z),  % X es padre de Z
    padre(Z, Y).  % Z es padre de Y