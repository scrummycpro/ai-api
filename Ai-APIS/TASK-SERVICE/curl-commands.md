Yes, the curl commands for interacting with your API endpoints remain largely the same. You'll need to include the `name` field in the JSON payloads when creating or updating tasks. Here are the updated curl commands for various operations:

### List All Tasks
```sh
curl -X GET http://localhost:4567/tasks
```

### Get a Task by ID
```sh
curl -X GET http://localhost:4567/tasks/1
```

### Create a New Task
```sh
curl -X POST http://localhost:4567/tasks \
     -H "Content-Type: application/json" \
     -d '{
           "name": "Sample Task",
           "description": "This is a sample task",
           "ranking": 5,
           "tags": "sample,task"
         }'
```

### Update a Task by ID
```sh
curl -X PATCH http://localhost:4567/tasks/1 \
     -H "Content-Type: application/json" \
     -d '{
           "name": "Updated Task",
           "description": "This is an updated task",
           "ranking": 8,
           "tags": "updated,task"
         }'
```

### Delete a Task by ID
```sh
curl -X DELETE http://localhost:4567/tasks/1
```

### Search Tasks by Keyword
```sh
curl -X GET http://localhost:4567/tasks/search/keyword
```

### Get Tasks with a Specific Ranking
```sh
curl -X GET http://localhost:4567/tasks/rank/5
```

### Get Tasks Within a Specific Ranking Range
```sh
curl -X GET http://localhost:4567/tasks/rank-range/1,5
```

By including the `name` field in the appropriate payloads, these commands will work with the updated API.