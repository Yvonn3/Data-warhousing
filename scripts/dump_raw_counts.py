import duckdb

# Connect to  DuckDB database
con = duckdb.connect('main.db')

tables = [
    'bike_data',
    'central_park_weather',
    'fhv_bases',
    'fhv_tripdata',
    'fhvhv_tripdata',
    'green_tripdata',
    'yellow_tripdata'    
]

with open('answers/raw_counts.txt', 'w') as f:
    for table in tables:
        # Execute the SQL command to get the row count
        result = con.execute(f'SELECT COUNT(*) FROM {table}').fetchone()
        # Print and save the table name and row count
        print(f'{table}: {result[0]}')
        f.write(f'{table}: {result[0]}\n')

con.close()