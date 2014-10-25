package WebService::DigitalOcean::Role::Droplets;
# ABSTRACT: Droplets role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Str Object Dict ArrayRef Optional Bool Int/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

our $VERSION = '0.010'; # VERSION

sub droplet_create {
    state $check = compile(Object,
        Dict[
            name               => Str,
            region             => Str,
            size               => Str,
            image              => Str,
            ssh_keys           => Optional[ ArrayRef ],
            backups            => Optional[ Bool ],
            ipv6               => Optional[ Bool ],
            private_networking => Optional[ Bool ],
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(POST => '/droplets', $opts);
}

sub droplet_list {
    state $check = compile(Object);
    my ($self) = $check->(@_);

    return $self->make_request(GET => '/droplets');
}

sub droplet_get {
    state $check = compile(Object, Int);
    my ($self, $id) = $check->(@_);

    return $self->make_request(GET => "/droplets/$id");
}

sub droplet_delete {
    state $check = compile(Object, Int);
    my ($self, $id) = $check->(@_);

    return $self->make_request(DELETE => "/droplets/$id");
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

WebService::DigitalOcean::Role::Droplets - Droplets role for DigitalOcean WebService

=head1 VERSION

version 0.010

=head1 METHODS

=head2 $do->droplet_create(\%args)

=head3 Arguments

=over

=item C<Str> $args{name}

=item C<Str> $args{region}

=item C<Str> $args{size}

=item C<Str> $args{image}

=item C<ArrayRef> $args{ssh_keys} (optional)

=item C<Bool> $args{backups} (optional)

=item C<Bool> $args{ipv6} (optional)

=item C<Bool> $args{private_networking} (optional)

=back

Creates a new droplet.

    $do->droplet_create(
        name               => "My-Droplet",
        region             => "nyc1",
        size               => "512mb",
        image              => 449676389,
        ssh_keys           => [ 52341234, 215124, 64325534 ],
        backups            => 0,
        ipv6               => 1,
        private_networking => 0,
    );

More info: L<< https://developers.digitalocean.com/#create-a-new-droplet >>.

=head2 $do->droplet_delete($id)

=head3 Arguments

=over

=item C<Int> $id

=back

Deletes the specified droplet.

    $do->droplet_delete(1250928);

More info: L<< https://developers.digitalocean.com/#delete-a-droplet >>.

=head2 $do->droplet_get($id)

=head3 Arguments

=over

=item C<Int> $id

=back

Retrieves the specified droplet.

    my $response = $do->droplet_get(15314123);

More info: L<< https://developers.digitalocean.com/#retrieve-an-existing-droplet-by-id >>.

=head2 $do->droplet_list()

Lists all droplets for this account.

    my $response = $do->droplet_list();

    for (@{ $response->{content}{droplets} }) {
        print $_->{id};
    }

More info: L<< https://developers.digitalocean.com/#list-all-droplets >>.

=head2 DESCRIPTION

Implements the droplets resource.

More info: L<< https://developers.digitalocean.com/#droplets >>.

=head1 AUTHOR

André Walker <andre@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by André Walker.

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut
