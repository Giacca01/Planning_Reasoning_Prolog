ricerca(CamminoFinale) :-
    iniziale(S0),
    euristica(S0, Soglia),
    ida(S0, [], [], Soglia, Soglia, NewMin, CamminoFinale).


ida(S, Cammino, Visitati, Soglia, CurrMin, NewMin, Cammino):-
    % lo stato corrente è entro il limite: procediamo con la valutazione
    \+member(S, Visitati),
    length(Cammino, CostoEffettivo),
    euristica(S, StimaCosto),
    StimaTotale is CostoEffettivo + StimaCosto,
    Soglia >= StimaTotale,
    finale(S),
    % Ultima iterazione dell'algoritmo
    !.

ida(S, Cammino, Visitati, Soglia, CurrMin, NewMin, CamminoFinale):-
    % Verifichi di non aver superato la soglia di ricerca
    % lo stato corrente è entro il limite: procediamo con la valutazione
    \+member(S, Visitati),
    length(Cammino, CostoEffettivo),
    euristica(S, StimaCosto),
    StimaTotale is CostoEffettivo + StimaCosto,
    Soglia >= StimaTotale,
    !,
    % Genero i nodi figli
    applicabile(Az, S),
    trasforma(Az, S, SNuovo),
    % TODO: tenere conto del fatto che gli stati oltre soglia non vengono aggiunti
    % all'elenco dei visitati
    ida(SNuovo, [Az|Cammino], [S|Visitati], Soglia, Soglia, NewMin, CamminoFinale).


ida(S, Cammino, Visitati, Soglia, CurrMin, NewMin, _) :-
    \+member(S, Visitati),
    !,
    length(Cammino, CostoEffettivo),
    euristica(S, StimaCosto),
    StimaTotale is CostoEffettivo + StimaCosto,
    TmpMin is min(CurrMin, StimaTotale),
    % In teoria bisogna forzare il backtracking in modo da valutare tutti i successori...
    fail.

% Se il nodo fa già parte del path non ci sono regole applicabili
% quindi la ricerca fallisce e si passa al successivo

% Regola che scatta dopo il fallimento dell'esplorazione dell'ultimo figlio
ida(_, _, _, CurrMin, CurrMin, _, CamminoFinale) :-
    % ATTENZIONE!! Non funziona con tanti stati iniziali diversi, perchè
    % non è detto che prenda sempre lo stesso in tutte le run
    iniziale(S0),
    ida(S0, [], [], CurrMin, CurrMin, NewMin, CamminoFinale).


euristica(pos(R1, C1), Result) :-
    findall(Uscita, finale(Uscita), ElencoUscite),
    manhattan(pos(R1, C1), ElencoUscite, Result).

manhattan(pos(R1, C1), [pos(R2, C2)], Result) :-
    Result is abs(R1 - R2) + abs(C1 - C2).

manhattan(pos(R1, C1), [pos(R2, C2)|Tail], Result) :-
    manhattan(pos(R1, C1), Tail, CurrMin),
    CurrDist is abs(R1 - R2) + abs(C1 - C2),
    Result is min(CurrMin, CurrDist).

% Inversione lista contenente il cammino completo
inverti(ListPrinc, Inversa) :- invertiAux(ListPrinc, [], Inversa).

invertiAux([], Tmp, Tmp).
invertiAux([Head|Tail], Tmp, Inversa) :-
    invertiAux(Tail, [Head|Tmp], Inversa).