#
#     Test script for DateTime::Format::Roman
#     Copyright (C) 2003, 2004, 2018 Eugene Pjill and Jean Forget
#
#     This program is distributed under the same terms as Perl 5.28.0:
#     GNU Public License version 1 or later and Perl Artistic License
#
#     You can find the text of the licenses in the F<LICENSE> file or at
#     L<http://www.perlfoundation.org/artistic_license_1_0>
#     and L<http://www.gnu.org/licenses/gpl-1.0.html>.
#
#     Here is the summary of GPL:
#
#     This program is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 1, or (at your option)
#     any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program; if not, write to the Free Software Foundation,
#     Inc., <http://www.fsf.org/>.
#
use strict;
BEGIN { $^W = 1 }

use Test::More tests => 13;
use DateTime;
use DateTime::Format::Roman;

my $f = DateTime::Format::Roman->new(pattern => ['%d', '%f', '%m', '%y']);

isa_ok($f, 'DateTime::Format::Roman' );

$" = ':';

     # date,           day,    fixed, month, year
for (['2003-03-01',      1, 'Kal',     3, 2003],
     ['2003-03-02',      6, 'Non',     3, 2003],
     ['2003-03-06',      2, 'Non',     3, 2003],
     ['2003-03-07',      1, 'Non',     3, 2003],
     ['2003-03-08',      8,  'Id',     3, 2003],
     ['2003-03-15',      1,  'Id',     3, 2003],
     ['2003-03-16',     17, 'Kal',     4, 2003],
     ['2003-03-31',      2, 'Kal',     4, 2003],
     ['2003-12-14',     19, 'Kal',     1, 2004],
     ['2000-02-23',      7, 'Kal',     3, 2000],
     ['2000-02-24', '6bis', 'Kal',     3, 2000],
     ['2000-02-25',      6, 'Kal',     3, 2000],
    ){
    my ($date, @r) = @$_;

    my ($y, $m, $d) = split /-/, $date;
    my $dt = DateTime->new( year => $y, month => $m, day => $d);

    my @f = $f->format_datetime( $dt );
    is( "@f", "@r", $date );
}
