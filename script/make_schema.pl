use strict;
use warnings;
use DBI;
use FindBin;
use File::Spec;
use lib File::Spec->catdir($FindBin::Bin, '..', 'lib');
use lib File::Spec->catdir($FindBin::Bin, '..', 'extlib', 'lib', 'perl5');
use AmonSample;
use Teng::Schema::Dumper;

my $c = AmonSample->bootstrap;
my $conf = $c->config->{'Teng'};

my $dbh = DBI->connect($conf->{dsn}, $conf->{username}, $conf->{password}, $conf->{connect_options}) or die "Cannot connect to DB:: " . $DBI::errstr;
my $schema = Teng::Schema::Dumper->dump(dbh => $dbh, namespace => 'AmonSample::DB');

my $dest = File::Spec->catfile($FindBin::Bin, '..', 'lib', 'AmonSample', 'DB', 'Schema.pm');
open my $fh, '>', $dest or die "cannot open file '$dest': $!";
print {$fh} $schema;
close $fh;
