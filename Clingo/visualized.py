import tkinter as tk
from tkinter import ttk
from tkinter import filedialog
import re

# Function to parse Clingo output from a single line
def parse_clingo_output(output):
    games = []
    # Split the output by spaces to separate the partita instances
    matches = output.split(' ')
    for match in matches:
        if 'SATISFIABLE' in match:
            break
        if match.startswith('partita'):
            parts = match[len('partita('):-1].split(',')
            games.append((parts[0], parts[1], parts[2], int(parts[3])))
    return games

# Function to load Clingo output from file
def load_clingo_output():
    file_path = filedialog.askopenfilename(filetypes=[("Text Files", "*.txt"), ("All Files", "*.*")])
    if not file_path:
        return

    with open(file_path, 'r') as file:
        output = file.read()
    
    games = parse_clingo_output(output)
    games.sort(key=lambda x: x[3])  # Sort games by matchday
    
    for row in tree1.get_children():
        tree1.delete(row)
    for row in tree2.get_children():
        tree2.delete(row)
        
    for game in games:
        if 1 <= game[3] <= 9:
            tree1.insert("", tk.END, values=game)
        elif 10 <= game[3] <= 18:
            tree2.insert("", tk.END, values=game)

# Create a Tkinter GUI
root = tk.Tk()
root.title("Football Games Calendar")

# Create a frame to hold the tables
frame = tk.Frame(root)
frame.pack(fill=tk.BOTH, expand=True)

# Create the first Treeview widget for matchdays 1 to 15
tree1 = ttk.Treeview(frame)
tree1["columns"] = ("Team 1", "Team 2", "Stadium", "Matchday")

# Define the columns for the first Treeview
tree1.column("#0", width=0, stretch=tk.NO)
tree1.column("Team 1", anchor=tk.W, width=200)
tree1.column("Team 2", anchor=tk.W, width=200)
tree1.column("Stadium", anchor=tk.W, width=200)
tree1.column("Matchday", anchor=tk.CENTER, width=100)

# Define the headings for the first Treeview
tree1.heading("#0", text="", anchor=tk.W)
tree1.heading("Team 1", text="Team 1", anchor=tk.W)
tree1.heading("Team 2", text="Team 2", anchor=tk.W)
tree1.heading("Stadium", text="Stadium", anchor=tk.W)
tree1.heading("Matchday", text="Matchday", anchor=tk.CENTER)

# Pack the first Treeview widget
tree1.grid(row=0, column=0, sticky='nsew')

# Label for the first Treeview
label1 = tk.Label(frame, text="Matchdays 1 to 15")
label1.grid(row=1, column=0)

# Create the second Treeview widget for matchdays 16 to 30
tree2 = ttk.Treeview(frame)
tree2["columns"] = ("Team 1", "Team 2", "Stadium", "Matchday")

# Define the columns for the second Treeview
tree2.column("#0", width=0, stretch=tk.NO)
tree2.column("Team 1", anchor=tk.W, width=200)
tree2.column("Team 2", anchor=tk.W, width=200)
tree2.column("Stadium", anchor=tk.W, width=200)
tree2.column("Matchday", anchor=tk.CENTER, width=100)

# Define the headings for the second Treeview
tree2.heading("#0", text="", anchor=tk.W)
tree2.heading("Team 1", text="Team 1", anchor=tk.W)
tree2.heading("Team 2", text="Team 2", anchor=tk.W)
tree2.heading("Stadium", text="Stadium", anchor=tk.W)
tree2.heading("Matchday", text="Matchday", anchor=tk.CENTER)

# Pack the second Treeview widget
tree2.grid(row=0, column=1, sticky='nsew')

# Label for the second Treeview
label2 = tk.Label(frame, text="Matchdays 16 to 30")
label2.grid(row=1, column=1)

# Add a button to load the Clingo output file
load_button = tk.Button(frame, text="Load Clingo Output", command=load_clingo_output)
load_button.grid(row=2, column=0, columnspan=2, pady=20)

# Configure the grid layout to make the tables resize with the window
frame.grid_rowconfigure(0, weight=1)
frame.grid_columnconfigure(0, weight=1)
frame.grid_columnconfigure(1, weight=1)

# Run the application
root.mainloop()
