package WebService::DigitalOcean::Role::DomainRecords;
# ABSTRACT: Domain Records role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Str Int Object slurpy Dict Optional/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

our $VERSION = '0.003'; # VERSION

sub domain_record_create {
    state $check = compile(Object,
        slurpy Dict[
            domain   => Str,
            type     => Str,
            name     => Optional[Str],
            data     => Optional[Str],
            priority => Optional[Int],
            port     => Optional[Int],
            weight   => Optional[Int],
        ],
    );
    my ($self, $opts) = $check->(@_);

    my $domain = delete $opts->{domain};

    return $self->make_request(POST => "/domains/$domain/records", $opts);
}

sub domain_record_list {
    state $check = compile(Object,
        slurpy Dict[
            domain => Str,
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(GET => "/domains/$opts->{domain}/records");
}

sub domain_record_get {
    state $check = compile(Object,
        slurpy Dict[
            domain => Str,
            id     => Int,
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(GET => "/domains/$opts->{domain}/records/$opts->{id}");
}

sub domain_record_delete {
    state $check = compile(Object,
        slurpy Dict[
            domain => Str,
            id     => Int,
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(DELETE => "/domains/$opts->{domain}/records/$opts->{id}");
}

# TODO:
# domain_record_update

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

WebService::DigitalOcean::Role::DomainRecords - Domain Records role for DigitalOcean WebService

=head1 VERSION

version 0.003

=head1 METHODS

=head2 $do->domain_record_create(%args)

=head3 Arguments

=over

=item C<Str> domain

The domain under which the record will be created.

=item C<Str> type

The type of the record (eg MX, CNAME, A, etc).

=item C<Str> name (optional)

The name of the record.

=item C<Str> data (optional)

The data (such as the IP address) of the record.

=item C<Int> priority (optional)

Priority, for MX or SRV records.

=item C<Int> port (optional)

The port, for SRV records.

=item C<Int> weight (optional)

The weight, for SRV records.

=back

Creates a new record for a domain.

    my $response = $do->domain_record_create(
        domain => 'example.com',
        type   => 'A',
        name   => 'www2',
        data   => '12.34.56.78',
    );

    my $id = $response->{content}{domain_record}{id};

More info: L<< https://developers.digitalocean.com/#create-a-new-domain-record >>.

=head2 $do->domain_record_delete(%args)

=head3 Arguments

=over

=item C<Str> domain

The domain to which the record belongs.

=item C<Int> id

The id of the record.

=back

Deletes the specified record.

    $do->domain_record_delete(
        domain => 'example.com',
        id     => 1215,
    );

More info: L<< https://developers.digitalocean.com/#delete-a-domain-record >>.

=head2 $do->domain_record_get(%args)

=head3 Arguments

=over

=item C<Str> domain

The domain to which the record belongs.

=item C<Int> id

The id of the record.

=back

Retrieves details about a particular record, identified by id.

    my $response = $do->domain_record_get(
        domain => 'example.com',
        id     => 1215,
    );

    my $ip = $response->{content}{domain_record}{data};

More info: L<< https://developers.digitalocean.com/#retrieve-an-existing-domain-record >>.

=head2 $do->domain_record_list(%args)

=head3 Arguments

=over

=item C<Str> domain

The domain to which the records belong.

=back

Retrieves all the records for a particular domain.

    my $response = $do->domain_record_list(
        domain => 'example.com',
    );

    for (@{ $response->{content}{domain_records} }) {
        print "$_->{name} => $_->{data}\n";
    }

More info: L<< https://developers.digitalocean.com/#list-all-domain-records >>.

=head2 DESCRIPTION

Implements the domain records resource.

More info: L<< https://developers.digitalocean.com/#domain-records >>.

=head1 AUTHOR

André Walker <andre@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by André Walker.

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut
