(function() {
    if (!liberator.globalVariables.mixi_settings) {
        liberator.globalVariables.mixi_settings = [
            {
                conf_name: 'disable',
                conf_usage: 'テスト',
                settings: [
                    {
                        label: 'type',
                        url: 'http://mixi.jp/',
                    }
                ]
            },
            {
                conf_name: 'polipo',
                conf_usage: 'use polipo cache proxy',
                settings: [
                    {
                        label: 'type',
                        url: 1
                    }
                ]
            }
        ];
    };

    var mixi_settings = liberator.globalVariables.mixi_settings;

    commands.addUserCommand(["mixi"], 'Proxy settings', function (args) {

        var name = (args.length > 1) ? args[0].toString() : args.string;

        if (!name) {
            liberator.echo("Usage: proxy {setting name}");
        }
        mixi_settings.some(function (mixi_setting) {
            if (mixi_setting.conf_name.toLowerCase() != name.toLowerCase()) {
                return false;
            }

            //delete setting
            ['http', 'ssl', 'ftp', 'gopher'].forEach(function (scheme_name) {
                //prefs.setCharPref("network.proxy." + scheme_name, '');
                //prefs.setIntPref("network.proxy." + scheme_name + "_port", 0);
            });

            mixi_setting.settings.forEach(function (conf) {
                //options.setPref('network.proxy.' + conf.label, conf.url);
		alert(conf.label);
		liberator.open(conf.url, liberator.CURRENT_TAB);
            });

            liberator.echo("Set config: " + name);
            return true;
        });
    },
    {
        completer: function (context, args) {
		context.anchored = false
		context.ignoreCase = true
            var completions = [];
            context.title = ["Proxy Name", "Proxy Usage"];
            context.completions = [[c.conf_name, c.conf_usage] for each (c in mixi_settings)];
        }
    });

})();
// vim: set sw=4 ts=4 et:
