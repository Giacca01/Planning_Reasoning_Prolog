% Maze dimensions
num_righe(20).
num_col(20).

% Starting position
iniziale(pos(1, 1)).

% Exits
finale(pos(20, 20)).
finale(pos(1, 20)).

% Walls (10% of 400 positions is 40 walls, ensuring exits are reachable)
occupata(pos(1, 3)).
occupata(pos(1, 4)).
occupata(pos(1, 5)).
occupata(pos(1, 6)).
occupata(pos(1, 7)).
occupata(pos(2, 7)).
occupata(pos(2, 8)).
occupata(pos(2, 9)).
occupata(pos(3, 9)).
occupata(pos(4, 9)).
occupata(pos(4, 10)).
occupata(pos(5, 10)).
occupata(pos(5, 11)).
occupata(pos(6, 11)).
occupata(pos(7, 11)).
occupata(pos(8, 11)).
occupata(pos(9, 11)).
occupata(pos(9, 12)).
occupata(pos(9, 13)).
occupata(pos(10, 13)).
occupata(pos(11, 13)).
occupata(pos(11, 14)).
occupata(pos(11, 15)).
occupata(pos(12, 15)).
occupata(pos(13, 15)).
occupata(pos(14, 15)).
occupata(pos(14, 16)).
occupata(pos(14, 17)).
occupata(pos(15, 17)).
occupata(pos(16, 17)).
occupata(pos(17, 17)).
occupata(pos(17, 18)).
occupata(pos(18, 18)).
occupata(pos(18, 19)).
occupata(pos(19, 19)).
occupata(pos(19, 20)).
occupata(pos(20, 3)).
occupata(pos(20, 4)).
occupata(pos(20, 5)).
occupata(pos(20, 6)).