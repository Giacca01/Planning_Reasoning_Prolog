ricerca(Cammino) :-
    iniziale(S0),
    euristica(S0, Soglia),
    ida([[S0, [], 0]], Soglia, Soglia, NewMin).



ida([[S, Cammino, Costo]|_], Soglia, CurrMin, NewMin):-
    length(Visitati, CostoEffettivo),
    euristica(S, StimaCosto),
    StimaTotale is CostoEffettivo + StimaCosto,
    % lo stato corrente è entro il limite: procediamo con la valutazione
    StimaTotale < Soglia,
    finale(S),
    % Ultima iterazione dell'algoritmo
    !.

ida([[S, Cammino, Costo]|Tail], Soglia, CurrMin, NewMin):-
    % Verifichi di non aver superato la soglia di ricerca
    % lo stato corrente è entro il limite: procediamo con la valutazione
    Soglia >= Costo,
    !,
    % Genero i nodi figli
    findall(Az, applicabile(Az, S), AzioniApplicabili),
    generaNuoviStati([S, Cammino, Costo], AzioniApplicabili, Tail, Successori),
    % TODO:controllare di non aver già visitato lo stato, ma rispetto a quale coda?
    ida(Successori, Soglia, NewVisitati, Soglia, NewMin).


ida([[S, Cammino, Costo]|Tail], Soglia, CurrMin, NewMin) :-
    TmpMin is min(Soglia, Costo),
    ida(Tail, Soglia, TmpMin, NewMin).

ida([], _, CurrMin, _) :-
    % ATTENZIONE!! Non funziona con tanti stati iniziali diversi, perchè
    % non è detto che prenda sempre lo stesso in tutte le run
    iniziale(S0),
    ida([[S0, [], 0]], CurrMin, CurrMin, NewMin).



generaNuoviStati(_, [], StatiDaVisitare, StatiDaVisitare).
generaNuoviStati([S, Cammino, Costo], [Az|Tail], StatiDaVisitare, NewStatiDaVisitare) :-
    trasforma(Az, S, SNuovo),
    length(Cammino, CostoEffettivo),
    euristica(SNuovo, StimaCosto),
    StimaTotale is CostoEffettivo + StimaCosto + 1,
    generaNuoviStati([S, Cammino, Costo], Tail, StatiDaVisitare, TmpStatiDaVisitare),
    insertOrdered(SNuovo, StimaTotale, [Az|Cammino], TmpStatiDaVisitare, NewStatiDaVisitare).
    


insertOrdered(Stato, Costo, Cammino, [], [[Stato, Cammino, Costo]]).
insertOrdered(NuovoStato, NuovoCosto, NuovoCammino, [[Stato, Cammino, Costo]|Successori], [[NuovoStato, NuovoCammino, NuovoCosto], [Stato, Cammino, Costo]|Successori]) :-
    NuovoCosto < Costo,
    !.
% sfrutto la possibilità di poter definire la forma della lista
insertOrdered(NuovoStato, NuovoCosto, NuovoCammino, [[Stato, Cammino, Costo]|Successori], [[Stato, Cammino, Costo]|NewSuccessori]) :-
    insertOrdered(NuovoStato, NuovoCosto, NuovoCammino, Successori, NewSuccessori).



euristica(pos(R1, C1), Result) :-
    findall(Uscita, finale(Uscita), ElencoUscite),
    manhattan(pos(R1, C1), ElencoUscite, Result).

manhattan(pos(R1, C1), [pos(R2, C2)], Result) :-
    Result is abs(R1 - R2) + abs(C1 - C2).

manhattan(pos(R1, C1), [pos(R2, C2)|Tail], Result) :-
    manhattan(pos(R1, C1), Tail, CurrMin),
    CurrDist is abs(R1 - R2) + abs(C1 - C2),
    Result is min(CurrMin, CurrDist).