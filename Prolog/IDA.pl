ricerca(CamminoFinale) :-
    iniziale(S0),
    euristica(S0, Soglia),
    NumeroTentativi is Soglia / 2,
    ida_driver(S0, [], [S0], Soglia, NumeroTentativi, CamminoInverso),
    inverti(CamminoInverso, CamminoFinale).


ida_driver(S0, Cammino, Visitati, Soglia, NumeroTentativi, CamminoInverso) :-
    NumeroTentativi > 0,
    % Iterazione i-esima
    ida(S0, Cammino, Visitati, Soglia, CamminoInverso, 0),
    % Se l'iterazione ha successo, non c'è bisogno di considerare l'applicazione di altre regole
    !.

ida_driver(S0, Cammino, Visitati, Soglia, NumeroTentativi, CamminoInverso) :-
    NumeroTentativi > 0,
    % Se arrivo qui, l'iterazione i-esimo non è andata a buon fine

    % Recupero le stime di costo prodotte durante l'iteazione i-esima
    findall(StimaCosto, (soglia(S, StimaCosto), isGreater(StimaCosto, Soglia)), StimeMaggiori),
   % exclude(>=(Soglia), ListaStime, ListaOltreSoglia),
    min_list(StimeMaggiori, NuovaSoglia),
    % Indispensabile, altrimenti tutte le iterazioni successive continueranno ad usare
    % la soglia della prima. Inoltre, così ci sono meno fatti da recupera con findAll
    retractall(soglia(_, _)),
    % Inizio iterazione i+1-esima
    NewNumeroTentativi is NumeroTentativi - 1,
    ida_driver(S0, Cammino, Visitati, NuovaSoglia, NewNumeroTentativi, CamminoInverso).
% Non serve mettere altri cut, tanto non ci sono altre regole da provare


isGreater(Stima, Soglia) :-
    Stima > Soglia.

% Se lo stato è già stato visitato non ho regole da applicare e quindi fallisco
ida(S, Cammino, Visitati, Soglia, Cammino, _):-
    % lo stato corrente è entro il limite: procediamo con la valutazione

    % Inutile: è una ricerca in profondità, non può essere che io trovi
    % due stati finali, al primo mi fermo
    % \+member(S, Visitati),
    finale(S),
    % Ultima iterazione dell'algoritmo
    !.

ida(S, Cammino, Visitati, Soglia, CamminoInverso, CostoAttuale):-
    % Genero i nodi figli
    applicabile(Az, S),
    trasforma(Az, S, SNuovo),
    \+member(SNuovo, Visitati),
    euristica(SNuovo, StimaCosto),
    NewCostoAttuale is CostoAttuale + 1,
    StimaTotale is CostoAttuale + StimaCosto + 1,
    % Salvo il valore della funzione F per il nodo corrente
    % in modo da poter recuperare il minimo dei valori fuori soglia all'iterazione i
    % che costituirà la soglia all'iterazione i + 1
    assert(soglia(S, StimaTotale)),
    % Se il nodo corrente supera la soglia, l'applicazione di questa regola fallisce
    % e, di conseguenza, tutta la catena di chiamate
    StimaTotale =< Soglia,
    ida(SNuovo, [Az|Cammino], [SNuovo|Visitati], Soglia, CamminoInverso, NewCostoAttuale).

% Se il nodo fa già parte del path non ci sono regole applicabili
% quindi la ricerca fallisce e si passa al successivo
% anche qui, non servono dei cut, tanto non ci sono altre regole applicabili


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