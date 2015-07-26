package Devel::Caller::Util;

# DATE
# VERSION

use 5.010001;
use warnings;
use strict;

use Exporter qw(import);
our @EXPORT_OK = qw(callers);

sub callers {
    my $start = shift // 0;

    my @res;
    my $i = $start;
    while (my @caller = caller($i)) {
        push @res, \@caller;
        $i++;
    }

    @res;
}

1;
# ABSTRACT: caller()-related utility routines

=head1 SYNOPSIS

 use Devel::Util::Caller qw(callers);

 my @callers = callers();


=head1 SEE ALSO

=cut
