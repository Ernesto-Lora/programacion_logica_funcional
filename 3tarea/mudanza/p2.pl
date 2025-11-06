:- autoload(library(lists), [member/2]).

%%% --- Representación (Sin cambios) ---
mascota(hamster).
mascota(perro).
mascota(gato).

% 1. Renombramos el hecho base
juntos_hecho(perro, hamster).

% 2. Definimos la regla simétrica NO recursiva
pueden_juntos(X, Y) :- juntos_hecho(X, Y).
pueden_juntos(X, Y) :- juntos_hecho(Y, X).

seguro([]).
seguro([_]).
seguro([A,B]):- pueden_juntos(A,B).

%%% --- Búsqueda Primero en Profundidad (Modificada) ---

% Predicado principal para iniciar la búsqueda
encontrar_viaje(Solucion) :-
    estado_inicial(Inicio),
    solucion(Inicio, Solucion).

% El estado inicial es una lista vacía
estado_inicial([]).

% Caso base: El Nodo actual es la meta.
% La solución (Sol) es el propio nodo meta.
solucion(Nodo, Nodo) :-
    meta(Nodo).

% Caso recursivo: Encontrar un sucesor (Nodo1) y
% buscar la solución (Sol) a partir de ese sucesor.
solucion(Nodo, Sol) :-
    s(Nodo, Nodo1),
    solucion(Nodo1, Sol).

% s(Nodo, Nodo1): El sucesor (Nodo1) es el estado actual (Nodo)
% más una nueva mascota que no esté ya en la lista.
s(ListaActual, [MascotaNueva | ListaActual]) :-
    mascota(MascotaNueva),
    \+ member(MascotaNueva, ListaActual).

% meta(Nodo): El nodo es una meta si es una lista de 3 mascotas
% que cumple la condición de 'viaje'.
%
% Nota: La lista se construye en orden [Mascota3, Mascota2, Mascota1].
% Si el 'viaje' original era viaje([A, B, C]), nuestro estado meta
% será [C, B, A].
%
% La lógica de viaje([A,B,C]) era:
%   1. mascota(A) -> (Garantizado por s/2)
%   2. \+ member(A, [B,C]) -> (Garantizado por s/2, son todos distintos)
%   3. seguro([B,C]) -> (Esta es la única condición que debemos checar)
%
meta([_, B, C]) :-
    seguro([B, C]).

% El predicado 'viaje' original ya no se necesita,
% su lógica está integrada en 'meta/1'.
% viaje([A,B,C]):- seguro([B,C]), mascota(A),\+ member(A, [B,C]).








:- autoload(library(lists), [member/2]).

mascota(hamster).
mascota(perro).
mascota(gato).

juntos_hecho(perro, hamster).

pueden_juntos(X, Y) :- juntos_hecho(X, Y).
pueden_juntos(X, Y) :- juntos_hecho(Y, X).

movimiento(perro, ida).
movimiento(perro, vuelta).
movimiento(hamster, ida).
movimiento(hamster, vuelta).
movimiento(gato, ida).
movimiento(gato, vuelta).
movimiento(yo,ida).
movimiento(yo, vuelta).



seguro([]).
seguro([_]).
seguro([A,B]):- pueden_juntos(A,B).

estado_inicial([]).


solucion(Nodo, Nodo) :-
    meta(Nodo).


solucion(Nodo, Sol) :-
    s(Nodo, Nodo1),
    solucion(Nodo1, Sol).


s(ListaActual, [MascotaNueva | ListaActual]) :-
    mascota(MascotaNueva),
    \+ member(MascotaNueva, ListaActual).


meta([_, B, C]) :-
    seguro([B, C]).

encontrar_viaje(Solucion) :-
    estado_inicial(Inicio),
    solucion(Inicio, Solucion).