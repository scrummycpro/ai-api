require 'sinatra'
require 'sqlite3'
require 'json'

# Connect to SQLite database
DB = SQLite3::Database.new 'tasks.db'
DB.execute <<-SQL
  CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    name TEXT,
    description TEXT,
    ranking INTEGER,
    tags TEXT
  );
SQL

# Define constants
MAX_RANKING = 10

# Helper method to parse task data
def parse_task(task)
  {
    id: task[0],
    timestamp: task[1],
    name: task[2],
    description: task[3],
    ranking: task[4],
    tags: task[5]
  }
end

# Error handling for not found tasks
not_found do
  { message: 'Not Found' }.to_json
end

# Error handling for bad request
error 400 do
  { message: 'Bad Request' }.to_json
end

# Error handling for internal server error
error 500 do
  { message: 'Internal Server Error' }.to_json
end

# Endpoint to list all tasks
get '/tasks' do
  tasks = DB.execute('SELECT * FROM tasks')
  tasks.map { |task| parse_task(task) }.to_json
end

# Endpoint to get a task by ID
get '/tasks/:id' do |id|
  task = DB.execute('SELECT * FROM tasks WHERE id = ?', id.to_i).first
  if task
    parse_task(task).to_json
  else
    status 404
    { message: 'Task not found' }.to_json
  end
end

# Endpoint to create a new task
post '/tasks' do
  begin
    data = JSON.parse(request.body.read)
    name = data['name']
    description = data['description']
    ranking = data['ranking']&.to_i  # Ensure ranking is converted to integer
    tags = data['tags']

    # Limit ranking to maximum value of MAX_RANKING
    ranking = [ranking, MAX_RANKING].min if ranking

    if name && description && ranking
      DB.execute('INSERT INTO tasks (name, description, ranking, tags) VALUES (?, ?, ?, ?)', [name, description, ranking, tags])
      status 201
    else
      status 400
      { message: 'Missing parameters or invalid ranking' }.to_json
    end
  rescue JSON::ParserError
    status 400
    { message: 'Invalid JSON format' }.to_json
  end
end

# Endpoint to update a task by ID
patch '/tasks/:id' do |id|
  begin
    data = JSON.parse(request.body.read)
    name = data['name']
    description = data['description']
    ranking = data['ranking']&.to_i  # Ensure ranking is converted to integer
    tags = data['tags']

    # Limit ranking to maximum value of MAX_RANKING
    ranking = [ranking, MAX_RANKING].min if ranking

    if name || description || ranking || tags
      DB.execute('UPDATE tasks SET name = ?, description = ?, ranking = ?, tags = ? WHERE id = ?', [name, description, ranking, tags, id.to_i])
      status 204
    else
      status 400
      { message: 'Missing parameters or invalid ranking' }.to_json
    end
  rescue JSON::ParserError
    status 400
    { message: 'Invalid JSON format' }.to_json
  end
end

# Endpoint to delete a task by ID
delete '/tasks/:id' do |id|
  begin
    DB.execute('DELETE FROM tasks WHERE id = ?', id.to_i)
    status 204
  rescue SQLite3::ConstraintException => e
    status 500
    { message: "Failed to delete task: #{e.message}" }.to_json
  end
end

# Endpoint to search tasks by keyword in name, description, or tags (case insensitive)
get '/tasks/search/:keyword' do |keyword|
  keyword = '%' + keyword.downcase + '%'  # Convert keyword to lowercase and add SQL wildcard for partial matching
  tasks = DB.execute('SELECT * FROM tasks WHERE LOWER(name) LIKE ? OR LOWER(description) LIKE ? OR LOWER(tags) LIKE ?', [keyword, keyword, keyword])
  
  if tasks.empty?
    status 404
    { message: 'No tasks found matching the keyword' }.to_json
  else
    tasks.map { |task| parse_task(task) }.to_json
  end
end

# Endpoint to get tasks with a specific ranking
get '/tasks/rank/:ranking' do |ranking|
  tasks = DB.execute('SELECT * FROM tasks WHERE ranking = ?', ranking.to_i)

  if tasks.empty?
    status 404
    { message: 'No tasks found with the specified ranking' }.to_json
  else
    tasks.map { |task| parse_task(task) }.to_json
  end
end

# Endpoint to get tasks within a specific ranking range
get '/tasks/rank-range/:min,:max' do |min, max|
  min_rank = min.to_i
  max_rank = max.to_i

  if min_rank > max_rank || min_rank < 0 || max_rank > MAX_RANKING
    status 400
    return { message: 'Invalid ranking range' }.to_json
  end

  tasks = DB.execute('SELECT * FROM tasks WHERE ranking BETWEEN ? AND ?', [min_rank, max_rank])

  if tasks.empty?
    status 404
    { message: 'No tasks found within the ranking range' }.to_json
  else
    tasks.map { |task| parse_task(task) }.to_json
  end
end