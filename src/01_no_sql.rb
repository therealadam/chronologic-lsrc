require 'cassandra'

# Connect to a running Cassandra server. Keyspace1 is present in vanilla
# Cassandra installs.
c = Cassandra.new("Keyspace1", '127.0.0.1:9160')

# Create a new keyspace definition.
ks = Cassandra::Keyspace.new

# Everything needs a name.
ks.name = 'ImportantStuff'

# Tell Cassandra how to decide where to store data (to take advantage of
# rack or datacenter topology).
ks.strategy_class = 'org.apache.cassandra.locator.SimpleStrategy'

# Tell Cassandra to only keep one copy of every row. You'll want to use
# more when you actually go into production. A replication factor of 3
# is pretty standard.
ks.replication_factor = 1

# We're not going to define any column families just yet
ks.cf_defs = []

# Add the keyspace to the ring already!
c.add_keyspace(ks)

# Now let's add a column family. It's like a table.
cf = Cassandra::ColumnFamily.new

# Add this column family to our keyspace
cf.keyspace = 'ImportantStuff'

# Name, etc.
cf.name = 'Important'

# Add the column family
c.add_column_family(cf)

# Clean up the column family
c.drop_column_family('Important')

# Clean up the keyspace
c.drop_keyspace('ImportantStuff')

