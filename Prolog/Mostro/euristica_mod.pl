euristica([pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme], Result) :-
    findall(Uscita, finale([Uscita, _, _, _, _]), ElencoUscite),
    manhattan(pos(R, C), ElencoUscite, ManhattanDist),
    bonusGemme(ListaGemme, ManhattanDist, Result).

bonusGemme(ListaGemme, Costo, CostoFinale) :-
    controllaGemme(ListaGemme, nil),
    !,
    % Se le gemme sono contigue modello il raggiungimento
    % del bonus dimezzando il costo del percorso
    CostoFinale is Costo / 2.
bonusGemme(ListaGemme, Costo, Costo).

controllaGemme([], _).
controllaGemme([gemma(pos(RG, CG))|Tail], PrevGemma) :-
    PrevGemma == nil,
    !,
    controllaGemme(Tail, gemma(pos(RG, CG))).
controllaGemme([gemma(pos(RG, CG))|Tail], gemma(pos(RP, CP))) :-
    TmpRP is RP + 1,
    TmpRG is RG + 1,
    TmpCG is CG + 1,
    TmpCP is CP + 1,
    (
        RG = TmpRP;
        CG = TmpCP;
        RP = TmpRG;
        CP = TmpCG
    ),
    controllaGemme(Tail, gemma(pos(RG, CG))).



manhattan(pos(R1, C1), [pos(R2, C2)], Result) :-
    Result is abs(R1 - R2) + abs(C1 - C2),
    !.

manhattan(pos(R1, C1), [pos(R2, C2)|Tail], Result) :-
    manhattan(pos(R1, C1), Tail, CurrMin),
    CurrDist is abs(R1 - R2) + abs(C1 - C2),
    Result is min(CurrMin, CurrDist).