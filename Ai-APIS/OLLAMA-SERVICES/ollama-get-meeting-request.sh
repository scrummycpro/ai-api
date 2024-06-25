#!/bin/bash

# Function to create the SQLite database and table if they don't exist
create_database() {
  sqlite3 responses.db <<EOF
CREATE TABLE IF NOT EXISTS meeting_scripts (
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
    "prompt": "'"write a email requesting specific times  for a meeting regarding  $prompt, include a brief description of the purpose of the meeting, and any relevant information that will help the recipient understand the context and importance of the meeting. Include a call to action to confirm the meeting time and date, and express appreciation for their time and consideration. Use a professional tone and formal language, and ensure the email is clear, concise, and polite. "'",
    "stream": false
  }' | jq -r .response)

  # Escape single quotes in the prompt and response
  escaped_prompt=$(echo "$prompt" | sed "s/'/''/g")
  escaped_response=$(echo "$response" | sed "s/'/''/g")

  # Insert the timestamp, prompt, and response into the SQLite database
  sqlite3 responses.db <<EOF
INSERT INTO meeting_scripts (timestamp, prompt, response) VALUES ('$timestamp', '$escaped_prompt', '$escaped_response');
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