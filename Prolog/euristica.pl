euristica(pos(R1, C1), Result) :-
    findall(Uscita, finale(Uscita), ElencoUscite),
    manhattan(pos(R1, C1), ElencoUscite, Result).


% Calcolo la distanza di manhattan tra la posizione corrente
% e ciascuna uscita, selezionando poi il valore minimo
% come stima del costo di raggiungimento del goal
manhattan(pos(R1, C1), [pos(R2, C2)], Result) :-
    Result is abs(R1 - R2) + abs(C1 - C2),
    !.

manhattan(pos(R1, C1), [pos(R2, C2)|Tail], Result) :-
    manhattan(pos(R1, C1), Tail, CurrMin),
    CurrDist is abs(R1 - R2) + abs(C1 - C2),
    Result is min(CurrMin, CurrDist).