:- dynamic possiedeMartello/0.
:- dynamic martello/1.
:- dynamic ghiaccio/1.
:- dynamic gemma/1.
:- dynamic mostro/1.

% Condizioni di applicabilità spostamento ad est
/* applicabile(est, pos(R, C)):-
    num_col(N),
    C < N,
    CRight is C + 1,
    \+occupata(pos(R, CRight)),
    (\+ghiaccio(pos(R, CRight)); possiedeMartello),
    (\+gemma(pos(R, CRight)); applicabileGemma(est, pos(R, CRight))). */


% Condizioni di applicabilità spostamento ad ovest
/* applicabile(ovest, pos(R, C)):-
    C > 1,
    CLeft is C - 1,
    \+occupata(pos(R, CLeft)),
    (\+ghiaccio(pos(R, CLeft)); possiedeMartello),
    (\+gemma(pos(R, CLeft)); applicabileGemma(ovest, pos(R, CLeft))). */

% Condizioni di applicabilità spostamento a sud
applicabile(sud, pos(R, C)):-
    num_righe(N),
    R < N,
    RDown is R + 1,
    \+occupata(pos(RDown, C)),
    (\+ghiaccio(pos(RDown, C)); possiedeMartello),
    (\+gemma(pos(RDown, C)); applicabileGemma(sud, pos(RDown, C))).


% Condizioni di applicabilità spostamento a nord
applicabile(nord, pos(R, C)):-
    R > 1,
    RUp is R - 1,
    \+occupata(pos(RUp, C)),
    (\+ghiaccio(pos(RUp, C)); possiedeMartello),
    (\+gemma(pos(RUp, C)); applicabileGemma(nord, pos(RUp, C))).




% Condizioni di spostamento della gemma ad est
/* applicabileGemma(est, pos(R, C)):-
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
    ). */

% Condizioni di spostamento della gemma ad ovest
/* applicabileGemma(ovest, pos(R, C)):-
    C > 1,
    CLeft is C - 1,
    \+occupata(pos(R, CLeft)),
    \+ghiaccio(pos(R, CLeft)),
    \+finale(pos(R, CLeft)),
    \+mostro(pos(R, CLeft)),
    !,
    (\+gemma(pos(R, CLeft));
        % Se c'è la gemma devo poterla spostare
        applicabileGemma(ovest, pos(R, CLeft))
    ). */

% Condizioni di spostamento della gemma a sud
applicabileGemma(sud, pos(R, C)):-
    num_righe(N),
    R < N,
    RDown is R + 1,
    \+occupata(pos(RDown, C)),
    \+ghiaccio(pos(RDown, C)),
    \+finale(pos(RDown, C)),
    \+mostro(pos(RDown, C)),
    !,
    (\+gemma(pos(RDown, C));
        % Se c'è la gemma devo poterla spostare
        applicabileGemma(sud, pos(RDown, C))
    ).

% Condizioni di spostamento della gemma a nord
applicabileGemma(nord, pos(R, C)):-
    R > 1,
    RUp is R - 1,
    \+occupata(pos(RUp, C)),
    \+ghiaccio(pos(RUp, C)),
    \+finale(pos(RUp, C)),
    \+mostro(pos(RUp, C)),
    !,
    (\+gemma(pos(RUp, C));
        % Se c'è la gemma devo poterla spostare
        applicabileGemma(sud, pos(RUp, C))
    ).


% effetto delle azioni sullo stato
% Rispetto a prima, serve modellare la raccolta dei collezionabili
% cioè ghiaccio, gemme e martello

% Driver dello spostamento di n passi, da pos(R, C) a pos(R, CFin)
trasforma(Direzione, pos(R, C), pos(R, CFin)) :-
    trasformaMultiStep(Direzione, pos(R, C), pos(R, CFin)),
    retract(mostro(pos(R, C))),
    assert(mostro(pos(R, CFin))),
    findall(pos(RG, CG), gemma(pos(RG, CG)), ListaPosizioniGemme),
    spostaListaGemme(ListaPosizioniGemme, Direzione).

% Spostamento di n passi in direzione est, da pos(R, C) a pos(R, CFin)
/* trasformaMultiStep(est, pos(R, C), pos(R, CFin)) :-
    NewC is C + 1,
    % Spostamento di una posizione
    spostamento(est, pos(R, C), pos(R, NewC)),
    !,
    % Chiamata ricorsiva per continuare il movimento
    (\+applicabile(est, pos(R, NewC)), CFin is NewC;
    trasformaMultiStep(est, pos(R, NewC), pos(R, CFin))). */

% Spostamento di n passi in direzione ovest, da pos(R, C) a pos(R, CFin)
/* trasformaMultiStep(ovest, pos(R, C), pos(R, CFin)) :-
    NewC is C - 1,
    % Spostamento di una posizione
    spostamento(ovest, pos(R, C), pos(R, NewC)),
    !,
    % Chiamata ricorsiva per continuare il movimento
    (\+applicabile(ovest, pos(R, NewC)), CFin is NewC;
    trasformaMultiStep(ovest, pos(R, NewC), pos(R, CFin))). */

% Spostamento di n passi in direzione sud, da pos(R, C) a pos(R, CFin)
trasformaMultiStep(sud, pos(R, C), pos(RFin, C)) :-
    NewR is R + 1,
    % Spostamento di una posizione
    spostamento(sud, pos(R, C), pos(NewR, C)),
    !,
    % Chiamata ricorsiva per continuare il movimento
    (\+applicabile(sud, pos(NewR, C)), RFin is NewR;
    trasformaMultiStep(sud, pos(NewR, C), pos(RFin, C))).

% Spostamento di n passi in direzione nord, da pos(R, C) a pos(RFin, C)
trasformaMultiStep(nord, pos(R, C), pos(RFin, C)) :-
    NewR is R - 1,
    % Spostamento di una posizione
    spostamento(nord, pos(R, C), pos(NewR, C)),
    !,
    % Chiamata ricorsiva per continuare il movimento
    (\+applicabile(nord, pos(NewR, C)), RFin is NewR;
    trasformaMultiStep(nord, pos(NewR, C), pos(RFin, C))).




spostamento(_, pos(RCurr, CCurr), pos(NewR, NewC)) :-
    % L'algoritmo che chiama trasforma ha verificato che la mossa sia applicabile soltanto ad un passo
    % implementare trasforma in modo che verifichi tutti gli n passi sarebbe troppo costoso
    ghiaccio(pos(NewR, NewC)),
    !,
    retract(ghiaccio(pos(NewR, NewC))).

spostamento(Direzione, pos(RCurr, CCurr), pos(NewR, NewC)) :-
    % Se incontro una gemma, la faccio avanzare fino al prossimo ostacolo
    % prima di spostare il mostro, in modo da preservare il posizionamento relativo
    gemma(pos(NewR, NewC)),
    !,
    applicabileGemma(Direzione, pos(R, NewC)),
    spostaGemma(Direzione, pos(NewR, NewC)).

spostamento(_, pos(RCurr, CCurr), pos(NewR, NewC)) :-
    martello(pos(NewR, NewC)),
    !,
    retract(martello(pos(NewR, NewC))),
    assert(possiedeMartello).

% Di base, se supero la verifica di appliabilità, il movimento ha successo
spostamento(_, pos(RCurr, CCurr), pos(NewR, NewC)).


% Singolo passo di spostamento della gemma verso est
/* spostaGemma(est, pos(R, C)) :-
    NewC is C + 1,
    (
        \+gemma(pos(R, NewC));
        spostaGemma(est, pos(R, NewC))
    ),
    retract(gemma(pos(R, C))),
    assert(gemma(pos(R, NewC))),
    (\+applicabileGemma(est, pos(R, NewC));
    spostaGemma(est, pos(R, NewC))). */


% Singolo passo di spostamento della gemma verso ovest
/* spostaGemma(ovest, pos(R, C)) :-
    NewC is C - 1,
    (
        \+gemma(pos(R, NewC));
        spostaGemma(ovest, pos(R, NewC))
    ),
    retract(gemma(pos(R, C))),
    assert(gemma(pos(R, NewC))),
    (\+applicabileGemma(ovest, pos(R, NewC));
    spostaGemma(ovest, pos(R, NewC))). */

spostaGemma(sud, pos(R, C)) :-
    NewR is R + 1,
    (
        \+gemma(pos(NewR, C));
        spostaGemma(sud, pos(NewR, C))
    ),
    retract(gemma(pos(R, C))),
    assert(gemma(pos(NewR, C))),
    (\+applicabileGemma(sud, pos(NewR, C));
    spostaGemma(sud, pos(NewR, C))).

spostaGemma(nord, pos(R, C)) :-
    NewR is R - 1,
    (
        \+gemma(pos(NewR, C));
        spostaGemma(nord, pos(NewR, C))
    ),
    retract(gemma(pos(R, C))),
    assert(gemma(pos(NewR, C))),
    (\+applicabileGemma(nord, pos(NewR, C));
    spostaGemma(nord, pos(NewR, C))).






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
