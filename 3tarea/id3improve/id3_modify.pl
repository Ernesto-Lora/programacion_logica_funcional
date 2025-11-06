:-  dynamic
       ejemplo/3,
       nodo/3.

%%% id3.pl
%%% Una implementación de ID3 en Prolog.
%%% MODIFICADO para usar Gain

id3(ArchCSV) :- id3(ArchCSV,1). % Umbral = 1, por default.

id3(ArchCSV,Umbral) :-
    reset,
    cargaEjs(ArchCSV,Atrs),
    findall(N,ejemplo(N,_,_),Inds), % Obtiene índices de los ejemplos
    induce(Inds,raiz,Atrs,Umbral),
    imprimeArbol, !.

% Caso 1.
induce(Ejs,Padre,_,Umbral) :-
    length(Ejs,NumEjs),
    NumEjs=<Umbral,
    distr(Ejs, Distr),
    assertz(nodo(hoja,Distr,Padre)), !. 

% Caso 2.
induce(Ejs,Padre,_,_) :-
    distr(Ejs, [Clase]),
    assertz(nodo(hoja,[Clase],Padre)).

% Caso 3.
induce(Ejs,Padre,Atrs,Umbral) :- 
    eligeAtr(Ejs,Atrs,Atr,Vals,Resto), !,
    particion(Vals,Atr,Ejs,Padre,Resto,Umbral).

% Caso 4.
induce(Ejs,Padre,_,_) :- !,
    nodo(Padre,Test,_),
    write('Datos inconsistentes: no es posible construir partición de '),
    write(Ejs), write(' en el nodo '), writeln(Test). 

%%%%%%%% MODIFICACION USANDO EL GAIN RATIO 

% eligeAtr(Ejs, Atrs, MejorAtr, MejorVals, RestoAtrs)
% Predicado principal para elegir el atributo.
% Falla si la lista de Atrs está vacía, 
% lo cual es correcto (lo captura el Caso 4 de induce).

eligeAtr(Ejs, [PrimerAtr|RestoAtrs], MejorAtr, MejorVals, RestoFinal) :-
    length(Ejs, NumEjs),
    contenidoInformacion(Ejs, NumEjs, InfoTotal),

    % Calcular ganancia para el primer atributo
    calcular_gain_ratio(PrimerAtr, Ejs, NumEjs,
         InfoTotal, ValsPrimer, GainRatioPrimer),
    
    % Inicializar el "mejor" con el primero
    % Guardamos (GainRatio, Atributo, Valores)
    MejorInicial = (GainRatioPrimer, PrimerAtr, ValsPrimer),

    % Recorrer el resto de atributos, comparando con el mejor inicial
    buscar_mejor(RestoAtrs, Ejs, NumEjs, InfoTotal, MejorInicial, MejorFinal),

    % Extraer los resultados finales
    MejorFinal = (_MejorGain, MejorAtr, MejorVals),
    
    quita_elemento(MejorAtr, [PrimerAtr|RestoAtrs], RestoFinal),
    !.

% buscar_mejor(AtributosRestantes, 
%       Ejs, NumEjs, InfoTotal, MejorAcumulado, MejorFinal)
% Caso base: No hay más atributos para comparar, el Acumulado es el mejor.
buscar_mejor([], _, _, _, MejorAcumulado, MejorAcumulado) :- !.

% Caso recursivo:
buscar_mejor([AtrActual|RestoAtrs],
     Ejs, NumEjs, InfoTotal, MejorAcumulado, MejorFinal) :-
    % Calcular ganancia del atributo actual
    calcular_gain_ratio(AtrActual, Ejs, NumEjs,
         InfoTotal, ValsActual, GainRatioActual),
    
    % Obtener el "mejor" gain guardado
    MejorAcumulado = (MejorGain, _, _),

    % Comparar
    ( GainRatioActual > MejorGain ->
        % El actual es mejor, actualizar el acumulador
        NuevoMejor = (GainRatioActual, AtrActual, ValsActual)
    ;
        % El acumulado sigue siendo el mejor
        NuevoMejor = MejorAcumulado
    ),
    
    % Continuar con el resto de la lista
    buscar_mejor(RestoAtrs, Ejs, NumEjs,
         InfoTotal, NuevoMejor, MejorFinal).

% Helper para calcular el Gain Ratio de un solo atributo
calcular_gain_ratio(Atr, Ejs, NumEjs,
     InfoTotal, Vals, GainRatio) :-
    % Usamos la nueva versión de vals/4
    vals(Ejs, Atr, [], Vals),
    separaEnSubConjs(Vals, Ejs, Atr, Partes),
    informacionResidual(Partes, NumEjs, InfoRes),
    Gain is InfoTotal - InfoRes,
    intrinsicValue(Partes, NumEjs, IV),
    ( IV =:= 0 ->
        GainRatio = 0
    ;
        GainRatio is Gain / IV
    ).

% Separa en sub-conjuntos
separaEnSubConjs([], _Ejs, _Atr, []) :- !.
separaEnSubConjs([Val|Vals], Ejs, Atr, [Parte|Partes]) :-
    % Usamos la nueva versión de subconj/3
    subconj(Ejs, Atr=Val, Parte),
    separaEnSubConjs(Vals, Ejs, Atr, Partes).

% información residual
informacionResidual([], _, 0) :- !.
informacionResidual([Parte|Partes], NumEjs, IR) :-
    length(Parte, NumEjsParte),
    ( NumEjsParte =:= 0 -> IParte = 0 ;
         contenidoInformacion(Parte, NumEjsParte, IParte) ),
    informacionResidual(Partes, NumEjs, IRresto),
    IR is IRresto + IParte * (NumEjsParte / NumEjs).

% --- intrinsic value (split information) 
intrinsicValue(Partes, NumEjs, IV) :-
    sumaTerminosIV(Partes, NumEjs, IV).

sumaTerminosIV([], _NumEjs, 0) :- !.
sumaTerminosIV([Parte|Partes], NumEjs, IVtotal) :-
    length(Parte, NumEjsParte),
    ( NumEjsParte =:= 0 ->
        Termino = 0
    ;
        Prob is NumEjsParte / NumEjs,
        Termino is - Prob * (log(Prob) / log(2))
    ),
    sumaTerminosIV(Partes, NumEjs, Resto),
    IVtotal is Resto + Termino.

quita_elemento(X, [X|Resto], Resto) :- !.
quita_elemento(X, [Y|Resto], [Y|RestoSin]) :-
    quita_elemento(X, Resto, RestoSin).

%%%%%%%%%%%%% FIN MODIFICACION


contenidoInformacion(Ejs,NumEjs,I) :-
    setof(Clase,Ej^AVs^(member(Ej,Ejs),ejemplo(Ej,Clase,AVs)),Clases), !,
    sumaTerms(Clases,Ejs,NumEjs,I).

sumaTerms([],_,_,0) :- !.
sumaTerms([Clase|Clases],Ejs,NumEjs,Info) :-
    findall(Ej,(member(Ej,Ejs),ejemplo(Ej,Clase,_)),EjsEnClase),
    length(EjsEnClase,NumEjsEnClase),
    sumaTerms(Clases,Ejs,NumEjs,I),
    ( NumEjsEnClase =:= 0 -> 
        Termino is 0
    ;
        Prob is NumEjsEnClase/NumEjs,
        Termino is - Prob * (log(Prob) / log(2))
    ),
    Info is I + Termino.

% --- Versión simplificada de vals/4 ---
% El predicado original era correcto, pero este es más estándar en Prolog.
% El '[]' en la 3ra posición es para mantener la firma (lo que espera la llamada)
vals(Ejs, Atr, [], Vals) :-
    findall(V, (member(Ej, Ejs), ejemplo(Ej, _, AVs), member(Atr=V, AVs)), ListaConDuplicados),
    sort(ListaConDuplicados, Vals). % sort/2 elimina duplicados

% --- Versión simplificada de subconj/3 ---
subconj(Ejs, AtrVal, SubEjs) :-
    findall(Ej,
            (member(Ej, Ejs), ejemplo(Ej, _, AVs), member(AtrVal, AVs)),
            SubEjs).

% particion(+Vals,+Atr,+Ejs,+Padre,+Resto,+Umbral)
particion([],_,_,_,_,_) :- !.
particion([Val|Vals],Atr,Ejs,Padre,RestoAtrs,Umbral) :-
    % subconj/3 ahora es el predicado simplificado
    subconj(Ejs,Atr=Val,SubEjs), !,
    generaNodo(Nodo), 
    assertz(nodo(Nodo,Atr=Val,Padre)),
    induce(SubEjs,Nodo,RestoAtrs,Umbral), !,
    particion(Vals,Atr,Ejs,Padre,RestoAtrs,Umbral).

%%% distr(+Ejs,-DistrClaseEjs)
distr(Ejs,DistClaseEjs) :-
    setof(Clase,Ej^AVs^(member(Ej,Ejs),ejemplo(Ej,Clase,AVs)),Clases),
    cuentaClases(Clases,Ejs,DistClaseEjs).

cuentaClases([],_,[]) :- !.
cuentaClases([Clase|Clases],Ejs,[Clase/NumEjsEnClase|RestoCuentas]) :-
    findall(Ej,(member(Ej,Ejs),ejemplo(Ej,Clase,_)),EjsEnClase),
    length(EjsEnClase,NumEjsEnClase), !,
    cuentaClases(Clases,Ejs,RestoCuentas).

/*--------------------- Imprime Arbol --------------------*/

imprimeArbol :-
    imprimeArbol(raiz,0).

imprimeArbol(Padre,_) :- 
    nodo(hoja,Clase,Padre), !,
    write(' => '),write(Clase).

imprimeArbol(Padre,Pos) :-
    findall(Hijo,nodo(Hijo,_,Padre),Hijos),
    Pos1 is Pos+2,
    imprimeLista(Hijos,Pos1).

imprimeLista([],_) :- !.

imprimeLista([N|T],Pos) :-
    nodo(N,Test,_),
    nl, tab(Pos), write(Test),
    imprimeArbol(N,Pos),
    imprimeLista(T,Pos).

/*------------------- Auxiliares --------------------------*/

generaNodo(M) :-
    retract(id(N)),
    M is N+1,
    assertz(id(M)), !.

generaNodo(1) :-
    assertz(id(1)).

eliminar(X,[X|T],T) :- !.

eliminar(X,[Y|T],[Y|Z]) :-
   eliminar(X,T,Z).

subconjunto([],_) :- !.

subconjunto([X|T],L) :-
    member(X,L), !,
    subconjunto(T,L).

maximo([X],X) :- !.
maximo([X/M|T],Y/N) :-
    maximo(T,Z/K),
    (M>K,Y/N=X/M ; Y/N=Z/K), !.

% elimina las ocurrencias de ejemplo y nodo en el espacio de trabajo

reset :-
    retractall(ejemplo(_,_,_)),
    retractall(nodo(_,_,_)),
    retractall(id(_)).

/*----------------------- Lectura y Procesamiento de CSV --------------------------*/

cargaEjs(ArchCSV,Atrs) :-
    csv2prolog(ArchCSV,Atrs,Ejs),
    maplist(assertz,Ejs).

csv2prolog(ArchCSV,Atrs,Ejs) :-
    leeCSV(ArchCSV,Atrs,EjsCSV),
    butlast(Atrs,AtrsSinClase),
    procEjs(1,AtrsSinClase,EjsCSV,Ejs).

procEjs(_,_,[],[]).

procEjs(Ind,AtrsSinClase,[Ej|Ejs],[ejemplo(Ind,Clase,EjAtrsVals)|Resto]) :-
    last(Ej,Clase),
    butlast(Ej,EjSinClase),
    maplist(procAtrVal,AtrsSinClase,EjSinClase,EjAtrsVals),
    IndAux is Ind + 1,
    procEjs(IndAux,AtrsSinClase,Ejs,Resto).

procAtrVal(Atr,Val,Atr=Val).

leeCSV(ArchCSV,Atrs,Ejs) :-
    csv_read_file(ArchCSV,[AtrsAux|EjsAux], [strip(true)]),
    AtrsAux =.. [_|Atrs],
    maplist(procEj,EjsAux,Ejs).

procEj(Ej,Args) :-
    Ej =.. [_|Args].

last([],[]).
last(L,E) :-
    append(_,[E],L).

butlast([],[]).
butlast(L1,L2) :-
    last(L1,Last),
    append(L2,[Last],L1).