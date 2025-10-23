%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Peano Numbers
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Peano numbers define that the successor of 0 is a natural number.
% Therefore, every natural number can be constructed starting from 0.
% In this manner:
% The successor of 0 is 1.
% The successor of the successor of 0 is 2, and so on.

peanoToNat(0, 0).

% Rule 1. We need a way to reduce the Peano number.
% For example, if we have s(s(0)) in the recursive function,
% we will process s(0) next.
%
% Rule 2. The variable N will "wait" for the unification
% with N_pred (the predecessor’s numeric value).
% When the predecessor reaches 0, N_pred unifies with 0.
% Then, through recursion, all N_pred values will sum 1 each time,
% resulting in the final N.

peanoToNat(s(predecessor), N) :-
    peanoToNat(predecessor, N_pred),
    N is N_pred + 1.


%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Sum of Peano Numbers
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Rules:
% Rule 1. Base case: The sum with 0 is the same Peano number.
% Rule 2. Recursive case: We have the first Peano number F (e.g., s(s(0))),
% and the second Peano number G (e.g., s(s(s(0)))).
% We apply the successor to the first number
% until the second number becomes 0,
% at which point the base case is reached.

sumaPeano(F, 0, F).
sumaPeano(F, s(G), H) :- sumaPeano(s(F), G, H).


%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Difference of Peano Numbers
%%%%%%%%%%%%%%%%%%%%%%%%%%

% We will assume the second number is greater than or equal to the first.
%
% Rule 1. Base case: When the second number is 0,
% the result unifies with the first number.
restaPeano(F, 0, F).

% Rule 2. In each recursive step, we keep the predecessor of both numbers.
% So, in each "iteration", both the first and second numbers are reduced
% until the second becomes 0.
restaPeano(s(F), s(G), H) :- restaPeano(F, G, H).
