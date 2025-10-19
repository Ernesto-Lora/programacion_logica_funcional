loc_en(atlanta,georgia).
loc_en(houston,texas).
loc_en(austin,texas).
loc_en(boston,massachussets).
loc_en(xalapa,veracruz).
loc_en(veracruz,veracruz).

loc_en(X, mexico):-loc_en(X,veracruz).
loc_en(X, usa):-loc_en(X,massachussets).
loc_en(X, usa):-loc_en(X,texas).
loc_en(X, usa):-loc_en(X,georgia).


factorial(0,1).
factorial(N, Result):- N>0,N_ is N-1, factorial(N_,Result_), Result is N*Result_.

gringas([X]):-loc_en(X,usa).
gringas([X|Xs]):-loc_en(X,usa), gringas(Xs).

append([],Ys,Ys).
append([X|Xs], Ys, [X|Zs]) :- append(Xs,Ys,Zs).

% ?- append([1,2,3],[4,5,6],L).
% L = [1, 2, 3, 4, 5, 6].

member(X,[X|_]).
member(X,[_|Ys]):- member(X,Ys).
subset([], _).
subset([X|Xs], Z):- member(X,Z), subset(Xs, Z ).
%cuando se hace una consulta verifica lo que esta primero en mi programa.
% Es decir en este caso verifica el caso base primero

intersection([],_,[]).
% it is like the append fucntion but, the elemen only add to the result
% only when it is a member 

% Rule 1. When head of the first list is a member of the second list
% Then  intersection([X|Xs],Ys,[X|Zs]) will include the fisrt element to the list.
intersection([X|Xs],Ys,[X|Zs]):- member(X,Ys), intersection(Xs,Ys, Zs).

% Rule 2. When the head is not in the list we skipped 
% We saw this in the third argument, we write Zs instead of [X|Zs]
intersection([_|Xs], Ys, Zs) :- 
    intersection(Xs, Ys, Zs).

%%%%%%%%%%%%%%%%%%%%%5
%   UNION           %%%
%%%%%%%%%%%%%%%%%%%%%%5

% The union will be similar to the intersection
% When an element of the 1st list is a member of the 2nd list
% Then, we will skip it, because we will insert after.

% When an element of the 1st list is not a member of the 2nd list
% Then, we will insert it on the "Result" list.

union([],Ys,Ys).
union([X|Xs], Ys, Zs):- member(X,Ys), union(Xs,Ys, Zs).
union([X|Xs],Ys,[X|Zs]):- \+ member(X, Ys), union(Xs, Ys, Zs).

% [1,2], [1,8]

%%%%%%%%%%%%%%%%%%%%%%
%   Difference  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%

dif([],_,[]).
% it is like the intersection fucntion but add the element when
% is NOT a member of the second list 

% Rule 1. When head of the first list is NOT a member of the second list
% Then  intersection([X|Xs],Ys,[X|Zs]) will include the fisrt element to the list.
dif([X|Xs],Ys,[X|Zs]):- \+ member(X,Ys), dif(Xs,Ys, Zs).

% Rule 2. When the head is in the list we skipped 
dif([_|Xs], Ys, Zs) :- 
    dif(Xs, Ys, Zs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Permutations    %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We have to find the rules
% With perms([1],L) L=[[1]]



% I need a function such as:

% choose([1,2,3],L ).
% L = [2,3], [1,3], [1,2]


% Rule 1. The element to be ommited is the head
choose([_|Xs], Xs).
%Rule 2. We ommit the "second" element but keep the "first"
choose([X,Y|Xs], [X|L_rest]) :- choose([Y|Xs], L_rest).

% helper: find which element was omitted
omitted_element(Xs, Rest, X) :-
    choose(Xs, Rest),
    member(X, Xs),
    \+ member(X, Rest).

% permutation using choose/2
perms([], []).
perms(Xs, [X|Ps]) :-
    omitted_element(Xs, Rest, X),
    perms(Rest, Ps).

