require 'cassandra'
c = Cassandra.new('lsrc')

# We're going to create five time-ordered events.
5.times do |i|

  # Generate a unique key for this event.
  key = "event_#{i}"

  # Store something somewhat interesting in each event.
  event = {
    'message' => "This is event #{i}"
  }

  # Create the event. Each event could appear in multiple timelines, so
  # we store one event per row.
  c.insert(:example, key, event)

  # Write an entry in the timeline index. Each event gets a column in
  # the index. The column names are a sortable value; in this case, just
  # the loop variable. The event's key is the value of the column.
  c.insert(:example, 'akk/feed', {i.to_s, key})
end

# Forming a timeline is a two-step process. First we read the timeline
# index. This gives us back a structure like so:
#
#    #<OrderedHash {"0"=>"event_0", "1"=>"event_1", "2"=>"event_2", "3"=>"event_3", "4"=>"event_4"}
#
# You can see the sortable value as the key and the event key as the
# value.
timeline = c.get(:example, 'akk/feed')

# Second, we fetch the actual events. We'll just grab the values out of
# the timeline index to give us the keys. We can use `multi_get` to
# fetch all the events in one RPC call. This gives us a somewhat
# convoluted structure that more or less looks like this:
#
#     {
#       "event_0" => {"message => "This is event 0"},
#       "event_1" => {"message => "This is event 1"},
#       "event_2" => {"message => "This is event 2"},
#       # etc.
#     }
# So if we want just the event data, we'd grab the `values` on this hash.
# If we want the event keys, we grab the `keys` on the hash.
multi_events = c.multi_get(:example, timeline.values)

# This gives us an array of hashes as we constructed above in `event`.
events = multi_events.values

# Now we clean up each event and then wipe the whole timeline.
multi_events.keys.each { |k| c.remove(:example, k) }
c.remove(:example, 'akk/feed')

