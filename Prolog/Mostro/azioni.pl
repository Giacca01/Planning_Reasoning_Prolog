% TODO: anche il portale va contato come un ostacolo
% TODO: modificare euristica per considerare le gemme
% TODO: testare cosa succede con più gemme sulla stessa riga/colonna

/* ostacoloMobile(pos(X, Y)) :- gemma(pos(X, Y)).

ostacoloFisso(pos(X, Y)) :- 
    ghiaccio(pos(X, Y)); 
    occupata(pos(X, Y)).

ostacolo(pos(X, Y)) :- 
    ostacoloMobile(pos(X, Y));
    ostacoloFisso(pos(X, Y)). */

% Condizioni di applicabilità delle singole azioni

% Rispetto a prima, dove la mossa era ostacolata soltanto da muri infrangibili
% qui abbiamo anche i frangibili, che però si possono eliminare con il martello
% e le gemme, che però si possono raccogliere
% in più, c'è anche l'avversario
% in più, potrebbe esserci anche il martello

% iniziamo dando la modellazione più espressiva possibile
% eventuali efficientamenti verranno dopo

% Condizioni di applicabilità spostamento a nord
% Se non ci sono ostacoli, oppure se c'è del ghiaccio
% ma io possiedo il martello, allora posso spostarmi
/* applicabile(nord, pos(R, C)) :-
    R > 1,
    RUp is R - 1,
    \+occupata(pos(RUp, C)),
    !,
    \+ghiaccio(pos(RUp, C)).

applicabile(nord, pos(R, C)) :-
    R > 1,
    RUp is R - 1,
    ghiaccio(pos(RUp, C)),
    possiedeMartello.

applicabile(nord, pos(R, C)) :-
    R > 1,
    RUp is R - 1,
    gemma(pos(RUp, C)),
    % Se il movimento dell'agente è ostacolato da una gemma
    % la mossa è applicabile se e solo se la gemma può spostarsi
    applicabile(nord, pos(RUp, C)).


% Condizioni di applicabilità spostamento a sud
applicabile(sud, pos(R, C)) :-
    num_righe(N),
    R < N,
    RDown is R + 1,
    \+occupata(pos(RDown, C)),
    !,
    \+ghiaccio(pos(RDown, C)).

applicabile(sud, pos(R, C)) :-
    num_righe(N),
    R < N,
    RDown is R + 1,
    ghiaccio(pos(RDown, C)),
    possiedeMartello.

applicabile(sud, pos(R, C)) :-
    num_righe(N),
    R < N,
    RDown is R + 1,
    gemma(pos(RDown, C)),
    % Se il movimento dell'agente è ostacolato da una gemma
    % la mossa è applicabile se e solo se la gemma può spostarsi
    applicabile(nord, pos(RDown, C)). */

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
    \+ghiaccio(pos(R, CRight)).

applicabile(est, pos(R, C)):-
    num_col(N),
    C < N,
    CRight is C + 1,
    ghiaccio(pos(R, CRight)),
    possiedeMartello.

applicabile(est, pos(R, C)):-
    num_col(N),
    C < N,
    CRight is C + 1,
    gemma(pos(R, CRight)),
    applicabile(est, pos(R, CRight)).


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
        applicabile(est, pos(R, CRight))
    ).



% Condizioni di applicabilità spostamento ad ovest
/* applicabile(ovest, pos(R, C)):-
    C > 1,
    CLeft is C - 1,
    \+ostacolo(pos(R, CLeft)),
    !,
    \+ghiaccio(pos(R, CLeft)).

applicabile(ovest, pos(R, C)):-
    C > 1,
    CLeft is C - 1,
    ghiaccio(pos(R, CLeft)),
    possiedeMartello.

applicabile(ovest, pos(R, C)):-
    C > 1,
    CLeft is C - 1,
    gemma(pos(R, CLeft)),
    applicabile(pos(R, CLeft)). */


% effetto delle azioni sullo stato
% Rispetto a prima, serve modellare la raccolta dei collezionabili
% cioè ghiaccio, gemme e martello

trasforma(est, pos(R, C), pos(R, CFin)) :-
    trasformaMultiStep(est, pos(R, C), pos(R, CFin)),
    retract(mostro(pos(R, C))),
    assert(mostro(pos(R, CFin))),
    findall(pos(RG, CG), gemma(pos(RG, CG)), ListaPosizioniGemme),
    spostaListaGemme(ListaPosizioniGemme, Direzione).

trasformaMultiStep(est, pos(R, C), pos(R, CFin)) :-
    NewC is C + 1,
    % Spostamento di una posizione
    spostamento(est, pos(R, C), pos(R, NewC)),
    !,
    % Chiamata ricorsiva per continuare il movimento
    (\+applicabile(est, pos(R, NewC)), CFin is C;
    trasformaMultiStep(est, pos(R, NewC), pos(R, CFin))).


% ci arrivo se non posso spostarmi ulteriomente a partire dalla cella corrente
%trasforma(est, pos(R, C), pos(R, C)) :-
    % pos(R, C) è la posizione in cui si trova l'agente a fine movimento
    % Lancio lo spostamento delle gemme, tenendo conto del fatto che in posizione
    % pos(R, C) c'è l'agente, che è un ostacolo
%    sposta_gemme(pos(R, C), est).


% in realtà più che lo spostamento modella il trattamento degli oggetti
% che avviene durante il medesimo
% spostamento(direzione, posizione di partenza, posizione di arrivo)
% la posizione di arrivo è stata calcolata da trasforma
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

% TODO: Possibile problema. Questa funzione fa tanti assert e retract
% tuttavia, il labirinto è piccolo e le gemme sono poche, quindi non dovrebbe essere
% un problema.
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
    (\+applicabileGemma(Direzione, pos(RG, CG));
    spostaGemma(pos(RG, CG), Direzione)).
