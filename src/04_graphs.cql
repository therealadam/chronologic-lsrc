connect localhost/9160;
use Keyspace1;

insert Standard1['akk']['user_rs_feed'] = ['user_rs']
insert Standard1['akk']['user_bf_feed'] = ['user_bf']
insert Standard1['akk']['user_am_feed'] = ['user_am']
insert Standard1['akk']['user_mt_feed'] = ['']

get Standard1['akk']

