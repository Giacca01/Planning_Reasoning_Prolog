num_col(8).
num_righe(8).

% Posizione iniziale del mostro
iniziale(pos(1, 4)).

% Posizione del portale
finale(pos(4, 4)).

% Modellazione muri infrangibili
occupata(pos(1, 6)).
occupata(pos(2, 2)).
occupata(pos(2, 8)).
occupata(pos(3, 8)).
occupata(pos(4, 4)).
occupata(pos(4, 5)).
occupata(pos(5, 5)).
occupata(pos(6, 2)).
occupata(pos(7, 2)).
occupata(pos(7, 6)).
occupata(pos(8, 3)).


% Modellazione del martello
martello(pos(8, 2)).

% Modellazione delle gemme
gemma(pos(1, 7)).
gemma(pos(5, 4)).
gemma(pos(8, 8)).

% Modellazione muri in ghiaccio
ghiaccio(pos(2, 6)).
ghiaccio(pos(2, 7)).
ghiaccio(pos(7, 7)).

% Modellazione avversario
avversario(pos(6, 7)).