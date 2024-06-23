## Detailed Documentation for RabbitMQ and PostgreSQL Architecture with Ruby Applications

### Architecture Overview

This architecture consists of the following components:

1. **PostgreSQL**: A relational database used to store tasks.
2. **RabbitMQ**: A message broker used to handle task messages.
3. **Ruby Sinatra Application**: A web application that allows clients to create and retrieve tasks via HTTP endpoints.
4. **Ruby Consumer**: A script that consumes messages from RabbitMQ and inserts them into the PostgreSQL database.

### System Architecture Diagram

```tex
              +--------------------------+
              |   Ruby Sinatra API       |
              |  (task_api.rb)           |
              |                          |
              +------------+-------------+
                           |
                           | HTTP Requests
                           |
                           v
              +------------+-------------+
              |   RabbitMQ Message Broker|
              |                          |
              +------------+-------------+
                           |
                           | RabbitMQ Messages
                           |
                           v
              +------------+-------------+
              |   Ruby Consumer          |
              |  (consume_task.rb)       |
              |                          |
              +------------+-------------+
                           |
                           | SQL Inserts
                           |
                           v
              +------------+-------------+
              |   PostgreSQL Database    |
              |  (tasks_db)              |
              |                          |
              +--------------------------+
```

### Step-by-Step Setup Instructions

#### Prerequisites

- Docker and Docker Compose installed on your machine.
- Ruby and Bundler installed on your machine.
- `jq` installed for JSON formatting (optional but recommended).

#### Step 1: Create Docker Compose File

Create a `docker-compose.yml` file to define the PostgreSQL and RabbitMQ services.

**File: `docker-compose.yml`**
```yaml
version: '3.1'

services:
  db:
    image: postgres
    restart: always
    environment:
      POSTGRES_USER: example
      POSTGRES_PASSWORD: example_password
      POSTGRES_DB: tasks_db
    ports:
      - "5432:5432"
    volumes:
      - ./pgdata:/var/lib/postgresql/data

  rabbitmq:
    image: rabbitmq:3-management
    environment:
      RABBITMQ_DEFAULT_USER: user
      RABBITMQ_DEFAULT_PASS: password
    ports:
      - "5672:5672"
      - "15672:15672"
    volumes:
      - ./rabbitmqdata:/var/lib/rabbitmq
```

#### Step 2: Start the Docker Services

Start the PostgreSQL and RabbitMQ services:

```sh
docker-compose up -d
```

#### Step 3: Create and Setup Ruby Sinatra Application

Create a Ruby Sinatra application (`task_api.rb`) to handle HTTP requests and publish messages to RabbitMQ.

**File: `task_api.rb`**
```ruby
require 'sinatra'
require 'bunny'
require 'json'
require 'pg'

# Connect to RabbitMQ
connection = Bunny.new(hostname: 'localhost', username: 'user', password: 'password')
connection.start
channel = connection.create_channel
queue = channel.queue('tasks')

# Connect to PostgreSQL
db = PG.connect(
  dbname: 'tasks_db', 
  user: 'example', 
  password: 'example_password', 
  host: 'localhost'
)

# Create tasks table if it doesn't exist
db.exec <<-SQL
  CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP,
    task TEXT,
    description TEXT,
    attachment TEXT,
    ranking INTEGER
  );
SQL

# Define the POST endpoint
post '/task' do
  content_type :json
  payload = {
    timestamp: Time.now,
    task: params[:task],
    description: params[:description],
    attachment: params[:attachment],
    ranking: params[:ranking].to_i
  }
  queue.publish(payload.to_json)
  { status: 'Task sent to RabbitMQ' }.to_json
end

# Define the GET endpoint to retrieve all tasks
get '/tasks' do
  content_type :json
  result = db.exec("SELECT * FROM tasks")
  tasks = result.map do |row|
    {
      id: row['id'],
      timestamp: row['timestamp'],
      task: row['task'],
      description: row['description'],
      attachment: row['attachment'],
      ranking: row['ranking']
    }
  end
  tasks.to_json
end
```

Create a `Gemfile` to manage dependencies:

**File: `Gemfile`**
```ruby
source 'https://rubygems.org'

gem 'sinatra'
gem 'bunny'
gem 'pg'
```

Install the necessary gems:

```sh
gem install bundler
bundle install
```

Run the Sinatra application:

```sh
ruby task_api.rb
```

#### Step 4: Create and Setup Ruby Consumer

Create a Ruby script (`consume_task.rb`) to consume messages from RabbitMQ and insert them into PostgreSQL.

**File: `consume_task.rb`**
```ruby
require 'bunny'
require 'pg'
require 'json'

# Connect to RabbitMQ
connection = Bunny.new(hostname: 'localhost', username: 'user', password: 'password')
connection.start
channel = connection.create_channel
queue = channel.queue('tasks')

# Connect to PostgreSQL
db = PG.connect(
  dbname: 'tasks_db', 
  user: 'example', 
  password: 'example_password', 
  host: 'localhost'
)

# Consume messages
puts "Consumer is connected and waiting for messages..."

queue.subscribe(block: true) do |delivery_info, _properties, body|
  task = JSON.parse(body)
  puts "Received task from RabbitMQ: #{task}"
  db.exec_params("INSERT INTO tasks (timestamp, task, description, attachment, ranking)
                  VALUES ($1, $2, $3, $4, $5)", 
                  [task['timestamp'], task['task'], task['description'], task['attachment'], task['ranking']])
  puts "Inserted task into PostgreSQL: #{task}"
end
```

Run the consumer script:

```sh
ruby consume_task.rb
```

#### Step 5: Verify the Setup

You can create tasks using `curl` and verify the data in PostgreSQL.

**Example `curl` Command to Create a Task**:

```sh
curl -X POST http://localhost:4567/task \
     -d "task=New Task" \
     -d "description=This is a new task description" \
     -d "attachment=/path/to/attachment" \
     -d "ranking=3"
```

**Example `curl` Command to Retrieve All Tasks**:

```sh
curl http://localhost:4567/tasks
```

#### Step 6: Export Data to CSV

You can export the data from PostgreSQL to a CSV file.

1. **Export Data to CSV Inside the Container**:

    ```sh
    sudo docker exec -it cal-api-db-1 psql -U example -d tasks_db -c "\copy (SELECT * FROM tasks) TO '/tmp/tasks.csv' WITH CSV HEADER;"
    ```

2. **Copy the CSV File to the Host Machine**:

    ```sh
    sudo docker cp cal-api-db-1:/tmp/tasks.csv ./tasks.csv
    ```

### Conclusion

This documentation provides a comprehensive guide to setting up a RabbitMQ and PostgreSQL architecture with Ruby applications. By following these steps, you can create a robust system for managing tasks through HTTP requests, message queuing, and database storage.

This setup ensures efficient handling of tasks with the flexibility to scale each component independently, providing a reliable architecture for various applications.