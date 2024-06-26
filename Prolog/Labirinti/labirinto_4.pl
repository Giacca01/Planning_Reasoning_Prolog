% Maze dimensions
num_righe(20).
num_col(20).

% Starting position
iniziale(pos(1, 1)).

% Exits
finale(pos(20, 20)).
finale(pos(1, 20)).

% Walls (2% of 400 positions is 8 walls, ensuring exits are reachable)
occupata(pos(1, 3)).
occupata(pos(2, 3)).
occupata(pos(3, 3)).
occupata(pos(4, 3)).
occupata(pos(5, 3)).
occupata(pos(6, 3)).
occupata(pos(7, 3)).
occupata(pos(8, 3)).