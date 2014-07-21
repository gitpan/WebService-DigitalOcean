package WebService::DigitalOcean::Role::UserAgent;
# ABSTRACT: User Agent Role for DigitalOcean WebService
use Moo::Role;
use LWP::UserAgent;
use JSON ();
use DateTime;
use utf8;

our $VERSION = '0.001'; # TRIAL VERSION

has ua => (
    is => 'lazy',
);

sub _build_ua {
    my ($self) = @_;

    my $version = __PACKAGE__->VERSION;
    $version ||= 'devel';

    my $ua = LWP::UserAgent->new(
        agent => 'WebService::DigitalOcean/' . $version,
    );

    $ua->default_header('Authentication' => 'Bearer ' . $self->token);
    $ua->default_header('Content-Type' => 'application/json');

    return $ua;
}

sub make_request {
    my ($self, $method, $uri, $data) = @_;

    my $response = $self->ua->request(
        HTTP::Request->new(
            $method,
            $self->api_base_url . $uri,
            undef,
            JSON::encode_json($data)
        )
    );

    my $result = {
        response_object => $response,
        is_success      => $response->is_success,
        status_line     => $response->status_line,
    };

    if ($response->content_type eq 'application/json') {
        $result->{content} = JSON::decode_json($response->decoded_content);
    }

    if (my $ratelimit = $response->header('RateLimit-Limit')) {
        $result->{ratelimit} = {
            limit     => $ratelimit,
            remaining => $response->header('RateLimit-Remaining'),
            reset     => DateTime->from_epoch(
                epoch => $response->header('RateLimit-Reset')
            ),
        };
    }

    return $result;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

WebService::DigitalOcean::Role::UserAgent - User Agent Role for DigitalOcean WebService

=head1 VERSION

version 0.001

=head1 METHODS

=head2 make_request

=head1 AUTHOR

André Walker <andre@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by André Walker.

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut
