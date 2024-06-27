import tkinter as tk
from tkinter import filedialog, messagebox
import re

class MazeViewerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Maze Viewer")
        self.grid = []
        self.num_rows = 0
        self.num_cols = 0
        self.init_positions = []
        self.final_positions = []
        self.walls = []
        self.select_file_and_load_maze()

    def select_file_and_load_maze(self):
        prolog_file = filedialog.askopenfilename(
            title="Select Prolog File",
            filetypes=(("Prolog Files", "*.pl"), ("All Files", "*.*"))
        )
        if not prolog_file:
            messagebox.showerror("Error", "No file selected.")
            self.root.destroy()
            return
        self.load_maze(prolog_file)
        self.init_maze_grid()

    def load_maze(self, prolog_file):
        with open(prolog_file, 'r') as f:
            content = f.read()
        
        # Extract num_col and num_righe
        self.num_cols = int(re.search(r'num_col\((\d+)\)\.', content).group(1))
        self.num_rows = int(re.search(r'num_righe\((\d+)\)\.', content).group(1))
        
        # Extract iniziale positions
        self.init_positions = [(int(match.group(2)) - 1, int(match.group(1)) - 1) 
                               for match in re.finditer(r'iniziale\(pos\((\d+), (\d+)\)\)\.', content)]
        
        # Extract finale positions
        self.final_positions = [(int(match.group(2)) - 1, int(match.group(1)) - 1) 
                                for match in re.finditer(r'finale\(pos\((\d+), (\d+)\)\)\.', content)]
        
        # Extract occupata positions
        self.walls = [(int(match.group(2)) - 1, int(match.group(1)) - 1) 
                      for match in re.finditer(r'occupata\(pos\((\d+), (\d+)\)\)\.', content)]

    def init_maze_grid(self):
        self.canvas = tk.Canvas(self.root, width=self.num_cols*30, height=self.num_rows*30)
        self.canvas.pack()
        for row in range(self.num_rows):
            row_cells = []
            for col in range(self.num_cols):
                fill_color = "white"
                if (row, col) in self.init_positions:
                    fill_color = "green"
                elif (row, col) in self.final_positions:
                    fill_color = "red"
                elif (row, col) in self.walls:
                    fill_color = "black"
                
                cell = self.canvas.create_rectangle(
                    col * 30, row * 30, (col + 1) * 30, (row + 1) * 30,
                    fill=fill_color, outline="black"
                )
                row_cells.append(cell)
            self.grid.append(row_cells)

if __name__ == "__main__":
    root = tk.Tk()
    app = MazeViewerApp(root)
    root.mainloop()
