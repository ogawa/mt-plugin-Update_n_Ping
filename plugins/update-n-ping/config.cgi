#!/usr/bin/perl -w
#
# config.cgi: Configuration script for Update-n-Ping Plugin
#
# Release 0.10 (Apr 25, 2005)
#
# This software is provided as-is. You may use it for commercial or 
# personal use. If you distribute it, please keep this notice intact.
#
# Copyright (c) 2005 Hirotaka Ogawa

use strict;

my $MT_DIR;
BEGIN {
    if (defined $ENV{SCRIPT_FILENAME}) {
	$MT_DIR = $ENV{SCRIPT_FILENAME};
	while (!-f "$MT_DIR/mt.cfg" && $MT_DIR =~ m|/|) {
	    $MT_DIR =~ s|[^/]*/?$||g;
	}
    } else {
	$MT_DIR = './';
    }
    unshift @INC, $MT_DIR . 'lib';
    unshift @INC, $MT_DIR . 'extlib';
}

package MT::App::Update_n_Ping;

require MT::App;
@MT::App::Update_n_Ping::ISA = 'MT::App';
require MT::Plugin;

my $PLUGIN_NAME = 'Update-n-Ping Plugin';

sub init {
    my $app = shift;
    $app->SUPER::init (@_) or return;
    $app->add_methods(default => \&show_form, save => \&save_form);
    $app->{default_mode} = 'default';
    $app->{requires_login} = 1;
    $app;
}

sub show_form {
    my $app = shift;
    my (%param) = @_;

    my $author = $app->{author};
    return $app->error("You cannot edit the settings for Update_n_Ping")
	unless $author->can_create_blog;

    require MT::Plugin;
    my $plugin = new MT::Plugin(name => $PLUGIN_NAME);

    defined($param{enabled} = $plugin->get_config_value('enabled'))
      or $param{enabled} = 1;
    defined($param{limit_entries} = $plugin->get_config_value('limit_entries'))
      or $param{limit_entries} = 15;
    my $t = $plugin->get_config_value('ping_urls');
    $param{ping_urls} = (defined $t && ref($t) eq 'ARRAY' && @$t) ?
      join "\r\n", @$t : '';

    $app->add_breadcrumb('Update-n-Ping Plugin');
    $app->build_page('update-n-ping.tmpl', \%param);
}

sub save_form {
    my $app = shift;
    my $auth = $app->{author};
    my $q = $app->{query};
    my $author = $app->{author};
    return $app->error("You cannot edit the settings for Nofollow") 
	unless $author->can_create_blog;
    $app->validate_magic() or return;

    require MT::Plugin;
    my $plugin = new MT::Plugin(name => $PLUGIN_NAME);

    $plugin->set_config_value('enabled',
			      defined $q->param('enabled') ? 1 : 0);
    $plugin->set_config_value('limit_entries', $q->param('limit_entries'));
    my @ping_urls;
    foreach (split /\r?\n/, $q->param('ping_urls')) {
	s/^\s+//;
	s/\s+$//;
	push @ping_urls, $_ unless m/^$/;
    }
    $plugin->set_config_value('ping_urls', \@ping_urls);

    my %param;
    $param{message} = "Settings updated.";
    $app->show_form(%param);
}

eval {
    my $app = MT::App::Update_n_Ping->new(Config => $MT_DIR . 'mt.cfg',
					  Directory => $MT_DIR)
	or die MT::App::Update_n_ping->errstr;
    local $SIG{__WARN__} = sub { $app->trace ($_[0]) };
    $app->run;
};
if ($@) {
    print "Content-Type: text/html\n\n";
    print "An error occurred: $@";
}
