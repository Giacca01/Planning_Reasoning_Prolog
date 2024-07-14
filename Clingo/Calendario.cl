
% Definizione dati problema

% Definizione predicato che modella le squadre
squadra(inter).
squadra(milan).
squadra(juventus).
squadra(atalanta).
squadra(bologna).
squadra(roma).
squadra(lazio).
squadra(fiorentina).
squadra(torino).
squadra(napoli).
squadra(genoa).
squadra(monza).
squadra(verona).
squadra(lecce).
squadra(udinese).
squadra(sampdoria).


% Squadre non richieste dal testo dell'esercizio
% ma inserite per prove aggiuntive

%squadra(empoli).
%squadra(frosinone).
%squadra(sassuolo).
%squadra(salernitana).
%squadra(cagliari).


% Definizione predicato che modella le Città
citta(milano).
citta(torino).
citta(bergamo).
citta(roma).
citta(bologna).
citta(firenze).
citta(napoli).
citta(genova).
citta(monza).
citta(verona).
citta(lecce).
citta(udine).
%citta(cagliari).
%citta(empoli).
%citta(frosinone).
%citta(sassuolo).
%citta(salerno).


% Definizione Stadi
stadio(sansiro).
stadio(allianz).
stadio(gewiss).
stadio(olimpicoRoma).
stadio(dallara).
stadio(olimpicoTorino).
stadio(franchi).
stadio(maradona).
stadio(marassi).
stadio(upower).
stadio(bentegodi).
stadio(viadelmare).
stadio(friuli).

%stadio(unipol).
%stadio(castellani).
%stadio(stirpe).
%stadio(mapei).
%stadio(arechi).


% Predicato che modella l'associazione tra squadra e città
associateA(milan, milano).
associateA(inter, milano).
associateA(juventus, torino).
associateA(atalanta, bergamo).
associateA(bologna, bologna).
associateA(roma, roma).
associateA(lazio, roma).
associateA(torino, torino).
associateA(genoa, genova).
associateA(fiorentina, firenze).
associateA(napoli, napoli).
associateA(monza, monza).
associateA(verona, verona).
associateA(lecce, lecce). 
associateA(udinese, udine).
associateA(sampdoria, genoa).

%associateA(cagliari, cagliari).
%associateA(empoli, empoli).
%associateA(frosinone, frosinone).
%associateA(sassuolo, sassuolo).
%associateA(salernitana, salerno).


% Predicato che modella l'sssociazione stadio-squadra
possessoStadio(sansiro, inter).
possessoStadio(sansiro, milan).
possessoStadio(allianz, juventus).
% Da utilizzare per aumentare il numero di derby
% tra squadre che condividono il terreno di gioco
%possessoStadio(olimpicoTorino, juventus).
possessoStadio(dallara, bologna).
possessoStadio(gewiss, atalanta).
possessoStadio(olimpicoRoma, roma).
possessoStadio(olimpicoRoma, lazio).
possessoStadio(olimpicoTorino, torino).
possessoStadio(franchi, fiorentina).
possessoStadio(maradona, napoli).
possessoStadio(marassi, genoa).
possessoStadio(upower, monza).
possessoStadio(bentegodi, verona).
possessoStadio(viadelmare, lecce).
possessoStadio(friuli, udinese).
possessoStadio(marassi, sampdoria).

%possessoStadio(unipol, cagliari).
%possessoStadio(castellani, empoli).
%possessoStadio(stirpe, frosinone).
%possessoStadio(mapei, sassuolo).
%possessoStadio(arechi, salernitana).


% Predicato che modella le partite del girone d'andata
andata(1..15).

% Predicato che modella le partite del girone di ritorno
ritorno(16..30).

% Regola che modella il concetto di giornata del calendario
giornata(X) :- andata(X).
giornata(X) :- ritorno(X).


% Per ogni coppia squadra1-squadra2, c'è esattamente una partita giocata in casa da Squadra1
1 {partita(Squadra1, Squadra2, Stadio, Giornata) : giornata(Giornata)} 1 :- 
    squadra(Squadra1), 
    squadra(Squadra2), 
    Squadra1 != Squadra2,
    associateA(Squadra1, Citta),
    possessoStadio(Stadio, Squadra1).

% Per ogni coppia squadra1-giornata, c'è al più una squadra2 affrontanta in casa da squadra1
0 {partita(Squadra1, Squadra2, Stadio, Giornata) : squadra(Squadra2), Squadra2 != Squadra1} 1 :-
    giornata(Giornata),
    squadra(Squadra1),
    associateA(Squadra1, Citta),
    possessoStadio(Stadio, Squadra1).

% Per ogni coppia squadra2-giornata, c'è al più una squadra1 affrontata in trasferta da squadra2
0 {partita(Squadra1, Squadra2, Stadio, Giornata) : squadra(Squadra1), associateA(Squadra1, Citta), possessoStadio(Stadio, Squadra1), Squadra1 != Squadra2} 1 :-
    giornata(Giornata),
    squadra(Squadra2).


% Ogni squadra deve giocare, in casa oppure in trasferta, in tutte le giornate
:- giornata(Giornata), squadra(Squadra), not partita(Squadra, _, _, Giornata), not partita(_, Squadra, _, Giornata).


% La stessa squadra non può giocare in casa e in trasferta nella giornata
:- partita(Squadra1, _, _, Giornata), partita(_, Squadra1, _, Giornata).


% Non ci devono essere più partite tra le stesse squadre nello stesso girone
:- partita(Squadra1, Squadra2, _, Giornata1), 
    partita(Squadra2, Squadra1, _, Giornata2), 
    andata(Giornata1),
    andata(Giornata2).

:- partita(Squadra1, Squadra2, _, Giornata1), 
    partita(Squadra2, Squadra1, _, Giornata2), 
    ritorno(Giornata1),
    ritorno(Giornata2).


% Due squadre non possono giocare nello stesso stadio e nella stessa giornata
% in caso di derby c'è una sola istanza di partita, quindi questo vincolo non scatta
:- partita(Squadra1, _, Stadio, Giornata),
partita(Squadra2, _, Stadio, Giornata),
squadra(Squadra1),
squadra(Squadra2),
Squadra1 != Squadra2.

% Non più di due partite consecutive in casa
:- partita(Squadra1, _, _, Giornata1),
partita(Squadra1, _, _, Giornata2),
partita(Squadra1, _, _, Giornata3),
Giornata2 == Giornata1 + 1,
Giornata3 == Giornata2 + 1.

% Non più di due partite consecutive in trasferta
:- partita(_, Squadra1, _, Giornata1),
partita(_, Squadra1, _, Giornata2),
partita(_, Squadra1, _, Giornata3),
Giornata2 == Giornata1 + 1,
Giornata3 == Giornata2 + 1.


% Conteggio numero di giornate girone
numGiornateAndata(N) :- N = #count {X:andata(X)}.

% Il calendario deve essere non simmetrico
:- partita(Squadra1, Squadra2, _, GiornataAndata),
partita(Squadra2, Squadra1, _, GiornataRitorno),
numGiornateAndata(N),
GiornataAndata == GiornataRitorno - N. 


#show partita/4.