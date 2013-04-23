# Update-n-Ping Plugin

A plugin for sending ''update pings'' when updating entries.

## Changes

 * 0.01(2005.02.23):
   * First Release
 * 0.02(2005.02.24):
   * Bug Fix
 * 0.04(2005.03.06):
   * Support Perl 5.0
 * 0.10(2005.04.25):
   * Support Plugin customization feature for MT 3.16 or later.
 * 0.11(2005.06.10):
   * Fix for sending Update-pings when updating via XMLRPC or Atom API.
 * 0.12(2005.10.24):
   * Now support MT 3.2.

## Overview

The default Movable Type 3.1 does send ''update pings'' if you post new entries or change entries' state from ''Draft'' to ''Publish''.  On other hand, MT3 does NOT send any update pings if modify ''published'' entries.

This plugin enables MT to send update pings when updating published entries and adding newly published entries.

## Requirements

This plugin is supported on Movable Type 3.1 or later.  If you are using an older version of Movable Type, we strongly suggest upgrading to the latest release.

## Installation

### For MT 3.2+

To install this plugin, upload or copy "update-n-ping.pl" into your "plugins" directory of Movable Type.  After proper installation, you will see a new "Update-n-Ping" plugin listed on the Main Menu of your Movable Type.

To uninstall this plugin, just remove "update-n-ping.pl" from your plugins directory.

### For MT 3.1

The following files are provided with this distribution:

    plugins/update-n-ping/plugin.pl
    plugins/update-n-ping/config.cgi
    plugins/update-n-ping/tmpl/update-n-ping.tmpl

To install this plugin, upload or copy these files into your Movable Type directory and set the permission of the "config.cgi" script to 0755 (be executable).

After proper installation, you will see a new "Update-n-Ping Plugin" listed on the Main Menu of your Movable Type.

To uninstall this plugin, remove the directories and files added by the installation process.

## Customization

### For MT 3.2 or later

You can customize the plugin feature from the "plugin settings" screen for each blogs.

### For MT 3.16 or later

You can customize the plugin feature from "Update-n-Ping Plugin" listed on the Main Menu of your Movable Type.

### For MT 3.15 or earlier

You can customize the plugin by modifying "plugin.pl" by yourself.  For example, this plugin sends a ping only to the Ping-o-Matic! server by default.  If you want to change this, just change the following part as you like:

    $PING_URL = [
             'http://rpc.pingomatic.com/',
             'http://rpc.technorati.com/rpc/ping'
            ];

## Note

This plugin sends update pings, when you save entries and their states are 'Publish'.  This means there is a restriction on using the plugin. When you post a NEW entry, both of MT and this plugin send update pings.  This means you send an update ping TWICE for one new entry.  This is a major flaw of this plugin.  But, major ping servers throttle receiving update pings from the same server or the same blog, I think.  So, it's not so a big problem... Sorry, I'm not sure...

## See Also

## License

This code is released under the Artistic License. The terms of the Artistic License are described at [http://www.perl.com/language/misc/Artistic.html](http://www.perl.com/language/misc/Artistic.html).

## Author & Copyright

Copyright 2005, Hirotaka Ogawa (hirotaka.ogawa at gmail.com)
