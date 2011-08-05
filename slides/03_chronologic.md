# Chronologic

A service for storing event data, related objects, social graphs, and assembling it into activity feeds.

# ORLY

- People generate events (statuses, checkins, photos, TPS reports, etc.)
- Events refer to other objects (users, locations, photos, documents,
  etc.)
- People connect with other people (follow, friend, manage, report to,
  etc.)
- People want to know what other people are up to (status feed, checkin
  feed, photo feed, etc.)

# Enter Chronologic

- Applications "record" referred objects (users, spots, etc.)
- Applications "subscribe" timelines to other timelines (follow, friend,
  etc.)
- Applications "publish" events to timelines (checkin -> user, spot)
- Chronologic saves the events and writes them to all the timelines that
  subscribe to that timeline 
- Applications "fetch" a timeline and get back a fully-materialized list
  of events, subevents, and objects that in one request
- Chronologic does this by replicating objects that are referred to by
  events and doing a fan-out write of all events to the relevant timelines

# Nitty gritty

- Applications talk to a REST/JSON API
- Chronologic is an HTTP service implemented in Sinatra
- Chronologic talks to a Cassandra cluster via Thrift

# Internals

- `Objects` stores replicated data as key/blob pairs, though this may
  change to leverage secondary indexes
- `Subscriptions` maps timelines that are consumed as feeds to timelines
  that are written to by events. It also includes a backlink to do basic
  privacy checks. The storage structure maps subscriber keys to consumer
  timeline/user key pairs.
- `Events` stores all events as key/column structures. Each event stores
  blobs for event attributes, timelines, and referenced objects. A
  timestamp is also stored and used to generate index keys.
- `Timelines` are indexes that map a feed to a series of events. Each
  key represents one timeline; the column name/value pairs map sortable
  timestamps (as stored in the event) to a key into the `Events` CF.
- When an event is published, it is immediately stored in `Events`. Each
  timeline it specifies is then updated with an index entry pointing to
  the new event. Any subscribers to the updated timelines are then
  themselves updated.
- When a timeline is requested, a batch of columns are fetched from
  `Timelines` and then each event referenced by those columns is fetched
  from `Event`.
- Events sometimes have subevents (e.g. a comment on a checkin). In this
  case, `Timelines` is read again to find events on the timeline for the
  event with subevents.

# The API

- `record`: `POST /objects`
- `unrecord`: `DELETE /objects`
- `subscribe`: `POST /subscriptions`
- `unsubscribe`: `DELETE /subscriptions`
- `publish`: `POST /events`
- `unpublish`: `DELETE /events`
- (Miscellaneous bits)
