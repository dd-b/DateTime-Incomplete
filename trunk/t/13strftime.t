#!/usr/bin/perl -w

# test suite stolen shamelessly from TimeDate distro

# re-stolen from DateTime

BEGIN
{
    return unless $] >= 5.006;

    require utf8; import utf8;
}

use strict;

use Test::More tests => 126;

use DateTime::Incomplete;
use DateTime;

my $DateTime = 'DateTime::Incomplete';
my $locale = 'en_US';
my $dt;
my $params;

while (<DATA>)
{
    chomp;
    if (/^year =>/)
    {
        $params = $_;
        eval "use DateTime::Locale::en_US";

        $dt = eval "$DateTime->new( $params, time_zone => 'UTC' )";
        next;
    }
    elsif (/^(\w+)/)
    {
        $locale = $1;
        eval "use DateTime::Locale::$1";
        die $@ if $@;

        Test::More::diag("New locale: $locale\n");

        $dt = eval "$DateTime->new( $params, time_zone => 'UTC', locale => '$locale' )";
        next;
    }

    my ($fmt, $res) = split /\t/, $_;

    my $broken = 'marted' . chr(195);
    if ( $fmt eq '%A' && $locale eq 'it' && $] >= 5.006 && $] <= 5.008 )
    {
        ok( 1, "Perl 5.6.0 & 5.6.1 cannot handle Unicode characters in the DATA filehandle properly" );
        next;
    }

    is( $dt->strftime($fmt), $res, "$fmt" );
}

# test use of strftime with multiple params - in list and scalar
# context
{
    my $dt = $DateTime->new( year => 1800,
                            month => 1,
                            day => 10,
                            time_zone => 'UTC',
                          );

    my ($y, $d) = $dt->strftime( '%Y', '%d' );
    is( $y, 1800, 'first value is year' );
    is( $d, 10, 'second value is day' );

    $y = $dt->strftime( '%Y', '%d' );
    is( $y, 1800, 'scalar context returns year' );
}

{
    my $dt = $DateTime->new( year => 2003,
                            hour => 0,
                            minute => 0
                          ) ;

    is( $dt->strftime('%I %M %p'), '12 00 AM', 'formatting of hours as 1-12' );
    is( $dt->strftime('%l %M %p'), '12 00 AM', 'formatting of hours as 1-12' );

    $dt->set(hour => 1) ;
    is( $dt->strftime('%I %M %p'), '01 00 AM', 'formatting of hours as 1-12' );
    is( $dt->strftime('%l %M %p'), ' 1 00 AM', 'formatting of hours as 1-12' );

    $dt->set(hour => 11) ;
    is( $dt->strftime('%I %M %p'), '11 00 AM', 'formatting of hours as 1-12' );
    is( $dt->strftime('%l %M %p'), '11 00 AM', 'formatting of hours as 1-12' );

    $dt->set(hour => 12) ;
    is( $dt->strftime('%I %M %p'), '12 00 PM', 'formatting of hours as 1-12' );
    is( $dt->strftime('%l %M %p'), '12 00 PM', 'formatting of hours as 1-12' );

    $dt->set(hour => 13) ;
    is( $dt->strftime('%I %M %p'), '01 00 PM', 'formatting of hours as 1-12' );
    is( $dt->strftime('%l %M %p'), ' 1 00 PM', 'formatting of hours as 1-12' );

    $dt->set(hour => 23) ;
    is( $dt->strftime('%I %M %p'), '11 00 PM', 'formatting of hours as 1-12' );
    is( $dt->strftime('%l %M %p'), '11 00 PM', 'formatting of hours as 1-12' );

    $dt->set(hour => 0) ;
    is( $dt->strftime('%I %M %p'), '12 00 AM', 'formatting of hours as 1-12' );
    is( $dt->strftime('%l %M %p'), '12 00 AM', 'formatting of hours as 1-12' );
}


# add these if we do roman-numeral stuff
# %Od	VII
# %Oe	VII
# %OH	XIII
# %OI	I
# %Oj	CCL
# %Ok	XIII
# %Ol	I
# %Om	IX
# %OM	II
# %Oq	III
# %OY	MCMXCIX
# %Oy	XCIX

__DATA__
year => 1999, month => 9, day => 7, hour => 13, minute => 2, second => 42, nanosecond => 123456789.123456
%y	99
%Y	1999
%%	%
%a	Tue
%A	Tuesday
%b	Sep
%B	September
%C	19
%d	07
%e	 7
%D	09/07/99
%h	Sep
%H	13
%I	01
%j	250
%k	13
%l	 1
%m	09
%M	02
%N	123456789
%3N	123
%6N	123456
%10N	1234567891
%p	PM
%r	01:02:42 PM
%R	13:02
%s	936709362
%S	42
%T	13:02:42
%U	36
%w	2
%W	36
%y	99
%Y	1999
%Z	UTC
%z	+0000
%{month}	9
%{year}	1999
%x	Sep 7, 1999
%X	1:02:42 PM
%c	Sep 7, 1999 1:02:42 PM
de
%y	99
%Y	1999
%%	%
%a	Di
%A	Dienstag
%b	Sep
%B	September
%C	19
%d	07
%e	 7
%D	09/07/99
%h	Sep
%H	13
%I	01
%j	250
%k	13
%l	 1
%m	09
%M	02
%p	nachm.
%r	01:02:42 nachm.
%R	13:02
%s	936709362
%S	42
%T	13:02:42
%U	36
%w	2
%W	36
%y	99
%Y	1999
%Z	UTC
%z	+0000
%{month}	9
%{year}	1999
it
%y	99
%Y	1999
%%	%
%a	mar
%A	martedì
%b	set
%B	settembre
%C	19
%d	07
%e	 7
%D	09/07/99
%h	set
%H	13
%I	01
%j	250
%k	13
%l	 1
%m	09
%M	02
%p	p.
%r	01:02:42 p.
%R	13:02
%s	936709362
%S	42
%T	13:02:42
%U	36
%w	2
%W	36
%y	99
%Y	1999
%Z	UTC
%z	+0000
%{month}	9
%{year}	1999
