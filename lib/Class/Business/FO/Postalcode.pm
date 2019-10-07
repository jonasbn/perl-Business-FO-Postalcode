package Class::Business::FO::Postalcode;

use strict;
use warnings;
use base qw(Class::Business::GL::Postalcode);
use 5.010; #5.10.0
use utf8;
use Data::Handle;

our $VERSION = '0.03';

use constant NUM_OF_DIGITS_IN_POSTALCODE => 3;

sub new {
    my $class = shift;

    my $self = bless ({}, $class);

    my $handle = Data::Handle->new( __PACKAGE__ );
    my @postal_data = $handle->getlines();

    $self->postal_data(\@postal_data);
    $self->num_of_digits_in_postalcode(NUM_OF_DIGITS_IN_POSTALCODE);

    return $self;
}

1;

=pod

=encoding UTF-8

=begin markdown

[![CPAN version](https://badge.fury.io/pl/Business-FO-Postalcode.svg)](http://badge.fury.io/pl/Business-FO-Postalcode)
[![Build Status](https://travis-ci.org/jonasbn/perl-Business-FO-Postalcode.svg?branch=master)](https://travis-ci.org/jonasbn/perl-Business-FO-Postalcode.svg)
[![Coverage Status](https://coveralls.io/repos/jonasbn/perl-Business-FO-Postalcode/badge.png)](https://coveralls.io/r/jonasbn/perl-Business-FO-Postalcode)

=end markdown

=head1 NAME

Class::Business::FO::Postalcode - OO interface to validation and listing of Faroe Islands postal codes

=head1 VERSION

This documentation describes version 0.03

=head1 SYNOPSIS

    # construction
    my $validator = Class::Business::FO::Postalcode->new();

    # basic validation of string
    if ($validator->validate($postalcode)) {
        print "We have a valid Faroe Islands postal code\n";
    } else {
        warn "Not a valid Faroe Islands postal code\n";
    }


    # All postal codes for use outside this module
    my @postalcodes = @{$validator->get_all_postalcodes()};


    foreach (@{postalcodes}) {
        printf
            'postal code: %s city: %s street/desc: %s company: %s province: %d country: %d', split /;/, $_, 6;
    }

=head1 FEATURES

=over

=item * Providing list of Faroe Islands postal codes and related area names

=item * Look up methods for Faroe Islands postal codes for web applications and the like

=back

=head1 DESCRIPTION

Please note that this class inherits from: L<https://metacpan.org/pod/Business::GL::Postalcode>,
so most of the functionality is implmented in the parent class.

This distribution is not the original resource for the included data, but simply
acts as a simple distribution for Perl use. The central source is monitored so this
distribution can contain the newest data. The monitor script (F<postdanmark.pl>) is
included in the distribution: L<https://metacpan.org/pod/Business::DK::Postalcode>.

The data are converted for inclusion in this module. You can use different extraction
subroutines depending on your needs:

=over

=item * L</get_all_data>, to retrieve all data, data description below in L</Data>.

=item * L</get_all_postalcodes>, to retrieve all postal codes

=item * L</get_all_cities>, to retieve all cities

=item * L</get_postalcode_from_city>, to retrieve one or more postal codes from a city name

=item * L</get_city_from_postalcode>, to retieve a city name from a postal code

=back

=head2 Data

Here follows a description of the included data, based on the description from
the original source and the authors interpretation of the data, including
details on the distribution of the data.

=head3 city name

A non-unique, case-sensitive representation of a city name in Faroese or Danish.

=head3 street/description

This field is unused for this dataset.

=head3 company name

This field is unused for this dataset.

=head3 province

This field is a bit special and it's use is expected to be related to distribution
all entries are marked as 'False'. The data are included since they are a part of
the original data.

=head3 country

Since the original source contains data on 3 different countries:

=over

=item * Denmark (1)

=item * Greenland (2)

=item * Faroe Islands (3)

=back

Only the data representing Faroe Islands has been included in this distribution, so this
field is always containing a '3'.

For access to the data on Denmark or Greenland please refer to: L<Business::DK::Postalcode>
and L<Business::GL::Postalcode> respectfully.

=head2 Encoding

The data distributed are in Faroese and Danish for descriptions and names and these are encoded in UTF-8.

=head1 SUBROUTINES AND METHODS

=head2 new

Basic contructor, takes no arguments. Load the dataset and returns
a Class::Business::FO::Postalcode object.

=head2 validate

A simple validator for Faroese postal codes.

Takes a string representing a possible Faroese postal code and returns either
B<1> or B<0> indicating either validity or invalidity.

    my $validator = Business::FO::Postalcode->new();

    my $rv = $validator->validate(100);

    if ($rv == 1) {
        print "We have a valid Faroese postal code\n";
    } ($rv == 0) {
        print "Not a valid Faroese postal code\n";
    }

=head2 get_all_postalcodes

Takes no parameters.

Returns a reference to an array containing all valid Faroese postal codes.

    my $validator = Business::FO::Postalcode->new();

    my $postalcodes = $validator->get_all_postalcodes;

    foreach my $postalcode (@{$postalcodes}) { ... }

=head2 get_all_cities

Takes no parameters.

Returns a reference to an array containing all Faroese city names having a postal code.

    my $validator = Business::FO::Postalcode->new();

    my $cities = $validator->get_all_cities;

    foreach my $city (@{$cities}) { ... }

Please note that this data source used in this distribution by no means is authorative
when it comes to cities located in Denmark, it might have all cities listed, but
unfortunately also other post distribution data.

=head2 get_city_from_postalcode

Takes a string representing a Faroese postal code.

Returns a single string representing the related city name or an empty string indicating nothing was found.

    my $validator = Business::FO::Postalcode->new();

    my $zipcode = '3900';

    my $city = $validator->get_city_from_postalcode($zipcode);

    if ($city) {
        print "We found a city for $zipcode\n";
    } else {
        warn "No city found for $zipcode";
    }

=head2 get_postalcode_from_city

Takes a string representing a Faroese city name.

Returns a reference to an array containing zero or more postal codes related to that city name. Zero indicates nothing was found.

Please note that city names are not unique, hence the possibility of a list of postal codes.

    my $validator = Business::FO::Postalcode->new();

    my $city = 'Tórshavn';

    my $postalcodes = $validator->get_postalcode_from_city($city);

    if (scalar @{$postalcodes} == 1) {
        print "$city is unique\n";
    } elsif (scalar @{$postalcodes} > 1) {
        warn "$city is NOT unique\n";
    } else {
        die "$city not found\n";
    }

=head2 num_of_digits_in_postalcode

Mutator to get/set the number of digits used to compose a Greenlandic postal code

    my $validator = Business::FO::Postalcode->new();

    my $rv = $validator->num_of_digits_in_postalcode(3);

    my $digits = $validator->num_of_digits_in_postalcode();

=head2 postal_data

Mutator to get/set the reference to the array comprising the main data structure

    my $validator = Business::FO::Postalcode->new();

    my $rv = $validator->postal_data(\@postal_data);

    my $postal_data = $validator->postal_data();

=head1 DIAGNOSTICS

There are not special diagnostics apart from the ones related to the different
subroutines.

=head1 CONFIGURATION AND ENVIRONMENT

This distribution requires no special configuration or environment.

=head1 DEPENDENCIES

=over

=item * L<https://metacpan.org/pod/Carp> (core)

=item * L<https://metacpan.org/pod/Exporter> (core)

=item * L<https://metacpan.org/pod/Data::Handle>

=item * L<https://metacpan.org/pod/List::Util>

=item * L<https://metacpan.org/pod/Params::Validate>

=back

=head2 TEST

Please note that the above list does not reflect requirements for:

=over

=item * Additional components in this distribution, see F<lib/>. Additional
components list own requirements

=item * Test and build system, please see: F<Build.PL> for details

=back

=head1 BUGS AND LIMITATIONS

There are no known bugs at this time.

The data source used in this distribution by no means is authorative when it
comes to cities located in Faroe Islands, it might have all cities listed, but
unfortunately also other post distribution data.

=head1 BUG REPORTING

Please report issues via CPAN RT:

=over

=item * Web (RT): L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Business-FO-Postalcode>

=item * Web (Github): L<https://github.com/jonasbn/perl-Business-FO-Postalcode/issues>

=item * Email (RT): L<bug-Business-FO-Postalcode@rt.cpan.org>

=back

=head1 SEE ALSO

=over

=item L<Business::DK::Postalcode>

=item L<Business::GL::Postalcode>

=back

=head1 MOTIVATION

Postdanmark the largest danish postal and formerly stateowned postal service, maintain the
postalcode mapping for Greenland and the Faroe Islands. Since I am using this resource to
maintain the danish postalcodes I decided to release distributions of these two other countries.

=head1 AUTHOR

Jonas B., (jonasbn) - C<< <jonasbn@cpan.org> >>

=head1 COPYRIGHT

Class-Business-FO-Postalcode is (C) by Jonas B., (jonasbn) 2014-2019

Class-Business-FO-Postalcode is released under the artistic license 2.0

=cut

__DATA__
100;Tórshavn;;;False;3
110;Tórshavn ;Postboks;;False;3
160;Argir;;;False;3
165;Argir ;Postboks;;False;3
175;Kirkjubøur;;;False;3
176;Velbastadur;;;False;3
177;Sydradalur, Streymoy;;;False;3
178;Nordradalur;;;False;3
180;Kaldbak;;;False;3
185;Kaldbaksbotnur;;;False;3
186;Sund;;;False;3
187;Hvitanes;;;False;3
188;Hoyvík;;;False;3
210;Sandur;;;False;3
215;Sandur;Postboks;;False;3
220;Skálavík;;;False;3
230;Húsavík;;;False;3
235;Dalur;;;False;3
236;Skarvanes;;;False;3
240;Skopun;;;False;3
260;Skúvoy;;;False;3
270;Nólsoy;;;False;3
280;Hestur;;;False;3
285;Koltur;;;False;3
286;Stóra Dimun;;;False;3
330;Stykkid;;;False;3
335;Leynar;;;False;3
336;Skællingur;;;False;3
340;Kvívík;;;False;3
350;Vestmanna;;;False;3
355;Vestmanna;Postboks;;False;3
358;Válur;;;False;3
360;Sandavágur;;;False;3
370;Midvágur;;;False;3
375;Midvágur;Postboks;;False;3
380;Sørvágur;;;False;3
385;Vatnsoyrar;;;False;3
386;Bøur;;;False;3
387;Gásadalur;;;False;3
388;Mykines;;;False;3
400;Oyrarbakki;;;False;3
405;Oyrarbakki;Postboks;;False;3
410;Kollafjørdur;;;False;3
415;Oyrareingir;;;False;3
416;Signabøur;;;False;3
420;Hósvík;;;False;3
430;Hvalvík;;;False;3
435;Streymnes;;;False;3
436;Saksun;;;False;3
437;Nesvík;;;False;3
438;Langasandur;;;False;3
440;Haldarsvík;;;False;3
445;Tjørnuvík;;;False;3
450;Oyri;;;False;3
460;Nordskáli;;;False;3
465;Svináir;;;False;3
466;Ljósá;;;False;3
470;Eidi;;;False;3
475;Funningur;;;False;3
476;Gjógv;;;False;3
477;Funningsfjørdur;;;False;3
478;Elduvík;;;False;3
480;Skáli;;;False;3
485;Skálafjørdur;;;False;3
490;Strendur;;;False;3
494;Innan Glyvur;;;False;3
495;Kolbanargjógv;;;False;3
496;Morskranes;;;False;3
497;Selatrad;;;False;3
510;Gøta;;;False;3
511;Gøtugjógv;;;False;3
512;Nordragøta;;;False;3
513;Sydrugøta;;;False;3
515;Gøta;Postboks;;False;3
520;Leirvík;;;False;3
530;Fuglafjørdur;;;False;3
535;Fuglafjørdur;Postboks;;False;3
600;Saltangará;;;False;3
610;Saltangará;Postboks;;False;3
620;Runavík;;;False;3
625;Glyvrar;;;False;3
626;Lambareidi;;;False;3
627;Lambi;;;False;3
640;Rituvík;;;False;3
645;Æduvík;;;False;3
650;Toftir;;;False;3
655;Nes, Eysturoy;;;False;3
656;Saltnes;;;False;3
660;Søldarfjørdur;;;False;3
665;Skipanes;;;False;3
666;Gøtueidi;;;False;3
690;Oyndarfjørdur;;;False;3
695;Hellur;;;False;3
700;Klaksvík;;;False;3
710;Klaksvík;Postboks;;False;3
725;Nordoyri;;;False;3
726;Ánir;;;False;3
727;Árnafjørdur;;;False;3
730;Norddepil;;;False;3
735;Depil;;;False;3
736;Nordtoftir;;;False;3
737;Múli;;;False;3
740;Hvannasund;;;False;3
750;Vidareidi;;;False;3
765;Svinoy;;;False;3
766;Kirkja;;;False;3
767;Hattarvík;;;False;3
780;Kunoy;;;False;3
785;Haraldssund;;;False;3
795;Sydradalur, Kalsoy;;;False;3
796;Húsar;;;False;3
797;Mikladalur;;;False;3
798;Trøllanes;;;False;3
800;Tvøroyri;;;False;3
810;Tvøroyri;Postboks;;False;3
825;Frodba;;;False;3
826;Trongisvágur;;;False;3
827;Øravík;;;False;3
850;Hvalba;;;False;3
860;Sandvík;;;False;3
870;Fámjin;;;False;3
900;Vágur;;;False;3
910;Vágur;Postboks;;False;3
925;Nes, Vágur;;;False;3
926;Lopra;;;False;3
927;Akrar;;;False;3
928;Vikarbyrgi;;;False;3
950;Porkeri;;;False;3
960;Hov;;;False;3
970;Sumba;;;False;3
