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