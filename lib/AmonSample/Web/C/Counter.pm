package AmonSample::Web::C::Counter;
use strict;
use warnings;
use Carp;
use Fcntl ':flock', ':seek';


sub index {
    my ($self, $c) = @_;
    my $count = counter_increment('test');
    my $is_round_number = $count =~ /^10+$/ ? 1 : 0;
    my $next_round_number = 10 ** int(log($count) / log(10)).0;
    $c->render(
        'counter.tx',
        {
            count => $count,
            is_round_number => $is_round_number,
            next_round_number => $next_round_number,
        }
    );
}


sub counter_increment {
    my ($fname) = @_;
    croak "ファイル名の指定がありません" unless $fname;
    $fname = Amon2::Util::base_dir('').'/data/'.$fname;
    my $mode = (-f $fname) ? '+<' : '+>';
    open my $fh, $mode, $fname or die "Fh$fname を開けません: $!";
    flock $fh, LOCK_EX;
    my $cnt = <$fh>;
    $cnt++;
    seek $fh, 0, SEEK_SET;
    print $fh $cnt or die "$fname にかきこめません: $!";
    flock $fh, LOCK_UN;
    close $fh or die "$fname を閉じることができません: $!";

    return $cnt;
}
1;
