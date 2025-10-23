%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Permutations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

% We have to find the rules.
% With perms([1], L) → L = [[1]].
% We need a function such as:
% ?- choose([1,2,3], L).
% L = [2,3] ; [1,3] ; [1,2].

% Rule 1. The element to be omitted is the head.
choose([_|Xs], Xs).

% Rule 2. We omit the "second" element but keep the "first".
choose([X,Y|Xs], [X|L_rest]) :- choose([Y|Xs], L_rest).

% Helper: find which element was omitted.
omitted_element(Xs, Rest, X) :-
    choose(Xs, Rest),
    member(X, Xs),
    \+ member(X, Rest).

% Permutation using choose/2.
perms_find([], []).
perms_find(Xs, [X|Ps]) :-
    omitted_element(Xs, Rest, X),
    perms_find(Rest, Ps).

perms(X, L) :-
    findall(Y, perms_find(X, Y), L).
