package AmonSample::Web;
use strict;
use warnings;
use parent qw/AmonSample Amon2::Web/;

# load all controller classes
use Module::Find ();
Module::Find::useall("AmonSample::Web::C");

# custom classes
use AmonSample::Web::Request;
use AmonSample::Web::Response;
sub create_request  { AmonSample::Web::Request->new($_[1]) }
sub create_response { shift; AmonSample::Web::Response->new(@_) }

use Amon2::Util;

# dispatcher
use AmonSample::Web::Dispatcher;
sub dispatch {
    return AmonSample::Web::Dispatcher->dispatch($_[0]) or die "response is not generated";
}

# setup view class
use Tiffany::Text::Xslate;
{
    my $view_conf = __PACKAGE__->config->{'Text::Xslate'} || die "missing configuration for Text::Xslate";
    my $view = Tiffany::Text::Xslate->new(+{
        'syntax'   => 'Kolon',
        'module'   => [ 'Text::Xslate::Bridge::TT2Like' ],
        'function' => {
            c => sub { Amon2->context() },
            uri_for  => sub { Amon2->context()->uri_for(@_) },
        },
        %$view_conf
    });
    sub create_view { $view }
}

use Amon2::Util;

# load plugins
__PACKAGE__->load_plugins('Web::FillInFormLite');
__PACKAGE__->load_plugins('Web::NoCache');
__PACKAGE__->load_plugins('Web::CSRFDefender');
__PACKAGE__->load_plugins('Web::MobileAgent');

use HTTP::Session::Store::File;
__PACKAGE__->load_plugins('Web::HTTPSession', {
    state => 'Cookie',
    store => sub {
        HTTP::Session::Store::File->new(
            dir => Amon2::Util::base_dir('').'/data/'
        );
    },
});

use AmonSample::DB;
sub db {
    my ($self) = @_;
    if (!defined $self->{db}) {
        my $conf = $self->config->{'Teng'} or die "missing configuration for 'Teng'";
        my $dbh = DBI->connect($conf->{dsn}, $conf->{username}, $conf->{password}, $conf->{connect_options}) or die "Cannot connect to DB:: " . $DBI::errstr;
        $self->{db} = AmonSample::DB->new({ dbh => $dbh });
    }
    return $self->{db};
}

# for your security
__PACKAGE__->add_trigger(
    AFTER_DISPATCH => sub {
        my ( $c, $res ) = @_;
        $res->header( 'X-Content-Type-Options' => 'nosniff' );
    },
);

1;
