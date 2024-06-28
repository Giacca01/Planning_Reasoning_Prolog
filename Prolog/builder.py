import tkinter as tk
from tkinter import simpledialog, messagebox

class MazeApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Maze Creator")
        self.num_rows = 0
        self.num_cols = 0
        self.grid = []
        self.cell_states = {}  # Dictionary to keep track of cell click counts
        self.init_positions = []
        self.final_positions = []
        self.walls = []
        self.start_maze_creation()

    def start_maze_creation(self):
        self.num_cols = simpledialog.askinteger("Input", "Number of columns:")
        self.num_rows = simpledialog.askinteger("Input", "Number of rows:")
        if not self.num_cols or not self.num_rows:
            messagebox.showerror("Error", "Invalid input for rows or columns.")
            return

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
                self.canvas.tag_bind(cell, '<Button-1>', lambda event, x=col, y=row: self.on_cell_click(x, y))
                row_cells.append(cell)
                self.cell_states[(col, row)] = 0  # Initialize cell click count
            self.grid.append(row_cells)

        self.save_button = tk.Button(self.root, text="Save to Prolog", command=self.save_to_prolog)
        self.save_button.pack(pady=10)

    def on_cell_click(self, x, y):
        self.cell_states[(x, y)] += 1
        state = self.cell_states[(x, y)] % 4  # Cycle through 0 to 3
        if state == 1:  # Green for starting position
            self.canvas.itemconfig(self.grid[y][x], fill="green")
            if (x, y) not in self.init_positions:
                self.init_positions.append((x, y))
            if (x, y) in self.final_positions:
                self.final_positions.remove((x, y))
            if (x, y) in self.walls:
                self.walls.remove((x, y))
        elif state == 2:  # Red for final position
            self.canvas.itemconfig(self.grid[y][x], fill="red")
            if (x, y) not in self.final_positions:
                self.final_positions.append((x, y))
            if (x, y) in self.init_positions:
                self.init_positions.remove((x, y))
            if (x, y) in self.walls:
                self.walls.remove((x, y))
        elif state == 3:  # Black for wall
            self.canvas.itemconfig(self.grid[y][x], fill="black")
            if (x, y) not in self.walls:
                self.walls.append((x, y))
            if (x, y) in self.init_positions:
                self.init_positions.remove((x, y))
            if (x, y) in self.final_positions:
                self.final_positions.remove((x, y))
        else:  # Reset to free state
            self.canvas.itemconfig(self.grid[y][x], fill="white")
            if (x, y) in self.init_positions:
                self.init_positions.remove((x, y))
            if (x, y) in self.final_positions:
                self.final_positions.remove((x, y))
            if (x, y) in self.walls:
                self.walls.remove((x, y))

    def save_to_prolog(self):
        with open("maze.pl", "w") as f:
            f.write(f"num_col({self.num_cols}).\n")
            f.write(f"num_righe({self.num_rows}).\n")
            for x, y in self.init_positions:
                f.write(f"iniziale(pos({y + 1}, {x + 1})).\n")  # Convert to 1-based index and swap x, y
            for x, y in self.final_positions:
                f.write(f"finale(pos({y + 1}, {x + 1})).\n")  # Convert to 1-based index and swap x, y
            for x, y in self.walls:
                f.write(f"occupata(pos({y + 1}, {x + 1})).\n")  # Convert to 1-based index and swap x, y
        messagebox.showinfo("Saved", "Maze saved to maze.pl")

if __name__ == "__main__":
    root = tk.Tk()
    app = MazeApp(root)
    root.mainloop()
