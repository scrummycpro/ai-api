The `COPY` command tries to write the file on the server-side, which is the PostgreSQL container in this case. The permission error indicates that the PostgreSQL process does not have permission to write to the `/tmp` directory.

To work around this, you can use the `\copy` command, which instructs `psql` to perform the copy on the client-side. This approach avoids permission issues on the server.

### Step 1: Use `\copy` to Export Data to CSV

Run the `\copy` command inside the container to export the data to a CSV file:

```sh
sudo docker exec -it cal-api-db-1 psql -U example -d tasks_db -c "\copy (SELECT * FROM tasks) TO '/tmp/tasks.csv' WITH CSV HEADER;"
```

### Step 2: Copy the CSV File to the Host Machine

After exporting the data to a CSV file inside the container, copy the file to your host machine:

```sh
sudo docker cp cal-api-db-1:/tmp/tasks.csv ./tasks.csv
```

### Example Commands

1. **Export Data to CSV**:

    ```sh
    sudo docker exec -it cal-api-db-1 psql -U example -d tasks_db -c "\copy (SELECT * FROM tasks) TO '/tmp/tasks.csv' WITH CSV HEADER;"
    ```

2. **Copy CSV File to Host**:

    ```sh
    sudo docker cp cal-api-db-1:/tmp/tasks.csv ./tasks.csv
    ```

### Full Example

Here is a full example of the commands you need to run:

```sh
# Export data to CSV inside the container
sudo docker exec -it cal-api-db-1 psql -U example -d tasks_db -c "\copy (SELECT * FROM tasks) TO '/tmp/tasks.csv' WITH CSV HEADER;"

# Copy the CSV file from the container to the host machine
sudo docker cp cal-api-db-1:/tmp/tasks.csv ./tasks.csv
```

### Verify the CSV File

After copying the CSV file to your host machine, you can open it with any text editor or spreadsheet software to verify the contents.

By following these steps, you should be able to export the data from your PostgreSQL database to a CSV file and copy it to your host machine for further analysis or processing.