#
#     Test script for DateTime::Format::Roman
#     Copyright (C) 2003, 2004, 2018, 2019, 2021 Eugene van der Pijll, Dave Rolsky and Jean Forget
#
#     This program is distributed under the same terms as Perl 5.28.0:
#     GNU Public License version 1 or later and Perl Artistic License
#
#     You can find the text of the licenses in the F<LICENSE> file or at
#     L<https://dev.perl.org/licenses/artistic.html>
#     and L<https://www.gnu.org/licenses/gpl-1.0.html>.
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
#     Inc., <https://www.fsf.org/>.
#
use strict;
BEGIN { $^W = 1 }

use Test::More tests => 4;
use DateTime;
use DateTime::Format::Roman;

for (['2003-03-01', 'I Kalends March MMIII'],
     ['2003-03-02', 'VI Nones March MMIII'],
     ['2003-03-08', 'VIII Ides March MMIII'],
     ['2000-02-24', 'VI bis Kalends March MM'],
    ){
    my ($date, $r) = @$_;

    my ($y, $m, $d) = split /-/, $date;
    my $dt = DateTime->new( year => $y, month => $m, day => $d);

    is( DateTime::Format::Roman->format_datetime( $dt ), $r, $date );;
}
