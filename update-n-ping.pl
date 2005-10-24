# A plugin for sending "update pings" when updating entries
#
# $Id$
#
# This software is provided as-is. You may use it for commercial or 
# personal use. If you distribute it, please keep this notice intact.
#
# Copyright (c) 2005 Hirotaka Ogawa
#
package MT::Plugin::Update_n_Ping;
use strict;
use base 'MT::Plugin';
use vars qw($VERSION);
$VERSION = '0.12';

my $plugin = MT::Plugin::Update_n_Ping->new({
    name => 'Update-n-Ping',
    description => 'This plugin enables MT to send update pings when updating published entries or adding newly published entries.',
    doc_link => 'http://as-is.net/hacks/2005/02/update_n_ping_plugin.html',
    author_name => 'Hirotaka Ogawa',
    author_link => 'http://profile.typekey.com/ogawa/',
    version => $VERSION,
    blog_config_template => \&template,
    settings => new MT::PluginSettings([
					['unp_ping_urls', { Default => '' }],
					['unp_limit_entries', { Default => 15 }]
					])
    });
MT->add_plugin($plugin);

my $mt = MT->instance;
MT->add_callback((ref $mt eq 'MT::App::CMS' ? 'AppPostEntrySave' : 'MT::Entry::post_save'),
		 10, $plugin, \&update_n_ping);

sub update_n_ping {
    my ($eh, $app, $entry) = @_;
    return if $entry->status != MT::Entry::RELEASE();

    my $entry_id = $entry->id;
    my $blog_id = $entry->blog_id;

    my $config = $plugin->get_config_hash("blog:$blog_id") or return;
    my $limit_entries = $config->{unp_limit_entries} || 0;
    my $ping_urls = $config->{unp_ping_urls} || '';
    my @ping_urls = ();
    foreach (split /\r?\n/, $ping_urls) {
	s/^\s+//;
	s/\s+$//;
	push @ping_urls, $_ unless m/^$/;
    }
    return unless @ping_urls;

    if ($limit_entries) {
	my $iter = MT::Entry->load_iter({ blog_id => $blog_id,
					  status => MT::Entry::RELEASE() },
					{ sort => 'created_on',
					  direction => 'descend',
					  limit => $limit_entries });
	my $is_recent = 0;
	while (my $e = $iter->()) {
	    if ($e->id == $entry_id) {
		$is_recent = 1;
		last;
	    }
	}
	return unless $is_recent;
    }

    require MT::Blog;
    require MT::XMLRPC;
    my $blog = MT::Blog->load($blog_id);
    for my $url (@ping_urls) {
	my $msg = "Update-n-Ping[$blog_id:$entry_id] $url ";
	if (MT::XMLRPC->ping_update('weblogUpdates.ping', $blog, $url)) {
	    $msg .= 'suceeded.';
	} else {
	    $msg .= 'failed. ' . MT::XMLRPC->errstr;
	}
	$app->log($msg);
    }
}

sub template {
    my $tmpl = <<'EOT';
<p>This plugin enables MT to send update pings when updating published entries or adding newly published entries.</p>

<p>For more details, see <a href="http://as-is.net/hacks/2005/02/update_n_ping_plugin.html">"Ogawa::Hacks: Update-n-Ping Plugin"</a>. Especially for Japanese readers, see <a href="http://as-is.net/blog/archives/000976.html">"Ogawa::Memoranda: Update-n-Ping Plugin"</a>.</p>

<div class="setting">
<div class="label"><label for="unp_limit_entries">Limit Entries:</label></div>
<div class="field">
<input name="unp_limit_entries" id="unp_limit_entries" size="5" value="<TMPL_VAR NAME=UNP_LIMIT_ENTRIES>" />
<p>If you wish to send 'update pings' when modifying one of the latest <em>N</em> entries, enter the "<em>N</em>" value here. (Default = 15)</p>
</div>
</div>

<div class="setting">
<div class="label"><label for="unp_ping_urls">Update Ping URL(s):</label></div>
<div class="field">
<textarea name="unp_ping_urls" id="unp_ping_urls" rows="4" cols="50"><TMPL_VAR NAME=UNP_PING_URLS ESCAPE=HTML></textarea>
<p>e.g., http://rpc.pingomatic.com/ (separate URLs with a carriage return)</p>
</div>
</div>
EOT
}

1;
