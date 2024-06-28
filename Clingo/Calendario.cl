% Definizione dati problema

% Definizione squadre
squadra(inter).
squadra(milan).
squadra(juventus).
squadra(atalanta).
squadra(bologna).
squadra(roma).
%*squadra(lazio).
squadra(fiorentina).
quadra(torino).  % TODO: Sistemare corrispondenza stadio
squadra(napoli).
squadra(genoa).
squadra(monza).
squadra(verona).
squadra(lecce).
squadra(udinese).
squadra(cagliari). *%

% Definizione Città
citta(milano).
citta(torino).
citta(bergamo).
citta(roma).
%*citta(firenze).
citta(napoli).
citta(genova).
citta(monza).
citta(verona).
citta(lecce).
citta(udine).
citta(cagliari). *%

% Definizione Stadi
% TODO: lo stadio va associato alla squadra e non alla città
stadio(sansiro).
stadio(allianz).
stadio(gewiss).
stadio(olimpicoRoma).
stadio(dallara).
%*stadio(olimpicoTorino).
stadio(franchi).
stadio(maradona).
stadio(marassi).
stadio(upower).
stadio(bentegodi).
stadio(viadelmare).
stadio(friuli).
stadio(unipol). *%

% Associazioni
associateA(milan, milano).
associateA(inter, milano).
associateA(juventus, torino).
associateA(atalanta, bergamo).
associateA(bologna, bologna).
associateA(roma, roma).
%*associateA(lazio, roma).
associateA(torino, torino).
associateA(genoa, genova).
associateA(fiorentina, firenze).
associateA(napoli, napoli).
associateA(monza, monza).
associateA(verona, verona).
associateA(lecce, lecce). 
associateA(udinese, udine).
associateA(cagliari, cagliari)*%

% Associazione Città-Stadi
situatiIn(sansiro, milano).
situatiIn(allianz, torino).
situatiIn(dallara, bologna).
situatiIn(gewiss, bergamo).
situatiIn(olimpicoRoma, roma).
%*situatiIn(olimpicoTorino, torino).
situatiIn(franchi, firenze).
situatiIn(maradona, napoli).
situatiIn(marassi, genova).
situatiIn(upower, monza).
situatiIn(bentegodi, verona).
situatiIn(viadelmare, lecce).
situatiIn(friuli, udine).
situatiIn(unipol, cagliari). *%


% Girone d'andata
andata(1..5).

% Girone di ritorno
ritorno(6..10).

giornata(X) :- andata(X).
giornata(X) :- ritorno(X).

% Elemento fondamentale del calendario
% calcolare una soluzione al problema significherà assegnare valori
% alle variabili di questo predicato in modo da soddisfare i vincoli
% partita(squadra1, squadra2, stadio, giornata).


% Ogni squadra deve giocare in tutte le giornate
:- giornata(Giornata), squadra(Squadra), not partita(Squadra, _, _, Giornata), not partita(_, Squadra, _, Giornata).

% Per ogni coppia di squadre, esiste una sola giornata in cui si affrontano
% in teoria dovrebbe bastare sia per imporre che giochino uno volta in casa ed una in trasferta


% Vincoli di livello macro, riguardanti tutto il calendario
% Per ogni coppia squadra1-giornata, c'è al più una partita giocata in casa da Squadra1
1 {partita(Squadra1, Squadra2, Stadio, Giornata) : giornata(Giornata)} 1 :- 
    squadra(Squadra1), 
    squadra(Squadra2), 
    Squadra1 != Squadra2,
    associateA(Squadra1, Citta),
    situatiIn(Stadio, Citta).

0 {partita(Squadra1, Squadra2, Stadio, Giornata) : squadra(Squadra2), Squadra2 != Squadra1} 1 :-
    giornata(Giornata),
    squadra(Squadra1),
    associateA(Squadra1, Citta),
    situatiIn(Stadio, Citta).

0 {partita(Squadra1, Squadra2, Stadio, Giornata) : squadra(Squadra1), associateA(Squadra1, Citta), situatiIn(Stadio, Citta), Squadra1 != Squadra2} 1 :-
    giornata(Giornata),
    squadra(Squadra2).


% La stessa squadra non può giocare in casa e in trasferta nella giornata
:- partita(Squadra1, _, _, Giornata), partita(_, Squadra1, _, Giornata).


% Questo è sicuramente subsunto dall'imporre Squadra1 != Squadra2 nei vincoli precedenti
% :- partita(Squadra1, Squadra1, _, _).

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
% Ad assicurarsi che lo stadio sia ben impostato sono i vincoli "costruttivi"
% di sopra, che dicono come deve essere fatto partita
% qui ci limitiamo ad escludere istanze già fatte
%* :- partita(Squadra1, Squadra2, Stadio, Giornata),
partita(Squadra3, Squadra4, Stadio, Giornata). *%

% Non più di due partite consecutive in casa
%* :- partita(Squadra1, _, _, Giornata1),
partita(Squadra1, _, _, Giornata2),
partita(Squadra1, _, _, Giornata3),
Giornata2 == Giornata1 + 1,
Giornata3 == Giornata2 + 1. *%

% Non più di due partite consecutive in trasferta
%* :- partita(_, Squadra1, _, Giornata1),
:- partita(_, Squadra1, _, Giornata2),
:- partita(_, Squadra1, _, Giornata3),
Giornata2 == Giornata1 + 1,
Giornata3 == Giornata2 + 1. *%

% Non ci devono essere più partite nello stesso stadio nella stessa giornata
% fatto salvo per i derby
#show partita/4.