# task-api-v2.rb
require 'sinatra'
require 'sqlite3'
require 'json'

# Set Sinatra to bind to all interfaces
set :bind, '0.0.0.0'

# Initialize SQLite database
DB = SQLite3::Database.new 'tasks.db'
DB.execute <<-SQL
  CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TEXT NOT NULL,
    task TEXT NOT NULL,
    description TEXT,
    ranking INTEGER CHECK (ranking >= 0 AND ranking <= 10)
  );
SQL

# Middleware to set content type for JSON responses
before do
  content_type 'application/json'
end

# POST endpoint to create a new task
post '/tasks' do
  request.body.rewind
  task_data = JSON.parse(request.body.read)
  
  timestamp = Time.now.to_s
  task = task_data['task']
  description = task_data['description']
  ranking = task_data['ranking']

  DB.execute("INSERT INTO tasks (timestamp, task, description, ranking) VALUES (?, ?, ?, ?)",
             [timestamp, task, description, ranking])
  
  status 201
end

# GET endpoint to list all tasks with task ID, description, and ranking
get '/tasks' do
  tasks = DB.execute("SELECT id, task, description, ranking FROM tasks")
  tasks.to_json
end

# GET endpoint to fetch tasks by ranking
get '/tasks/:ranking' do |ranking|
  tasks = DB.execute("SELECT id, task, description, ranking FROM tasks WHERE ranking = ?", ranking.to_i)
  tasks.to_json
end

# PATCH endpoint to update a task by ID
patch '/tasks/:id' do |id|
  request.body.rewind
  task_data = JSON.parse(request.body.read)
  
  task = task_data['task']
  description = task_data['description']
  ranking = task_data['ranking']

  DB.execute("UPDATE tasks SET task = ?, description = ?, ranking = ? WHERE id = ?",
             [task, description, ranking, id.to_i])
  
  status 204
end

# DELETE endpoint to delete a task by ID
delete '/tasks/:id' do |id|
  DB.execute("DELETE FROM tasks WHERE id = ?", id.to_i)
  status 204
end