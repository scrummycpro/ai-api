#!/bin/bash

# Function to create the SQLite database and table if they don't exist
create_database() {
  sqlite3 responses.db <<EOF
CREATE TABLE IF NOT EXISTS job_story (
  id INTEGER PRIMARY KEY,
  timestamp TEXT,
  prompt TEXT,
  response TEXT
);
EOF
}

# Function to query Ollama and insert response into SQLite
store_response() {
  local prompt="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

  # Query Ollama for a response
  response=$(curl -s http://localhost:11434/api/generate -d '{
    "model": "llama3",
    "prompt": "'"write a story for a senior position  for $prompt and give some accomplishments with numbers, show management of cross global teams, use software, buzzwords, and jargon, include a summary as some one with over a decade of experience, include any valuble information that will make the story entry sound as human and successful as possible keywords to associate. Make the story seem like an expert; use the format, at first nothing was happening, then bad things started to happesn , we tried to get the bad things to stop happeneing but they kep happening, we were just getting ready to give up , then we figured it out, all we had to do was three things, we did the first thing, then the second thing and then the third thing, and thats it, by doing the third thing,second thing, and the first thing, we where able to solve the problem .; in volve apis, kubernetes, teams, AWS, EC2, RDS, RabbitMQ, docker, memory"'",
    "stream": false
  }' | jq -r .response)

  # Escape single quotes in the prompt and response
  escaped_prompt=$(echo "$prompt" | sed "s/'/''/g")
  escaped_response=$(echo "$response" | sed "s/'/''/g")

  # Insert the timestamp, prompt, and response into the SQLite database
  sqlite3 responses.db <<EOF
INSERT INTO job_story (timestamp, prompt, response) VALUES ('$timestamp', '$escaped_prompt', '$escaped_response');
EOF
}

# Check if a prompt was provided
if [ -z "$1" ]; then
  echo "Usage: $0 <prompt>"
  exit 1
fi

# Create the database and table if they don't exist
create_database

# Call the function with the provided prompt
store_response "$1"