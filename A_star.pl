ricerca(Cammino) :-
    iniziale(S0),
    astar([[S0, [], 0]], [], CamminoInverso),
    inverti(CamminoInverso, Cammino).



% astar(Lista Open, Lista Closed, CamminoInverso)
% La testa di Open, per costruzione, è il nodo di costo minimo
astar([[S, Cammino, StimaCosto]|_], _, Cammino) :-
    % Se S è finale non ha senso passare a valutare le formule
    % per stati non finali (questo è un cut verde)
    finale(S),
    !.

astar([[S, Cammino, StimaCosto]|Open], Closed, Risultato) :-
    % non serve fare la rimozione esplicita, perchè tanto togliamo il nodo
    % di testa, quindi la posizione degli altri non cambia
    insertOrdered(S, StimaCosto, Cammino, Closed, NewClosed),
    % Assumiamo che, per costruzione, S sia il nodo di costo stimato minimo
    % S non è finale, quindi devo espanderlo, generandone i successori
    % genero tutte le istanziazioni di Az per le quali vale applicable(Az, S)
    % e le memorizzo in ListaAzioni
    findall(Az, applicabile(Az, S), AzApplicabili),
    generaNuoviStati([S, Cammino, StimaCosto], AzApplicabili, NuoviStati),
    valutaStati(NuoviStati, Open, OpenModified, NewClosed, ClosedModified),
    astar(OpenModified, ClosedModified, Risultato).

    

generaNuoviStati(_, [], []).
generaNuoviStati([S, Cammino, StimaCosto], [Az|Tail], [[SNuovo, [Az|Cammino], StimaNuovoCosto]|NuoviStati]) :-
    trasforma(Az, S, SNuovo),
    length(Cammino, CostoEffettivo),
    euristica(SNuovo, ValEuristica),
    % possiamo assumere che le azioni abbiano costo unitario
    StimaNuovoCosto is CostoEffettivo + ValEuristica + 1,
    generaNuoviStati([S, Cammino, StimaCosto], Tail, NuoviStati).


valutaStati([], Open, Open, Closed, Closed).
valutaStati([[NuovoStato, Cammino, StimaCosto]|NuoviStati], Open, NewOpen, Closed, NewClosed) :-
    \+findCost(Open, NuovoStato, _),
    \+findCost(Closed, NuovoStato, _),
    !,
    % inserimento ordinato nella lista
    insertOrdered(NuovoStato, StimaCosto, Cammino, Open, TmpOpen),
    valutaStati(NuoviStati, TmpOpen, NewOpen, Closed, NewClosed).

valutaStati([[NuovoStato, Cammino, StimaCosto]|NuoviStati], Open, NewOpen, Closed, NewClosed) :-
    % Stato già visitato
    findCost(Open, NuovoStato, CostoCorrente),
    StimaCosto < CostoCorrente,
    select([NuovoStato, _, CostoCorrente], Open, TmpOpen),
    % Non Corretto
    insertOrdered(NuovoStato, StimaCosto, Cammino, TmpOpen, AuxOpen),
    valutaStati(NuoviStati, AuxOpen, NewOpen, Closed, NewClosed).

valutaStati([[NuovoStato, Cammino, StimaCosto]|NuoviStati], Open, NewOpen, Closed, NewClosed) :-
    findCost(Closed, NuovoStato, CostoCorrente),
    StimaCosto < CostoCorrente,
    select([NuovoStato, _, CostoCorrente], Closed, TmpClosed),
    insertOrdered(NuovoStato, StimaCosto, Cammino, Open, TmpOpen),
    valutaStati(NuoviStati, TmpOpen, NewOpen, TmpClosed, NewClosed).

valutaStati([[NuovoStato, Cammino, StimaCosto]|NuoviStati], Open, NewOpen, Closed, NewClosed) :-
    valutaStati(NuoviStati, Open, NewOpen, Closed, NewClosed).

% Se la lista è vuota e non ho trovato stato target
% non ci sono clausole applicabili, quindi restituirà false
% ed è giusto che sia così.    
findCost([[S, _, Costo]|Tail], StatoTarget, Costo) :-
    S == StatoTarget,
    !.

findCost([[_, _, Costo]|Tail], StatoTarget, CostoTarget) :-
    findCost(Tail, StatoTarget, CostoTarget).


insertOrdered(Stato, Costo, Cammino, [], [[Stato, Cammino, Costo]]).
insertOrdered(NuovoStato, NuovoCosto, NuovoCammino, [[Stato, Cammino, Costo]|Open], [[NuovoStato, NuovoCammino, NuovoCosto], [Stato, Cammino, Costo]|Open]) :-
    NuovoCosto < Costo,
    !.
% sfrutto la possibilità di poter definire la forma della lista
insertOrdered(NuovoStato, NuovoCosto, NuovoCammino, [[Stato, Cammino, Costo]|Open], [[Stato, Cammino, Costo]|NewOpen]) :-
    insertOrdered(NuovoStato, NuovoCosto, NuovoCammino, Open, NewOpen).


% Inversione lista contenente il cammino completo
inverti(ListPrinc, Inversa) :- invertiAux(ListPrinc, [], Inversa).

invertiAux([], Tmp, Tmp).
invertiAux([Head|Tail], Tmp, Inversa) :-
    invertiAux(Tail, [Head|Tmp], Inversa).

euristica(pos(R1, C1), Result) :-
    findall(Uscita, finale(Uscita), ElencoUscite),
    manhattan(pos(R1, C1), ElencoUscite, Result).

manhattan(pos(R1, C1), [pos(R2, C2)], Result) :-
    Result is abs(R1 - R2) + abs(C1 - C2).

manhattan(pos(R1, C1), [pos(R2, C2)|Tail], Result) :-
    manhattan(pos(R1, C1), Tail, CurrMin),
    CurrDist is abs(R1 - R2) + abs(C1 - C2),
    Result is min(CurrMin, CurrDist).