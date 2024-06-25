Sure, here's a detailed README for the script:

---

# SQLite Response Storage Script

This script queries the Ollama API for a response to a given prompt and stores the prompt, response, and timestamp in a SQLite database. The script ensures that the database and table are created if they do not already exist.

## Prerequisites

1. **SQLite3**: Ensure SQLite3 is installed on your system. You can install it using Homebrew:
   ```bash
   brew install sqlite3
   ```

2. **curl**: Ensure curl is installed on your system. This tool is typically installed by default on macOS. If not, you can install it using Homebrew:
   ```bash
   brew install curl
   ```

3. **jq**: Ensure jq is installed on your system. You can install it using Homebrew:
   ```bash
   brew install jq
   ```

## Script Usage

1. **Download the Script**:
   Save the script below as `store_response.sh`:

   ```bash
   #!/bin/bash

   # Function to create the SQLite database and table if they don't exist
   create_database() {
     sqlite3 responses.db <<EOF
   CREATE TABLE IF NOT EXISTS responses (
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
       "prompt": "'"$prompt"'",
       "stream": false
     }' | jq -r .response)

     # Escape single quotes in the prompt and response
     escaped_prompt=$(echo "$prompt" | sed "s/'/''/g")
     escaped_response=$(echo "$response" | sed "s/'/''/g")

     # Insert the timestamp, prompt, and response into the SQLite database
     sqlite3 responses.db <<EOF
   INSERT INTO responses (timestamp, prompt, response) VALUES ('$timestamp', '$escaped_prompt', '$escaped_response');
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
   ```

2. **Make the Script Executable**:
   Make the script executable by running the following command:
   ```bash
   chmod +x store_response.sh
   ```

3. **Run the Script**:
   Run the script with a prompt as an argument. For example:
   ```bash
   ./store_response.sh "Why is the sky blue?"
   ```

   This command will query the Ollama API with the prompt "Why is the sky blue?", store the response along with the prompt and timestamp in the `responses.db` SQLite database.

4. **Verify the Data**:
   You can verify the stored data by querying the SQLite database:
   ```bash
   sqlite3 responses.db "SELECT * FROM responses;"
   ```

## Script Details

### `create_database` Function

This function creates the SQLite database and the `responses` table if they do not already exist. The table schema includes:
- `id`: An integer primary key.
- `timestamp`: The timestamp when the response was stored.
- `prompt`: The prompt sent to the Ollama API.
- `response`: The response received from the Ollama API.

### `store_response` Function

This function:
1. Takes a prompt as an argument.
2. Captures the current timestamp.
3. Queries the Ollama API for a response to the prompt.
4. Escapes single quotes in the prompt and response to prevent SQL injection issues.
5. Inserts the timestamp, prompt, and response into the `responses` table.

### Handling Single Quotes

Single quotes in the prompt and response are escaped by replacing each single quote with two single quotes. This ensures that the SQL query is properly formatted and prevents SQL injection issues.

### Usage Check

The script checks if a prompt was provided as an argument. If no prompt is provided, the script prints usage instructions and exits.

### Example

Here's an example of how to run the script and verify the stored data:

1. **Run the Script**:
   ```bash
   ./store_response.sh "What is the meaning of life?"
   ```

2. **Verify the Data**:
   ```bash
   sqlite3 responses.db "SELECT * FROM responses;"
   ```

   The output will show the stored timestamp, prompt, and response.

## License

This script is provided under the MIT License. Feel free to use, modify, and distribute it as needed.

---

By following this README, you should be able to set up and use the script to store responses from the Ollama API in a SQLite database, along with the corresponding prompts and timestamps.