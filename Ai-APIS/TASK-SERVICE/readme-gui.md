Certainly! Here is the documentation on how to use the Python GUI application to interact with the task management API:

## Task Manager GUI Application

### Overview

This Python GUI application allows users to interact with a task management API using curl commands. The application provides a user-friendly interface to list, create, update, delete, and search tasks, as well as save the result as a JSON file.

### Requirements

- Python 3.x
- `tkinter` library (comes pre-installed with Python)
- `subprocess` module (comes pre-installed with Python)

### How to Run the Application

1. Save the script to a file named `task_manager_gui.py`.
2. Open a terminal or command prompt and navigate to the directory where the file is saved.
3. Run the script using the following command:
   ```sh
   python task_manager_gui.py
   ```

### Features

The application has the following features, accessible via buttons arranged in two rows:

1. **List All Tasks:** Lists all tasks available in the database.
2. **Get Task by ID:** Retrieves a specific task by its ID.
3. **Create New Task:** Creates a new task with name, description, ranking, and tags.
4. **Update Task by ID:** Updates an existing task by its ID.
5. **Delete Task by ID:** Deletes a task by its ID.
6. **Search Tasks by Keyword:** Searches for tasks by a keyword in their name, description, or tags.
7. **Get Tasks by Ranking:** Retrieves tasks with a specific ranking.
8. **Get Tasks by Ranking Range:** Retrieves tasks within a specific ranking range.
9. **Save Result as JSON:** Saves the result displayed in the output area as a JSON file.

### How to Use the Features

1. **List All Tasks:**
   - Click the "List All Tasks" button.
   - The result will be displayed in the output area.

2. **Get Task by ID:**
   - Click the "Get Task by ID" button.
   - Enter the task ID in the prompt and click "OK".
   - The result will be displayed in the output area.

3. **Create New Task:**
   - Click the "Create New Task" button.
   - Enter the task details (name, description, ranking, tags) in the prompts and click "OK".
   - The task will be created, and the result will be displayed in the output area.

4. **Update Task by ID:**
   - Click the "Update Task by ID" button.
   - Enter the task ID in the prompt and click "OK".
   - Enter the new details for the task (leave fields blank to keep unchanged) in the prompts and click "OK".
   - The task will be updated, and the result will be displayed in the output area.

5. **Delete Task by ID:**
   - Click the "Delete Task by ID" button.
   - Enter the task ID in the prompt and click "OK".
   - The task will be deleted, and the result will be displayed in the output area.

6. **Search Tasks by Keyword:**
   - Click the "Search Tasks by Keyword" button.
   - Enter the search keyword in the prompt and click "OK".
   - The result will be displayed in the output area.

7. **Get Tasks by Ranking:**
   - Click the "Get Tasks by Ranking" button.
   - Enter the ranking in the prompt and click "OK".
   - The result will be displayed in the output area.

8. **Get Tasks by Ranking Range:**
   - Click the "Get Tasks by Ranking Range" button.
   - Enter the minimum and maximum rankings in the prompts and click "OK".
   - The result will be displayed in the output area.

9. **Save Result as JSON:**
   - Click the "Save Result as JSON" button.
   - A file dialog will open; specify the location and name of the JSON file and click "Save".
   - The result will be saved as a JSON file.

### Additional Information

- The application uses the `curl` command to interact with the API.
- The `-s` flag is used to silence the verbosity of the curl command.
- The output of the curl command is displayed in a scrollable text area within the GUI.
- The saved JSON file contains the result displayed in the output area.

### Example

Here is an example of how to create a new task:

1. Click the "Create New Task" button.
2. Enter "Sample Task" as the task name and click "OK".
3. Enter "This is a sample task" as the task description and click "OK".
4. Enter "5" as the task ranking and click "OK".
5. Enter "sample,task" as the task tags and click "OK".
6. The new task will be created, and the result will be displayed in the output area.

### Troubleshooting

- If the application encounters any errors, they will be displayed in the output area.
- Ensure that the task management API is running and accessible at `http://localhost:4567`.
- If the result is not valid JSON, an error message will be displayed when trying to save it as a JSON file.

By following this documentation, you should be able to effectively use the Task Manager GUI Application to interact with your task management API.