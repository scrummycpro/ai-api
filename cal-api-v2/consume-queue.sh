#!/bin/bash
# Description: This script fetches and processes messages from RabbitMQ queue
# Usage: ./consume-and-append.sh

# Define RabbitMQ credentials and queue URL
rabbitmq_url="http://localhost:15672/api/queues/%2F/tasks_queue/get"
rabbitmq_auth="guest:guest"

# Fetch one message from RabbitMQ queue and process
message=$(curl -s -u $rabbitmq_auth -XPOST $rabbitmq_url \
  -H "content-type: application/json" \
  -d '{"count": 1, "requeue": true, "encoding": "auto", "ackmode": "ack_requeue_true"}' | jq -r '.[].payload'|jq)

if [ -z "$message" ]; then
    echo "No messages in queue."
else
    # Append payload to todo list file
    echo "$message" >> todo_list.txt
    echo "Message appended to todo_list.txt"

    # Fetch and display remaining messages in RabbitMQ queue
    remaining_messages=$(curl -s -u $rabbitmq_auth -XPOST $rabbitmq_url \
      -H "content-type: application/json" \
      -d '{"count": 10, "requeue": true, "encoding": "auto", "ackmode": "ack_requeue_true"}' | jq)
    
    echo "Remaining messages in queue:"
    echo "$remaining_messages"
fi