# Update-n-Pingプラグイン

エントリーを更新したときに更新Pingを送信するプラグイン。Movable Type 3.1以降でしか動作しません。

## 更新履歴

 * 0.01(2005.02.23):
   * 公開開始。
 * 0.02(2005.02.24):
   * バグ修正。
   * Feedに反映されないような古いエントリーを更新してもPingを送信しないように動作変更。
 * 0.03(2005.03.01):
   * Perl 5.0で動作しない問題への対策。
 * 0.04(2005.03.06):
   * Storable.pmが存在しないときに動作しない問題への対策。
 * 0.10(2005.04.25):
   * MT 3.16以降のバージョンでプラグインのカスタマイズ機能が使えるように変更。
 * 0.11(2005.06.10):
   * XMLRPCやAtom API経由で編集・保存した場合にも更新Pingが送られるように変更。
 * 0.12(2005.10.24):
   * MT 3.2に対応したバージョンを同梱。

## 概要

Movable Type 3.1では、新規エントリーを「公開」状態でポストしたり、「下書き」状態のエントリーを「公開」状態に変更すると、予め設定されているPingサーバーに更新Pingが送信されます。一方、すでに公開状態のエントリーを編集して再度保存しても更新Pingは送信されません。

このプラグインは、公開状態のエントリーを更新したり、新規に公開状態のエントリーを追加したときに更新Pingを送信します。Pingが成功したかどうかはメイン・メニューのログで確認できます。

このプラグインは次のような場合に役に立つでしょう。XML FeedをFeedBurnerにハンドオフしている場合、ブログが更新され、オリジナルのXML Feedが更新されたとしても、FeedBurnerが提供するFeedにはすぐには反映されません。FeedBurner botがオリジナルFeedを「そのうち」フェッチしてくれるまで反映されるのを待たねばなりません。しかし、このプラグインを使ってブログが更新されたタイミングでPing-o-Matic!に明示的にPingを打てば、FeedBurner botは十分速くオリジナルのFeedをフェッチしてくれるはずです。

## インストール方法

### Movable Type 3.2以降

プラグインをインストールするには、パッケージに含まれるupdate-n-ping.plをpluginsディレクトリにアップロードしてください。正しくインストールが完了すれば、メインメニューの「利用可能なプラグインの設定」にUpdate-n-Ping Pluginが表示されるはずです。

アンインストールするには、update-n-ping.plをpluginsディレクトリから削除してください。

### Movable Type 3.1x

このディストリビューションには以下のファイルが含まれています。

    plugins/update-n-ping/plugin.pl
    plugins/update-n-ping/config.cgi
    plugins/update-n-ping/tmpl/update-n-ping.tmpl

プラグインをインストールするには、これらのファイルをMovable Typeのプラグインディレクトリにアップロードし、config.cgiに実行パーミッションを設定するだけで済みます。

正しくインストールが完了すれば、メインメニューの「利用可能なプラグインの設定」にUpdate-n-Ping Pluginが表示されるはずです。

## カスタマイズ方法

### Movable Type 3.2以降

各ブログの「プラグインの設定」画面から設定変更できます。

### Movable Type 3.16以降

デフォルトでこのプラグインはPing-o-Matic!に更新Pingを送信します。また、作成日が15番目よりも古いエントリーを更新しても更新Pingが送信されないようになっています。

これらは、メインメニューの「利用可能なプラグインの設定」の「Update-n-Ping Plugin」のところから設定変更することができます(プラグインファイルへの修正は不要)。また、この画面からプラグインを利用しないように設定することもできます。

### Movable Type 3.151以前

デフォルトでこのプラグインはPing-o-Matic!に更新Pingを送信します。この設定を変更するには以下の部分を変更するとよいでしょう。

    $PING_URLS = [
             'http://rpc.pingomatic.com/',
             'http://rpc.technorati.com/rpc/ping'
            ];

また、作成日が15番目よりも古いエントリーを更新しても更新Pingが送信されないようになっています。これはFeedが更新されないような古いエントリーを更新した場合に無駄なPingを打たないためです。Feedに表示しているエントリー数が15件ではない場合は$LIMIT_ENTRIES変数の値を変更した方がよいでしょう。

    $LIMIT_ENTRIES = 15;

また、この値を0にすると、作成日に関わらず更新Pingが送信されます。

## 注意事項

このプラグインは、エントリーを保存し、かつその状態が公開状態のとき、更新Pingを送信します。したがって、新規エントリーを公開状態でポスト、もしくは下書き状態のエントリーを公開状態にして保存した場合、Movable Typeの正規の更新Pingと、このプラグインによる更新Ping、の両方が送信されます。仮に両方が同じPingサーバーに更新Pingを送るように設定してあると、二重に更新Pingが送られます。

これは致命的な欠陥であることは認識していますが、以下の理由・方法でこの問題を緩和することができるでしょう。

 * 主要なPingサーバーは更新Pingが同じIPアドレスまたはブログから送信された場合にスロットリングします。したがって、更新Pingが二重に送られることによるflooding効果はほとんどないと期待されます。
 * プラグインではpriorityの高いサーバー一個だけ(例えば、Ping-o-Matic!)にPingを送信し、MT正規の機能ではそれ以外のサーバーに送信してもらうという使い分けをすることで問題を回避できます。

更新Pingの打ち過ぎには十分注意しましょう!!

## See Also

## License

This code is released under the Artistic License. The terms of the Artistic License are described at [http://www.perl.com/language/misc/Artistic.html](http://www.perl.com/language/misc/Artistic.html).

## Author & Copyright

Copyright 2005, Hirotaka Ogawa (hirotaka.ogawa at gmail.com)
