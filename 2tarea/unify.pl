
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Unification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We will implement the Robinson Algorithm (1965)
% It was one of the first algorithms
% It has the problem of exponential time and space complexity

% The first condition checks if T1 or T2 is a variable
% Then X will be the variable
% Checks if a term is a variable.

% Inside that condition. 
% If X and T are the same, then sigma will be [] 
% (Note: This comment referred to your original unify/3 predicate)

% If occurs_check(X,T) succeeds, it means we have something like X, f(X)

% Else, if occurs_check(X,T) succeeds, it means we have to check something like:
% X = 'X', T = f('X')
occurs_check(V, T) :- 
    var(T), 
    V == T, !.
occurs_check(V, T) :-
    \+ atomic(T), \+ var(T),
    T =.. [_ | Args],
    member(Arg, Args),
    occurs_check(V, Arg).

% Unification 

% Case 1: T1 and T2 are identical.
unify(T, T) :- !.

% Case 2: T1 is a variable.
unify(T1, T2) :- 
    var(T1), !, 
    \+ occurs_check(T1, T2), 
    T1 = T2.                 

% Case 3: T2 is a variable. (Symmetric to Case 2)
unify(T1, T2) :- 
    var(T2), !,
    \+ occurs_check(T2, T1),
    T2 = T1.                 

% Then, we create the rules for functions
% Assuming T1 = f(X1,..., Xn), T2 = g(Y1,..., Ym)

% We create the rule for when F = G and N = M (same functor and arity)
unify(T1,T2):-
    compound(T1),
    compound(T2),
    T1 =.. [F | Args1],
    T2 =.. [F | Args2],  
    unify_args(Args1, Args2).

% Case 5: T1 and T2 are different atomic terms (e.g., a, b)
unify(T1, T2) :-
    atomic(T1), atomic(T2),
    T1 \== T2, !, fail.

unify_args([], []).
unify_args([A1 | RestArgs1], [A2 | RestArgs2]) :-
    unify(A1, A2),
    unify_args(RestArgs1, RestArgs2).
