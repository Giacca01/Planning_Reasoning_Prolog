ricerca(Cammino) :-
    iniziale(S0),
    euristica(S0, StimaCosto),
    astar([[S0, [], StimaCosto]], [], CamminoInverso),
    inverti(CamminoInverso, Cammino).



% astar(Lista Nodi Open, Lista Nodi Closed, CamminoInverso)
astar([[S, Cammino, StimaCosto]|_], _, Cammino) :-
    % Se S è uno stato finale non ha senso passare a valutare le formule
    % per stati non finali
    finale(S),
    !.

astar([[S, Cammino, StimaCosto]|Open], Closed, Risultato) :-
    % La testa di Open, per costruzione, è il nodo di costo minimo
    % che procedo ad espandere

    % Inserisco il nodo nella lista di quelli chiusi
    insertOrdered(S, StimaCosto, Cammino, Closed, NewClosed),

    % Genero i successori di S mendiante tutte le azioni applicabili
    findall(Az, applicabile(Az, S), AzApplicabili),
    generaNuoviStati([S, Cammino, StimaCosto], AzApplicabili, NuoviStati),
    % Valuto i successori, calcolandone il costo e decidendo cosa mettere
    % in open e cosa in closed
    valutaStati(NuoviStati, Open, OpenModified, NewClosed, ClosedModified),
    % Procedo con l'esplorazione del prossimo stato più promettente
    astar(OpenModified, ClosedModified, Risultato).


% Genero tutti i successori del nodo corrente
generaNuoviStati(_, [], []) :- !.
generaNuoviStati([S, Cammino, StimaCosto], [Az|Tail], [[SNuovo, [Az|Cammino], StimaNuovoCosto]|NuoviStati]) :-
    trasforma(Az, S, SNuovo),
    % Supponendo che le azioni abbiano costo unitario
    % il costo di raggiungimento dello stato corrente è la lunghezza
    % del percorso seguito
    length(Cammino, CostoEffettivo),
    euristica(SNuovo, ValEuristica),
    % possiamo assumere che le azioni abbiano costo unitario
    StimaNuovoCosto is CostoEffettivo + ValEuristica + 1,
    generaNuoviStati([S, Cammino, StimaCosto], Tail, NuoviStati).


% valutaStati(ElencoStati, 
%    Lista nodi aperti, 
%    lista nodi aperti aggiornata
%    Lista nodi chiusi
%    Lista nodi chiusi aggiornata
%)
valutaStati([], Open, Open, Closed, Closed).
valutaStati([[NuovoStato, Cammino, StimaCosto]|NuoviStati], Open, NewOpen, Closed, NewClosed) :-
    % Non conosco ancora un cammino che porti dallo stato corrente al goal
    \+findCost(Open, NuovoStato, _),
    \+findCost(Closed, NuovoStato, _),
    !,
    % inserisco il nodo tra quelli di cui sto calcolando il cammino verso il goal
    insertOrdered(NuovoStato, StimaCosto, Cammino, Open, TmpOpen),
    valutaStati(NuoviStati, TmpOpen, NewOpen, Closed, NewClosed).

valutaStati([[NuovoStato, Cammino, StimaCosto]|NuoviStati], Open, NewOpen, Closed, NewClosed) :-
    % Stato già visitato: conosco già un cammino che porti da esso al goal
    findCost(Open, NuovoStato, CostoCorrente),
    % Il nuovo cammino è più promettente di quello corrente
    StimaCosto < CostoCorrente,
    % Aggiorno il costo nella lista open
    select([NuovoStato, _, CostoCorrente], Open, TmpOpen),
    insertOrdered(NuovoStato, StimaCosto, Cammino, TmpOpen, AuxOpen),
    valutaStati(NuoviStati, AuxOpen, NewOpen, Closed, NewClosed).

valutaStati([[NuovoStato, Cammino, StimaCosto]|NuoviStati], Open, NewOpen, Closed, NewClosed) :-
    findCost(Closed, NuovoStato, CostoCorrente),
    StimaCosto < CostoCorrente,
    select([NuovoStato, _, CostoCorrente], Closed, TmpClosed),
    insertOrdered(NuovoStato, StimaCosto, Cammino, Open, TmpOpen),
    valutaStati(NuoviStati, TmpOpen, NewOpen, TmpClosed, NewClosed).

valutaStati([[NuovoStato, Cammino, StimaCosto]|NuoviStati], Open, NewOpen, Closed, NewClosed) :-
    % Il nodo è già tra quelli visitati ed il nuovo percorso
    % non è migliore di quello noto
    valutaStati(NuoviStati, Open, NewOpen, Closed, NewClosed).



% Restitusice il costo di StatoTarget memorizzato nella lista primo argomento   
findCost([[S, _, Costo]|Tail], StatoTarget, Costo) :-
    S == StatoTarget,
    !.
findCost([[_, _, Costo]|Tail], StatoTarget, CostoTarget) :-
    findCost(Tail, StatoTarget, CostoTarget).


insertOrdered(Stato, Costo, Cammino, [], [[Stato, Cammino, Costo]]) :- !.
% sfrutto la possibilità di poter definire la forma della lista
% per specificare l'ordine relativo degli elementi
insertOrdered(NuovoStato, NuovoCosto, NuovoCammino, [[Stato, Cammino, Costo]|Tail], [[NuovoStato, NuovoCammino, NuovoCosto], [Stato, Cammino, Costo]|Tail]) :-
    NuovoCosto < Costo,
    !.
insertOrdered(NuovoStato, NuovoCosto, NuovoCammino, [[Stato, Cammino, Costo]|Tail], [[Stato, Cammino, Costo]|NewTail]) :-
    insertOrdered(NuovoStato, NuovoCosto, NuovoCammino, Tail, NewTail).


% Inversione lista contenente il cammino completo
inverti(ListPrinc, Inversa) :- invertiAux(ListPrinc, [], Inversa).

invertiAux([], Tmp, Tmp).
invertiAux([Head|Tail], Tmp, Inversa) :-
    invertiAux(Tail, [Head|Tmp], Inversa).