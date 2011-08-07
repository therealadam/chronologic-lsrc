# You know how this part goes by now...
require 'cassandra'
c = Cassandra.new('lsrc')

# This time, we're going to write our data structure as columns, rather
# than sticking it a value that is opaque to Cassandra. This gives us
# finer grained access to the values we write to the row and make it
# possible for Cassandra to index the column values.
#
# Note that column names **and** values are strings. The Ruby driver
# is pretty curmudeongly about this. Technically it __could__ coerce
# values to strings (Cassandra doesn't know about other data types), but
# it's better for applications to do coercions on their own.
columns = {
  'username' => 'ak',
  'age' => '31'
}

# Just like any other insert; column family, key, and the columns to
# write.
c.insert(:example, 'akk', columns)

# Just like any other get; column family and key. This time we get back
# a more interesting hash:
#
#     <OrderedHash {"username"=>"ak", "age"=>"31"}
#     {"username"=>1312743932840327, "age"=>1312743932840327}>
#
# One key/value for each column we created, plus a timestamp for each.
# Note that the timestamps are identical. Writes to a single _row_ in
# Cassandra are atomic.
p c.get(:example, 'akk')

# Just like any other remove; column family and key. Do you get the
# feeling that 95% of all your operations on Cassandra will pass a
# column family and key? Yes? You're a clever one, gold star for you!
c.remove(:example, 'akk')

