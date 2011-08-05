connect localhost/9160;

create keyspace ImportantStuff;
use ImportantStuff;

create column family Users;
create column family Stuff with comparator = UTF8Type
  and column_metadata=[{column_name: things, validation_class: UTF8Type}];

drop column family Users;
drop column family Stuff;
