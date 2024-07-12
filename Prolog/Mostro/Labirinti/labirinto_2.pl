num_col(8).
num_righe(8).

iniziale(
    [
        pos(8, 8),
        pos(8, 8),
        [
            ghiaccio(pos(8, 5)),
            ghiaccio(pos(2, 6)),
            ghiaccio(pos(3, 6)),
            ghiaccio(pos(3, 7))
        ],
        [martello(pos(8, 2))],
        [
            gemma(pos(3, 3)),
            gemma(pos(5, 1)),
            gemma(pos(2, 8))
        ]
    ]
).

finale(
    [
        pos(5, 3),
        pos(5, 3),
        ListaGhiaccio,
        ListaMartello,
        ListaGemme
    ]
).

occupata(pos(1, 6)).
occupata(pos(3, 8)).
occupata(pos(2, 2)).
occupata(pos(4, 3)).
occupata(pos(5, 4)).
occupata(pos(6, 1)).
occupata(pos(8, 3)).
occupata(pos(7, 7)).

