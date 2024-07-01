ostacoloMobile(pos(X, Y)) :- gemma(pos(X, Y)).

ostacoloFisso(pos(X, Y)) :- 
    ghiaccio(pos(X, Y)); 
    occupata(pos(X, Y)).

ostacolo(pos(X, Y)) :- 
    ostacoloMobile(pos(X, Y));
    ostacoloFisso(pos(X, Y)).

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
applicabile(nord, pos(R, C)) :-
    R > 1,
    RUp is R - 1,
    \+ostacolo(pos(RUp, C)),
    !.

applicabile(nord, pos(R, C)) :-
    R > 1,
    RUp is R - 1,
    ghiaccio(pos(RUp, C)),
    possiedeMartello.



% Condizioni di applicabilità spostamento a sud
applicabile(sud, pos(R, C)) :-
    num_righe(N),
    R < N,
    RDown is R + 1,
    \+ostacolo(pos(RDown, C)),
    !.

applicabile(sud, pos(R, C)) :-
    num_righe(N),
    R < N,
    RDown is R + 1,
    ghiaccio(pos(RDown, C)),
    possiedeMartello.



% Condizioni di applicabilità spostamento ad est
applicabile(est, pos(R, C)):-
    num_col(N),
    C < N,
    CRight is C + 1,
    \+ostacolo(pos(R, CRight)),
    !.

applicabile(est, pos(R, C)):-
    num_col(N),
    C < N,
    CRight is C + 1,
    ghiaccio(pos(R, CRight)),
    possiedeMartello.



% Condizioni di applicabilità spostamento ad ovest
applicabile(ovest, pos(R, C)):-
    C > 1,
    CLeft is C - 1,
    \+ostacolo(pos(R, CLeft)).

applicabile(ovest, pos(R, C)):-
    C > 1,
    CLeft is C - 1,
    ghiaccio(pos(R, CLeft)),
    possiedeMartello.


% effetto delle azioni sullo stato
% Rispetto a prima, serve modellare la raccolta dei collezionabili
% cioè ghiaccio, gemme e martello
trasforma(est, pos(R, C), pos(R, CDx)) :- 
    CDx is C + 1,
    ghiaccio(pos(R, CDx)),
    % Non serve davvero ricontrollarlo, è una proprietà che c'è sicuramente
    % altrimenti lo spostamento non sarebbe stato autorizzato in origine
   % possiedeMartello,
    % sono in grado di rompere il ghiaccio
    % "attivo" il fatto solo ora perchè non è detto che
    % la verifica dell'applicabilità di un'azione corrisponda alla sua effettiva applicaziones
    ghiaccioRotto(pos(R, CDx)).


% Effetti del movimento ad Est
trasforma(est, pos(R, C), pos(R, CDx)) :- 
    ghiaccio(pos())

    % Idea: con findAll recupero mostri, gemme ed ostacoli in ghiaccio
    % ed applico a tutti una regola trasforma che codica solo la componente di movimento
    % cioè la modifica della singola coordinata
    CDx is C + 1,
    % Recupero ostacoli sulla stessa riga, 
    findAll(C1, ostacolo(pos(R, C1)), ListaOstacoliFissi),
    MinOstacoloFisso is min(ListaOstacoliFissi),
    % Le gemme che si trovano sulla stessa riga ma a destra del mostro
    % vanno mosse prima e normalmente
    findAll(pos(R1, G1), gemma(pos(R1, G1)), ListaGemme),
    selezioneGemmeEst(ListaGemme, pos(R, C), GemmeDiffRiga, GemmeAfter, GemmeBefore),
    spostaGemmeEst(GemmeAfter),
    % TODO: implementare spostamento gemme che si trovano prima del mostro
    % (In teoria basta spostare prima il mostro e poi trattarle come le altre)

    % Recupero gemme da spostare
    findAll(pos(RG, CG), gemma(pos(RG, CG)), ListaGemme),

    % Verifico se ci sia un martello da poter recuperare
    checkMartello(pos(R, CDX)),

    % Frantumo il ghiaccio in celle adiacenti

checkMartello(pos(R, C)) :-
    martello(pos(R, C)),
    !,
    retract(martello(pos(R, C))),
    assert(possiedeMartello).

checkMartello(pos(R, C)) :-
    \+martello(pos(R, C)).


frantumaGhiaccio(pos(R, C)) :-
    ghiaccio(pos(R, C)),
    possiedeMartello,
    retract(ghiaccio(pos(R, C))).


selezioneGemmeEst([], _, [], [], []).



selezioneGemmeEst([pos(R, C)|TailOriginale], pos(RM, CM), GemmeDiffRiga, [C|ListAfter], ListBefore) :-
    RM == R,
    !,
    C > CM,
    !,
    selezioneGemmeEst(TailOriginale, pos(RM, CM), GemmeDiffRiga, ListAfter, ListBefore).

selezioneGemmeEst([pos(R, C)|TailOriginale], pos(RM, CM), GemmeDiffRiga, ListAfter, [C|ListBefore]) :-
    RM == R,
    !,
    selezioneGemmeEst(TailOriginale, ColMostro, GemmeDiffRiga, ListAfter, ListBefore).

selezioneGemmeEst([pos(R, C)|TailOriginale], pos(RM, CM), [GemmeDiffRiga], ListAfter, ListBefore) :-



% Supponiamo che la lista di gemme sia ordinata in modo decrescente
spostaGemmeEst([pos(R, C)]) :-
    retract(gemma(pos(R, C))),
    findAll(C1, ostacoloFisso(pos(R, C1)), ListaOstacoliFissi),
    MinOstacoloFisso is min(ListaOstacoliFissi),
    CDx is MinOstacoloFisso - 1,
    assert(gemma(R, CDx)).

spostaGemmeEst([pos(R, C)|ListaGemme]) :-
    spostaGemmeEst(ListaGemme, PosLastGemma),
    retract(gemma(pos(R, C))),
    % Recupero ostacoli fissi sulla stessa riga
    findAll(C1, ostacoloFisso(pos(R, C1)), ListaOstacoliFissi),
    MinOstacoloFisso is min(ListaOstacoliFissi),
    CDx is PosLastGemma - 1,
    assert(gemma(pos(R, CDx))).


trasforma(est, pos(R, C), pos(R, CDx)) :- 
    CDx is C + 1,
    gemma(pos(R, CDx)),
    gemmaRaccolta(pos(R, CDx)).


% Effetti del movimento ad ovest
trasforma(ovest, pos(R, C), pos(R, CSx)) :-
    CSx is C - 1,
    martello(pos(R, CSx)),
    possiedeMartello(pos(R, CSx)).

trasforma(ovest, pos(R, C), pos(R, CSx)) :-
    CSx is C - 1,
    gemma(pos(R, CSx)),
    gemmaRaccolta(pos(R, CSx)).

trasforma(ovest, pos(R, C), pos(R, CSx)) :-
    CSx is C - 1,
    ghiaccio(pos(R, CSx)),
    ghiaccioRotto(pos(R, CSx)).


% Effetto del movimento a nord
trasforma(nord, pos(R, C), pos(RUp, C)) :-
    RUp is R - 1,
    martello(pos(RUp, C)),
    possiedeMartello(pos(RUp, C)).

trasforma(nord, pos(R, C), pos(RUp, C)) :-
    RUp is R - 1,
    gemma(pos(RUp, C)),
    gemmaRaccolta(pos(RUp, C)).

trasforma(nord, pos(R, C), pos(RUp, C)) :-
    RUp is R - 1,
    ghiaccio(pos(RUp, C)),
    ghiaccioRotto(pos(RUp, C)).


% Effetto del movimento a sud
trasforma(sud, pos(R, C), pos(RDown, C)) :-
    RDown is R + 1,
    martello(pos(RDown, C)),
    possiedeMartello(pos(RDown, C)).

trasforma(sud, pos(R, C), pos(RDown, C)) :-
    RDown is R + 1,
    gemma(pos(RDown, C)),
    gemmaRaccolta(pos(RDown, C)).

trasforma(sud, pos(R, C), pos(RDown, C)) :-
    RDown is R + 1,
    ghiaccio(pos(RDown, C)),
    ghiaccioRotto(pos(RDown, C)).