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

% Se c'è la gemma posso comunque spostarmi, perchè anche lei si muoverà
% male che vada, la gemma non può spostarsi, quindi lanciando trasforma
% non si sposta nemmeno lui
applicabile(nord, pos(R, C)) :-
    R > 1,
    RUp is R - 1,
    gemma(pos(RUp, C)).



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

applicabile(sud, pos(R, C)) :-
    num_righe(N),
    R < N,
    RDown is R + 1,
    gemma(pos(RDown, C)).



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

applicabile(est, pos(R, C)):-
    num_col(N),
    C < N,
    CRight is C + 1,
    gemma(pos(R, CRight)).



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

applicabile(ovest, pos(R, C)):-
    C > 1,
    CLeft is C - 1,
    gemma(pos(R, CLeft)).


% effetto delle azioni sullo stato
% Rispetto a prima, serve modellare la raccolta dei collezionabili
% cioè ghiaccio, gemme e martello

trasforma(est, pos(R, C), pos(R, CDxFin)) :-
    CDx is C + 1,
    % non è molto efficiente, però riciclo il controllo sui bound
    applicabile(est, pos(R, CDx)),
    ghiaccio(pos(R, CDx)),
    !,
    possiedeMartello,
    retract(ghiaccio(pos(R, CDx))),
    CDxFin is CDx.

trasforma(est, pos(R, C), pos(R, CDxFin)) :-
    CDx is C + 1,
    % Se c'è il martello è sicuramente applicabile
    % anche qui, testare applicabile serve a fare il controllo sui bound
    applicabile(est, pos(R, CDx)),
    martello(pos(R, CDx)),
    !,
    retract(martello(pos(R, CDx))),
    assert(possiedeMartello),
    CDxFin is CDx.

trasforma(est, pos(R, C), pos(R, CDxFin)) :- 
    CDx is C + 1,
    applicabile(est, pos(R, CDx)),
    !,
    trasforma(est, pos(R, CDx), pos(R, CDxFin)).


trasforma(est, pos(R, C), pos(R, CDxFin)) :-
    CDx is C + 1,
    % Se arrivo qui, so che sicuramente l'azione è non applicabile
    % ma non è detto lo sia per colpa della gemma, potrebbe derivare dai bounds
    gemma(pos(R, CDx)),
    !,
    % Movimento della gemma incontrata, in modo da mantenere ordine relativo
    muoviGemma(est, pos(R, CDx), pos(R, CDx), pos(R, C), pos(R, CFinGemma)),
    % L'agente si sposta nella cella precedente la gemma
    CDxFin is CFinGemma - 1,
    % Sposto tutte le altre gemme, stando attento a non sbattere nell'agente
    findAll(pos(R1, G1), gemma(pos(R1, G1)), ListaGemme),
    spostaGemme(ListaGemme, est, pos(R, CDxFin)).


% direzione, posizione iniziale gemma, lastPos, pos agente, posizione finale gemma
muoviGemma(est, pos(R, CIn), pos(RLast, CLast),  pos(RAgente, CAgente), pos(R, Cfin)) :-
    CNew is CLast + 1,
    R \== RAgente,
    CAgente \== CNew,
    \+ostacolo(pos(R, CNew)),
    muoviGemma(est, pos(R, CIn), pos(RLast, CNew), pos(RAgente, CAgente), pos(R, Cfin)).

muoviGemma(est, pos(R, CIn), pos(RLast, CLast), pos(RAgente, CAgente), pos(R, Cfin)) :-
    CNew is CIn + 1,
    gemma(pos(R, CNew)),
    !,
    muoviGemma(est, pos(R, CNew), pos(R, CNew), pos(RAgente, CAgente), pos(RFinG, CFinG)),
    retract(gemma(pos(R, CIn))),
    Cfin is CFinG - 1,
    assert(gemma(pos(R, Cfin))).

muoviGemma(_, pos(RIn, CIn), pos(RLast, CLast), pos(RAgente, CAgente), pos(RIn, CIn)) :-
    retract(gemma(pos(RIn, CIn))),
    assert(gemma(pos(RLast, CLast))).



spostaGemme([], _, _, _).
spostaGemme([Gemma|Tail], est, pos(RAgente, CAgente)) :-
    muoviGemma(est, Gemma, Gemma, pos(RAgente, CAgente), _).

