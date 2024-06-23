% Dimensioni labirinto
num_col(20).
num_righe(20).

% Elenco ostacoli

occupata(pos(2,5)).
occupata(pos(3,5)).
occupata(pos(4,5)).
occupata(pos(5,5)).
occupata(pos(6,5)).
occupata(pos(7,5)).
occupata(pos(7,1)).
occupata(pos(7,2)).
occupata(pos(7,3)).
occupata(pos(7,4)).
occupata(pos(5,7)).
occupata(pos(6,7)).
occupata(pos(7,7)).
occupata(pos(8,7)).
occupata(pos(4,7)).
occupata(pos(4,8)).
occupata(pos(4,9)).
occupata(pos(4,10)).


%occupata(pos(1, 5)).

% Posizione iniziale agente
iniziale(pos(1,1)).
%iniziale(pos(1,1)).

% Uscita Labirinto
finale(pos(12,13)).
%finale(pos(10,2)).