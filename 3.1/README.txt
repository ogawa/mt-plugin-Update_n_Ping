Update-n-Ping Plugin 0.10


* DESCRIPTION

The default Movable Type version 3.1 does send 'update pings' if you
post new entries or change entries' state from 'Draft' to
'Publish'. On other hand, MT3 does NOT send any update pings if modify
'published' entries.

This plugin enables MT to send update pings when updating published
entries and adding newly published entries.


* REQUIREMENTS

This plugin is supported on Movable Type 3.1 or later.  If you are
using an older version of Movable Type, we strongly suggest upgrading
to the latest release.


* INSTALLATION

The following files are provided with this distribution:

    plugins/update-n-ping/plugin.pl
    plugins/update-n-ping/config.cgi
    plugins/update-n-ping/tmpl/update-n-ping.tmpl

To install this plugin, upload or copy these files into your Movable
Type directory and set the permission of the "config.cgi" script to
0755 (be executable).

After proper installation, you will see a new "Update-n-Ping" plugin
listed on the Main Menu of your Movable Type.


* UNINSTALLATION

To uninstall this plugin, remove the directories and files added by
the installation process.


* SEE ALSO

http://as-is.net/hacks/2005/02/update_n_ping_plugin.html
http://as-is.net/blog/archives/000976.html (for Japanese readers)


* LICENSE

This code is released under the Artistic License. The terms of the
Artistic License will be found:
    http://www.opensource.org/licenses/artistic-license.php


* AUTHOR & COPYRIGHT

Copyright 2005, Hirotaka Ogawa (hirotaka.ogawa@gmail.com)
