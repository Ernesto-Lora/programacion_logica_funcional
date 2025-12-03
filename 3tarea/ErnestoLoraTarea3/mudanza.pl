:- autoload(library(lists), [member/2, select/3]).

mascota(hamster).
mascota(perro).
mascota(gato).

juntos_hecho(perro, hamster).

pueden_juntos(X, Y) :- juntos_hecho(X, Y).
pueden_juntos(X, Y) :- juntos_hecho(Y, X).

% una_lista_es_insegura(Mascotas)
% Mascotas es una lista. X va a "sacar" una mascota de la lista
% y el resto se va a guardar en Resto.
% "Y" va a ser otra mascota del Resto.
% Regresa True si la combinación es **insegura**.
una_lista_es_insegura(Mascotas) :-
    select(X, Mascotas, Resto), 
    member(Y, Resto),           
    \+ pueden_juntos(X, Y).    


% Nos dice que la lista Mascotas es **segura**.
seguro(Mascotas) :-
    \+ una_lista_es_insegura(Mascotas).
    

% Situacion/3 va a tener como primer argumento una lista
% la cual va a significar las mascotas que están en la **casa vieja**.
% Como segundo argumento las mascotas que están en la **casa nueva**.
% Como tercer argumento es dónde me ubico yo.

estado_inicial(situacion([gato,hamster,perro], [], vieja)).
meta(situacion([], [gato,hamster,perro], nueva)).



% transicion(SituacionAnterior, AccionRealizada, SituacionSiguiente)

% 1. Mover una mascota de casaVieja a casaNueva
% El tercer argumento en la SituacionVieja siempre va a ser **vieja**
% ya que de ahí me estoy moviendo.
% Por lo tanto, en SituacionSiguiente va a ser **nueva**.

transicion( situacion(AnteriorVieja, AnteriorNueva, vieja),  
            accion(Mascota, ida),                  
            situacion(SiguienteVieja, SiguienteNueva, nueva) ) :- 
    mascota(Mascota),
    select(Mascota, AnteriorVieja, SiguienteVieja),  
    % Elige una mascota y la pasa a la casa nueva
    seguro(SiguienteVieja),                   
    % Ve si ahora la casa vieja es segura 
    sort([Mascota | AnteriorNueva], SiguienteNueva). 
    % Agrega la mascota a la casa nueva

% 2. Moverme yo
% Solo tiene sentido regresarme yo solo de la casa Nueva a la Vieja.

transicion( situacion(Vieja, Nueva, nueva),    
                % Situación Anterior
            accion(yo, vuelta),           
            % Acción que se toma
            situacion(Vieja, Nueva, vieja) ) :- 
                % Situación Siguiente
    seguro(Nueva).

% 3. Mover una mascota de nueva a vieja (vuelta).
% Simétrico al caso uno (mover de vieja a nueva, pero en dirección opuesta).
transicion( situacion(AnteriorVieja, AnteriorNueva, nueva), 
            accion(Mascota, vuelta),             
            situacion(SiguienteVieja, SiguienteNueva, vieja) ) :- 
    mascota(Mascota),
    select(Mascota, AnteriorNueva, SiguienteNueva),
    seguro(SiguienteNueva),                    
    sort([Mascota | AnteriorVieja], SiguienteVieja).


% Búsqueda en profundidad

% solucion(SituacionActual, Visitados, ListaDeAccionesResultante)

% Caso Base: Si la 'Situacion' actual es la meta, terminamos.
solucion(Situacion, _Visitados, []) :-
    meta(Situacion).

% Caso Recursivo
solucion(SituacionActual, Visitados, [Accion | RestoSolucion]) :-
    
    % 1. Genera una transición válida
    transicion(SituacionActual, Accion, SituacionSiguiente),
    
    % 2. Evitar ciclos
    \+ member(SituacionSiguiente, Visitados),
    
    % 3. Resolver recursivamente desde la nueva situación
    solucion(SituacionSiguiente,
         [SituacionSiguiente | Visitados], RestoSolucion).


% Inicializa con la situación inicial y encuentra el resultado.
encontrar_viaje(Solucion) :-
    estado_inicial(Inicio),
    solucion(Inicio, [Inicio], Solucion).