package AmonSample::Web::C::Form;
use strict;
use warnings;

sub index {
    my ($class, $c) = @_;

    my $r = $c->req->param('r');

    $c->render(
        "form.tx", {
            r => $r,
        }
    );
}

1;
