import tkinter as tk
from tkinter import filedialog

class MazeVisualizerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Maze Visualizer")
        self.grid = []
        self.num_cols = 0
        self.num_rows = 0
        self.init_positions = []
        self.final_positions = []
        self.walls = []
        self.load_maze()

    def load_maze(self):
        file_path = filedialog.askopenfilename(
            title="Open Prolog Maze File",
            filetypes=[("Prolog Files", "*.pl")]
        )
        if not file_path:
            return
        
        with open(file_path, "r") as f:
            lines = f.readlines()
        
        for line in lines:
            if line.startswith("num_col"):
                self.num_cols = int(line.split("(")[1].split(")")[0])
            elif line.startswith("num_righe"):
                self.num_rows = int(line.split("(")[1].split(")")[0])
            elif line.startswith("iniziale"):
                pos = line.split("pos(")[1].split(")")[0].split(",")
                self.init_positions.append((int(pos[0]) - 1, int(pos[1]) - 1))
            elif line.startswith("finale"):
                pos = line.split("pos(")[1].split(")")[0].split(",")
                self.final_positions.append((int(pos[0]) - 1, int(pos[1]) - 1))
            elif line.startswith("occupata"):
                pos = line.split("pos(")[1].split(")")[0].split(",")
                self.walls.append((int(pos[0]) - 1, int(pos[1]) - 1))
        
        self.init_maze_grid()

    def init_maze_grid(self):
        self.frame = tk.Frame(self.root)
        self.frame.pack(fill=tk.BOTH, expand=1)

        self.canvas = tk.Canvas(self.frame)
        self.canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=1)

        self.scrollbar_y = tk.Scrollbar(self.frame, orient=tk.VERTICAL, command=self.canvas.yview)
        self.scrollbar_y.pack(side=tk.RIGHT, fill=tk.Y)
        
        self.scrollbar_x = tk.Scrollbar(self.root, orient=tk.HORIZONTAL, command=self.canvas.xview)
        self.scrollbar_x.pack(side=tk.BOTTOM, fill=tk.X)

        self.canvas.configure(yscrollcommand=self.scrollbar_y.set, xscrollcommand=self.scrollbar_x.set)
        self.canvas.bind('<Configure>', lambda e: self.canvas.configure(scrollregion=self.canvas.bbox("all")))

        self.grid_frame = tk.Frame(self.canvas)
        self.canvas.create_window((0, 0), window=self.grid_frame, anchor="nw")

        for row in range(self.num_rows):
            row_cells = []
            for col in range(self.num_cols):
                cell = self.canvas.create_rectangle(
                    col * 30, row * 30, (col + 1) * 30, (row + 1) * 30,
                    fill="white", outline="black"
                )
                row_cells.append(cell)
            self.grid.append(row_cells)

        self.visualize_maze()

    def visualize_maze(self):
        for x, y in self.init_positions:
            self.canvas.itemconfig(self.grid[x][y], fill="green")
        for x, y in self.final_positions:
            self.canvas.itemconfig(self.grid[x][y], fill="red")
        for x, y in self.walls:
            self.canvas.itemconfig(self.grid[x][y], fill="black")

if __name__ == "__main__":
    root = tk.Tk()
    app = MazeVisualizerApp(root)
    root.mainloop()
