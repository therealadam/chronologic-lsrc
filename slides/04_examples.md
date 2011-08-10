<!SLIDE center>

# Hello, Chronologic

<!SLIDE code>

    @@@ ruby
    connection = Chronologic::Client::Connection.new(
      'http://localhost:9292'
    )

<!SLIDE code>

    @@@ ruby
    event = Chronologic::Event.new
    event.key = "story_1"
    event.timestamp = Time.now.utc
    event.data = {
      "headline" => "First ever post in Chronologic!",
      "lede" => "A monumental occasion for housecats everywhere.",
      "body" => "There is currently a cat perched on my arm. This is normal, carry on!"
    }
    event.timelines = ['home']

    connection.publish(event)

<!SLIDE code>

    @@@ ruby
    feed = connection.timeline('home')

    puts "We found #{feed['count']} events."
    puts "That event looks just like this:"
    pp feed['items'].first

<!SLIDE center>

# Event fanout

<!SLIDE code>

    @@@ ruby
    connection.subscribe("tech", "home")

<!SLIDE code>

    @@@ ruby
    event = Chronologic::Event.new
    event.key = "story_1"
    event.timestamp = Time.now.utc
    event.data = {
      "headline" => "First ever post in Chronologic!",
      "lede" => "A monumental occasion for housecats everywhere.",
      "body" => "There is currently a cat perched on my arm. This is normal, carry on!"
    }
    event.timelines = ["tech"]

<!SLIDE code>

    @@@ ruby
    connection.publish(event)

    feed = connection.timeline("home")

    puts "Home has #{feed['count']} events."
    pp feed['items'].first

<!SLIDE center>

# Events beget subevents

<!SLIDE code>

    @@@ ruby
    event = Chronologic::Event.new
    event.key = "story_1"
    event.timestamp = Time.now
    event.data = {
      "headline" => "First ever post in Chronologic!",
      "lede" => "A monumental occasion for housecats everywhere.",
      "body" => "There is currently a cat perched on my arm. This is normal, carry on!"
    }
    event.timelines = ["home"]

    connection.publish(event)

<!SLIDE code>

    @@@ ruby
    subevent = Chronologic::Event.new
    subevent.key = "comment_1"
    subevent.timestamp = Time.now
    subevent.data = {
      "message" => "LOL cats!"
    }
    subevent.parent = "story_1"
    subevent.timelines = ["story_1"]

    connection.publish(subevent)

<!SLIDE code>

    @@@ ruby
    feed = connection.timeline("home")

    pp feed['items'].first

<!SLIDE center>

# Events reference objects

<!SLIDE code>

    @@@ ruby
    connection.record(
      "author_1", 
      {"name" => "Adam"}
    )
    connection.record(
      "author_2", 
      {"name" => "Fred Derp"}
    )

<!SLIDE code>

    @@@ ruby
    event = Chronologic::Event.new
    event.key = "story_1"
    event.timestamp = Time.now
    event.data = {
      "headline" => "First ever post in Chronologic!",
      "lede" => "A monumental occasion for housecats everywhere.",
      "body" => "There is currently a cat perched on my arm. This is normal, carry on!"
    }
    event.objects = {"author" => ["author_1"]}
    event.timelines = ["home"]

    connection.publish(event)

<!SLIDE code>

    @@@ ruby
    subevent = Chronologic::Event.new
    subevent.key = "comment_1"
    subevent.timestamp = Time.now
    subevent.data = {
      "message" => "LOL cats!"
    }
    subevent.parent = "story_1"
    subevent.objects = {"author" => ["author_2"]}
    subevent.timelines = ["story_1"]

    connection.publish(subevent)

<!SLIDE code>

    @@@ ruby
    feed = connection.timeline("home")

    pp feed['items'].first

<!SLIDE center>

# A familiar social application

<!SLIDE code>

    @@@ ruby
    connection.record(
      "user:ak", 
      {"long_name" => "Adam Keys"}
    )
    connection.record(
      "user:rs", 
      {"long_name" => "Richard Schneeman"}
    )
    connection.record(
      "user:mt", 
      {"long_name" => "Mattt Thompson"}
    )
    connection.record(
      "user:am", 
      {"long_name" => "Adam Michaela"}
    )

    connection.record(
      "spot:lsrc", 
      {"name" => "Lone Star Ruby Conference"}
    )

<!SLIDE code>

    @@@ ruby
    connection.subscribe(
      "passport:ak", 
      "friends:rs"
    )
    connection.subscribe(
      "passport:ak", 
      "friends:am"
     )
    connection.subscribe(
      "passport:ak", 
      "friends:mt"
    )

<!SLIDE code>

    @@@ ruby
    event = Chronologic::Event.new
    event.key = "checkin:1"
    event.timestamp = Time.now
    event.data = {"message" => "I'm giving a talk!"}
    event.objects = {
      "user" => ["user:ak"], 
      "spots" => ["spot:lsrc"]
    }
    event.timelines = ["passport:ak"]

    connection.publish(event)

<!SLIDE code>

    @@@ ruby
    subevent = Chronologic::Event.new
    subevent.key = "comment:1"
    subevent.timestamp = Time.now
    subevent.data = {"message" => "Me too!"}
    subevent.parent = "checkin:1"
    subevent.objects = {"user" => ["user:rs"]}
    subevent.timelines = ["checkin:1"]

    connection.publish(subevent)

<!SLIDE code>

    @@@ ruby
    feed = connection.timeline("friends:rs")
    pp feed['items'].first

    feed = connection.timeline("friends:am")
    pp feed['items'].first

    feed = connection.timeline("friends:mt")
    pp feed['items'].first

