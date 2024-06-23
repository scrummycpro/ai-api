Here's a basic documentation template for your Flask application and how to run it using Docker:

---

## Flask API Documentation

### Overview

This Flask application provides a simple API for managing tasks in a SQLite database.

### Installation and Setup

#### Prerequisites

- Docker installed on your machine ([Docker installation guide](https://docs.docker.com/get-docker/))

#### Building the Docker Image

1. Clone the repository containing your Flask application (`task-api-v2.py`).
   
   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```

2. Create a Dockerfile in the root directory with the following content:

   ```Dockerfile
   # Use Alpine Linux as the base image
   FROM alpine:latest

   # Set the working directory inside the container
   WORKDIR /app

   # Install Python 3, pip, and system dependencies
   RUN apk add --no-cache python3 py3-pip gcc musl-dev libffi-dev sqlite-dev

   # Install Flask and sqlite3
   RUN pip3 install --no-cache-dir flask --break-system-packages

   # Copy your Flask application script into the container
   COPY task-api-v2.py .

   # Expose port 12349 (replace with your desired port)
   EXPOSE 12349

   # Command to run the Flask application
   CMD ["python3", "task-api-v2.py"]
   ```

3. Build the Docker image using the Dockerfile:

   ```bash
   docker build -t flask-task-api .
   ```

### Running the Flask Application

4. Run the Docker container from the built image:

   ```bash
   docker run -p 12349:12349 flask-task-api
   ```

   This command maps port 12349 of the host machine to port 12349 inside the Docker container where your Flask application is running.

### API Endpoints

- **POST `/tasks`**: Create a new task.
  ```bash
  curl -X POST \
       -H "Content-Type: application/json" \
       -d '{"task":"Complete project", "description":"Finish documentation", "ranking":8}' \
       http://localhost:12349/tasks
  ```

- **GET `/tasks`**: Retrieve all tasks.
  ```bash
  curl http://localhost:12349/tasks
  ```

- **GET `/tasks/<ranking>`**: Retrieve tasks by ranking.
  ```bash
  curl http://localhost:12349/tasks/8
  ```

- **PATCH `/tasks/<id>`**: Update a task by ID.
  ```bash
  curl -X PATCH \
       -H "Content-Type: application/json" \
       -d '{"task":"Updated task name", "description":"Updated task description", "ranking":7}' \
       http://localhost:12349/tasks/1
  ```

- **DELETE `/tasks/<id>`**: Delete a task by ID.
  ```bash
  curl -X DELETE http://localhost:12349/tasks/1
  ```

### Notes

- Replace `task-api-v2.py` with your actual Flask application script name if different.
- Modify port numbers (`12349`) in the Dockerfile and curl commands as per your configuration.

---

This documentation provides a basic outline of how to set up, run, and interact with your Flask API using Docker. Adjustments may be needed based on your specific application requirements and environment setup.

Here's the documentation for running your Flask application using Docker, including Docker commands and a Docker Compose file:

### Running Flask Application with Docker

#### Docker Command

To run your Flask application using Docker and attach the current directory as a volume:

```bash
docker run -d -p 12349:12349 -v "$(pwd)":/app --name task-api task-api
```

- `-d`: Detached mode (run container in the background).
- `-p 12349:12349`: Maps port 12349 on the host to port 12349 in the container.
- `-v "$(pwd)":/app`: Mounts the current directory (`$(pwd)`) as a volume inside the container at `/app`.
- `--name task-api`: Assigns a name `task-api` to the container.
- `task-api`: Specifies the Docker image name.

#### Docker Compose

Create a `docker-compose.yml` file in your project directory with the following content:

```yaml
version: '3.8'

services:
  task-api:
    image: task-api
    build:
      context: .
    ports:
      - "12349:12349"
    volumes:
      - .:/app
    environment:
      - FLASK_APP=task-api-v2.py
      - FLASK_ENV=development
```

To run your application using Docker Compose, use the following commands:

1. **Build and Start:**

   ```bash
   docker-compose up -d --build
   ```

   - `-d`: Detached mode (run containers in the background).
   - `--build`: Builds the Docker images before starting the containers.

2. **Stop:**

   ```bash
   docker-compose down
   ```

   This stops and removes the Docker containers.

### Documentation

#### Running the Application

1. **Using Docker:**

   - Ensure Docker is installed on your machine.
   - Navigate to the project directory containing `task-api-v2.py` and `docker-compose.yml`.
   - Run `docker-compose up -d --build` to start the application in detached mode.

2. **Accessing the Application:**

   - Once the application is running, you can access it at `http://localhost:12349`.
   - Use `curl` or a similar tool to interact with the API endpoints.

3. **Stopping the Application:**

   - To stop the application and remove containers, run `docker-compose down` in the same directory where `docker-compose.yml` is located.

#### Notes:

- Adjust the port numbers (`12349`) in the commands if your Flask application uses a different port.
- Ensure your Flask application script (`task-api-v2.py`) is correctly configured to listen on the specified port and handle API requests.

This documentation provides a clear guide for running your Flask application using Docker, whether through direct Docker commands or Docker Compose for more complex setups.