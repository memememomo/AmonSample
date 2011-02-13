package AmonSample::DB::Schema;
use Teng::Schema::Declare;
table {
    name 'entries';
    pk 'id';
    columns qw/
        id
        title
        message
    /;
};

1;
