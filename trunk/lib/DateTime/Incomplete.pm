package DateTime::Incomplete;

use strict;
use vars qw($VERSION);
$VERSION = '0.00_02';


1;

__END__

=head1 NAME

DateTime::Incomplete - The partial date & time thing


=head1 SYNOPSIS

  my $dti = DateTime::Incomplete->new( year => 2003 );
  # 2003-xx-xx
  $dti->set( month => 12 );
  # 2003-12-xx
  $dt = $dti->to_datetime( base => DateTime->now );
  # 2003-12-19T16:54:33


=head1 DESCRIPTION

DateTime::Incomplete is a class for representing partial
date and times.

Such values are generated by expressions like '10:30',
'2003', and 'dec-14'.


=head1 DATETIME-LIKE METHODS

=over 4

=item * new()

Creates a new incomplete date:

  my $dtc1 = DateTime::Incomplete->new( year => 2003 );
  # 2003-xx-xx

This class method accepts parameters for each date and
time component: "year", "month", "day", "hour",
"minute", "second", "nanosecond".  Additionally, it
accepts a "time_zone" parameter.

Note: There is no "language" parameter.

C<new> without parameters creates a completely undefined datetime:

  my $dtc1 = DateTime::Incomplete->new();

The parameters can be explicitly undefined:

  my $dtc1 = DateTime::Incomplete->new( year => 2003, day => undef );


=item * set

Use this to define or undefine a datetime field:

  $dti->set( month => 12 );
  $dti->set( day => 24 );
  $dti->set( day => undef );

=item * set_time_zone

This method accepts either a time zone object or a string that can be
passed as the "name" parameter to C<< DateTime::TimeZone->new() >>.

Incomplete dates don't know the "local time" concept:
If the new time zone's offset is different from the old time zone,
no local time adjust is made.


=item * clone

Creates a new object with the same datetime.


=item * datetime

Stringify the datetime, just like DateTime::datetime().

Undefined fields are replaced by 'xx' or 'xxxx'.


=item * year, month, day, hour, minute, second, nanosecond

Return the field value, or C<undef>.

=item * time_zone

This returns the C<DateTime::TimeZone> object for the datetime object,
or C<undef>.

=back

=head1 DATETIME::INCOMPLETE METHODS

=over 4

=item * is_undef

Returns true if the datetime is completely undefined.

=item * to_datetime

  $dt = $dti->to_datetime( base => DateTime->now );

Returns a "complete" datetime.

The resulting datetime is in the same Calendar as C<base>. 

The following example creates a Julian Calendar date, within
year 1534:

  $dtj = DateTime::Calendar::Julian->new( ... );
  $dti = DateTime::Incomplete->new( year => 1534 );
  $dtj2 = $dti->to_datetime( base => $dtj );
 
The resulting datetime can be either before of after the
C<base> datetime. No adjustments are made, besides setting
the missing fields.

This method may C<die> if it results in a datetime that
doesn't exist.


=item * to_recurrence

  $dti = DateTime::Incomplete->new( month => 12, day => 24 );
  $dtset= $dti->to_recurrence;   # Christmas day recurrence

This method uses some magic to find out a proper recurrence
frequency, and then calls DateTime::Event::Recurrence to generate
a recurrence set.

The recurrences are DateTime::Set objects:

  $dt_next_xmas = $dti->to_recurrence->next( DateTime->today );

Note: DateTime::Event::Recurrence has only been tested with
Gregorian dates so far.


=item * contains

  $bool = $dti->contains( $dt );

Returns a true value if the incomplete datetime range 
I<contains> a given datetime value.

For example:

  2003-xx-xx contains 2003-12-24
  2003-xx-xx does not contain 1999-12-14

=back

=head1 TODO - "MAY-BE-USEFUL" METHODS

These are some ideas for methods, that are not implemented.
Let us know if any of these might be useful for you,
at <datetime@perl.org>.

=over 4

=item * add_datetime

Just like to_datetime, but adds the field values.

=item * compare

or is that simply not defined?

=item * to_spanset

=item * to_span

=item * other C<DateTime> methods

=item * other C<DateTime::Set> methods (next/previous/...)

Those can be implemented using a cached to_recurrence()

=item * set_week

$dti->set( week => 10 )


=back


=head1 AUTHORS

Flavio S. Glock <fglock[at]cpan.org>

With Ben Bennett <fiji[at]ayup.limey.net>, 
Eugene Van Der Pijll <pijll[at]gmx.net>,
and the DateTime team.

=head1 COPYRIGHT

Copyright (c) 2003 Flavio S. Glock.  All rights reserved.
This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE
file included with this module.

=head1 SEE ALSO

datetime@perl.org mailing list

http://datetime.perl.org/

=cut

