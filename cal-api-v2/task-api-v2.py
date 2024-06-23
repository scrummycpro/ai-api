from flask import Flask, request, jsonify
import sqlite3
import json
from datetime import datetime

app = Flask(__name__)

# Initialize SQLite database
conn = sqlite3.connect('tasks.db')
c = conn.cursor()
c.execute('''
    CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        task TEXT NOT NULL,
        description TEXT,
        ranking INTEGER CHECK (ranking >= 0 AND ranking <= 10)
    )
''')
conn.commit()
conn.close()

# POST endpoint to create a new task
@app.route('/tasks', methods=['POST'])
def create_task():
    task_data = request.get_json()
    
    timestamp = datetime.now().isoformat()
    task = task_data['task']
    description = task_data.get('description', '')
    ranking = task_data['ranking']

    conn = sqlite3.connect('tasks.db')
    c = conn.cursor()
    c.execute("INSERT INTO tasks (timestamp, task, description, ranking) VALUES (?, ?, ?, ?)",
              (timestamp, task, description, ranking))
    conn.commit()
    conn.close()

    return '', 201

# GET endpoint to list all tasks with task ID, description, and ranking
@app.route('/tasks', methods=['GET'])
def get_tasks():
    conn = sqlite3.connect('tasks.db')
    c = conn.cursor()
    c.execute("SELECT id, task, description, ranking FROM tasks")
    tasks = c.fetchall()
    conn.close()

    return jsonify(tasks)

# GET endpoint to fetch tasks by ranking
@app.route('/tasks/<int:ranking>', methods=['GET'])
def get_tasks_by_ranking(ranking):
    conn = sqlite3.connect('tasks.db')
    c = conn.cursor()
    c.execute("SELECT id, task, description, ranking FROM tasks WHERE ranking = ?", (ranking,))
    tasks = c.fetchall()
    conn.close()

    return jsonify(tasks)

# PATCH endpoint to update a task by ID
@app.route('/tasks/<int:id>', methods=['PATCH'])
def update_task(id):
    task_data = request.get_json()

    task = task_data['task']
    description = task_data.get('description', '')
    ranking = task_data['ranking']

    conn = sqlite3.connect('tasks.db')
    c = conn.cursor()
    c.execute("UPDATE tasks SET task = ?, description = ?, ranking = ? WHERE id = ?",
              (task, description, ranking, id))
    conn.commit()
    conn.close()

    return '', 204

# DELETE endpoint to delete a task by ID
@app.route('/tasks/<int:id>', methods=['DELETE'])
def delete_task(id):
    conn = sqlite3.connect('tasks.db')
    c = conn.cursor()
    c.execute("DELETE FROM tasks WHERE id = ?", (id,))
    conn.commit()
    conn.close()

    return '', 204

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=12349)
    