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

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Peano Number
%%%%%%%%%%%%%%%%%%%%%%%%%%

% The Peano number refer that the succesor of 0 is a natural number
% So, every natural number can be constructed starting with 0.
% In is manner Succesor of 0 is 1.
% Succesor of Succesor of 0 is 2. And so on.

peanoToNat(0,0).

% Rule 1. We need a way of reducing the peano number
% Such as if we have s(s(0)) in the recursive function we have s(0) 
% Rule 2. The N at first, will be "waiting" for the unification 
% of N_pred 
% The same with the N_pred 
% when the predecessor is 0, then N_pred will unify with 0
% And with all the N_preds of the recursion will sum a 1 each other.
% Finishing with the final N

peanoToNat(s(predecessor), N) :-
    peanoToNat(predecessor, N_pred),
    N is N_pred + 1.


% Sum of Peano numbers.
% Rules: 
% Rule 1. Base case: The sum with 0 is the same peano number
% Rule 2. Recursive: We have the 1st Peano number F, for example s(s()).
% And we have 2nd Peano number, for example s(s(s())).
% We have to aply the succesor to the 1st number
% until the 2nd number is 0
% and base case is reached 

sumaPeano(F,0,F).
sumaPeano(F,s(G),H):-sumaPeano(s(F),G, H ).

% Rest of peano numbers
% We will asumme the 2nd number is greater than the 1st
% Rule 1. Base case. When the 2st number is zero, the unification
% will be the 1st.
restaPeano(F,0,F).
% Rule 2. We will keep the antecessor in each recursive.
% So in each "iteration" the 1st and the 2nd will be reduced
% Intil the 2nd is zero.
restaPeano(s(F),s(G),H):- restaPeano(F,G,H).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Unification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We will implement the Robinson Algorithm (1965)
% It was one of the first algortm
% Has the problem of exponential time and space complexity

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Robinson's Unification Algorithm from First Principles
%
%  - Main Predicate: unify(Term1, Term2, Substitution)
%  - Succeeds with the most general unifier in Substitution.
%  - Fails if the terms cannot be unified.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Main Entry Point ---
% This predicate serves as a clean interface. It calls the internal
% logic and provides a simple success/failure result.
unify(T1, T2, Subst) :- unify_internal(T1, T2, Subst), !.
unify(_, _, fail). % If unify_internal fails, this clause catches it.


% --- Core Unification Logic ---
% This maps directly to the algorithm steps.

% Step 1.2: Trivial Case - If terms are already identical.
unify_internal(T, T, []).

% Step 1.4: Variable is unified with a term.
unify_internal(V, T, [var(V) = T]) :-
    is_variable(V),
    \+ occurs_check(V, T). % Negation of Step 1.3 (occurs check)

% Symmetric case for (Term, Variable).
unify_internal(T, V, [var(V) = T]) :-
    is_variable(V),
    \+ occurs_check(V, T).

% Step 3: Recursive Unification for complex terms.
unify_internal(T1, T2, FinalSubst) :-
    % Pre-condition: both are complex terms (not variables or constants)
    \+ is_variable(T1), \+ atomic(T1),
    \+ is_variable(T2), \+ atomic(T2),
    % Step 2: Header Check (Functor and Arity)
    % Prolog's "=.." operator checks this for us. It fails if F is different
    % or if the list lengths (arity) are different.
    T1 =.. [F | Args1],
    T2 =.. [F | Args2],
    % Step 3: Loop through arguments.
    unify_arg_list(Args1, Args2, [], FinalSubst).


% --- Argument List Unification (Algorithm Step 3 Loop) ---
% This helper predicate recursively unifies the arguments of two functions.
% unify_arg_list(Args1, Args2, InputSubstitution, OutputSubstitution)

% Base case: No more arguments to unify.
unify_arg_list([], [], Sigma, Sigma).

% Recursive step:
unify_arg_list([H1|T1], [H2|T2], Sigma_in, Sigma_out) :-
    % a. Apply the current substitution to the arguments.
    apply_substitution(Sigma_in, H1, H1_prime),
    apply_substitution(Sigma_in, H2, H2_prime),
    % b. Recursively call unify on the prepared arguments.
    unify_internal(H1_prime, H2_prime, Tau),
    % c. Update the overall substitution by composing the new one.
    compose_substitutions(Tau, Sigma_in, Sigma_new),
    % d. Increment: Continue with the rest of the arguments.
    unify_arg_list(T1, T2, Sigma_new, Sigma_out).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  TOOLBOX PREDICATES (Built from scratch)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- is_variable/1 ---
% Checks if a term is a variable (an atom starting with an uppercase letter).
is_variable(V) :-
    atom(V),
    atom_chars(V, [C|_]),
    C @>= 'A',
    C @=< 'Z'.

% --- occurs_check/2 (Algorithm Step 1.3) ---
% occurs_check(Variable, Term)
% Succeeds if Variable appears anywhere inside Term.

% A variable occurs in itself.
occurs_check(V, T) :-
    is_variable(T),
    V == T.
% Check for the variable inside the arguments of a complex term.
occurs_check(V, T) :-
    \+ is_variable(T), \+ atomic(T), % T must be a complex term
    T =.. [_ | Args],
    member(Arg, Args),
    occurs_check(V, Arg).


% --- apply_substitution/3 ---
% apply_substitution(Substitution, Term, ResultingTerm)
% Applies a substitution to a term to produce a new term.

% Applying to a constant does nothing.
apply_substitution(_, T, T) :-
    \+ is_variable(T), atomic(T).

% Applying to a variable: look it up or return the variable itself.
apply_substitution(Subst, V, Result) :-
    is_variable(V),
    (   lookup(V, Subst, Term) -> Result = Term
    ;   Result = V % Variable not in substitution, remains unchanged
    ).

% Applying to a complex term: apply recursively to all arguments.
apply_substitution(Subst, T, Result) :-
    \+ is_variable(T), \+ atomic(T), % T is a complex term
    T =.. [F | Args],
    apply_substitution_to_list(Subst, Args, NewArgs),
    Result =.. [F | NewArgs].

% Helper to apply substitution to a list of terms.
apply_substitution_to_list(_, [], []).
apply_substitution_to_list(Subst, [H|T], [H_new|T_new]) :-
    apply_substitution(Subst, H, H_new),
    apply_substitution_to_list(Subst, T, T_new).

% lookup(Variable, Substitution, Term)
lookup(V, [var(V) = T | _], T) :- !.
lookup(V, [_ | Rest], T) :- lookup(V, Rest, T).


% --- compose_substitutions/3 ---
% compose_substitutions(Tau, Sigma, Result)
% This composes two substitutions, equivalent to compose(tau, sigma).
% The resulting substitution is (apply(tau, sigma) U tau), where we filter
% out redundant bindings from tau.

compose_substitutions(Tau, Sigma, Result) :-
    % First, apply Tau to the right-hand-side of every binding in Sigma.
    apply_substitution_to_subst_range(Tau, Sigma, Sigma_prime),
    % Get all the variables bound by Sigma (its "domain").
    get_domain(Sigma, Domain),
    % Filter Tau to get only the bindings for variables NOT in Sigma's domain.
    filter_tau(Tau, Domain, Tau_prime),
    % The result is the combination of the two lists.
    append(Tau_prime, Sigma_prime, Result).

% Helper to apply a substitution to the right-hand-side of another one.
apply_substitution_to_subst_range(_, [], []).
apply_substitution_to_subst_range(Subst, [var(V) = T | Rest], [var(V) = T_prime | Rest_prime]) :-
    apply_substitution(Subst, T, T_prime),
    apply_substitution_to_subst_range(Subst, Rest, Rest_prime).

% Helper to get the list of variables bound in a substitution.
get_domain([], []).
get_domain([var(V) = _ | Rest], [V | Domain]) :-
    get_domain(Rest, Domain).

% Helper to filter bindings from Tau.
filter_tau([], _, []).
filter_tau([var(V) = T | RestTau], Domain, Filtered) :-
    (   member(V, Domain)
    ->  % If V is already in Sigma's domain, skip this binding.
        filter_tau(RestTau, Domain, Filtered)
    ;   % Otherwise, keep this binding.
        Filtered = [var(V) = T | RestFiltered],
        filter_tau(RestTau, Domain, RestFiltered)
    ).


% --- Basic List Utilities ---

% member(Element, List)
member(X, [X|_]).
member(X, [_|T]) :- member(X, T).

% append(List1, List2, ResultList)
append([], L, L).
append([H|T], L, [H|R]) :- append(T, L, R).
