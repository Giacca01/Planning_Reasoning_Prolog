% Dimensioni labirinto
num_col(10).
num_righe(10).

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
occupata(pos(1,5)).


% Posizione iniziale agente
iniziale(pos(4,2)).

% Uscita Labirinto
finale(pos(7,9)).
finale(pos(2,9)).