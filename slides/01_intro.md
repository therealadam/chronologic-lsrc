<!SLIDE>

# Cassandra at Gowalla

<!SLIDE bullets incremental>

# What is Cassandra?

- A persistent, distributed hashtable?
- A column-oriented, masterless database?
- A Dynamo/Bigtable thingy?

<!SLIDE center>

# YES

<!SLIDE center bullets incremental>

# It's Cassandra, it's whatever it wants to be

(Zuul)

<!SLIDE center bullets incremental>

- Keys and values, like memcached or Riak
- Keys and hashes, like Redis
- Keys and sorted sets, like Redis
- Keys and counters, like Redis
- Keys and key/values, like MongoDB
- Rows and columns, like MySQL or PostgreSQL

<!SLIDE center bullets incremental>

# But it's distributed!

- Each server in the cluster is on a "ring"
- Data is stored and replicated along the ring
- Each server in the ring knows about every other server
- Connect to any server, do stuff
- Tolerate servers going down

<!SLIDE center bullets incremental>

- Operate with no durability (memcached, Mongo)
- Operate with full durability (MySQL, PostgreSQL)
- Operate with no consistency
- Operate with quorum consistency
- Operate with full consistency
- Do any of this across racks or datacenters

<!SLIDE>

# Why are we using Cassandra?

<!SLIDE bullets incremental>

- Fast growing data: checkins, social graph, photos, comments, etc.
- Data that benefits from prematerialized views: activity,
  notifications, etc.
- Masterless design that accounts for redundancy and availability

<!SLIDE>

# What are we using Cassandra for?

- Audit: store change logs on AR models
- Chronologic: activity stream data

<!SLIDE>

# What would we use Cassandra for?

- Cache social graphs from other networks (FB, Twitter, etc.)
- "Like" annotations
- Out-of-band notifications

<!SLIDE>

# What do I want to use Cassandra for in the future?

- Replace Redis
- Replace Solr with Solrandra
- Replace HDFS/Hadoop with CassandraFS + Brisk

<!SLIDE>

# What wouldn't I use Cassandra for?

- Geo-searches
- Heap-based caches
- Normalized, relational data
- Small datasets
- Prototypes 
