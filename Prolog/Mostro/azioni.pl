% Condizioni di applicabilità spostamento ad ovest
applicabile(ovest, [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme]):-
    C > 1,
    CLeft is C - 1,
    \+occupata(pos(R, CLeft)),
    controlloGhiaccio(pos(R, CLeft), ListaMuriGhiaccio, ListaMartello),
    controlloGemma(ovest, pos(R, CLeft), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme).


% Condizioni di applicabilità spostamento a sud
applicabile(sud, [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme]):-
    num_righe(N),
    R < N,
    RDown is R + 1,
    \+occupata(pos(RDown, C)),
    controlloGhiaccio(pos(RDown, C), ListaMuriGhiaccio, ListaMartello),
    controlloGemma(sud, pos(RDown, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme).


% Condizioni di applicabilità spostamento a nord
applicabile(nord, [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme]):-
    R > 1,
    RUp is R - 1,
    \+occupata(pos(RUp, C)),
    controlloGhiaccio(pos(RUp, C), ListaMuriGhiaccio, ListaMartello),
    controlloGemma(nord, pos(RUp, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme).


% Condizioni di applicabilità spostamento ad est
applicabile(est, [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme]):-
    num_col(N),
    C < N,
    CRight is C + 1,
    \+occupata(pos(R, CRight)),
    controlloGhiaccio(pos(R, CRight), ListaMuriGhiaccio, ListaMartello),
    controlloGemma(est, pos(R, CRight), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme).



controlloGhiaccio(NuovaPos, ListaMuriGhiaccio, ListaMartello) :-
    \+member(ghiaccio(NuovaPos), ListaMuriGhiaccio),
    !.
% Nella posizione di arrivo c'è un muro di ghiaccio, quindi l'agente deve avere il martello
controlloGhiaccio(NuovaPos, ListaMuriGhiaccio, [possiedeMartello]).
    
% Nella Posizione di arrivo non ci devono essere gemme, oppure devono essere spostabili
controlloGemma(Direzione, NuovaPos, PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme) :-
    \+member(gemma(NuovaPos), ListaGemme),
    !.
controlloGemma(Direzione, NuovaPos, PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme) :-
    applicabileGemma(Direzione, NuovaPos, PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme).












% Condizioni di spostamento della gemma ad est
% TODO: controllare se la posizione del mostro sia corretta
% Qui pos(R, C) è la posizione della gemma
applicabileGemma(est, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme):-
    num_col(N),
    C < N,
    CRight is C + 1,
    \+occupata(pos(R, CRight)),
    % Verifica esistenza muro
    \+member(ghiaccio(pos(R, CRight)), ListaMuriGhiaccio),
    \+finale(pos(R, CRight)),
    % Verifico che la gemma non sbatta contro il mostro
    pos(R, CRight) \= PosMostro,
    controlloGemma(est, pos(R, CRight), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme).

% Condizioni di spostamento della gemma ad ovest
applicabileGemma(ovest, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme):-
    C > 1,
    CLeft is C - 1,
    \+occupata(pos(R, CLeft)),
    \+member(ghiaccio(pos(R, CLeft)), ListaMuriGhiaccio),
    \+finale(pos(R, CLeft)),
    pos(R, CLeft) \= PosMostro,
    controlloGemma(ovest, pos(R, CLeft), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme).


% Condizioni di spostamento della gemma a sud
applicabileGemma(sud, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme):-
    num_righe(N),
    R < N,
    RDown is R + 1,
    \+occupata(pos(RDown, C)),
    \+member(ghiaccio(pos(RDown, C)), ListaMuriGhiaccio),
    \+finale(pos(RDown, C)),
    pos(RDown, C) \= PosMostro,
    controlloGemma(sud, pos(RDown, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme).


% Condizioni di spostamento della gemma a nord
applicabileGemma(nord, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme):-
    R > 1,
    RUp is R - 1,
    \+occupata(pos(RUp, C)),
    \+member(ghiaccio(pos(RUp, C)), ListaMuriGhiaccio),
    \+finale(pos(RUp, C)),
    pos(RUp, C) \= PosMostro,
    controlloGemma(nord, pos(RUp, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme).




% Driver dello spostamento di n passi, da pos(R, C) a pos(R, CFin)
trasforma(
    Direzione, 
    [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme], 
    [pos(RFin, CFin), pos(RFin, CFin), NewListaMuriGhiaccio, NewListaMartello, NewListaGemme]
) :-
    % Spostamento da n passi
    trasformaMultiStep(
        Direzione, 
        [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme], 
        [pos(RFin, CFin), pos(RFin, CFin), NewListaMuriGhiaccio, NewListaMartello, TmpListaGemme]
    ),
    % Spostamento delle gemme
    spostaListaGemme(TmpListaGemme, Direzione, pos(RFin, CFin), ListaMuriGhiaccio, ListaMartello, NewListaGemme).





% Spostamento di n passi in direzione est, da pos(R, C) a pos(RFin, CFin)
trasformaMultiStep(est, 
    [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme], 
    [pos(RFin, CFin), pos(RFin, CFin), NewListaMuriGhiaccio, NewListaMartello, NewListaGemme]
) :-
    NewC is C + 1,
    % effetti dello Spostamento di una posizione
    spostamento(
        est, 
        [pos(R, NewC), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme] ,
        % Modifica dello stato derivante dal singolo passo di spostamento
        [pos(R, NewC), pos(R, C), TmpListaMuriGhiaccio, TmpListaMartello, TmpListaGemme]
    ),
    % Chiamata ricorsiva per continuare il movimento
    continuaSpostamento(
        est, 
        [pos(R, NewC), pos(R, NewC), TmpListaMuriGhiaccio, TmpListaMartello, TmpListaGemme],
        [pos(RFin, CFin), pos(RFin, CFin), NewListaMuriGhiaccio, NewListaMartello, NewListaGemme]
    ).

% Spostamento di n passi in direzione ovest, da pos(R, C) a pos(RFin, CFin)
trasformaMultiStep(ovest, 
    [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme], 
    [pos(RFin, CFin), pos(RFin, CFin), NewListaMuriGhiaccio, NewListaMartello, NewListaGemme]
) :-
    NewC is C - 1,
    % Spostamento di una posizione
    spostamento(
        ovest, 
        [pos(R, NewC), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme] ,
        % Modifica dello stato derivante dal singolo passo di spostamento
        [pos(R, NewC), pos(R, C), TmpListaMuriGhiaccio, TmpListaMartello, TmpListaGemme]
    ),
    % Chiamata ricorsiva per continuare il movimento
    continuaSpostamento(
        ovest, 
        [pos(R, NewC), pos(R, NewC), TmpListaMuriGhiaccio, TmpListaMartello, TmpListaGemme],
        [pos(RFin, CFin), pos(RFin, CFin), NewListaMuriGhiaccio, NewListaMartello, NewListaGemme]
    ).

% Spostamento di n passi in direzione sud, da pos(R, C) a pos(RFin, CFin)
trasformaMultiStep(sud, 
    [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme], 
    [pos(RFin, CFin), pos(RFin, CFin), NewListaMuriGhiaccio, NewListaMartello, NewListaGemme]
) :-
    NewR is R + 1,
    % Spostamento di una posizione
    spostamento(
        sud, 
        [pos(NewR, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme] ,
        % Modifica dello stato derivante dal singolo passo di spostamento
        [pos(NewR, C), pos(R, C), TmpListaMuriGhiaccio, TmpListaMartello, TmpListaGemme]
    ),
    % Chiamata ricorsiva per continuare il movimento
    continuaSpostamento(
        sud, 
        [pos(NewR, C), pos(NewR, C), TmpListaMuriGhiaccio, TmpListaMartello, TmpListaGemme],
        [pos(RFin, CFin), pos(RFin, CFin), NewListaMuriGhiaccio, NewListaMartello, NewListaGemme]
    ).

% Spostamento di n passi in direzione norc, da pos(R, C) a pos(RFin, CFin)
trasformaMultiStep(nord, 
    [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme], 
    [pos(RFin, CFin), pos(RFin, CFin), NewListaMuriGhiaccio, NewListaMartello, NewListaGemme]
) :-
    NewR is R - 1,
    % Modifiche derivanti dallo Spostamento di una posizione
    spostamento(
        nord, 
        [pos(NewR, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme] ,
        % Modifica dello stato derivante dal singolo passo di spostamento
        [pos(NewR, C), pos(R, C), TmpListaMuriGhiaccio, TmpListaMartello, TmpListaGemme]
    ),
    % Chiamata ricorsiva per continuare il movimento
    continuaSpostamento(
        nord, 
        [pos(NewR, C), pos(NewR, C), TmpListaMuriGhiaccio, TmpListaMartello, TmpListaGemme],
        [pos(RFin, CFin), pos(RFin, CFin), NewListaMuriGhiaccio, NewListaMartello, NewListaGemme]
    ).

% Se la mossa non è ulteriormente applicabile lo stato ovviamente non cambia
continuaSpostamento(Direzione, 
    [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme],
    [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme]) :-
    \+applicabile(Direzione, [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme]),
    !.

continuaSpostamento(Direzione, 
    [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme],
    [pos(RFin, CFin), pos(RFin, CFin), NewListaMuriGhiaccio, NewListaMartello, NewListaGemme]) :-
    trasformaMultiStep(
        Direzione, 
        [pos(R, C), pos(R, C), ListaMuriGhiaccio, ListaMartello, ListaGemme] ,
        [pos(RFin, CFin), pos(RFin, CFin), NewListaMuriGhiaccio, NewListaMartello, NewListaGemme]
    ).


spostamento(_, 
    [pos(NewR, NewC), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme], 
    [pos(NewR, NewC), PosMostro, NewListaMuriGhiaccio, ListaMartello, ListaGemme]) :-
    % L'algoritmo che chiama trasforma ha verificato che la mossa sia applicabile soltanto ad un passo
    % implementare trasforma in modo che verifichi tutti gli n passi sarebbe troppo costoso
    member(ghiaccio(pos(NewR, NewC)), ListaMuriGhiaccio),
    !,
    select(ghiaccio(pos(NewR, NewC)), ListaMuriGhiaccio, NewListaMuriGhiaccio).


spostamento(
    Direzione, 
    [pos(NewR, NewC), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme], 
    [pos(NewR, NewC), PosMostro, ListaMuriGhiaccio, ListaMartello, NewListaGemme]) :-
    % Se incontro una gemma, la faccio avanzare fino al prossimo ostacolo
    % prima di spostare il mostro, in modo da preservare il posizionamento relativo
    member(gemma(pos(NewR, NewC)), ListaGemme),
    !,
    applicabileGemma(Direzione, pos(NewR, NewC), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme),
    spostaGemma(Direzione, pos(NewR, NewC), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, NewListaGemme).

spostamento(_, 
    [pos(NewR, NewC), PosMostro, ListaMuriGhiaccio, [martello(pos(NewR, NewC))], ListaGemme], 
    [pos(NewR, NewC), PosMostro, ListaMuriGhiaccio, [possiedeMartello], ListaGemme]).


% Caso in cui non ci sono collezionabili particolari da trattare in posizione
% pos(NewR, NewC). Il mostro può dirigervisi senza accorgimenti particolari
spostamento(_, 
    [pos(NewR, NewC), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme], 
    [pos(NewR, NewC), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme]).


% Singolo passo di spostamento della gemma verso est
spostaGemma(est, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, NewListaGemme) :-
    NewC is C + 1,
    % Verifico se nella posizione di arrivo ci sia un'altra gemma
    % Se c'è ed è possbile, la sposto
    controlloAltraGemma(est, pos(R, NewC), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, TmpListaGemme1),
    % Tolgo la gemma dalla posizione corrente
    select(gemma(pos(R, C)), TmpListaGemme1, TmpListaGemme2),
    % Aggiungo la gemma nella nuova posizione
    continuaSpostamentoGemma(est, pos(R, NewC), PosMostro, ListaMuriGhiaccio, ListaMartello, [gemma(pos(R, NewC))|TmpListaGemme2], NewListaGemme).

% Singolo passo di spostamento della gemma verso ovest
spostaGemma(ovest, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, NewListaGemme) :-
    NewC is C - 1,
    controlloAltraGemma(ovest, pos(R, NewC), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, TmpListaGemme1),
    select(gemma(pos(R, C)), TmpListaGemme1, TmpListaGemme2),
    continuaSpostamentoGemma(ovest, pos(R, NewC), PosMostro, ListaMuriGhiaccio, ListaMartello, [gemma(pos(R, NewC))|TmpListaGemme2], NewListaGemme).

spostaGemma(sud, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, NewListaGemme) :-
    NewR is R + 1,
    controlloAltraGemma(sud, pos(NewR, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, TmpListaGemme1),
    select(gemma(pos(R, C)), TmpListaGemme1, TmpListaGemme2),
    continuaSpostamentoGemma(sud, pos(NewR, C), PosMostro, ListaMuriGhiaccio, ListaMartello, [gemma(pos(NewR, C))|TmpListaGemme2], NewListaGemme).

spostaGemma(nord, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, NewListaGemme) :-
    NewR is R - 1,
    controlloAltraGemma(nord, pos(NewR, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, TmpListaGemme1),
    select(gemma(pos(R, C)), TmpListaGemme1, TmpListaGemme2),
    continuaSpostamentoGemma(nord, pos(NewR, C), PosMostro, ListaMuriGhiaccio, ListaMartello, [gemma(pos(NewR, C))|TmpListaGemme2], NewListaGemme).


% Verifico se nella posizione pos(R, C) ci sia una gemma, ed, eventualmente, ne avvio il movimento
controlloAltraGemma(Direzione, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, ListaGemme) :-
    \+member(gemma(pos(R, C)), ListaGemme),
    !.
controlloAltraGemma(Direzione, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, NewListaGemme) :-
    spostaGemma(Direzione, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, NewListaGemme).

% Se la mossa è ancora applicabile, continuo lo spostamento della gemma
continuaSpostamentoGemma(Direzione, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, ListaGemme) :-
    \+applicabileGemma(Direzione, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme),
    !.
continuaSpostamentoGemma(Direzione, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, NewListaGemme):-
    spostaGemma(Direzione, pos(R, C), PosMostro, ListaMuriGhiaccio, ListaMartello, ListaGemme, NewListaGemme).



spostaListaGemme([], _, _, _, _, NewListaGemme).
spostaListaGemme([gemma(pos(RG, CG))|Tail], Direzione, PosMostro, ListaMuriGhiaccio, ListaMartello, NewListaGemme) :-
    \+applicabileGemma(Direzione, pos(RG, CG), PosMostro, ListaMuriGhiaccio, ListaMartello, [gemma(pos(RG, CG))|Tail]),
    !,
    spostaListaGemme(Tail, Direzione, PosMostro, ListaMuriGhiaccio, ListaMartello, NewListaGemme).

spostaListaGemme([gemma(pos(RG, CG))|Tail], Direzione, PosMostro, ListaMuriGhiaccio, ListaMartello, NewListaGemme) :-
    spostaGemma(Direzione, pos(RG, CG), PosMostro, ListaMuriGhiaccio, ListaMartello, [gemma(pos(RG, CG))|Tail], TmpListaGemme),
    spostaListaGemme(TmpListaGemme, Direzione, PosMostro, ListaMuriGhiaccio, ListaMartello, NewListaGemme).