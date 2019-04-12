package Devel::Caller::Util;

# DATE
# VERSION

use warnings;
use strict;

use Exporter qw(import);
our @EXPORT_OK = qw(caller callers);

my $_is_caller;

sub callers {
    my ($start, $with_args, $packages_to_ignore, $subroutines_to_ignore) = @_;
    $start = 0 unless defined $start;

    my @res;
    my $i = $start+1;

    while (1) {
        my @caller;
        if ($with_args) {
            {
                package # hide from PAUSE
                    DB;
                @caller = caller($i);
                $caller[11] = [@DB::args] if @caller;
            }
        } else {
            @caller = caller($i);
        }
        last unless @caller;
        $i++;

        if ($packages_to_ignore) {
            if (ref $packages_to_ignore eq 'ARRAY') {
                next if grep { $_ eq $caller[0] } @$packages_to_ignore;
            } else {
                next if $caller[0] =~ $packages_to_ignore;
            }
        }

        if ($subroutines_to_ignore) {
            if (ref $subroutines_to_ignore eq 'ARRAY') {
                next if grep { $_ eq $caller[3] } @$subroutines_to_ignore;
            } else {
                next if $caller[3] =~ $subroutines_to_ignore;
            }
        }

        do { $_is_caller = 0; return @caller } if $_is_caller;
        push @res, \@caller;
    }

    @res;
}

sub caller {
    $_is_caller = 1; # "local" doesn't work here
    goto &callers;
}

1;
# ABSTRACT: caller()-related utility routines

=head1 SYNOPSIS

 use Devel::Util::Caller qw(caller callers);

 my @info = caller(3);

 my @callers = callers();


=head1 FUNCTIONS

=head2 caller

Usage:

 caller([ $offset [, $with_args [, $packages_to_ignore [, $subroutines_to_ignore ] ] ] ]) => LIST

Just like the built-in C<caller()>, except with three additional optional
arguments. Will return this list:

     #  0          1           2       3             4          5            6           7             8        9          10
     ($package1, $filename1, $line1, $subroutine1, $hasargs1, $wantarray1, $evaltext1, $is_require1, $hints1, $bitmask1, $hinthash1)

If C<$with_args> is true, will also return subroutine arguments in the 11th
element of the result, produced by retrieving C<@DB::args>.

C<$packages_to_ignore> can be set to a regex (will be matched against
C<$packageI>) or an arrayref of package names.

Similarly, C<$subroutines_to_ignore> can be set to a regex or an arrayref of
subroutine names. Note that subroutine names are B<fully qualified names>.

=head2 callers([ $start=0 [, $with_args [, $packages_to_ignore [, $subroutines_to_ignore ] ] ] ]) => LIST

A convenience function to return the whole callers stack, produced by calling
C<caller()> repeatedly from frame C<$start+1> until C<caller()> returns empty.
Result will be like:

 (
     #  0          1           2       3             4          5            6           7             8        9          10
     [$package1, $filename1, $line1, $subroutine1, $hasargs1, $wantarray1, $evaltext1, $is_require1, $hints1, $bitmask1, $hinthash1],
     [$package2, $filename2, $line2, ...],
     ...
 )

See L</caller> for more information about the three additional, optional
arguments.


=head1 SEE ALSO

=cut
