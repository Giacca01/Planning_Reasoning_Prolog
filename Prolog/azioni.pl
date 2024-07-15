% La semantica dei predicati che seguono
% e di quelli usati per modellare il labirinto
% è la stessa vista a lezione

% Condizioni di applicabilità delle singole azioni
applicabile(nord, pos(R, C)) :-
    R > 1,
    RUp is R - 1,
    \+occupata(pos(RUp, C)).


applicabile(sud, pos(R, C)) :-
    num_righe(N),
    R < N,
    RDown is R + 1,
    \+occupata(pos(RDown, C)).

applicabile(est, pos(R, C)):-
    num_col(N),
    C < N,
    CRight is C + 1,
    \+occupata(pos(R, CRight)).

applicabile(ovest, pos(R, C)):-
    C > 1,
    CLeft is C - 1,
    \+occupata(pos(R, CLeft)).

% effetto delle azioni sullo stato
trasforma(est, pos(R, C), pos(R, CDx)) :- 
    CDx is C + 1.

trasforma(ovest, pos(R, C), pos(R, CSx)) :-
    CSx is C - 1.

trasforma(nord, pos(R, C), pos(RUp, C)) :-
    RUp is R - 1.

trasforma(sud, pos(R, C), pos(RDown, C)) :-
    RDown is R + 1.