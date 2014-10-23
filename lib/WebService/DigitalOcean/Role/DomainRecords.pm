package WebService::DigitalOcean::Role::DomainRecords;
# ABSTRACT: Domain Records role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Str Int Object slurpy Dict Optional/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

our $VERSION = '0.001'; # TRIAL VERSION

sub domain_record_create {
    state $check = compile(Object,
        slurpy Dict[
            domain   => Str,
            name     => Optional[Str],
            data     => Optional[Str],
            priority => Optional[Int],
            port     => Optional[Int],
            weight   => Optional[Int],
        ],
    );
    my ($self, %opts) = $check->(@_);

    my $domain = delete $opts{domain};

    return $self->make_request(POST => "/domains/$domain/records", \%opts);
}

sub domain_record_list {
    state $check = compile(Object,
        slurpy Dict[
            domain => Str,
        ],
    );
    my ($self, %opts) = $check->(@_);

    return $self->make_request(GET => "/domains/$opts{domain}/records");
}

sub domain_record_get {
    state $check = compile(Object,
        slurpy Dict[
            domain => Str,
            id     => Int,
        ],
    );
    my ($self, %opts) = $check->(@_);

    return $self->make_request(GET => "/domains/$opts{domain}/records/$opts{id}");
}

sub domain_record_delete {
    state $check = compile(Object,
        slurpy Dict[
            domain => Str,
            id     => Int,
        ],
    );
    my ($self, %opts) = $check->(@_);

    return $self->make_request(DELETE => "/domains/$opts{domain}/records/$opts{id}");
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

version 0.001

=head1 METHODS

=head2 domain_record_create

=head2 domain_record_delete

=head2 domain_record_get

=head2 domain_record_list

=head1 AUTHOR

André Walker <andre@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by André Walker.

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut
