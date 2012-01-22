package CPAN::Access::AdHoc::Util;

use 5.008;

use strict;
use warnings;

use File::Find;
use File::Spec;

use base qw{ Exporter };

our @EXPORT_OK = qw{ __attr __load __whinge __wail __weep };

our %EXPORT_TAGS = (
    all	=> [ @EXPORT_OK ],
    carp => [ qw{ __whinge __wail __weep } ],
);

our $VERSION = '0.000_04';

sub __attr {
    my ( $self ) = @_;
    my $name_space = caller;
    return ( $self->{$name_space} ||= {} );
}

sub __load {
    my ( @args ) = @_;
    foreach my $module ( @args ) {

	$module =~ m< \A
	    [[:alpha:]_] \w*
	    (?: :: [[:alpha:]_] \w* )* \z
	>smx
	    or __wail( "Malformed module name '$module'" );

	( my $fn = $module ) =~ s{ :: }{/}smxg;
	$fn .= '.pm';
	require $fn;
    }
    return;
}

our @CARP_NOT = qw{
    CPAN::Access::AdHoc
    CPAN::Access::AdHoc::Archive
    CPAN::Access::AdHoc::Archive::Null
    CPAN::Access::AdHoc::Archive::Tar
    CPAN::Access::AdHoc::Archive::Zip
};


sub __whinge {
    my @args = @_;
    require Carp;
    Carp::carp( @args );
    return;
}

sub __wail {
    my @args = @_;
    require Carp;
    Carp::croak( @args );
}

sub __weep {
    my @args = @_;
    require Carp;
    Carp::confess( 'Programming Error - ', @args );
}

1;

__END__

=head1 NAME

CPAN::Access::AdHoc::Util - Utility functions for CPAN::Access::AdHoc

=head1 SYNOPSIS

 use CPAN::Access::AdHoc::Util;

 say 'The CPAN default plugins are ',
     join ', ', CPAN::Access::AdHoc::Util::plugins(
         'CPAN::Access::AdHoc::Default::CPAN' );

=head1 DESCRIPTION

This module provides utility functions to
L<CPAN::Access::AdHoc|CPAN::Access::AdHoc>. It is private to the
C<CPAN-Access-AdHoc> distribution. Documentation is for the benefit of
the author only.

=head1 SUBROUTINES

This module provides the following public subroutines (which are
nonetheless private to the C<CPAN-Access-AdHoc> distribution):

=head2 __attr

This subroutine/method returns the hash element of its argument which is
named after the caller's name space. This element is initialized to an
empty hash if necessary.

=head2 __load

This subroutine takes as its arguments one or more module names, and
loads them.

=head2 __whinge

This subroutine loads L<Carp|Carp>, and then passes its arguments to
C<carp()>.

=head2 __wail

This subroutine loads L<Carp|Carp>, and then passes its arguments to
C<croak()>.

=head2 __weep

This subroutine loads L<Carp|Carp>, and then passes its arguments to
C<confess()>, prefixed by the text C<'Programming Error - '>.

=head1 SUPPORT

Support is by the author. Please file bug reports at
L<http://rt.cpan.org>, or in electronic mail to the author.

=head1 AUTHOR

Thomas R. Wyant, III F<wyant at cpan dot org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Thomas R. Wyant, III

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl 5.10.0. For more details, see the full text
of the licenses in the directory LICENSES.

This program is distributed in the hope that it will be useful, but
without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

=cut

# ex: set textwidth=72 :