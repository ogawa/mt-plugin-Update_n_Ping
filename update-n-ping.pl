# A plugin for sending "update pings" when updating entries
#
# Release 0.03 (Mar 5, 2005)
#
# This software is provided as-is. You may use it for commercial or 
# personal use. If you distribute it, please keep this notice intact.
#
# Copyright (c) 2005 Hirotaka Ogawa

use strict;
use vars qw($urls $LIMIT_ENTRIES);

$urls = [
	 'http://rpc.pingomatic.com/'
	];
$LIMIT_ENTRIES = 15;

if (MT->can('add_plugin')) {
  require MT::Plugin;
  my $plugin = new MT::Plugin();
  $plugin->name("Update-n-Ping Plugin 0.03");
  $plugin->description("Send 'update pings' when updating entries");
  $plugin->doc_link("http://as-is.net/hacks/2005/02/update_n_ping_plugin.html");
  MT->add_plugin($plugin);
}

if (MT->can('add_callback')) {
  MT->add_callback('AppPostEntrySave', 10, "Send 'update pings' when updating entries", \&update_n_ping);
}

sub update_n_ping {
  my ($eh, $app, $new_entry) = @_;
  return if $new_entry->status != MT::Entry::RELEASE();

  if ($LIMIT_ENTRIES) {
    my $iter = MT::Entry->load_iter({ blog_id => $new_entry->blog_id,
				      status => MT::Entry::RELEASE() },
				    { sort => 'created_on',
				      direction => 'descend',
				      limit => $LIMIT_ENTRIES });
    my $is_recent = 0;
    while (my $e = $iter->()) {
      if ($e->id == $new_entry->id) {
	$is_recent = 1;
	last;
      }
    }
    return unless $is_recent;
  }

  require MT::Blog;
  require MT::XMLRPC;
  my $blog = MT::Blog->load($new_entry->blog_id);

  for my $url (@$urls) {
    my $msg = "Update-n-Ping[" . $new_entry->blog_id . ":" . $new_entry->id . "] $url ";
    if (MT::XMLRPC->ping_update('weblogUpdates.ping', $blog, $url)) {
      $msg .= 'suceeded.';
    } else {
      $msg .= 'failed. ' . MT::XMLRPC->errstr;
    }
    $app->log($msg);
  }
}

1;
