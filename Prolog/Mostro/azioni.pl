% Condizioni di applicabilità delle singole azioni

% Rispetto a prima, dove la mossa era ostacolata soltanto da muri infrangibili
% qui abbiamo anche i frangibili, che però si possono eliminare con il martello
% e le gemme, che però si possono raccogliere
% in più, c'è anche l'avversario
% in più, potrebbe esserci anche il martello

% iniziamo dando la modellazione più espressiva possibile
% eventuali efficientamenti verranno dopo

% Condizioni di applicabilità spostamento a nord
applicabile(nord, pos(R, C)) :-
    R > 1,
    RUp is R - 1,
    % Se c'è il muro di ghiaccio sicuramente la cella non può essere occupata
    % da un muro infrangibile
    %\+occupata(pos(RUp, C)),
    % Posso spostarmi dove c'è un muro di ghiaccio solo se posseggo il martello
    ghiaccio(pos(RUp, C)),
    \+ghiaccioRotto(pos(RUp, C)),
    possiedeMartello.


% In una cella con gemme in realtà posso spostarmi sempre
% perchè la gemma non ha condizioni di raccolta particolari
/* applicabile(nord, pos(R, C)) :-
    R > 1,
    RUp is R - 1,
    gemma(pos(RUp, C)),
    \+gemmaRaccolta(pos(RUp, C)). */


% Anche in una cella con martello posso spostarmi sempre
% perchè non ci sono condizioni particolari per la raccolta
/* applicabile(nord, pos(R, C)) :-
    R > 1,
    RUp is R - 1,
    martello(pos(RUp, C)). */

applicabile(nord, pos(R, C)) :-
    R > 1,
    RUp is R - 1,
    % In una cella con avversario non posso muovermi mai
    \+avversario(pos(RUp, C)).

% TODO: aggiungere cut sincerandosi che parta solo quando non ci sono altri ostacoli
applicabile(nord, pos(R, C)) :-
    R > 1,
    RUp is R - 1,
    \+occupata(pos(RUp, C)).



% Condizioni di applicabilità spostamento a sud
applicabile(sud, pos(R, C)) :-
    num_righe(N),
    R < N,
    RDown is R + 1,
    ghiaccio(pos(RDown, C)),
    \+ghiaccioRotto(pos(RDown, C)),
    possiedeMartello.

applicabile(sud, pos(R, C)) :-
    num_righe(N),
    R < N,
    RDown is R + 1,
    \+avversario(pos(RDown, C)).

applicabile(sud, pos(R, C)) :-
    num_righe(N),
    R < N,
    RDown is R + 1,
    \+occupata(pos(RDown, C)).


% Condizioni di applicabilità spostamento ad est
applicabile(est, pos(R, C)):-
    num_col(N),
    C < N,
    CRight is C + 1,
    ghiaccio(pos(R, CRight)),
    \+ghiaccioRotto(pos(R, CRight)),
    possiedeMartello.

applicabile(est, pos(R, C)):-
    num_col(N),
    C < N,
    CRight is C + 1,
    \+avversario(pos(R, CRight)).

applicabile(est, pos(R, C)):-
    num_col(N),
    C < N,
    CRight is C + 1,
    \+occupata(pos(R, CRight)).



% Condizioni di applicabilità spostamento ad ovest
applicabile(ovest, pos(R, C)):-
    C > 1,
    CLeft is C - 1,
    ghiaccio(pos(R, CLeft)),
    \+ghiaccioRotto(pos(R, CLeft)),
    possiedeMartello.

applicabile(ovest, pos(R, C)):-
    C > 1,
    CLeft is C - 1,
    \+avversario(pos(R, CLeft)).

applicabile(ovest, pos(R, C)):-
    C > 1,
    CLeft is C - 1,
    \+occupata(pos(R, CLeft)).


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

% Conviene modellarlo come un fatto, perchè tanto
% le ipotesi le ho già verificate.
ghiaccioRotto(pos(R, C)).

possiedeMartello(pos(R, C)).

gemmaRaccolta(pos(R, C)).

% Effetti del movimento ad Est
trasforma(est, pos(R, C), pos(R, CDx)) :- 
    CDx is C + 1,
    martello(pos(R, CDx)),
    possiedeMartello(pos(R, CDx)).


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