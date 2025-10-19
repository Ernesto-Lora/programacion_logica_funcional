progenitor(pam, bob).
progenitor(tom, bob).
progenitor(tom, liz).
progenitor(bob, ann).
progenitor(bob, pat).
progenitor(pat, jim).

mujer(pam).
mujer(liz).
mujer(ann).
mujer(pat).

hermana(X, Y) :-
    progenitor(Z, X),
    progenitor(Z, Y),
    mujer(X),
    X \= Y.

progenitor(Z, X), progenitor(Z, ann), mujer(X), X \= ann.