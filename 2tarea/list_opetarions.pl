append([], Ys, Ys).
append([X|Xs], Ys, [X|Zs]) :- append(Xs, Ys, Zs).

% ?- append([1,2,3],[4,5,6],L).
% L = [1, 2, 3, 4, 5, 6].

member(X, [X|_]).
member(X, [_|Ys]) :- member(X, Ys).

%%%%%%%%%%%%%%%%%%%%%5
%       Subset
%%%%%%%%%%%%%%%%%%%%%55
subset([], _).
subset([X|Xs], Z) :- member(X, Z), subset(Xs, Z).

%%%%%%%%%%%%%%%%%%%%
% Intersection
%%%%%%%%%%%%%%%%%
% It is similar to the append function, but an element is added to the result
% only when it is a member of the second list.

inter([], _, []). % Base case

% Rule 1. When the head of the first list is a member of the second list,
% inter([X|Xs], Ys, [X|Zs]) will include the first element in the result list.
inter([X|Xs], Ys, [X|Zs]) :- member(X, Ys), inter(Xs, Ys, Zs).

% Rule 2. When the head is not in the second list, we skip it.
% We see this in the third argument: we write Zs instead of [X|Zs].
inter([_|Xs], Ys, Zs) :- 
    inter(Xs, Ys, Zs).

%%%%%%%%%%%%%%%%%%%%%
%       UNION
%%%%%%%%%%%%%%%%%%%%%
% The union is similar to the intersection.
% When an element of the first list is already a member of the second list,
% we skip it, because it will already be included.
%
% When an element of the first list is not a member of the second list,
% we insert it into the result list.

union([], Ys, Ys).
union([X|Xs], Ys, Zs) :- member(X, Ys), union(Xs, Ys, Zs).
union([X|Xs], Ys, [X|Zs]) :- \+ member(X, Ys), union(Xs, Ys, Zs).


%%%%%%%%%%%%%%%%%%%%%%
%     Difference
%%%%%%%%%%%%%%%%%%%%%%
dif([], _, []).
% It is similar to the intersection function, but it adds the element when
% it is NOT a member of the second list.

% Rule 1. When the head of the first list is NOT a member of the second list,
% dif([X|Xs], Ys, [X|Zs]) will include the first element in the result list.
dif([X|Xs], Ys, [X|Zs]) :- \+ member(X, Ys), dif(Xs, Ys, Zs).

% Rule 2. When the head is in the second list, we skip it.
dif([_|Xs], Ys, Zs) :- 
    dif(Xs, Ys, Zs).
