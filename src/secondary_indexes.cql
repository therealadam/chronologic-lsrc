connect localhost/9160;
use Keyspace1;

create column family Users with
  comparator=UTF8Type and
  column_metadata=[
    {column_name: username, validation_class: UTF8Type, index_type: KEYS},
    {column_name: age, validation_class: UTF8Type, index_types: KEYS},
    {column_name: bio, validation_class: UTF8Type},
    {column_name: admin, validation_class: UTF8Type];

set Users['ak']['username'] = 'therealadam';
set Users['ak']['age'] = '31';
set Users['ak']['bio'] = 'Telling a joke.';
set Users['ak']['admin'] = 'true';

set Users['mt']['username'] = 'mattt';
set Users['mt']['age'] = '21';
set Users['mt']['bio'] = 'Contemplating the nature of language.';
set Users['mt']['admin'] = 'true';

set Users['wn']['username'] = 'pengwynn';
set Users['wn']['age'] = '73';
set Users['wn']['bio'] = 'Hosting a podcast';
set Users['wn']['admin'] = 'false';

get Users where admin='true' and age > '18';

drop column family Users;
