euristica([pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme], Result) :-
    findall(Uscita, finale([Uscita, _, _, _, _]), ElencoUscite),
    manhattan(pos(R, C), ElencoUscite, Result).

manhattan(pos(R1, C1), [pos(R2, C2)], Result) :-
    Result is abs(R1 - R2) + abs(C1 - C2),
    !.

manhattan(pos(R1, C1), [pos(R2, C2)|Tail], Result) :-
    manhattan(pos(R1, C1), Tail, CurrMin),
    CurrDist is abs(R1 - R2) + abs(C1 - C2),
    Result is min(CurrMin, CurrDist).