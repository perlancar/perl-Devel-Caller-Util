package Devel::Caller::Util;

# DATE
# VERSION

use 5.010001;
use warnings;
use strict;

use Exporter qw(import);
our @EXPORT_OK = qw(callers);

sub callers {
    my $start = $_[0] // 0;
    my $with_args = $_[1];

    my @res;
    my $i = $start+1;

    if ($with_args) {
        {
            package DB;
            while (my @caller = caller($i)) {
                $caller[11] = [@DB::args];
                push @res, \@caller;
                $i++;
            }
        }
    } else {
        while (my @caller = caller($i)) {
            push @res, \@caller;
            $i++;
        }
    }

    @res;
}

1;
# ABSTRACT: caller()-related utility routines

=head1 SYNOPSIS

 use Devel::Util::Caller qw(callers);

 my @callers = callers();


=head1 FUNCTIONS

=head2 callers([ $start=0 [, $with_args] ]) => LIST

A convenience function to return the whole callers stack, produced by calling
C<caller()> repeatedly from frame C<$start+1> until C<caller()> returns empty.
Result will be like:

 (
     #  0          1           2       3             4          5            6           7             8        9          10
     [$package1, $filename1, $line1, $subroutine1, $hasargs1, $wantarray1, $evaltext1, $is_require1, $hints1, $bitmask1, $hinthash1],
     [$package2, $filename2, $line2, ...],
     ...
 )

If C<$with_args> is true, will also return subroutine arguments in the 11th
element of each frame, produced by retrieving C<@DB::args>.


=head1 SEE ALSO

=cut
