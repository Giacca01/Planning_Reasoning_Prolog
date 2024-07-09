:- dynamic possiedeMartello/0.
:- dynamic martello/1.
:- dynamic ghiaccio/1.
:- dynamic gemma/1.
:- dynamic mostro/1.

% Condizioni di applicabilità spostamento ad est
applicabile(est, pos(R, C)):-
    num_col(N),
    C < N,
    CRight is C + 1,
    \+occupata(pos(R, CRight)),
    (\+ghiaccio(pos(R, CRight)); possiedeMartello),
    (\+gemma(pos(R, CRight)); applicabileGemma(est, pos(R, CRight))).


applicabileGemma(est, pos(R, C)):-
    num_col(N),
    C < N,
    CRight is C + 1,
    \+occupata(pos(R, CRight)),
    \+ghiaccio(pos(R, CRight)),
    \+finale(pos(R, CRight)),
    \+mostro(pos(R, CRight)),
    !,
    (\+gemma(pos(R, CRight));
        % Se c'è la gemma devo poterla spostare
        applicabileGemma(est, pos(R, CRight))
    ).




% effetto delle azioni sullo stato
% Rispetto a prima, serve modellare la raccolta dei collezionabili
% cioè ghiaccio, gemme e martello

trasforma(est, pos(R, C), pos(R, CFin)) :-
    trasformaMultiStep(est, pos(R, C), pos(R, CFin)),
    retract(mostro(pos(R, C))),
    assert(mostro(pos(R, CFin))),
    findall(pos(RG, CG), gemma(pos(RG, CG)), ListaPosizioniGemme),
    spostaListaGemme(ListaPosizioniGemme, est).

trasformaMultiStep(est, pos(R, C), pos(R, CFin)) :-
    NewC is C + 1,
    % Spostamento di una posizione
    spostamento(est, pos(R, C), pos(R, NewC)),
    !,
    % Chiamata ricorsiva per continuare il movimento
    (\+applicabile(est, pos(R, NewC)), CFin is NewC;
    trasformaMultiStep(est, pos(R, NewC), pos(R, CFin))).


spostamento(est, pos(RCurr, CCurr), pos(NewR, NewC)) :-
    % L'algoritmo che chiama trasforma ha verificato che la mossa sia applicabile soltanto ad un passo
    % implementare trasforma in modo che verifichi tutti gli n passi sarebbe troppo costoso
    ghiaccio(pos(NewR, NewC)),
    !,
    retract(ghiaccio(pos(NewR, NewC))).

spostamento(est, pos(RCurr, CCurr), pos(NewR, NewC)) :-
    % Se incontro una gemma, la faccio avanzare fino al prossimo ostacolo
    % prima di spostare il mostro, in modo da preservare il posizionamento relativo
    gemma(pos(NewR, NewC)),
    !,
    applicabileGemma(est, pos(R, NewC)),
    spostaGemma(est, pos(NewR, NewC)).

spostamento(est, pos(RCurr, CCurr), pos(NewR, NewC)) :-
    martello(pos(NewR, NewC)),
    !,
    retract(martello(pos(NewR, NewC))),
    assert(possiedeMartello).

% Di base, se supero la verifica di appliabilità, il movimento ha successo
spostamento(est, pos(RCurr, CCurr), pos(NewR, NewC)).


spostaGemma(est, pos(R, C)) :-
    NewC is C + 1,
    (
        \+gemma(pos(R, NewC));
        spostaGemma(est, pos(R, NewC))
    ),
    retract(gemma(pos(R, C))),
    assert(gemma(pos(R, NewC))),
    (\+applicabileGemma(est, pos(R, NewC));
    spostaGemma(est, pos(R, NewC))).


spostaListaGemme([], _).
spostaListaGemme([pos(RG, CG)|Tail], Direzione) :-
    % La gemma potrebbe essere stata spostata durante il movimento
    % di un altro elemento della lista
    (
        \+gemma(pos(RG, CG));
        (
            \+applicabileGemma(Direzione, pos(RG, CG));
            spostaGemma(Direzione, pos(RG, CG))
        )
    ),
    spostaListaGemme(Tail, Direzione).
