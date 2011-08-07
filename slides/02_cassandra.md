<!SLIDE title center>
# Six Easy Pieces on Cassandra #

With apologies to Dr. Richard Feynman

<!SLIDE bullets incremental>

* Like SQL with beer goggles
* Keys and blobs (events)
* Keys and columns (objects)
* Simple graphs (subscribers)
* Timeline indexes (timelines)
* Secondary indexes (comfort food)

<!SLIDE code>

    # Connect to Cassandra
    connect localhost/9160;

    # Select the keyspace to operate on
    use Keyspace1;

    # Insert a row into the column family
    set Standard1['akk']['data'] = '{age: 31'};

    # Read a specific row and column
    # from a column family
    get Standard1['akk']['data'];

<!SLIDE code>

    @@@ ruby
    require "cassandra/0.7"

    # Connect to localhost, select a keyspace
    c = Cassandra.new('Keyspace1')

    # Insert one column into a row 
    # in the column family
    c.insert(
      :Standard1, 
      'akk', 
      {'data' => JSON.dump(:age => 31)}
    )

    # Fetch a specific row and column 
    # from the column family
    c.get(
      :Standard1, 
      'akk', 
      'data'
    )

<!SLIDE>

