package AmonSample::Web::C::Mobile;
use strict;
use warnings;

sub index {
    my ($self, $c) = @_;
    $c->render(
        'mobile.tx',
        {
            mobile_agent => $c->mobile_agent()->carrier_longname,
        }
    );
}

1;
