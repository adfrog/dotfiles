// plugin_loader.js
liberator.globalVariables.plugin_loader_roots = "~/Project/Vimperator/Plugins/";
liberator.globalVariables.plugin_loader_plugins = [
  '_libly',
  '_smooziee',
  'appendAnchor',				//リンク中の URL っぽいテキストにアンカーをつける
  'auto_detect_link',			//(次|前)っぽいページへのリンクを探してジャンプ
//  'autopagerize_controll',
//  'bitly',						//Bit.ly で短縮URLを得る
  'commandBookmarklet',
  'char-hints-mod2',			
  'cookie',						//:pageinfo で cookie を表示する
  'copy',						
  'encodingSwitcherCommand',
  'feedSomeKeys_2',
  'gmperator',
  'hd-youkai-youtube',
  'httpheaders',
  'ldrize_cooperation',
  'maine_coon',
  'migemized_find',
  'migemo_completion',
  'migemo_hint',
  'migratestatusbar',
//  'multi_requester',
  'pluginManager',
//  'tabsort',
  'toggler',
  'walk-input',
  'yetmappings',
];


// copy.js



liberator.globalVariables.copy_templates = [
  { label: 'titleAndURL',    value: '%TITLE% %URL%' },
  { label: 'title',          value: '%TITLE%' },
  { label: 'url',            value: '%URL%' },
  { label: 'markdown',       value: '[%TITLE%](%URL% "%TITLE%")' },
  { label: 'markdownsel',    value: '[%SEL%](%URL% "%TITLE%")' },
  { label: 'htmlblockquote', value: '<blockquote cite="%URL%" title="%TITLE%">%HTMLSEL%</blockquote>' },
  { label: 'Tabslist', value: 'Current tabs copy to <UL> list', custom: function() { let result = <ul/>; for each ([,tab] in tabs.browsers) result.li += <li> <a href={tab.currentURI.spec}> {tab.contentTitle}</a>
</li>; return result; }},
  { label: 'bitly', value: 'Copy bitly URL and domain', cosutom: function(){ let uri = util.newURI(buffer.URL); return liberator.plugins.bitly.get(uri.spec) + " [" + uri.host + "]"; }},
];
    




liberator.globalVariables.migrate_elements = [
    {
        // star button of awesome bar
        id:    'star-button',
        dest:  'security-button',
        after: true,
    },
    {
        // ステータスバーにfeedボタンを表示
        id:    'feed-button',
        dest:  'security-button',
        after: true,
    },
    {
        // statusline に favicon を表示
        id:    'page-proxy-stack',
        dest:  'liberator-statusline',
        after: false,
    },
];


//toggler.js
/*
liberator.globalVariables.toggler = {
  go: ["set go=Brn","set go=B","set go="],
  sb: ["sbclose","sbar Console"],
};
*/


//_smooziee.js
mappings.addUserMap(
  [modes.NORMAL], 
  ["<C-d>"], 
  "", 
  function() plugins.smooziee.smoothScrollBy(400)
);
mappings.addUserMap(
  [modes.NORMAL], 
  ["<C-u>"], 
  "", 
  function() plugins.smooziee.smoothScrollBy(-400)
);

mappings.addUserMap(
  [modes.NORMAL], 
  ["J"], 
  "", 
  function() plugins.smooziee.smoothScrollBy(400)
);
mappings.addUserMap(
  [modes.NORMAL], 
  ["K"], 
  "", 
  function() plugins.smooziee.smoothScrollBy(-400)
);

// hints一覧表示コマンド
(function(){
    completion.hintslist = function(context){
        context.title = ["hints","prompt"];
        context.completions = let(H=liberator.eval("hintModes",hints.addMode)) [[a,b] for([a,{prompt:b}] in Iterator(H))];
    };
    commands.addUserCommand(["hintslist"],"hints list", function() completion.listCompleter("hintslist"),{argCount:"0"},true);
})();

// about:blank の時は t でも :open にする
mappings.addUserMap(
    [modes.NORMAL],
    ['t'],
    ':topen or :open',
    function () {
      if (buffer.URL == 'about:blank') {
        commandline.open(":", "open ", modes.EX);
      } else {
        commandline.open(":", "tabopen ", modes.EX);
      }
    },
    {}
  );


// css js を自動ロード

(function(){
  var colorDir = io.getRuntimeDirectories("styles")[0];
  colorDir.readDirectory(true).forEach(function(file){
    if (/\.css$/i.test(file.path)) io.source(file.path, false);
  });
})();
(function(){
  var jsDir = io.getRuntimeDirectories("userchrome")[0];
  jsDir.readDirectory(true).forEach(function(file){
    if (/\.js$/i.test(file.path)) io.source(file.path, false);
  });
})();


//タブ上でのダブルクリックで再読込
gBrowser.mTabContainer.addEventListener("dblclick", function(e){
if (e.target.localName == "tab" && e.button == 0)BrowserReload();
else if (e.target.localName == "spacer" && e.button == 0)BrowserOpenTab();
},false); 



