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
            gemma(pos(4, 8)),
            gemma(pos(4, 7))
        ]
    ]
).

occupata(pos(1, 1)).

finale(
    [
        pos(7, 7),
        pos(7, 7),
        ListaGhiaccio,
        ListaMartello,
        ListaGemme
    ]
).