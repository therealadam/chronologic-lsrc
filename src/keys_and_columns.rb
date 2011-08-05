require 'cassandra/0.7'

c = Cassandra.new('Keyspace1')
c.insert(
  :Standard1,
  'akk',
  {
    'username' => 'therealadam',
    'age' => '32'
  }
)
c.get(:Stanard1, 'akk')
