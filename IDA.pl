ricerca(Cammino, Soglia) :-
    iniziale(S0),
    ida(S0, Soglia, [], Cammino).


ida(S, _, _, Cammino):-
    finale(S),
    !.

ida(S, Soglia, Visitati, [Az|ListaAzioni]):-
    valutaNodo(S, StimaCosto),
    % lo stato corrente è entro il limite: procediamo con la valutazione
    StimaCosto < Soglia,
    !,
    applicabile(Az, S),
    trasforma(Az, S, SNuovo),
    \+member(S, Visitati),
    
    