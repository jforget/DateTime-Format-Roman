package DateTime::Format::Roman;

use strict;

use vars qw($VERSION);

$VERSION = 0.01;

use DateTime 0.12;

use Roman;
use Params::Validate qw/validate SCALAR ARRAYREF/;

sub new {
    my $class = shift;
    my %p = validate( @_,
                      { pattern => {type  => SCALAR | ARRAYREF }, 
                      } );

    $p{pattern} = [$p{pattern}] unless ref $p{pattern};

    my $self = bless \%p, $class;
	return $self;
}

my @fixed_days_names = (
    { Kal => 'Kal', Non => 'Non', Id => 'Id' },
    { Kal => 'K', Non => 'N', Id => 'Id' },
    { Kal => 'Kalends', Non => 'Nones', Id => 'Ides' },
);

my %dt_elem;
my %formats;
%formats =
    ( 'b' => sub { (shift->language->month_abbreviations)->[$dt_elem{month}-1] },
      'B' => sub { (shift->language->month_names)->[$dt_elem{month}-1] },
      'd' => sub { $dt_elem{day} },
      'D' => sub { ($dt_elem{day} ne 1 && $dt_elem{day}.' ') . $formats{f}->(@_) },
      'f' => sub { $fixed_days_names[$_[1]||0]{$dt_elem{fixed_day}} },
      'm' => sub { $dt_elem{month} },
      'y' => sub { $dt_elem{year} },
    );

sub format_datetime {
    my ($self, $dt) = @_;

    %dt_elem = DateTime::Format::Roman->date_elements($dt);

    my @return;
    for (@{$self->{pattern}}) {
        my $pat = $_;
        $pat =~ s/%([Oo]?)(\d*)([a-zA-Z])/
                    $formats{$3} ?
                        _romanize($formats{$3}->($dt, $2),$1)
                    : "$1$2$3" /ge;
        return $pat unless wantarray;
        push @return, $pat;
    }
    return @return;
}

sub _romanize {
    my ($str, $extra) = @_;
    if ($extra eq 'O') {
        $str =~ s/(\d+)(\w?)/Roman($1) . ($2?" $2":'')/ge;
    } elsif ($extra eq 'o') {
        $str =~ s/(\d+)(\w?)/roman($1) . ($2?" $2":'')/ge;
    }
    return $str;
}

sub date_elements {
    my ($self, $dt) = @_;

    my ($d, $m, $y) = ($dt->day, $dt->month, $dt->year);
    my $nones = _nones($m);
    my $ides = $nones + 8;

    my %retval;

    if ($d == 1) {
        @retval{'day', 'fixed_day'} = (1, 'Kal');
    } elsif ($d <= $nones) {
        @retval{'day', 'fixed_day'} = ($nones + 1 - $d, 'Non');
    } elsif ($d <= $ides) {
        @retval{'day', 'fixed_day'} = ($ides + 1 - $d, 'Id');
    } else {
        my $days_in_month = (ref $dt)->last_day_of_month(
                                        year => $y, month => $m )->day;
        my $day = $days_in_month + 2 - $d;

        # In leap years, 6 Kal March is doubled (24&25 Feb)
        if ($dt->is_leap_year && $m == 2) {
            if ($day > 7) {
                $day --;
            } elsif ($day == 7) {
                $day = '6bis';
            }
        }
        @retval{'day', 'fixed_day'} = ($day, 'Kal');
        $m++;
        if ($m > 12) {
            $m -= 12;
            $y++;
        }
    }

    @retval{'month', 'year'} = ($m, $y);
    return %retval;
}

sub _nones {
    my $m = shift;
    return 7 if $m == 3 or $m == 5 or $m == 7 or $m == 10;
    return 5;
}

1;
__END__

=head1 NAME

DateTime::Format::Roman - Roman day numbering for DateTime objects

=head1 SYNOPSIS

  use DateTime::Format::Roman;

  my $formatter = DateTime::Format::Roman->new(
                      pattern => '%d %f %b %y' );

  my $dt = DateTime->new( year => 2003, month => 5, day => 28 );

  $formatter->format_datetime($dt);
   # '5 Kal Jun 2003'

=head1 DESCRIPTION

TODO

=head1 METHODS

=over 4

=item * new( ... )

=item * format_datetime($datetime)

=head2 PATTERN SPECIFIERS

The following specifiers are allowed in the format strings given to the
new() method:

=over 4

=item * %b

The abbreviated month name.

=item * %B

The full month name.

=item * %d

The day of the month as a decimal number (including '1' for the fixed
days).

=item * %D

The day of the month, written as a number plus the corresponding fixed
day.

=item * %f

The 'fixed day' part of the date.

=item * %m

The month as a decimal number (range 1 to 12).

=item * %y

The year as a decimal number.

=back

If a specifier is preceded by 'O' or 'o', numbers will be written in
uppercase and lowercase Roman numerals, respectively.

=head1 SUPPORT

Support for this module is provided via the datetime@perl.org email
list. See http://lists.perl.org/ for more details.

Note that this is a beta release. The interface *will* change,
especially the format specifiers, and the way the "fixed days" are
returned.

=head1 AUTHOR

Eugene van der Pijll <pijll@gmx.net>

=head1 COPYRIGHT

Copyright (c) 2003 Eugene van der Pijll.  All rights reserved.  This
program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

L<DateTime>

datetime@perl.org mailing list

=cut
