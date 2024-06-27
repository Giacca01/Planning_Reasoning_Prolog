% Calcolare soglia massima minimo

ricerca(CamminoFinale) :-
    iniziale(S0),
    euristica(S0, Soglia),
    NumeroTentativi is Soglia * 2,
    ida(S0, [], [], Soglia, 500, NewMinimo, CamminoCorrente, UltimoStato),
    fine(NewMinimo, UltimoStato, CamminoCorrente, CamminoInverso, NumeroTentativi),
    inverti(CamminoInverso, CamminoFinale).

fine(NuovaSoglia, UltimoStato, CamminoCorrente, CamminoCorrente, NumeroTentativi) :-
    finale(UltimoStato),
    !.

fine(NuovaSoglia, UltimoStato, _, CamminoFinale, NumeroTentativi, MaxVal) :-
   % \+finale(UltimoStato),
    NumeroTentativi > 0,
    !,
    iniziale(S0),
    euristica(S0, Soglia),
    !,
    ida(S0, [], [], NuovaSoglia, 500, NewMinimo, CamminoCorrente, StatoFin),
    NewNumTentativi is NumeroTentativi - 1,
    fine(NewMinimo, StatoFin, CamminoCorrente, CamminoFinale, NewNumTentativi).




ida(S, Cammino, Visitati, Soglia, Minimo, NewMinimo, CamminoCorrente, S) :-
    \+member(S, Visitati),
    length(Cammino, CostoEffettivo),
    euristica(S, StimaCosto),
    StimaTotale is CostoEffettivo + StimaCosto,
    StimaTotale > Soglia,
    NewMinimo is min(StimaTotale, Minimo),
    !.

% Se lo stato è già stato visitato non ho regole da applicare e quindi fallisco
ida(S, Cammino, Visitati, Soglia, Minimo, NewMinimo, Cammino, S):-
    % lo stato corrente è entro il limite: procediamo con la valutazione
    \+member(S, Visitati),
    finale(S),
    % Ultima iterazione dell'algoritmo
    !.

ida(S, Cammino, Visitati, Soglia, Minimo, NewMinimo, CamminoFinale, SFinale):-
    \+member(S, Visitati),
    % Genero i nodi figli
    applicabile(Az, S),
    trasforma(Az, S, SNuovo),
    ida(SNuovo, [Az|Cammino], [S|Visitati], Soglia, Minimo, NewMinimo, CamminoFinale, SFinale).

% Se il nodo fa già parte del path non ci sono regole applicabili
% quindi la ricerca fallisce e si passa al successivo


euristica(pos(R1, C1), Result) :-
    findall(Uscita, finale(Uscita), ElencoUscite),
    manhattan(pos(R1, C1), ElencoUscite, Result).

manhattan(pos(R1, C1), [pos(R2, C2)], Result) :-
    Result is abs(R1 - R2) + abs(C1 - C2),
    !.

manhattan(pos(R1, C1), [pos(R2, C2)|Tail], Result) :-
    manhattan(pos(R1, C1), Tail, CurrMin),
    CurrDist is abs(R1 - R2) + abs(C1 - C2),
    Result is min(CurrMin, CurrDist).

% Inversione lista contenente il cammino completo
inverti(ListPrinc, Inversa) :- invertiAux(ListPrinc, [], Inversa).

invertiAux([], Tmp, Tmp).
invertiAux([Head|Tail], Tmp, Inversa) :-
    invertiAux(Tail, [Head|Tmp], Inversa).