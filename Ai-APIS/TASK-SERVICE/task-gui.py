import tkinter as tk
from tkinter import messagebox, simpledialog, scrolledtext, filedialog
import subprocess
import json

class TaskManagerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Task Manager")

        # Create frames for better organization
        self.frame1 = tk.Frame(root)
        self.frame1.pack(pady=10)

        self.frame2 = tk.Frame(root)
        self.frame2.pack(pady=10)

        # First row of buttons
        self.list_tasks_btn = tk.Button(self.frame1, text="List All Tasks", command=self.list_tasks)
        self.list_tasks_btn.grid(row=0, column=0, padx=5, pady=5)

        self.get_task_btn = tk.Button(self.frame1, text="Get Task by ID", command=self.get_task_by_id)
        self.get_task_btn.grid(row=0, column=1, padx=5, pady=5)

        self.create_task_btn = tk.Button(self.frame1, text="Create New Task", command=self.create_task)
        self.create_task_btn.grid(row=0, column=2, padx=5, pady=5)

        self.update_task_btn = tk.Button(self.frame1, text="Update Task by ID", command=self.update_task_by_id)
        self.update_task_btn.grid(row=0, column=3, padx=5, pady=5)

        # Second row of buttons
        self.delete_task_btn = tk.Button(self.frame2, text="Delete Task by ID", command=self.delete_task_by_id)
        self.delete_task_btn.grid(row=0, column=0, padx=5, pady=5)

        self.search_tasks_btn = tk.Button(self.frame2, text="Search Tasks by Keyword", command=self.search_tasks_by_keyword)
        self.search_tasks_btn.grid(row=0, column=1, padx=5, pady=5)

        self.get_tasks_by_ranking_btn = tk.Button(self.frame2, text="Get Tasks by Ranking", command=self.get_tasks_by_ranking)
        self.get_tasks_by_ranking_btn.grid(row=0, column=2, padx=5, pady=5)

        self.get_tasks_by_ranking_range_btn = tk.Button(self.frame2, text="Get Tasks by Ranking Range", command=self.get_tasks_by_ranking_range)
        self.get_tasks_by_ranking_range_btn.grid(row=0, column=3, padx=5, pady=5)

        # Save result as JSON button
        self.save_json_btn = tk.Button(root, text="Save Result as JSON", command=self.save_result_as_json)
        self.save_json_btn.pack(pady=5)

        # Output area
        self.output_text = scrolledtext.ScrolledText(root, wrap=tk.WORD, width=100, height=20)
        self.output_text.pack(pady=10)

    def run_curl_command(self, command):
        try:
            result = subprocess.run(command, shell=True, capture_output=True, text=True)
            self.output_text.delete(1.0, tk.END)
            self.output_text.insert(tk.END, result.stdout)
            if result.stderr:
                self.output_text.insert(tk.END, "\nError:\n" + result.stderr)
            return result.stdout
        except Exception as e:
            messagebox.showerror("Error", str(e))
            return None

    def save_result_as_json(self):
        result = self.output_text.get(1.0, tk.END)
        if not result.strip():
            messagebox.showwarning("Warning", "No result to save")
            return
        try:
            json_data = json.loads(result)
            file_path = filedialog.asksaveasfilename(defaultextension=".json", filetypes=[("JSON files", "*.json")])
            if file_path:
                with open(file_path, 'w') as json_file:
                    json.dump(json_data, json_file, indent=4)
                messagebox.showinfo("Success", "Result saved as JSON file")
        except json.JSONDecodeError:
            messagebox.showerror("Error", "The result is not valid JSON")

    def list_tasks(self):
        command = "curl -s -X GET http://localhost:4567/tasks"
        self.run_curl_command(command)

    def get_task_by_id(self):
        task_id = simpledialog.askstring("Input", "Enter task ID:")
        if task_id:
            command = f"curl -s -X GET http://localhost:4567/tasks/{task_id}"
            self.run_curl_command(command)

    def create_task(self):
        name = simpledialog.askstring("Input", "Enter task name:")
        description = simpledialog.askstring("Input", "Enter task description:")
        ranking = simpledialog.askinteger("Input", "Enter task ranking:")
        tags = simpledialog.askstring("Input", "Enter task tags (comma-separated):")
        if name and description and ranking is not None:
            data = {
                "name": name,
                "description": description,
                "ranking": ranking,
                "tags": tags
            }
            command = f"curl -s -X POST http://localhost:4567/tasks -H \"Content-Type: application/json\" -d '{json.dumps(data)}'"
            self.run_curl_command(command)

    def update_task_by_id(self):
        task_id = simpledialog.askstring("Input", "Enter task ID:")
        name = simpledialog.askstring("Input", "Enter task name (leave blank to keep unchanged):")
        description = simpledialog.askstring("Input", "Enter task description (leave blank to keep unchanged):")
        ranking = simpledialog.askinteger("Input", "Enter task ranking (leave blank to keep unchanged):")
        tags = simpledialog.askstring("Input", "Enter task tags (leave blank to keep unchanged):")
        if task_id:
            data = {}
            if name:
                data['name'] = name
            if description:
                data['description'] = description
            if ranking is not None:
                data['ranking'] = ranking
            if tags:
                data['tags'] = tags
            command = f"curl -s -X PATCH http://localhost:4567/tasks/{task_id} -H \"Content-Type: application/json\" -d '{json.dumps(data)}'"
            self.run_curl_command(command)

    def delete_task_by_id(self):
        task_id = simpledialog.askstring("Input", "Enter task ID:")
        if task_id:
            command = f"curl -s -X DELETE http://localhost:4567/tasks/{task_id}"
            self.run_curl_command(command)

    def search_tasks_by_keyword(self):
        keyword = simpledialog.askstring("Input", "Enter search keyword:")
        if keyword:
            command = f"curl -s -X GET http://localhost:4567/tasks/search/{keyword}"
            self.run_curl_command(command)

    def get_tasks_by_ranking(self):
        ranking = simpledialog.askinteger("Input", "Enter task ranking:")
        if ranking is not None:
            command = f"curl -s -X GET http://localhost:4567/tasks/rank/{ranking}"
            self.run_curl_command(command)

    def get_tasks_by_ranking_range(self):
        min_rank = simpledialog.askinteger("Input", "Enter minimum ranking:")
        max_rank = simpledialog.askinteger("Input", "Enter maximum ranking:")
        if min_rank is not None and max_rank is not None:
            command = f"curl -s -X GET http://localhost:4567/tasks/rank-range/{min_rank},{max_rank}"
            self.run_curl_command(command)

if __name__ == "__main__":
    root = tk.Tk()
    app = TaskManagerApp(root)
    root.mainloop()