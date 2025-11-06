
% The 3 coins problem
% Get from [h,h,t] to either [h,h,h] or [t,t,t] by either flipping
% coin 1, 2 or 3.

s(S1, S2) :-
    select(Coin,S1,Coin_aux,S2),
    flip(Coin,Coin_aux).

flip(h,t).
flip(t,h).

meta([h,h,h]).
meta([t,t,t]).
