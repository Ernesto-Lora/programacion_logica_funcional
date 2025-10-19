loc_en(atlanta, georgia).
loc_en(houston,texas).
loc_en(austin,texas).
loc_en(boston,massachussets).
loc_en(xalapa,veracruz).
loc_en(veracruz,veracruz).

%%% loc_en(X,Y)/2
%%% La ciudad X está localizada en el paı́s Y

loc_en(X,usa) :- loc_en(X,georgia).
loc_en(X,usa) :- loc_en(X,texas).
loc_en(X,usa) :- loc_en(X,massachussets).


loc_en(X,mexico) :- loc_en(X,veracruz).

%%% loc_en(X,Y)/2
%%% La ciudad X está en norteamérica

loc_en(X,norteamerica) :- loc_en(X,usa).
loc_en(X,norteamerica) :- loc_en(X,usa).
loc_en(X,norteamerica) :- loc_en(X,mexico).

%%% Consultas negativas
?- \+ loc_en(xalapa,usa).

?- \+ loc_en(Ciudad,usa).

?- loc_en(Ciudad,norteamerica), \+ loc_en(Ciudad,usa).