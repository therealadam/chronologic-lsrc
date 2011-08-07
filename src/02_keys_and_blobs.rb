require 'cassandra'
require 'yajl'

# Connect to a keyspace for this demo.
c = Cassandra.new('lsrc')

# Throw some data in a hash. We're just throwing blobs at Cassandra, so
# anything that works with your encoding scheme (we'll use JSON) works.
data = {
  'username' => 'akk',
  'age' => '31'
}

# Insert a row into the `example` column family. The row key (primary
# key) is `akk`. Within that row, we'll create a column named `data` and
# dump our JSON data into it.
c.insert(:example, 'akk', {'data' => Yajl.dump(data)})

# Read our row back out. We specify the column family to read and the
# key to fetch. This is the simplest and most coarse-grained way to read
# data out of Cassandra. The returned data looks like this:
#
#     #<OrderedHash {"data"=>"{\"username\":\"akk\",\"age\":\"31\"}"}
#     {"data"=>1312742715985471}>
#
# Because rows are stored with a defined ordering in Cassandra, the Ruby
# driver returns an ordered hash type (it maps to Ruby 1.9's hash type
# when you use 1.9). The keys in the hash are the column names in the
# row; the values are the opaque strings that were stored in Cassandra.
# The extra bit on the second line is the timestamp associated with the
# column. You don't need to worry about that until non-atomic
# concurrency control is a big deal.
p c.get(:example, 'akk')

# Now let's delete the data we just created. Again, we specify the
# column family and key to operate on.
c.remove(:example, 'akk')

