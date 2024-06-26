% Definizione dati problema

% Definizione squadre
squadra(inter).
squadra(milan).
squadra(juventus).
squadra(atalanta).
squadra(bologna).

%* squadra(roma).
squadra(lazio).
squadra(fiorentina).
squadra(torino).
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
citta(bologna).

%* citta(roma).
citta(firenze).
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
stadio(dallara).
stadio(gewiss).

%* stadio(olimpicoRoma).
stadio(olimpicoTorino).
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
associateA(bologna, bologna).
associateA(juventus, torino).
associateA(atalanta, bergamo).

%* associateA(roma, roma).
associateA(lazio, roma).
associateA(torino, torino).
associateA(genoa, genova).
associateA(fiorentina, firenze).
associateA(napoli, napoli).
associateA(cagliari, cagliari).
associateA(monza, monza).
associateA(verona, verona).
associateA(udinese, udine).
associateA(lecce, lecce). *%

% Associazione Città-Stadi
situatiIn(sansiro, milano).
situatiIn(allianz, torino).
situatiIn(dallara, bologna).
situatiIn(gewiss, bergamo).

%* situatiIn(olimpicoRoma, roma).
situatiIn(olimpicoTorino, torino).
situatiIn(franchi, firenze).
situatiIn(maradona, napoli).
situatiIn(marassi, genova).
situatiIn(upower, monza).
situatiIn(bentegodi, verona).
situatiIn(viadelmare, lecce).
situatiIn(friuli, udine).
situatiIn(unipol, cagliari). *%


% Girone d'andata
andata(1..4).

% Girone di ritorno
ritorno(5..8).

giornata(X) :- andata(X).
giornata(X) :- ritorno(X).

% Elemento fondamentale del calendario
% calcolare una soluzione al problema significherà assegnare valori
% alle variabili di questo predicato in modo da soddisfare i vincoli
% partita(squadra1, squadra2, stadio, giornata).


% Proviamo ora a dire che il girone d'andata va da 1 a 15 e quello di ritorno da 16 a 30
% più che altro, serve una regola per calcolare i valori di partita
1 {partita(Squadra1, Squadra2, Stadio, Giornata): giornata(Giornata)} 1 :- 
    squadra(Squadra1),
    squadra(Squadra2),
    Squadra1 != Squadra2,
    associateA(Squadra1, Citta),
    situatiIn(Stadio, Citta).

1 {partita(Squadra1, Squadra2, Stadio, Giornata) : squadra(Squadra2), Squadra1 != Squadra2} 1 :- 
    squadra(Squadra1), 
    giornata(Giornata),
    associateA(Squadra1, Citta),
    situatiIn(Stadio, Citta).


% Non ci devono essere più partite tra le stesse squadre nello stesso girone
%* :- partita(Squadra1, Squadra2, _, Giornata1), 
    partita(Squadra2, Squadra1, _, Giornata2), 
    andata(Giornata1),
    andata(Giornata2).

:- partita(Squadra1, Squadra2, _, Giornata1), 
    partita(Squadra2, Squadra1, _, Giornata2), 
    ritorno(Giornata1),
    ritorno(Giornata2).

:- partita(Squadra1, Squadra1, _, _). *%

%* :- squadra(Squadra1), partita(Squadra1, Squadra1, _, _).
    situatiIn(Stadio, Citta), *%


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