num_col(8).
num_righe(8).
% Lo stato iniziale del labirinto diventa una lista
iniziale(
    [
        pos(8, 1), 
        pos(8, 1), 
        [ghiaccio(pos(8, 4))],
        [martello(pos(8, 3))],
        [
            gemma(pos(5, 1)),
            gemma(pos(5, 7))
        ]
    ]
).

occupata(pos(1, 1)).
occupata(pos(3, 4)).

finale(
    [
        pos(3, 7),
        pos(3, 7),
        ListaGhiaccio,
        ListaMartello,
        ListaGemme
    ]
).