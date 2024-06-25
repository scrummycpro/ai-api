#!/bin/bash

# Function to create the SQLite database and table if they don't exist
create_database() {
  sqlite3 responses.db <<EOF
CREATE TABLE IF NOT EXISTS magic (
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
    "prompt": "'" what are the hebrew meanings of $prompt and give some SOP and debates, why and keywords to associate, also include any  kabbalah, freemasons, royal arch, and scottish rite rituals, also give the origin classical greek and hebrew, and any bible verses associated. Mention any thelema , wicca, alchemic refeferences and give  references, the answer should explain what it is, its opposite and its associations, and antonyms"'",
    "stream": false
  }' | jq -r .response)

  # Escape single quotes in the prompt and response
  escaped_prompt=$(echo "$prompt" | sed "s/'/''/g")
  escaped_response=$(echo "$response" | sed "s/'/''/g")

  # Insert the timestamp, prompt, and response into the SQLite database
  sqlite3 responses.db <<EOF
INSERT INTO magic (timestamp, prompt, response) VALUES ('$timestamp', '$escaped_prompt', '$escaped_response');
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