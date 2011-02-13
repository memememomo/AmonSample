package AmonSample::Web::C::Session;
use strict;
use warnings;

sub index {
    my ($self, $c) = @_;

    my $session_id = $c->session->session_id();
    my $session_state_class = ref $c->session->state();
    my $session_store_class = ref $c->session->store();

    my $counter = $c->session->get('COUNTER') || 1;
    $c->session->set('COUNTER' => $counter+1);
    
    $c->render(
        'session.tx',
        {
            session_id => $session_id,
            session_state_class => $session_state_class,
            session_store_class => $session_store_class,
            counter => $counter,
        }
    );
}

1;
