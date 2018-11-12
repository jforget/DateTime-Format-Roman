#
#     Configuration script for DateTime::Format::Roman
#     Copyright (C) 2003, 2004, 2018 Eugene Pjill and Jean Forget
#
#     This program is distributed under the same terms as Perl 5.28.0:
#     GNU Public License version 1 or later and Perl Artistic License
#
#     You can find the text of the licenses in the F<LICENSE> file or at
#     L<http://www.perlfoundation.org/artistic_license_1_0>
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
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME         => 'DateTime::Format::Roman',
    VERSION_FROM => 'lib/DateTime/Format/Roman.pm',
    PREREQ_PM    => { DateTime => 0.12,
                      Roman    => 0,
                      Test::More => 0,
                       },
    AUTHOR       => 'Eugene van der Pijll (pijll@gmx.net)',
    ABSTRACT     => 'Roman day names (kalends, ides, nones) for DateTime objects',
);
