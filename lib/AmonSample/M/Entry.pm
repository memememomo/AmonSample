package AmonSample::M::Entry;
use strict;
use warnings;
use Smart::Args;


sub recent {
    args my $class,
        my $rows_per_page => {default => 20, isa => 'Int'},
        my $current_page => {isa => 'Int'},
        my $c,
            ;

    my @entries = $c->db->search(
        entries => {}, {
            limit => $rows_per_page + 1,
            offset => $rows_per_page*($current_page-1),
            order_by => {id => 'DESC'},
    });
    my $has_next = ($rows_per_page+1 == @entries);
    if ($has_next) { pop @entries }

    return (\@entries, $has_next);
}

1;
