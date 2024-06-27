% Maze dimensions
num_righe(100).
num_col(100).

% Starting position
iniziale(pos(1, 1)).

% Exits
finale(pos(99, 99)).
%finale(pos(17, 20)).

% Walls (2% of 400 positions is 8 walls, ensuring exits are reachable)
occupata(pos(1, 3)).
occupata(pos(2, 3)).
occupata(pos(3, 3)).
occupata(pos(4, 3)).
occupata(pos(5, 3)).
occupata(pos(6, 3)).
occupata(pos(7, 3)).
occupata(pos(8, 3)).