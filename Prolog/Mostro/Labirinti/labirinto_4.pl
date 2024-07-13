num_col(8).
num_righe(8).
% Lo stato iniziale del labirinto diventa una lista
iniziale(
    [
        pos(8, 3), 
        pos(8, 3), 
        [ghiaccio(pos(6, 4))],
        [martello(pos(7, 4))],
        [
            gemma(pos(3, 5)),
            gemma(pos(3, 6)),
            gemma(pos(3, 7))
        ]
    ]
).

occupata(pos(5, 3)).
occupata(pos(5, 4)).
occupata(pos(5, 5)).
occupata(pos(5, 6)).

occupata(pos(3, 1)).
occupata(pos(3, 8)).

occupata(pos(2, 1)).
occupata(pos(2, 3)).
occupata(pos(2, 5)).
occupata(pos(2, 6)).
occupata(pos(2, 7)).

occupata(pos(7, 4)).
occupata(pos(7, 3)).

finale(
    [
        pos(4, 4),
        pos(4, 4),
        ListaGhiaccio,
        ListaMartello,
        ListaGemme
    ]
).