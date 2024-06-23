
#!/bin/bash

# RabbitMQ credentials and server URL
# be sure to update the RABBITMQ_USER and RABBITMQ_PASS with the correct credentials

# Create a new queue
curl -u guest:guest -X PUT \
  http://localhost:15672/api/queues/%2F/tasks_queue \ # task-queue can be changed to another name, this is the actual queue name
  -H "content-type: application/json" \
  -d '{
    "durable": true,
    "auto_delete": false
  }'

# Bind the queue to the exchange with the routing key 

curl -u guest:guest -X POST \
  http://localhost:15672/api/bindings/%2F/e/tasks/q/tasks_queue \ # the /e is for exchange this can be changed to another name, it is binded to task_queue which has the topic called large
  -H "content-type: application/json" \
  -d '{
    "routing_key": "large",
    "arguments": {}
  }'

  curl -u guest:guest -X GET \
  http://localhost:15672/api/queues/%2F/tasks_queue