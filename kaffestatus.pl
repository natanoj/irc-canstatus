use strict;
use warnings;

use Irssi;

our $VERSION = '1.01';
our %IRSSI = (
    authors     =>  'Anton Landberg',
    contact     =>  'git@atnon.se',
    name        =>  'ETAkaffestatus',
    description =>  'Lyssnar efter fråga kring kaffe ställd till '.
                    'uppkopplad användare',
    license     =>  'GNU GPLv3',
);

Irssi::signal_add_first 'message public', 'sig_message_public';
Irssi::signal_add_first 'message private', 'sig_message_private';

sub sig_message_public {
    my ($server, $msg, $nick, $nick_addr, $target) = @_;
    my $MyNick = $server->{nick};
    my $KaffeStatus = "Vem vet?";
    if ($target =~ m/#eta/i) { # only operate in these channels
        my $KaffeStatus = `python /home/eta/.irssi/.scripts/kaffestatus.py`;
        $server->command("msg $target $nick: $KaffeStatus") if ($msg =~ m/$MyNick:.*?kaffe.*?/i);
    }
}

sub sig_message_private {
    my ($server, $msg, $nick, $nick_addr) = @_;
    my $KaffeStatus = `python /home/eta/.irssi/.scripts/kaffestatus.py`;
    $server->command("msg $nick $KaffeStatus") if ($msg =~ m/.*?kaffe.*?/i);
}

