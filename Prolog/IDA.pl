ricerca(CamminoFinale) :-
    iniziale(S0),
    euristica(S0, Soglia),
    ida_driver(S0, [], [S0], Soglia, CamminoInverso),
    inverti(CamminoInverso, CamminoFinale).


ida_driver(S0, Cammino, Visitati, Soglia, CamminoInverso) :-
    % Iterazione i-esima
    ida(S0, Cammino, Visitati, Soglia, CamminoInverso, 0),
    % Se l'iterazione ha successo, non c'è bisogno di considerare l'applicazione di altre regole
    !.

ida_driver(S0, Cammino, Visitati, Soglia, CamminoInverso) :-
    % Se arrivo qui, l'iterazione i-esima non è andata a buon fine
    % quindi devo salvare il minimo dei valori fuori soglia

    % Recupero le stime di costo prodotte durante l'iteazione i-esima
    findall(StimaCosto, (soglia(S, StimaCosto), isGreater(StimaCosto, Soglia)), StimeMaggiori),
    min_list(StimeMaggiori, NuovaSoglia),
    % Indispensabile, altrimenti tutte le iterazioni successive continueranno ad usare
    % la soglia della prima, che, per costruzione, è minore di quelle che verranno dopo
    retractall(soglia(_, _)),
    % Inizio iterazione i+1-esima
    ida_driver(S0, Cammino, Visitati, NuovaSoglia, CamminoInverso).

isGreater(Stima, Soglia) :-
    Stima > Soglia.


ida(S, Cammino, Visitati, Soglia, Cammino, _):-
    % lo stato corrente è entro il limite: procediamo con la valutazione

    % Inutile: è una ricerca in profondità, non può essere che io trovi
    % due stati finali, al primo mi fermo
    % \+member(S, Visitati),
    finale(S),
    % Ultima iterazione dell'algoritmo
    !.

ida(S, Cammino, Visitati, Soglia, CamminoInverso, CostoAttuale):-
    % Genero uno dei nodi figli
    applicabile(Az, S),
    trasforma(Az, S, SNuovo),
    % processamento del nodo figlio
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




% Inversione lista contenente il cammino completo
inverti(ListPrinc, Inversa) :- invertiAux(ListPrinc, [], Inversa).

invertiAux([], Tmp, Tmp).
invertiAux([Head|Tail], Tmp, Inversa) :-
    invertiAux(Tail, [Head|Tmp], Inversa).