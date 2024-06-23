#!/bin/bash

# RabbitMQ credentials and server URL
RABBITMQ_USER="guest"
RABBITMQ_PASS="guest"
RABBITMQ_HOST="localhost"
RABBITMQ_PORT="15672"
RABBITMQ_VHOST="%2F"  # Default vhost is encoded as "%2F"
EXCHANGE_NAME="tasks"
ROUTING_KEY="large"
QUEUE_NAME="large_tasks_queue"

# Ensure the exchange exists or create it if it doesn't
if ! curl -u "$RABBITMQ_USER:$RABBITMQ_PASS" -X PUT \
     -H "Content-Type: application/json" \
     "http://$RABBITMQ_HOST:$RABBITMQ_PORT/api/exchanges/$RABBITMQ_VHOST/$EXCHANGE_NAME"; then
    echo "Failed to create exchange '$EXCHANGE_NAME'. Check RabbitMQ setup."
    exit 1
fi

# Ensure the queue exists or create it if it doesn't
if ! curl -u "$RABBITMQ_USER:$RABBITMQ_PASS" -X PUT \
     -H "Content-Type: application/json" \
     -d '{"auto_delete":false,"durable":true}' \
     "http://$RABBITMQ_HOST:$RABBITMQ_PORT/api/queues/$RABBITMQ_VHOST/$QUEUE_NAME"; then
    echo "Failed to create queue '$QUEUE_NAME'. Check RabbitMQ setup."
    exit 1
fi

# Bind the queue to the exchange with the routing key
if ! curl -u "$RABBITMQ_USER:$RABBITMQ_PASS" -X POST \
     -H "Content-Type: application/json" \
     -d '{"routing_key":"large"}' \
     "http://$RABBITMQ_HOST:$RABBITMQ_PORT/api/bindings/$RABBITMQ_VHOST/e/$EXCHANGE_NAME/q/$QUEUE_NAME"; then
    echo "Failed to bind queue '$QUEUE_NAME' to exchange '$EXCHANGE_NAME'. Check RabbitMQ setup."
    exit 1
fi

# Query and filter tasks from SQLite database
results=$(sqlite3 tasks.db <<EOF
.headers on
.mode json
SELECT * FROM tasks
WHERE timestamp >= datetime('now', '-1 day')
AND timestamp <= datetime('now')
AND ranking >= 7 AND ranking <= 10
ORDER BY ranking;
EOF
)

# Check if there are results
if [ -n "$results" ]; then
    # Loop through each task and publish to RabbitMQ
    echo "$results" | jq -c '.[]' | while IFS= read -r task; do
        echo "Publishing task: $task"
        # Construct JSON payload with required fields
        json_payload=$(jq -n --arg rk "$ROUTING_KEY" --argjson payload "$task" \
                        '{ "routing_key": $rk, "properties": {}, "payload": ($payload | tostring), "payload_encoding": "string" }')
        
        # Publish message to RabbitMQ
        if ! curl -u "$RABBITMQ_USER:$RABBITMQ_PASS" -X POST \
             -H "Content-Type: application/json" \
             -d "$json_payload" \
             "http://$RABBITMQ_HOST:$RABBITMQ_PORT/api/exchanges/$RABBITMQ_VHOST/$EXCHANGE_NAME/publish"; then
            echo "Failed to publish message to RabbitMQ."
        fi
    done
else
    echo "No tasks found with rankings between 7 and 10."
fi