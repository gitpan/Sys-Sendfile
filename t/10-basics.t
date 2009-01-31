#!perl -T

use strict;
use warnings;
use Socket;
use Test::More tests => 2;
use Sys::Sendfile;
use Fcntl 'SEEK_SET';
use Socket 'MSG_DONTWAIT';

alarm 2;

socketpair my ($in), my ($out), AF_UNIX, SOCK_STREAM, PF_UNIX;

open my $self, '<', $0 or die "Couldn't open self: $!";
my $slurped = do { local $/; <$self> };
seek $self, 0, SEEK_SET;

sendfile $out, $self, -s $self or diag("Couldn't sendfile(): $!");
recv $in, my $read, -s $self, 0;

is($read, $slurped, "Read the same as was written");

seek $self, 0, SEEK_SET;

sendfile $out, $self or diag("Couldn't sendfile(): $!");
recv $in, $read, -s $self, 0;

is($read, $slurped, "Read the same as was written");
