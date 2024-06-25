#!/bin/bash

# Function to create the SQLite database and table if they don't exist
create_database() {
  sqlite3 responses.db <<EOF
CREATE TABLE IF NOT EXISTS jobs (
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
    "prompt": "'"write a a resume entry for a senior position  for $prompt and give some accomplishments with numbers, show management of cross global teams, use software, buzzwords, and jargon, include a summary as some one with over a decade of experience, include any valuble information that will make the resume entry sound as human and successful as possible keywords to associate. Make the resume entry seem like an expert "'",
    "stream": false
  }' | jq -r .response)

  # Escape single quotes in the prompt and response
  escaped_prompt=$(echo "$prompt" | sed "s/'/''/g")
  escaped_response=$(echo "$response" | sed "s/'/''/g")

  # Insert the timestamp, prompt, and response into the SQLite database
  sqlite3 responses.db <<EOF
INSERT INTO jobs (timestamp, prompt, response) VALUES ('$timestamp', '$escaped_prompt', '$escaped_response');
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