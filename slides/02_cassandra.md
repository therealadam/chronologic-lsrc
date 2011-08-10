<!SLIDE title center>
# Six Easy Pieces on Cassandra #

### With apologies to Dr. Richard Feynman

<!SLIDE bullets incremental>

* Like SQL with beer goggles
* Keys and blobs (events)
* Keys and columns (objects)
* Simple graphs (subscribers)
* Timeline indexes (timelines)
* Secondary indexes (comfort food)

<!SLIDE center>

# SQL with beer goggles


<!SLIDE code>

    @@@ sql
    create keyspace ImportantStuff;
    use ImportantStuff;

<!SLIDE code>

    @@@ sql
    create column family Users;
    create column family Stuff 
      with comparator = UTF8Type
      and column_metadata=[
        {column_name: things, 
         validation_class: UTF8Type}
      ];

<!SLIDE code>

    @@@ sql
    drop column family Users;
    drop column family Stuff;

<!SLIDE code>

    @@@ sql
    drop keyspace ImportantStuff;

<!SLIDE center>

# Keys and Blobs

<!SLIDE code>

    @@@ ruby
    require 'cassandra'
    require 'yajl'

    c = Cassandra.new('lsrc')

<!SLIDE code>

    @@@ ruby
    data = {
      'username' => 'akk',
      'age' => '31'
    }
    c.insert(
      :example, 
      'akk', 
      {'data' => Yajl.dump(data)}
    )

<!SLIDE code>

    @@@ ruby
    p c.get(:example, 'akk')
    #     #<OrderedHash {"data"=>"{\"username\":\"akk\",\"age\":\"31\"}"}
    #     {"data"=>1312742715985471}>

    c.remove(:example, 'akk')

<!SLIDE center>

# Keys and columns

<!SLIDE code>

    @@@ ruby
    columns = {
      'username' => 'ak',
      'age' => '31'
    }

    c.insert(:example, 'akk', columns)

<!SLIDE code>

    @@@ ruby
    p c.get(:example, 'akk')
    # <OrderedHash {"username"=>"ak", "age"=>"31"}
    # {"username"=>1312743932840327, "age"=>1312743932840327}>

    c.remove(:example, 'akk')

<!SLIDE center>

# Graphs!!!!

<!SLIDE code>

    @@@ ruby
    akk_graph = {
      # RS follows AK and AK is friends with RS
      'user_rs_feed' => 'user_rs',
      # BF follows AK and AK is friends with BF
      'user_bf_feed' => 'user_bf',       
      # AM follows AK and AK is friends with AM
      'user_am_feed' => 'user_am',       
      # MT follows AK, but AK doesn't reciprocate
      'user_mt_feed' => '' 
    }

    c.insert(:example, 'akk/graph', akk_graph)

<!SLIDE code>

    @@@ ruby
    graph = c.get(:example, 'akk/graph')

    followers = graph.keys

    friends = graph.values.reject {|u| u.empty?}

    c.remove(:example, 'akk/graph')

<!SLIDE center>

# Indexes (!)


<!SLIDE code>

    @@@ ruby
    5.times do |i|
      key = "event_#{i}"

      event = {
        'message' => "This is event #{i}"
      }
      c.insert(:example, key, event)

      c.insert(
        :example, 
        'akk/feed', 
        {i.to_s, key}
      )
    end

<!SLIDE code>

    @@@ ruby
    timeline = c.get(:example, 'akk/feed')
    # #<OrderedHash {"0"=>"event_0", 
    #    "1"=>"event_1", "2"=>"event_2", 
    #    "3"=>"event_3", "4"=>"event_4"}

    multi_events = c.multi_get(
      :example, 
      timeline.values
    )
    # {
    #   "event_0" => {"message => "This is event 0"},
    #   "event_1" => {"message => "This is event 1"},
    #   "event_2" => {"message => "This is event 2"},
    #   # etc.
    # }

<!SLIDE code>

    @@@ ruby
    # {
    #   "event_0" => {"message => "This is event 0"},
    #   "event_1" => {"message => "This is event 1"},
    #   "event_2" => {"message => "This is event 2"},
    #   # etc.
    # }
    events = multi_events.values

    multi_events.keys.each { |k| 
      c.remove(:example, k)
    }
    c.remove(:example, 'akk/feed')

<!SLIDE center>

# Secondary indexes


<!SLIDE code>

    @@@ sql
    create column family Users with
      comparator=UTF8Type and
      column_metadata=[
        {column_name: username, 
         validation_class: UTF8Type, 
         index_type: KEYS},
        {column_name: age, 
         validation_class: UTF8Type, 
         index_types: KEYS},
        {column_name: bio, 
         validation_class: UTF8Type},
        {column_name: admin, 
         validation_class: UTF8Type];

<!SLIDE code>

    @@@ sql
    set Users['ak']['username'] = 'therealadam';
    set Users['ak']['age'] = '31';
    set Users['ak']['bio'] = 'Telling a joke.';
    set Users['ak']['admin'] = 'true';

<!SLIDE code>

    @@@ sql
    set Users['mt']['username'] = 'mattt';
    set Users['mt']['age'] = '21';
    set Users['mt']['bio'] = 
      'Contemplating the nature of language.';
    set Users['mt']['admin'] = 'true';

<!SLIDE code>

    @@@ sql
    set Users['wn']['username'] = 'pengwynn';
    set Users['wn']['age'] = '73';
    set Users['wn']['bio'] = 'Hosting a podcast';
    set Users['wn']['admin'] = 'false';

<!SLIDE code>

    @@@ sql
    get Users where admin='true' and age > '18';

