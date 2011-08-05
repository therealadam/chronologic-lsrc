connect localhost/9160;
use Keyspace1;

insert Standard1['akk_feed']['abc-123'] = 'event_1'
insert Standard1['akk_feed']['abc-456'] = 'event_2'
insert Standard1['akk_feed']['abc-789'] = 'event_3'
insert Standard1['akk_feed']['abc-abc'] = 'event_4'

get Standard1['akk_feed']
