package WebService::DigitalOcean;
# ABSTRACT: Access the DigitalOcean RESTful API (v2)
use Moo;
use Types::Standard qw/Str/;
use LWP::UserAgent;
use JSON ();
use DateTime;
use utf8;

with
    'WebService::DigitalOcean::Role::UserAgent',
    'WebService::DigitalOcean::Role::Domains',
    'WebService::DigitalOcean::Role::DomainRecords';

our $VERSION = '0.001'; # TRIAL VERSION

has api_base_url => (
    is      => 'ro',
    isa     => Str,
    default => sub { 'https://api.digitalocean.com/v2' }
);

has token => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

WebService::DigitalOcean - Access the DigitalOcean RESTful API (v2)

=head1 VERSION

version 0.001

=head1 SYNOPSIS

    use WebService::DigitalOcean;

    my $do = WebService::DigitalOcean->new(
        token => $TOKEN,
    );

    my $res = $do->domain_create(
        name => 'example.com',
        ip_address => '127.0.0.1',
    );

    if ($res->{is_success}) {
        say $res->{content}{domain}{name};
    }
    else {
        say "Could not create domain";
    }

=head1 DESCRIPTION

This module implements DigitalOceans new RESTful API.

It's on a very early stage of development, expect new features, better docs and
tests very soon.

Patches welcome: L<< https://github.com/andrewalker/p5-webservice-digitalocean >>

=head1 ATTRIBUTES

=head2 api_base_url

=head2 token

=head1 SEE ALSO

L<DigitalOcean>

=head1 CAVEATS

This is alpha software. The interface is unstable, and may change without
notice.

=head1 AUTHOR

André Walker <andre@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by André Walker.

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut
