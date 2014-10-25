package WebService::DigitalOcean::Role::Sizes;
# ABSTRACT: Sizes role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Object/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

our $VERSION = '0.010'; # VERSION

sub size_list {
    state $check = compile(Object);
    my ($self, $opts) = $check->(@_);

    return $self->make_request(GET => "/sizes");
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

WebService::DigitalOcean::Role::Sizes - Sizes role for DigitalOcean WebService

=head1 VERSION

version 0.010

=head1 METHODS

=head2 $do->size_list()

Retrieves all the sizes available in Digital Ocean.

    my $sizes = $do->size_list();

    for my $s (@{ $sizes->{content}{sizes} }) {
        say "Size $s->{slug} costs $s->{price_hourly} per hour.";
    }

More info: L<< https://developers.digitalocean.com/#list-all-sizes >>.

=head2 DESCRIPTION

Implements the Sizes resource.

More info: L<< https://developers.digitalocean.com/#sizes >>.

=head1 AUTHOR

André Walker <andre@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by André Walker.

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut
