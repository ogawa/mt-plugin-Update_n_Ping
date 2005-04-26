# A plugin for sending "update pings" when updating entries
#
# Release 0.10 (Apr 25, 2005)
#
# This software is provided as-is. You may use it for commercial or 
# personal use. If you distribute it, please keep this notice intact.
#
# Copyright (c) 2005 Hirotaka Ogawa

use strict;
use vars qw($PING_URLS $LIMIT_ENTRIES);

# default settings (these will be overridden by config-script)
$PING_URLS = [
	      'http://rpc.pingomatic.com/',
	     ];
$LIMIT_ENTRIES = 15;

my $plugin;
eval {
    require MT::Plugin;
    $plugin = new MT::Plugin();
    $plugin->name("Update-n-Ping Plugin");
    $plugin->description("Send 'update pings' when updating entries");
    $plugin->doc_link("http://as-is.net/hacks/2005/02/update_n_ping_plugin.html");
    $plugin->config_link("config.cgi");
    MT->add_plugin($plugin);
};

if (MT->can('add_callback')) {
    MT->add_callback('AppPostEntrySave', 10, "Send 'update pings' when updating entries", \&update_n_ping);
}

sub update_n_ping {
    my ($eh, $app, $entry) = @_;
    return if $entry->status != MT::Entry::RELEASE();

    my $limit_entries = $LIMIT_ENTRIES;
    my @ping_urls = @$PING_URLS;
    if ($plugin) {
	my $enabled = $plugin->get_config_value('enabled');
	return if (defined $enabled && !$enabled);

	my $s = $plugin->get_config_value('limit_entries');
	$limit_entries = $s if defined $s;

	my $t = $plugin->get_config_value('ping_urls');
	@ping_urls = @$t if (defined $t && ref($t) eq 'ARRAY' && @$t);
    }

    if ($limit_entries) {
	my $iter = MT::Entry->load_iter({ blog_id => $entry->blog_id,
					  status => MT::Entry::RELEASE() },
					{ sort => 'created_on',
					  direction => 'descend',
					  limit => $limit_entries });
	my $is_recent = 0;
	while (my $e = $iter->()) {
	    if ($e->id == $entry->id) {
		$is_recent = 1;
		last;
	    }
	}
	return unless $is_recent;
    }

    require MT::Blog;
    require MT::XMLRPC;
    my $blog = MT::Blog->load($entry->blog_id);

    for my $url (@ping_urls) {
	my $msg = "Update-n-Ping[" . $entry->blog_id . ":" . $entry->id . "] $url ";
	if (MT::XMLRPC->ping_update('weblogUpdates.ping', $blog, $url)) {
	    $msg .= 'suceeded.';
	} else {
	    $msg .= 'failed. ' . MT::XMLRPC->errstr;
	}
	$app->log($msg);
    }
}

1;
