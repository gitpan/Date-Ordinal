#-----------------------------------------------------------------------

=head1 NAME

Locale::US - two letter codes for state identification in the United States 
    and vice versa.

=head1 SYNOPSIS

    use Locale::US;
    
    $state   = code2state('AL');               # $state gets 'Alabama'
    $code    = state2code('Alabama');          # $code gets 'AL'
    
    @codes   = all_state_codes();
    $coder   = all_state_codes_ref();
    @names   = all_state_names();
    $namer   = all_state_names_ref();

    %code_hash  = all_code_hash();
    %state_hash = all_state_hash();
    
=cut

#-----------------------------------------------------------------------

package Locale::US;
#use strict;

#-----------------------------------------------------------------------

=head1 DESCRIPTION

The C<Locale::US> module provides access to the two-letter
codes for identifying states in the United States. You can either
access the codes via the L<conversion routines> (described below),
or with the two functions which return lists of all states codes or
all state names.

=cut

#-----------------------------------------------------------------------

require Exporter;
use Carp;

#-----------------------------------------------------------------------
#	Public Global Variables
#-----------------------------------------------------------------------
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
$VERSION   = '1.00';
@ISA       = qw(Exporter);
@EXPORT    = qw(code2state state2code
                all_state_codes all_state_names 
                all_state_codes_ref all_state_names_ref 
		all_code_hash all_state_hash);

#-----------------------------------------------------------------------
#	Non-Private Global Variables
#-----------------------------------------------------------------------
 %CODE     = ();
 %STATE    = ();

#=======================================================================

=head1 CONVERSION ROUTINES

There are two conversion routines: C<code2state()> and C<state2code()>.

=over 8

=item code2state()

This function takes a two letter state code and returns a string
which contains the name of the state identified. If the code is
not a valid state code, then C<undef> will be returned:

    $state = code2state('CA');

=item state2code()

This function takes a state name and returns the corresponding
two letter state code, if such exists.
If the argument could not be identified as a state name,
then C<undef> will be returned:

    $code = state2code('California');

The case of the state name is not important.
See the section L<KNOWN BUGS AND LIMITATIONS> below.

=back

=cut

#=======================================================================
sub code2state
{
    my $code = shift;


    return undef unless defined $code;
    $code = "\U$code";
    if (exists $STATE{$code})
    {
        return $STATE{$code};
    }
    else
    {
        #---------------------------------------------------------------
        # no such state code!
        #---------------------------------------------------------------
        return undef;
    }
}

sub state2code
{
    my $state = shift;


    return undef unless defined $state;
    $state = "\u\L$state";
    if (exists $CODE{$state})
    {
        return $CODE{$state};
    }
    else
    {
        #---------------------------------------------------------------
        # no such state!
        #---------------------------------------------------------------
        return undef;
    }
}

#=======================================================================

=head1 QUERY ROUTINES

There are two function which can be used to obtain a list of all codes,
or all state names:

=over 8

=item C<all_state_codes()>

Returns a list of all two-letter state codes.
The codes are guaranteed to be all lower-case,
and not in any particular order.

=item C<all_state_names()>

Returns a list of all state names for which there is a corresponding
two-letter state code. The names are capitalised, and not returned
in any particular order.

=item C<all_code_hash()>

Returns a hash of all states names keyed by two-letter state code.

=item C<all_state_hash()>

Returns a hash of all codes names keyed by state name.

=back

=cut

#=======================================================================
sub all_state_codes
{
    return keys %STATE;
}

sub all_state_codes_ref
{
    return [ keys %STATE ] ;
}

sub all_state_names
{
    return values %STATE;
}

sub all_state_names_ref
{
    return [ &all_state_names() ];
}


sub all_code_hash
{
    return %CODE;
}

sub all_state_hash
{
    return %STATE;
}



#-----------------------------------------------------------------------

=head1 EXAMPLES

The following example illustrates use of the C<code2state()> function.
The user is prompted for a state code, and then told the corresponding
country name:

    $| = 1;   # turn off buffering
    
    print "Enter state code: ";
    chop($code = <STDIN>);
    $state = code2state($code);
    if (defined $state)
    {
        print "$code = $state\n";
    }
    else
    {
        print "'$code' is not a valid state code!\n";
    }


=head1 KNOWN BUGS AND LIMITATIONS

=over 4

=item *

When using C<state2code()>, the country name must currently appear
exactly as it does in the source of the module. For example,

    state2code('Alabama')

will return B<AL>, as expected. But the following will all return C<undef>:

    state2code('Alabama ')
    state2code(' Alabama')


If there's need for it, a future version could have variants
for state names.

=item *

In the current implementation, all data is read in when the
module is loaded, and then held in memory.
A lazy implementation would be more memory friendly.

=back

=head1 SEE ALSO

=over 4

=item Locale::Country


=item http://www.usps.gov/ncsc/lookups/usps_abbreviations.htm

Online file with the USPS two-letter codes for the United States
and its possessions.

=back

=head1 AUXILLIARY CODE:

=over 4

=item lynx -dump http://www.usps.gov/ncsc/lookups/usps_abbreviations.htm > kruft.txt

=item kruft2codes.pl

=back


=head1 AUTHOR

Terrence Brannon E<lt>tbrannon@end70.comE<gt>

=head1 COPYRIGHT

Copyright (c) 1999 End70 Corporation

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

#-----------------------------------------------------------------------

#=======================================================================
# initialisation code - stuff the DATA into the CODES hash
#=======================================================================
{
    my $code;
    my $state;


    while (<DATA>)
    {
        next unless /\S/;
        chop;
        ($code, $state)     = split(/:/, $_, 2);
	$code               = "\U$code";
	my @tmp=();
	for (split '\s', $state) {
	    push @tmp, "\u\L$_";
	}
	$state = join ' ', @tmp;
#        print "CODE{$state}       = $code\n";
        $CODE{$state}       = $code;
#        print "STATE{$code}       = $state\n";
        $STATE{$code}       = $state;
    }
}

1;

__DATA__
AL:ALABAMA
AK:ALASKA
AS:AMERICAN SAMOA
AZ:ARIZONA
AR:ARKANSAS
CA:CALIFORNIA
CO:COLORADO
CT:CONNECTICUT
DE:DELAWARE
DC:DISTRICT OF COLUMBIA
FM:FEDERATED STATES OF MICRONESIA
FL:FLORIDA
GA:GEORGIA
GU:GUAM
HI:HAWAII
ID:IDAHO
IL:ILLINOIS
IN:INDIANA
IA:IOWA
KS:KANSAS
KY:KENTUCKY
LA:LOUISIANA
ME:MAINE
MH:MARSHALL ISLANDS
MD:MARYLAND
MA:MASSACHUSETTS
MI:MICHIGAN
MN:MINNESOTA
MS:MISSISSIPPI
MO:MISSOURI
MT:MONTANA
NE:NEBRASKA
NV:NEVADA
NH:NEW HAMPSHIRE
NJ:NEW JERSEY
NM:NEW MEXICO
NY:NEW YORK
NC:NORTH CAROLINA
ND:NORTH DAKOTA
MP:NORTHERN MARIANA ISLANDS
OH:OHIO
OK:OKLAHOMA
OR:OREGON
PW:PALAU
PA:PENNSYLVANIA
PR:PUERTO RICO
RI:RHODE ISLAND
SC:SOUTH CAROLINA
SD:SOUTH DAKOTA
TN:TENNESSEE
TX:TEXAS
UT:UTAH
VT:VERMONT
VI:VIRGIN ISLANDS
VA:VIRGINIA
WA:WASHINGTON
WV:WEST VIRGINIA
WI:WISCONSIN
WY:WYOMING
