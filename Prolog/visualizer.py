import tkinter as tk

# Define maze dimensions and colors
CELL_SIZE = 40
WALL_COLOR = "black"
START_COLOR = "green"
EXIT_COLOR = "red"
EMPTY_COLOR = "white"

def parse_predicates(predicates):
    walls = set()
    start = None
    exits = set()
    num_rows = 0
    num_cols = 0

    for line in predicates.splitlines():
        line = line.strip()
        if line.startswith("num_righe"):
            num_rows = int(line[10:-2])
        elif line.startswith("num_col"):
            num_cols = int(line[8:-2])
        elif line.startswith("occupata"):
            x, y = map(int, line[17:-2].split(','))
            walls.add((x, y))
        elif line.startswith("iniziale"):
            x, y = map(int, line[17:-2].split(','))
            start = (x, y)
        elif line.startswith("finale"):
            x, y = map(int, line[15:-2].split(','))
            exits.add((x, y))

    return num_rows, num_cols, walls, start, exits

def load_maze(file_path):
    with open(file_path, 'r') as file:
        predicates = file.read()
    return parse_predicates(predicates)

def create_maze_gui(num_rows, num_cols, walls, start, exits):
    root = tk.Tk()
    root.title("Maze Visualization")

    canvas = tk.Canvas(root, width=num_cols * CELL_SIZE, height=num_rows * CELL_SIZE)
    canvas.pack()

    for y in range(num_rows):
        for x in range(num_cols):
            color = EMPTY_COLOR
            if (x, y) in walls:
                color = WALL_COLOR
            elif (x, y) == start:
                color = START_COLOR
            elif (x, y) in exits:
                color = EXIT_COLOR

            canvas.create_rectangle(
                x * CELL_SIZE, y * CELL_SIZE,
                (x + 1) * CELL_SIZE, (y + 1) * CELL_SIZE,
                fill=color, outline="black"
            )

    root.mainloop()

if __name__ == "__main__":
    file_path = 'Labirinti/labirinto_1.pl'
    num_rows, num_cols, walls, start, exits = load_maze(file_path)
    create_maze_gui(num_rows, num_cols, walls, start, exits)
