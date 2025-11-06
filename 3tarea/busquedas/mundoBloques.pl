%%% Sucesor y meta en el mundo de los bloques

s(Pilas, [Pila1, [Tope1|Pila2] | OtrasPilas ]) :-
    quitar([Tope1|Pila1], Pilas, Pilas1),
    quitar(Pila2, Pilas1, OtrasPilas).

quitar(X, [X|Ys], Ys).
quitar(X, [Y|Ys], [Y|Ys1]) :-
    quitar(X,Ys,Ys1).

meta(Estado) :-
    member([a,b,c],Estado).

%%% Imprime estados

impr_edos([]) :- write('Fin'),nl.
impr_edos([Edo|Edos]) :- write(Edo),nl,impr_edos(Edos).
