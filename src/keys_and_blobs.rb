require "cassandra/0.7"

# Connect to localhost, select a keyspace
c = Cassandra.new('Keyspace1')

# Insert one column into a row in the column family
c.insert(:Standard1, 'akk', {'data' => JSON.dump(:age => 31)})

# Fetch a specific row and column from the column family
c.get(:Standard1, 'akk', 'data')
