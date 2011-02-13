package AmonSample::Web::C::BBS;
use strict;
use warnings;
use AmonSample::M::Entry;

sub index {
    my ($self, $c) = @_;

    my $page = $c->req->param('page') || 1;
    $page =~ /^[0-9]+$/ or die "bad page number: $page";

    my ( $entries, $has_next ) = AmonSample::M::Entry->recent(
        current_page  => $page,
        rows_per_page => 5,
        c             => $c,
    );

    $c->render(
        'bbs.tx',
        {
            entries  => $entries,
            page     => $page,
            has_next => $has_next,
            prev_page => $page - 1,
            next_page => $page + 1,
        }
    );
}

sub post {
    my ($self, $c) = @_;

    my $title   = $c->req->param('title');
    my $message = $c->req->param('message');
    if ($message) {
        $c->db->insert(entries => {
            title   => $title,
            message => $message,
        });
    }

    $c->redirect('/bbs');
}

1;
