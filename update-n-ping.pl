# A plugin for sending "update pings" when updating entries
#
# Release 0.01 (Feb 23, 2005)
#
# This software is provided as-is. You may use it for commercial or 
# personal use. If you distribute it, please keep this notice intact.
#
# Copyright (c) 2005 Hirotaka Ogawa

use strict;
our $urls = [
	     'http://rpc.pingomatic.com/'
	    ];

if (MT->can('add_plugin')) {
  require MT::Plugin;
  my $plugin = new MT::Plugin();
  $plugin->name("Update-n-Ping Plugin 0.01");
  $plugin->description("Send 'update pings' when updating entries");
  $plugin->doc_link("http://as-is.net/hacks/2005/02/update_n_ping_plugin.html");
  MT->add_plugin($plugin);
}

if (MT->can('add_callback')) {
  MT->add_callback('AppPostEntrySave', 10, "Send 'update pings' when updating entries", \&update_n_ping);
}

sub update_n_ping {
  my ($eh, $app, $new_entry) = @_;
  return if (!$new_entry->allow_pings ||
	     $new_entry->status != MT::Entry::RELEASE());

  require MT::Blog;
  require MT::XMLRPC;
  my $blog = MT::Blog->load($new_entry->blog_id);

  for my $url (@$urls) {
    my $msg = "Update-n-Ping[" . $new_entry->blog_id . ":" . $new_entry->id . "] $url ";
    if (MT::XMLRPC->ping_update('weblogUpdates.ping', $blog, $url)) {
      $msg .= 'suceeded.';
    } else {
      $msg .= 'failed.';
    }
    $app->log($msg);
  }
}

1;
