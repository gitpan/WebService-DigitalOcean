package WebService::DigitalOcean::Role::Domains;
# ABSTRACT: Domains role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Str Object slurpy Dict/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

our $VERSION = '0.003'; # VERSION

sub domain_create {
    state $check = compile(Object,
        slurpy Dict[
            name => Str,
            ip_address => Str,
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(POST => '/domains', $opts);
}

sub domain_list {
    state $check = compile(Object);
    my ($self) = $check->(@_);

    return $self->make_request(GET => '/domains');
}

sub domain_get {
    state $check = compile(Object,
        slurpy Dict[
            domain => Str,
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(GET => "/domains/$opts->{domain}");
}

sub domain_delete {
    state $check = compile(Object,
        slurpy Dict[
            domain => Str,
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(DELETE => "/domains/$opts->{domain}");
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

WebService::DigitalOcean::Role::Domains - Domains role for DigitalOcean WebService

=head1 VERSION

version 0.003

=head1 METHODS

=head2 $do->domain_create(%args)

=head3 Arguments

=over

=item C<Str> name

The domain name.

=item C<Str> ip_address

The IP address the domain will point to.

=back

Creates a new domain name.

    $do->domain_create(
        name => 'example.com',
        ip_address => '12.34.56.78',
    );

More info: L<< https://developers.digitalocean.com/#create-a-new-domain >>.

=head2 $do->domain_delete(%args)

=head3 Arguments

=over

=item C<Str> domain

The domain name.

=back

Deletes the specified domain.

    $do->domain_delete(
        domain => 'example.com',
    );

More info: L<< https://developers.digitalocean.com/#delete-a-domain >>.

=head2 $do->domain_get(%args)

=head3 Arguments

=over

=item C<Str> domain

The domain name.

=back

Retrieves the specified domain.

    my $response = $do->domain_get(
        domain => 'example.com',
    );

More info: L<< https://developers.digitalocean.com/#retrieve-an-existing-domain >>.

=head2 $do->domain_list(%args)

Lists all domains for this account.

    my $response = $do->domain_list();

    for (@{ $response->{content}{domains} }) {
        print $_->{id};
    }

More info: L<< https://developers.digitalocean.com/#list-all-domains >>.

=head2 DESCRIPTION

Implements the domain resource.

More info: L<< https://developers.digitalocean.com/#domains >>.

=head1 AUTHOR

André Walker <andre@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by André Walker.

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut
