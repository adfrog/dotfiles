(function() {
    // statuslineに現在のモードと履歴とMIMEタイプと文字コードとを表示する
    liberator.plugins.krogueUpdateStatusBar = function() {
        var target = document.getElementById("liberator-statusline");
        var id_prefix = "liberator-statusline-field-";
        var items = [
            {
                id: "krogue-history",
                pos: "before",
                func: function() {
                    var history = getWebNavigation().sessionHistory;
                    return "[" + (history.index > 0 ? "<" : " ") + "|" + (history.index < history.count - 1 ? ">" : " ") + "]";
                },
            },
            {
                id: "krogue-contenttype",
                func: function() window.content.document.contentType,
            },
            {
                id: "krogue-characterset",
                func: function() window.content.document.characterSet,
            },
            {
                id: "krogue-modemessage",
                pos: "before",
                func: function() liberator.eval("getModeMessage", modes.getMode)().replace(/^-- (.*) --$/, "$1"),
            },
        ];
        items.forEach(function(item, i, arr) {
            var label = document.getElementById(id_prefix + item.id);
            if (!label) {
                label = document.createElement("label");
                label.setAttribute("class", "plain");
                label.setAttribute("id", id_prefix + item.id);
                label.setAttribute("flex", 0);
                switch (item.pos) {
                    case "before":
                        target.insertBefore(label, target.firstChild);
                        break;
                    case "after":
                        target.appendChild(label);
                        break;
                    default:
                        target.appendChild(label);
                }
            }
            label.setAttribute("value", item.func());
        });
    };
    setInterval(liberator.plugins.krogueUpdateStatusBar, 100);
})();