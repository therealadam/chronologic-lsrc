require 'cassandra'
c = Cassandra.new('lsrc')

# We're going to store a social graph in Cassandra this time. Each row
# lists the connections for an original feed object. Each column is a single
# connection. The column name is a feed that has subscribed to the
# original feed. The value indicates whether the connection is
# bidirectional. In this example, unidirectional connections represent
# follow relationships; bidirectional connections represent friend
# relationships.
akk_graph = {
  'user_rs_feed' => 'user_rs', # RS follows AK and AK is friends with RS
  'user_bf_feed' => 'user_bf', # BF follows AK and AK is friends with BF
  'user_am_feed' => 'user_am', # AM follows AK and AK is friends with AM
  'user_mt_feed' => '' # MT follows AK, but AK suspects MT is an automaton
}

# Store the sub-graph
c.insert(:example, 'akk/graph', akk_graph)

# Somewhere else in our applicaiton, we'll read the sub-graph back out.
graph = c.get(:example, 'akk/graph')

# We can find AK's followers by taking the keys of the sub-graph.
followers = graph.keys

# We can find AK's friends by taking the values and culling the empty
# strings.
friends = graph.values.reject { |u| u.empty? }

# Clean up.
c.remove(:example, 'akk/graph')
