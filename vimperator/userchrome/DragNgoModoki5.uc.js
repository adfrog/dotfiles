// ==UserScript==
// @name          DragNgoModoki5.uc.js
// @namespace     http://forums.mozillazine.org/
// @description   Drag'n'go (cf. Super DragAndGo)
// @include       main
// @compatibility Firefox 3.5 3.6a1pre
// @author        zeniko
// @permalink     http://forums.mozillazine.org/viewtopic.php?t=397735
// @Modified      by Alice0775
// @version       2009/10/09 17:20  SFにマルチバイトなフォルダを指定する際,ユニコードに変換しなくてもいいようにした(ずら)
// ==/UserScript==
// @version       2009/09/04 19:00  誤爆しないように, ドラッグ時間が極端に短い場合は何もしないように。
// @version       2009/09/03 22:00  Tree Style Tab 0.8.2009090201 のタブバーのドロップに対応
// @version       2009/06/22 00:00  Bug 456106 -  Switch to new drag and drop api in toolkit/browser 暫定
/*
   @Note          ファイルをinput type='file'フィールドにドロップでファイルパス名を挿入
   @Note          Fx3.0b2preの場合は, 参照ボタン上にドロップしなければならない
   @Note          UCJS Loaderは不可です
*/
var DragNGo = {
  _timer: null, directionChain:'', last_direction:'', last_keyCode:99, last_SourceNode:'',
  _startX:0, _startY:0, _lastX:0, _lastY:0, startTime:null,
  init: function(){
    var E=[],LINK=[],XPI=[],IMAGE=[],SEARCH=[],SIDEBAR,OUTSIDE, SF=[];
// --- config ---
/*ここから 等号の右側を使用方法に応じてカスタマイズする*/
//タブをコンテンツエリアにドロップした場合の処理方法   DETACH,  NOT_DETACH
  var DORPPING_TAB =  'DETACH';
//ジェスチャーの最後が RESET_GESTURE ならジェスチャーをリセットするようにする
  var RESET_GESTURE = 'RDLU';

//イメージをデスクトップにドロップしたとき,実体(false)とするかショートカット(true)とするか
  var IMAGE_DROP_ONDESKTOP_SHORTCUT = false;

//【リンクのD&Dの処理方法】
/*  表示場所: 新規タブ前面:NTF, 新規タブ背面:NTB, 現在のタブ: C, 新規ウインドウ:W, 名前を付けて保存:S, Save Folder(SF0〜8):SFn
                        [通常  , shiftKey時] の順で指定 */
  //リンク
  LINK["U"]           = ["NTF"  , "SF0"];
  LINK["D"]           = ["NTB"  , "SF1"];
  LINK["L"]           = ["C"    , "E2,E1"];
  //LINK["R"]           = ["S"     , "E3" ]; //2008/10/08 LINKのRはユーザー定義の方を使うようにした。
  LINK["UR"]          = ["E2,E1", ""   ];
  LINK["UL"]          = ["E3"   , "E5" ];
  LINK["LU"]          = ["W"    , ""   ];
  LINK["RU"]          = ["SF0"  , ""   ];
  LINK["RD"]          = ["SF1"  , ""   ];
  //画像
  IMAGE["U"]          = ["NTF"  , "SF0"];
  IMAGE["D"]          = ["NTB"  , "SF2"];
  IMAGE["L"]          = ["C"    , "W" ];
  IMAGE["R"]          = ["S"    , "E3" ];
  IMAGE["UR"]         = ["E2,E1", ""   ];
  IMAGE["UL"]         = ["E3"   , ""   ];
  IMAGE["LU"]         = ["W"    , ""   ];
  IMAGE["RU"]         = ["SF0"  , ""   ];
  IMAGE["RD"]         = ["SF2"  , ""   ];

//【Firefox上のサイドバーおよびウインドウからのD&Dの処理方法】
/* 表示場所: 新規タブ前面:NTF, 新規タブ背面:NTB, 現在のタブ: C, 新規ウインドウ:W, 名前を付けて保存:S
                        [通常 , shiftKey時, ctrlKey時]の順で指定 */
  SIDEBAR            = ["NTF", "NTB", "C" ];

//【Firefox以外のアプリケーションからD&Dの処理方法】
/* 表示場所: 新規タブ前面:NTF, 新規タブ背面:NTB, 現在のタブ: C, 新規ウインドウ:W, 名前を付けて保存:S
                        [通常 , shiftKey時, ctrlKey時]の順で指定 */
  OUTSIDE            = ["NTF", "NTB", "C" ];

//【XPIのD&Dの処理方法】
/* 処理方法: 名前を付けて保存:S, インストール:I
                        [通常  , shiftKey時]の順で指定*/
  XPI["U"]            = ["I"   , "SF0"];
  XPI["D"]            = ["I"   , ""   ];
  XPI["L"]            = [""    , ""   ];
  XPI["R"]            = ["S"   , "E3" ];
  XPI["RU"]           = ["SF0" , ""   ];
  XPI["RD"]           = ["E3"  , ""   ];


//【選択文字列のD&Dの処理方法 】
/* 結果表示場所 : 新規タブ前面:NTF, 新規タブ背面:NTB, 現在のタブ: C, 新規ウインドウ:W, 外部アプリ:En
   検索エンジン名: エンジン名, Default, Current, ConQuery, ページ内検索:Page, サイト内検索:Domain
   (ConQueryとPageは結果表示場所の指定は不可)
                       [通常, 検索エンジン名, shiftKey時, 検索エンジン名]の順で指定 */
  SEARCH["U"]       = ["NTF", "Google"          , "NTF", "goo 辞書(すべて)"];
  SEARCH["D"]       = ["NTB", "Google"          , "NTF", "Yahoo! JAPAN"    ];
  SEARCH["L"]       = [""   , "Page"            , "NTF", "Domain"          ];
  SEARCH["R"]       = [""   , "ConQuery"        , "E4" , ""                ];
  SEARCH["UL"]      = ["C"  , "Google"          , "NTF", ""                ];
  SEARCH["UR"]      = ["NTF", "Yahoo! JAPAN"    , "NTF", ""                ];
  SEARCH["LU"]      = ["W"  , "Google"          , "NTF", ""                ];
  SEARCH["LD"]      = ["NTF", "Domain"          , "NTF", ""                ];
  SEARCH["RD"]      = ["E4" , ""                , "NTF", ""                ];

//【外部アプリの登録】
/*  外部アプリ: E1 E2 ...E8まで, 引数は文字列(urlまたは選択文字)のみ
    書式: include:URL正規表現, path:アプリケーションパス(日本語OK), params:渡すオプション配列, code:オプションの文字コード*/
  E[1] = {include:"^h?ttps?://.+", path:"C:\\Program Files\\Internet Explorer\\iexplore.exe", params:["%%URL%%"], code:"Shift_JIS"};
  E[2] = {include:"^h?ttps?://.*\.2ch\.net", path:"C:\\Program Files\\Jane Style\\Jane2ch.exe", params:["%%URL%%"], code:"Shift_JIS"};
  E[3] = {include:"^(h?ttps?|ftp)://.+", path:"C:\\Program Files\\FlashGet\\flashget.exe", params:["%%URL%%"], code:"Shift_JIS"};
  E[4] = {include:".+", path:"c:\\Program Files\\DDwin\\ddwin.exe", params:[",2,,G1,%%SEL%%"], code:"Shift_JIS"};
  E[5] = {include:"^h?ttps?://.+", path:"C:\\Program Files\\Mozilla Firefox\\firefox.exe", params:["%%URL%%", "-no-remote", "-p", "2222"], code:"Shift_JIS"};
  E[6] = {include:".+", path:"", params:[], code:"Shift_JIS"};
  E[7] = {include:".+", path:"", params:[], code:"Shift_JIS"};
  E[8] = {include:".+", path:"", params:[], code:"Shift_JIS"};

//【SaveFolderModokiと保存フォルダのパスの登録】
/*
SFn:  SF0...SF8まで 保存フォルダのパスを指定(SaveFolderModokiで指定しているフォルダパスとは関連なし)
                   ブランク:SaveFolderModokiのポップアップを表示 */
  SF[0]            ="";
  SF[1]            ="d:";
  SF[2]            ="d:\\ほげほげ";
  SF[3]            ="";
  SF[4]            ="";
  SF[5]            ="";
  SF[6]            ="";
  SF[7]            ="";
  SF[8]            ="";

//【ユーザー定義機能の登録】
/* (上記の定義済み機能以外にユーザー定義機能を記述, ただし同一ウインドウ内D&Dのみに適用)
  nsDragAndDrop.jsラッパーオブジェクト(http://xul-app.hp.infoseek.co.jp/xultu-janit/dragwrap.html):
                                   : aEvent, aXferData, aDragSession
  ドラッグジェスチャーの方向文字列 : direction
  リンクURL文字列                 : aURL
  リンク表示文字列,または選択文字列: aText
  D&D実行フラグ                   : exec  ドラッグ中: false, ドロップ後: true */
DragNGo.userDefined = function userDefined(aEvent, aXferData, aDragSession, direction, aURL, aText, exec){
  /*ドラッグデータ    : DragNGo.url
    ドラッグ開始時node: DragNGo.sourcenode
    キーモディファイア: var _keyCode =  aEvent.altKey?1:0+aEvent.shiftKey?2:0+aEvent.ctrlKey?4:0;
    aURLを開く際はセキュリテイチェックを行うこと
                      : gBrowser.dragDropSecurityCheck(aEvent, aDragSession, aURL); */
  switch(direction){
    //クリップボードにテキストをコピー
    case 'UD':
        if(!aText) return false; //実行NG: falseを返す
        if(exec){ //ドロップ
          (function(){
            Components.classes["@mozilla.org/widget/clipboardhelper;1"]
            .getService(Components.interfaces.nsIClipboardHelper).copyString(aText);
          })();
        }else{ //ドラッグ中はステータスバーに動作を表示
          this._setStatusMessage((this.locale=="en")?'Copy text to Clip Board'
                                                    :'クリップボードにテキストをコピー', 0);
        }
        return true; //実行OK: trueを返す
    //クリップボードにURLをコピー
    case 'UDU':
        if(!aURL) return false;
        if(exec){
          (function(){
            Components.classes["@mozilla.org/widget/clipboardhelper;1"]
            .getService(Components.interfaces.nsIClipboardHelper).copyString(aURL);
          })();
        }else{
          this._setStatusMessage((this.locale=="en")?'Copy URL to Clip Board'
                                                    :'クリップボードにURLをコピー', 0);
        }
        return true;
    //検索バーにテキストをコピー
    case 'DR':
        var word = this.getDropText(aDragSession);
        if (!word) return false;

        if(exec){
          (function(){
            DragNGo.searchBardispatchEvent(word.replace(/\n/mg,' '));
          })();
        }else{
          this._setStatusMessage((this.locale=="en")?'Copy text to Search bar'
                                                    :'検索バーにテキストをコピー', 0);
        }
        return true;
    //画像をBase64エンコードしクリップボードにコピー
    case 'RDR':
        //対象が画像かどうか判定し, 偽ならば何もしない
        var imgObj = aDragSession.sourceNode;
        if(!imgObj || !(imgObj instanceof HTMLImageElement) ) return false;
        if(exec){
          (function(){
            var UI = Components.classes["@mozilla.org/intl/scriptableunicodeconverter"].
                  createInstance(Components.interfaces.nsIScriptableUnicodeConverter);
            UI.charset = "UTF-8";
            var query, message;
            message = UI.ConvertToUnicode("16 x 16px に変換しますか?");
            if(imgObj.localName == "IMG"){
              query = convertIconDataToBase64Format(imgObj.src,confirm(message));
            }
            if(query != null && query != ""){
              Components.classes["@mozilla.org/widget/clipboardhelper;1"]
                  .getService(Components.interfaces.nsIClipboardHelper).copyString(query);
            }
            //
            //Thanks Milx https://addons.mozilla.org/firefox/3698/
            function convertIconDataToBase64Format(iconURI,flg){
                var canvas = document.createElementNS("http://www.w3.org/1999/xhtml", "html:canvas");
                var image = document.createElementNS("http://www.w3.org/1999/xhtml", "html:img");
                image.src = iconURI;
                if(flg){
                  canvas.width = canvas.height = 16;
                }else{
                  canvas.width = image.width;
                  canvas.height = image.height;
                }
                var ctx = canvas.getContext('2d');
                ctx.drawImage(image, 0, 0, canvas.width, canvas.height);
                return canvas.toDataURL();
            }
          })();
        }else{
          this._setStatusMessage((this.locale=="en")?'Base64 encode, copy Clip Board'
                                                    :'画像をBase64エンコードしクリップボードにコピー', 0);
        }
        return true;
    //選択範囲のリンクを開く(最初のタブのみ前面))
    case 'RUL':
        //選択範囲のリンクを得る
        var links = DragNGo.getSelectedLinks();
        //リンクあるか?
        if(links.length<1) return false;
        if(exec){
          (function openMultipleLinks(inBackground){
            var firstTime = true;
            (function x(i){
              if(i>links.length-1)return;
              if(links[i].href){
                DragNGo.openURL(aEvent, aDragSession, links[i].href, null, gBrowser.currentURI,
                                 inBackground?'NTB':(firstTime?'NTF':'NTB'), true)
                firstTime = false;
              }
              setTimeout(function(i){x(i)},0,++i);
            })(0);
            return true;
          })(false);
        }else{
          this._setStatusMessage((this.locale=="en")?'Open selected links'
                                                    :'選択範囲のリンクを開く', 0);
        }
        return true;

    //選択範囲のリンクに対してcopy URLを実行(CopyURLLite_mod1.uc.jsが必要)
    case 'LUR':
        //選択範囲のリンクを得る
        var links = DragNGo.getSelectedLinks();
        //リンクあるか?
        if(links.length<1) return false;
        if(exec){
          if (typeof copyUrlLitePlus != 'undefined') {
            copyUrlLitePlus.setLinks(links);
            copyUrlLitePlus.showHotmenu(null, aEvent.screenX, aEvent.screenY);
          }
        }else{
          this._setStatusMessage((this.locale=="en")?'copy URL for selected links'
                                                    :'選択範囲のリンクにcopy URL', 0);
        }
        return true;

    //リンクをドラッグ リンク表示文字列でWeb検索
    case 'DL': //LINKとダブらないように ここは任意
        {
          //modifier キー押してる? (LINKとダブらないように)
          if (aEvent.ctrlKey || aEvent.shiftKey || aEvent.altKey) return false;

          //リンクでない?
          var SourceNode = aDragSession.sourceNode;
          while(SourceNode){
            if (SourceNode instanceof HTMLAnchorElement ||
                 SourceNode instanceof HTMLAreaElement)
              break;
            SourceNode = SourceNode.parentNode;
          }
          if (!SourceNode) return false;
          //リンクテキストがない?
          var word = gatherTextUnder(SourceNode);
          if (!word) return false;
          //検索エンジンげと
          var engine = DragNGo.getEngine("Default");
          if (!engine)  return false;

          if (exec){
            //文字列を検索エンジンで検索しNewTabFocus
            DragNGo.openSearch(engine, word, "NTF");

          } else {
            this._setStatusMessage((this.locale=="en")?'Google Search with Link Text'
                                                      :'リンクをドラッグ リンク表示文字列でWeb検索', 0);
          }
          return true;
        }

    //リンク or リンク化imageの保存(ctrl押下時) a要素内の一つめのimg要素のみしか対応してないよ
    case 'R': //LINKとダブらないように ここは任意
        {
          var url, msg;
          if (aEvent.altKey )
            return false;
          //shift押下時
          if (aEvent.shiftKey){
            func = 'E3'; //外部アプリ3番目
          } else {
            func = 'S'; //保存
            //func = ('saveFolderModoki' in window) ? 'SF0' : 'S'; //保存
          }

          //a要素
          var SourceNode = aDragSession.sourceNode;
          while (SourceNode &&
                 !(SourceNode instanceof HTMLAnchorElement ||
                   SourceNode instanceof HTMLAreaElement)){
            SourceNode = SourceNode.parentNode;
          }
          if (!SourceNode)
            return false;

          if (SourceNode instanceof HTMLAnchorElement ||
              SourceNode instanceof HTMLAreaElement){
            url = SourceNode.href;
            msg = {en:' link', ja:'リンクを'};
          }
          //ctl押下時はリンク化イメージがあればそれを優先することに
          if (aEvent.ctrlKey){
            //img要素ある?
            var img = SourceNode.ownerDocument.
                                 evaluate('.//*[contains(" img IMG ", concat(" ", local-name(), " "))]',
                                          SourceNode,
                                          null,
                                          XPathResult.FIRST_ORDERED_NODE_TYPE,
                                          null);
            if (img && img.singleNodeValue){
              SourceNode = img.singleNodeValue;
              url = img.singleNodeValue.src;
              msg = {en:' Linked Image', ja:'リンク化イメージを'};
            }
          }

          if (!url)
            return false;

          if (exec){
            this.sourcenode = SourceNode;
            this.openURL(aEvent, aDragSession, url, aText, null, func, true);
          } else {
            this._setStatusMessage((this.locale=='en')?
                       this.DISP[func].en + msg.en :
                       msg.ja + this.DISP[func].ja, 0);
          }
          return true;
        }











     default:
        return false; //ジェスチャに該当しないのでfalseを返す
  }
}
//ここまで
// --- config ---
/* 200/10/07 02:00仮パッチ
    // Patch For checked in Bug 456048 - Use the new D&D API in tabbrowser
    // Patch For Bug 458070 -  Dragging a url to the tabbar loads it in multiple tabs
    if ('_onDrop' in gBrowser && this.getVer() > 3.0){
      var content = document.getElementById("content");
      content.removeAttribute("ondragdrop");
      content.setAttribute("ondrop", "nsDragAndDrop.drop(event, contentAreaDNDObserver);");
      var statusbar = document.getElementById("status-bar");
      statusbar.removeAttribute("ondragdrop");
      statusbar.setAttribute("ondrop", "nsDragAndDrop.drop(event, contentAreaDNDObserver);");
    }
*/
    this.DORPPING_TAB = DORPPING_TAB;
    this.RESET_GESTURE = RESET_GESTURE; RESET_GESTURE = null;
    this.IMAGE_DROP_ONDESKTOP_SHORTCUT = IMAGE_DROP_ONDESKTOP_SHORTCUT; IMAGE_DROP_ONDESKTOP_SHORTCUT=null;
    this.E = E;           E=null;
    this.LINK = LINK;     LINK=null;
    this.XPI = XPI;       XPI=null;
    this.IMAGE = IMAGE;   IMAGE=null;
    this.SEARCH = SEARCH; SEARCH=null;
    this.SIDEBAR = SIDEBAR;SIDEBAR=null;
    this.OUTSIDE = OUTSIDE;OUTSIDE=null;
    this.SF = SF; SF=null;
    this.DISP=[];
    this.DISP["NTF"] = {en:"open with New Tab Forground",ja:"新規タブ 前面 に開く"};
    this.DISP["NTB"] = {en:"open with New Tab Background",ja:"新規タブ 背面 に開く"};
    this.DISP["C"] = {en:"open with Current Tab",ja:"現在のタブに開く"};
    this.DISP["W"] = {en:"open with New Wndow",ja:"新しいウインドウに開く"};
    this.DISP["I"] = {en:"Install",ja:"インストールする"};
    this.DISP["S"] = {en:"Save",ja:"保存する"};
    this.DISP[""] = {en:"",ja:""};
    var UI = Components.classes["@mozilla.org/intl/scriptableunicodeconverter"].
          createInstance(Components.interfaces.nsIScriptableUnicodeConverter);
    UI.charset = "UTF-8";
    for(var i=0;i<9;i++){
      if(this.SF[i]==''){
        this.DISP["SF"+i] = {en:"Popup Save Folder Menu" ,ja:"Save Folder メニュー"};
      }else{
        this.DISP["SF"+i] = {en:"Save to "+this.SF[i] ,ja:"【"+ this.SF[i]+ "】に保存"};
        this.SF[i] = UI.ConvertToUnicode(this.SF[i]);
      }
    }
    for(var i=1;i<9;i++){
      this.DISP["E"+i] = {en:"External apprication"+this.E[i].path ,ja:"外部アプリ 【"+ this.E[i].path+ "】 で開く"};
    }
    this.dataRegExp     = /^\s*(.*)\s*$/m;
    this.mdataRegExp    = /(^\s*(.*)\s*\n?)*$/m;
    this.linkRegExp     = /(((h?t)?tps?|h..ps?|ftp|file):\/\/.+)/i;
    this.xpiFileRegExp  = /^file:\/{3}(?:.*\/)?(.+\.(xpi|jar))$/i;
    this.xpiLinkRegExp  = /^https?:\/{2}(?:.*\/)?(.+\.(xpi|jar))$/i;
    this.textRegExp     = /(^h?.?.ps?:\/\/)|(^ftp:)|(^file:\/{3})|(^data:)|(^\(?javascript:)|(^localhost:).+$/i;
    this.imageLinkRegExp = /^((https?:\/{2})|(file:\/{3}))(?:.*\/)?(.+\.(png|jpg|jpeg|gif|bmp))$/i;
    this.locale = Components.classes["@mozilla.org/preferences-service;1"]
                  .getService(Components.interfaces.nsIPrefBranch);
    this.locale = this.locale.getCharPref("general.useragent.locale").indexOf("ja") == -1 ? "en" : "ja";
      gBrowser.addEventListener("dragover", function(aEvent) {
        nsDragAndDrop.dragOver(aEvent, contentAreaDNDObserver);
      }, false);
      gBrowser.addEventListener("dragexit", function(aEvent) {
        nsDragAndDrop.dragExit(aEvent, contentAreaDNDObserver);
      }, false);
      gBrowser.addEventListener("draggesture", function(aEvent) {
        nsDragAndDrop.startDrag(aEvent, contentAreaDNDObserver);
      }, true);
  },

  uninit: function(){
      gBrowser.removeEventListener("dragover", function(aEvent) {
        nsDragAndDrop.dragOver(aEvent, contentAreaDNDObserver);
      }, false);
      gBrowser.removeEventListener("dragexit", function(aEvent) {
        nsDragAndDrop.dragExit(aEvent, contentAreaDNDObserver);
      }, false);
      gBrowser.removeEventListener("draggesture", function(aEvent) {
        nsDragAndDrop.startDrag(aEvent, contentAreaDNDObserver);
      }, true);
  },

  debug: function(aMsg){
    try{
          Cc["@mozilla.org/consoleservice;1"]
          .getService(Ci.nsIConsoleService)
          .logStringMessage(decodeURIComponent(escape(aMsg)));
    }catch(ex){
        Cc["@mozilla.org/consoleservice;1"]
          .getService(Ci.nsIConsoleService)
          .logStringMessage(aMsg);
    }
  },


  //"E2,E3"の文字列からアプリのパス E[2].path+ ', '+ E[3].path にして返す
  _getAppPath: function(k){
    var ex = k.split(',');
    var p = '';
    for(var i= 0;i< ex.length;i++){
      var n = ex[i].match(/\d/);
      if(n>0 && n<9){
        p = p + ',【' +this.E[n].path + '】';
      }
    }
    return p.replace(/^,/,'');
  },
  //kindをkで開く を返す, ここにkind:ドラッグ対象, kは外部アプリ"E2,E3"のような文字列
  _makeDisplay: function(kind,k){
    return  (this.locale=="en")
    ?'Open '+ kind + ' with ' + this._getAppPath(k)
    :kind +'を ' + this._getAppPath(k) +' で開く';
  },
  //ステータスバーに文字列を表示, timeToClearミリ秒後自動クリア
  _setStatusMessage: function(msg, timeToClear, flg) {
    const Cc = Components.classes;
    const Ci = Components.interfaces;
    const UI = Cc["@mozilla.org/intl/scriptableunicodeconverter"].
          createInstance(Ci.nsIScriptableUnicodeConverter);
    UI.charset = "UTF-8";
    var statusBar = document.getElementById("statusbar-display");
    if (!statusBar) return;
    try{
      if(msg!=''){
        statusBar.label = ((!flg)?(this.directionChain + ' : '):'') + UI.ConvertToUnicode(msg);
      }else{
        statusBar.label = '';
      }
    }catch(e){
      statusBar.label = '';
    }
    if(this._timer) clearTimeout(this._timer);
    this._timer = setTimeout(function(){
      statusBar.label=(DragNGo.locale=="en")?'Done':UI.ConvertToUnicode('完了');
    }, !timeToClear?1500:timeToClear);
  },

  isParentEditableNode : function(node) {
    try {
      if (Components.lookupMethod(node.ownerDocument, 'designMode').call(node.ownerDocument) == 'on')
        return node;
    } catch(e) {
    }
    while (node && node.parentNode) {
      try {
        node.QueryInterface(Ci.nsIDOMNSEditableElement);
        return node;
      }
      catch(e) {
      }
      node = node.parentNode;
    }
    return null;
  },

  //Fxのバージョン
  get appVer(){
    const Cc = Components.classes;
    const Ci = Components.interfaces;
    var info = Cc["@mozilla.org/xre/app-info;1"].getService(Ci.nsIXULAppInfo);
    var ver = parseInt(info.version.substr(0,3) * 10,10) / 10;
    return ver;
  },

  //選択範囲のリンクを得る
  //thanks piro
  getSelectedLinks: function(aWindow) {
    var links = [];
    if (!aWindow) aWindow = this.focusedWindow;
    var selection = aWindow.getSelection();
    if (!selection || !selection.rangeCount) return links;
    const count = selection.rangeCount;
    var range,
        node,
        link,
        nodeRange = aWindow.document.createRange();
    for (var i = 0; i < count; i++) {
      selectionRange = selection.getRangeAt(i);
      node           = selectionRange.startContainer;
      traceTree:
      while (true) {
        nodeRange.selectNode(node);
        if (nodeRange.compareBoundaryPoints(Range.START_TO_END, selectionRange) > -1) {
          if (nodeRange.compareBoundaryPoints(Range.END_TO_START, selectionRange) > 0) {
            if (
              links.length &&
              selectionRange.startContainer.nodeType != Node.ELEMENT_NODE &&
              selectionRange.startOffset == selectionRange.startContainer.nodeValue.length &&
              links[0] == getParentLink(selectionRange.startContainer)
              )
              links.splice(0, 1);
            if (
              links.length &&
              selectionRange.endContainer.nodeType != Node.ELEMENT_NODE &&
              selectionRange.endOffset == 0 &&
              links[links.length-1] == getParentLink(selectionRange.endContainer)
              )
              links.splice(links.length-1, 1);
            break;
          }
          else if ((link = getParentLink(node)))
            links.push(link);
        }
        if (node.hasChildNodes() && !link) {
          node = node.firstChild;
        } else {
          while (!node.nextSibling) {
            node = node.parentNode;
            if (!node) break traceTree;
          }
          node = node.nextSibling;
        }
      }
    }
    function getParentLink(aNode) {
      var node = aNode;
      while (!node.href && node.parentNode)
        node = node.parentNode;
      return node.href ? node : null ;
    }
    nodeRange.detach();
    return links;
  },

  //appPathをparamsで開く, paramsはtxtで置き換えcharsetに変換される
  launch: function launch(appPath,params,charset,txt){
    var UI = Components.classes["@mozilla.org/intl/scriptableunicodeconverter"].
          createInstance(Components.interfaces.nsIScriptableUnicodeConverter);
    UI.charset = charset;

    var appfile = Components.classes['@mozilla.org/file/local;1']
                    .createInstance(Components.interfaces.nsILocalFile);
    appfile.initWithPath(decodeURIComponent(escape(appPath)));
    if (!appfile.exists()){
      alert("Executable does not exist.");
      return;
    }
    var process = Components.classes['@mozilla.org/process/util;1']
                  .createInstance(Components.interfaces.nsIProcess);

    var args = new Array();
    for(var i=0,len=params.length;i<len;i++){
      if(params[i]){
        args.push(UI.ConvertFromUnicode(params[i].replace(/%%URL%%/i,txt).replace(/%%SEL%%/i,txt)));
      }
    }
    process.init(appfile);
    process.run(false, args, args.length, {});
  },

  //現在のウインドウを得る
  get focusedWindow(){
    var win = document.commandDispatcher.focusedWindow;
    if (!win || win == window)
      win = window.content;
    return win;
  },

  //選択文字列を得る
  get selection(){
    var targetWindow = this.focusedWindow;
    var sel = Components.lookupMethod(targetWindow, 'getSelection').call(targetWindow);
    if (sel && !sel.toString()) {
      var node = document.commandDispatcher.focusedElement;
      if (node &&
          (node.type == "text" || node.type == "textarea") &&
          'selectionStart' in node &&
          node.selectionStart != node.selectionEnd) {
        var offsetStart = Math.min(node.selectionStart, node.selectionEnd);
        var offsetEnd  = Math.max(node.selectionStart, node.selectionEnd);
        return node.value.substr(offsetStart, offsetEnd-offsetStart);
      }
    }
    return sel ?
      sel.toString() : "";
  },

  //選択範囲の親要素を得る
  getSelectedNodes: function(){
    var targetWindow = this.focusedWindow;
    var selection = Components.lookupMethod(targetWindow, 'getSelection').call(targetWindow);
    try{
      var selRange = selection.getRangeAt(0);
    }catch(e){
      var selRange = selection;
    }
    if(!selRange)return null;;
    var sNode = selRange.startContainer;
    var eNode = selRange.endContainer;
    return [this.oyaNode(sNode),this.oyaNode(eNode)]
  },

//選択範囲の要素が所属するa要素を得る, a要素でないならnull
  oyaNode: function(aNode){
    var pNode = aNode;
    while(pNode && !(pNode instanceof HTMLAnchorElement || pNode instanceof HTMLAreaElement) ){
      pNode = pNode.parentNode;
    }
    return pNode;
  },

  //選択テキストがリンク要素か
  isSelectedIn: function(aNode){
    aNode = this.oyaNode(aNode);
    if(!aNode) return true;
    var selNodes = this.getSelectedNodes();
    if(!selNodes) return false;
    if(aNode == selNodes[0] && aNode == selNodes[1]) return true;
    return false;
  },

  //ドロップしたテキストを得る。選択テキストまたはリンクテキスト
  getDropText: function(aDragSession){
    var word;
    //リンクでない?
    var SourceNode = aDragSession.sourceNode;
    while(SourceNode){
      if (SourceNode instanceof HTMLAnchorElement ||
           SourceNode instanceof HTMLAreaElement)
        break;
      SourceNode = SourceNode.parentNode;
    }
    if (!SourceNode ||
       ( aDragSession.sourceNode && this.isSelectedIn(aDragSession.sourceNode))) {
      word = this.selection.replace(/\s*\n\s*/m,' ');
    } else {
      word = gatherTextUnder(SourceNode);
    }
    return word;
  },

  //aURLのcontentTypeをキャッシュから得る
  getContentType: function(aURL){
    var contentType = null;
    //var contentDisposition = null;
    try {
      var imageCache = Cc["@mozilla.org/image/cache;1"].getService(imgICache);
      var props =
        imageCache.findEntryProperties(makeURI(aURL, getCharsetforSave(null)));
      if (props) {
        contentType = props.get("type", nsISupportsCString);
        //contentDisposition = props.get("content-disposition", nsISupportsCString);
      }
    } catch (e) {
      // Failure to get type and content-disposition off the image is non-fatal
    }
    return contentType;
  },

  //検索バーを得る
  get searchBar(){
    var searchBar;
    try{
      searchBar = BrowserSearch.getSearchBar();
    }catch(e){
      searchBar = BrowserSearch.searchBar;  //fx3
    }
    return searchBar;
  },

  //検索エンジン名から検索エンジンを得る
  getEngine: function(aEngineName){
    const nsIBSS = Ci.nsIBrowserSearchService;
    const searchService = Cc["@mozilla.org/browser/search-service;1"].getService(nsIBSS);
    if(aEngineName.toUpperCase()==="CURRENT"){
      var searchBar = this.searchBar;
      if (searchBar) return searchBar.currentEngine;
    }else{
      var engine = searchService.getEngineByName(aEngineName);
      if (engine) return engine;
    }
    //Default
    return searchService.defaultEngine;
  },
  //検索バーに疑似イベント発行
  searchBardispatchEvent: function(searchText){
    var searchBar = this.searchBar;
    if(!searchBar)return;
    searchBar.value = searchText;
    var evt = document.createEvent("UIEvents");
    evt.initUIEvent("input", true, true, window, 0);
    searchBar.dispatchEvent(evt);
  },
  //ページ内検索
  findWords: function findWords(word){
    var findbar, textbox;
    var findbar = document.getElementById('FindToolbar');
    if ('gFindBar' in window && 'onFindAgainCommand' in gFindBar){ //fx3
      if(gFindBar.hidden)
        gFindBar.onFindCommand();
      gFindBar._findField.value = word;
      var evt = document.createEvent("UIEvents");
      evt.initUIEvent("input", true, false, window, 0);
      gFindBar._findField.dispatchEvent(evt);
    }else{ //fx2
      if (findbar.hidden)
        gFindBar.onFindCmd();
      textbox = document.getElementById("find-field");
      textbox.value = word;
      var evt = document.createEvent("UIEvents");
      evt.initUIEvent("input", true, false, window, 0);
      textbox.dispatchEvent(evt);
    }
  },
  //Web検索
  loadSearch: function loadSearch(engine, searchText, useNewTab, backGround, useNewWin){
    var submission = engine.getSubmission(searchText, null); // HTML response
    if (!submission)
      return;
    if (useNewWin){
      openNewWindowWith(submission.uri.spec, null, submission.postData, false)
    }else if (useNewTab) {
      gBrowser.loadOneTab(submission.uri.spec, null, null, submission.postData, backGround, false);
      this.searchBardispatchEvent(searchText);
    }else
      gBrowser.loadURI(submission.uri.spec, null, submission.postData, false);
      this.searchBardispatchEvent(searchText);
  },
  //Web検索前処理
  openSearch: function openSearch(engine, word, func){
    switch(func.toUpperCase()){
      case "NTF":
      case "NTB":
        this.loadSearch(engine, word, gBrowser.mCurrentBrowser.docShell.busyFlags || gBrowser.mCurrentBrowser.docShell.restoringDocument || gBrowser.currentURI.spec != "about:blank", func.toUpperCase()!="NTF", false);
        break;
      case "C":
      case "W":
        this.loadSearch(engine, word, false, false, func.toUpperCase()=="W");
        break;
    }
    if(!func.match(/^E/i)) return;
    var f = func.toUpperCase().split(',');
    for(var i=0,len=f.length;i<len;i++){
      var j = f[i].match(/\d/);
      try{
        if(new RegExp(this.E[j].include,'i').test(word) ){
          this.launch(this.E[j].path, this.E[j].params, this.E[j].code, word);
          break;
        }
      }catch(ex){}
    }
  },
  //Xpiのインストール
  installXpi: function installXpi(aEvent, aDragSession, url, fname){
    var xpinstallObj = {};
    try{
      gBrowser.dragDropSecurityCheck(aEvent, aDragSession, url);   //セキュリテイチェック
    }catch(e){
      return;
    }
    xpinstallObj[fname] = url;
    for(var i=1; i<aDragSession.numDropItems; i++){ // allow to install several extensions at once
      url = this._getDroppedURL(aDragSession, i);
      url = this._getDroppedURL_Fixup(url);
      if (url && (this.xpiFileRegExp.test(url) || this.xpiLinkRegExp.test(url)) ){
        try{
          gBrowser.dragDropSecurityCheck(aEvent, aDragSession, url);  //セキュリテイチェック
        }catch(e){
          return;
        }
        xpinstallObj[RegExp.$1] = url;
      }
    }
    InstallTrigger.install(xpinstallObj);
  },
  //ファイルのパスをインプットフィールドに記入
  putFilePath: function putFilePath(aEvent, aDragSession, url){
    //Get File Path and copy to input field.
    try{
      gBrowser.dragDropSecurityCheck(aEvent, aDragSession, url);  //セキュリテイチェック
    }catch(e){
      return;
    }
    aEvent.preventDefault();
    aEvent.stopPropagation();
    try{
      var ioService = Cc["@mozilla.org/network/io-service;1"].getService(Ci.nsIIOService);
      var fileHandler = ioService.getProtocolHandler("file").QueryInterface(Ci.nsIFileProtocolHandler);
      var aFile = fileHandler.getFileFromURLSpec(url);
      aEvent.target.value = aFile.path;
    }catch(e){
      //alert("Drag de Go fails to Get File Path");
    }
  },
  //urlを開く
  openURL: function openURL(aEvent, aDragSession, url, text, referer,func,isLink){
    try{
      gBrowser.dragDropSecurityCheck(aEvent, aDragSession, url);  //セキュリテイチェック
    }catch(e){
      return;
    }
    var prefSvc = Components.classes["@mozilla.org/preferences-service;1"]
                                   .getService(Components.interfaces.nsIPrefBranch2);
    prefSvc = prefSvc.getBranch(null);
    if(url){
      switch(func.toUpperCase()){
        case "NTF":
        case "NTB":
          if ( !gBrowser.mCurrentBrowser.docShell.busyFlags
               && !gBrowser.mCurrentBrowser.docShell.restoringDocument
               && gBrowser.currentURI.spec == "about:blank"){
            gBrowser.loadURI(url, null, null, false);
          }else{
            if (!!isLink && 'TreeStyleTabService' in window)
              TreeStyleTabService.readyToOpenChildTab(gBrowser.selectedTab);
            if(!!isLink){
              // should we open it in a new tab?
              var loadInBackground;
              try {
                loadInBackground = prefSvc.getBoolPref("browser.tabs.loadInBackground");
              }catch(ex) {
                loadInBackground = true;
              }
              prefSvc.setBoolPref("browser.tabs.loadInBackground",func.toUpperCase()!="NTF");
              if (this.appVer > 2){ //fx3
                openNewTabWith(url, referer?gBrowser.selectedBrowser.contentDocument:null, null, null, false);
              }else{
                openNewTabWith(url, referer?referer.spec:null, null, null, false);
              }
              prefSvc.setBoolPref("browser.tabs.loadInBackground",loadInBackground);
            }else{
              var newTab = gBrowser.addTab(url, referer,null,null,gBrowser.selectedTab);
              if (func.toUpperCase()=="NTF") gBrowser.selectedTab = newTab;
            }
          }
          break;
        case "C":
          gBrowser.loadURI(url, null, null, false);
          break;
        case "W":
          openNewWindowWith(url, null, null, false)
          break;
        case "S": // Save as
          var contentType = this.getContentType(url);
          if (this.imageLinkRegExp.test(url) ||/^image\//i.test(contentType)){
            if (/^data:/.test(url))
              saveImageURL(url, "index.png", null, true, false, referer );
            else
              saveImageURL(url, null, null, false, false, referer );
          }else{
            this.saveURL(url, text, null, true, false, referer );
          }
          break;
      }
      if(DragNGo.sourcenode && typeof saveFolderModoki != 'undefined' && func.match(/^SF\d/i)){
        saveFolderModoki.sourcenode = DragNGo.sourcenode;

        var j = func.match(/\d/);
        if(this.SF[j]==''){
          saveFolderModoki.showHotMenu(aEvent.screenX, aEvent.screenY);
        }else{
          saveFolderModoki.saveLink(url, text, this.SF[j]);
        }
        return;
      }
      if(!func.match(/^E/i)) return;
      var f = func.toUpperCase().split(',');
      for(var i=0,len=f.length;i<len;i++){
        var j = f[i].match(/\d/);
        try{
          if(new RegExp(this.E[j].include,'i').test(url) ){
            this.launch(this.E[j].path, this.E[j].params, this.E[j].code, url);
            break;
          }
        }catch(ex){}
      }
    }
  },
  //urlを名前を付けて保存
  saveURL: function saveURL(aURL, aFileName, aFilePickerTitleKey, aShouldBypassCache,
                 aSkipPrompt, aReferrer){
    window.saveURL(aURL, aFileName, aFilePickerTitleKey, aShouldBypassCache,
                 aSkipPrompt, aReferrer)
  },
  //URLのfixUP
  _getDroppedURL_Fixup: function(url) {
    if(!url) return null;
    if (/^h?.?.p(s?):(.+)$/i.test(url)){
      url = "http" + RegExp.$1 + ':' + RegExp.$2;
      if(!RegExp.$2) return null;
    }
    var URIFixup = Components.classes['@mozilla.org/docshell/urifixup;1']
                 .getService(Components.interfaces.nsIURIFixup);
    try{
      url = URIFixup.createFixupURI(url, URIFixup.FIXUP_FLAG_ALLOW_KEYWORD_LOOKUP ).spec;
      // valid urls don't contain spaces ' '; if we have a space it
      // isn't a valid url, or if it's a javascript: or data: url,
      // bail out
      if (!url ||
          !url.length ||
           url.indexOf(" ", 0) != -1 ||
           /^\s*javascript:/.test(url) ||
           /^\s*data:/.test(url) && !/^\s*data:image\//.test(url))
        return false;
      return url;
    }catch(e){
      return false;
    }
  },
  //D&DされるべきURLを得る
  _getDroppedURL: function(aDragSession, aIx) {
    try{
      var xfer = Components.classes["@mozilla.org/widget/transferable;1"].createInstance(Components.interfaces.nsITransferable);
      xfer.addDataFlavor("text/x-moz-url");
      xfer.addDataFlavor("text/plain");
      xfer.addDataFlavor("application/x-moz-file", "nsIFile");
      aDragSession.getData(xfer, aIx);

      var flavour = {}, data = {}, length = {};
      xfer.getAnyTransferData(flavour, data, length);
      if (data && flavour) {
        //this.debug(flavour.value);
        var type = flavour.value;
        var modtype = (type == "text/unicode") ? "text/plain" : type;
        var xferData = new FlavourData(data.value, length.value, contentAreaDNDObserver.getSupportedFlavours().flavourTable[modtype]);
        return transferUtils.retrieveURLFromData(xferData.data, xferData.flavour.contentType);
      } else {
        return null;
      }
    }catch (ex){
      return null;
    }
  },
  //D&Dオブジェクトデータを得る
  getTransferData : function(aContentType, aDragSession){
    const Cc = Components.classes;
    const Ci = Components.interfaces;
    var transfer = Cc["@mozilla.org/widget/transferable;1"].
        createInstance(Ci.nsITransferable);
    transfer.addDataFlavor(aContentType);
    aDragSession.getData (transfer, 0);
    var Data = {};
    Data.dataObj = new Object();
    Data.len = new Object();
    try{
      transfer.getTransferData(aContentType, Data.dataObj, Data.len);
    } catch (ex) {}
    return Data;
  },
  //D&Dの方向を得る
  _getdirection: function(aEvent){
    // 認識する最小のマウスの動き
    const tolerance = 10;
    var x = aEvent.screenX;
    var y = aEvent.screenY;

    //直前の座標と比較, 移動距離が極小のときは無視する
    var distanceX = Math.abs(x - this._lastX);
    var distanceY = Math.abs(y - this._lastY);
    if (distanceX < tolerance && distanceY < tolerance)
      return this.directionChain;

    // 方向の決定
    var direction;
    if (distanceX > distanceY*2)
        direction = x < this._lastX ? "L" : "R";
    else if (distanceX*2 < distanceY)
        direction = y < this._lastY ? "U" : "D";
    else {
        this._lastX = x;
        this._lastY = y;
        return this.directionChain;
    }
    // 前回の方向と比較して異なる場合はdirectionChainに方向を追加
    var lastDirection = this.directionChain.charAt(this.directionChain.length - 1);
    if (direction != lastDirection) {
      this.directionChain += direction;
    }
    // 今回の位置を保存
    this._lastX = x;
    this._lastY = y;

    //directionChainの最後が RDLU ならdirectionChainをリセットする
    if(new RegExp('.+' + this.RESET_GESTURE,'').test(this.directionChain)) {
      this.directionChain ='';
      this._setStatusMessage('', 0);
      return this.directionChain;
    }

    return this.directionChain;
  },
  //dropしたときの場合分け execがtrueで実行, falseで実行せずステータスバー表示
  drop: function drop(aEvent, aXferData, aDragSession, exec){
    const Cc = Components.classes;
    const Ci = Components.interfaces;
    const UI = Cc["@mozilla.org/intl/scriptableunicodeconverter"].
          createInstance(Ci.nsIScriptableUnicodeConverter);
    UI.charset = "UTF-8";
    const IO_SERVICE = Cc['@mozilla.org/network/io-service;1']
                         .getService(Ci.nsIIOService);
    if(exec){
      this._lastX = null;
      this._lastY = null;
        /*
        //仮のFix Bug 459334 - Drag and Drop issue の2番目(後で 取り除く)
        if(aEvent.target.type && aEvent.target.type.match(/text/i) &&
           !aEvent.target.localName.match(/select/i) ){
          return true;
        }
        */
        try{
          //仮のFix Bug 459334 - Drag and Drop issue の1番目(後で 取り除く)
          if (this.appVer > 3.0 &&
              (aEvent.target.hasAttribute('ondragover') ||
               aEvent.target.hasAttribute('ondorp')) ){
            return true;
          }
        }catch(e){}

    }

    // Tree Style Tab 0.8.2009090201 のタブバーのドロップは無視
    if (typeof aEvent.dataTransfer != "undefined") { //Firefox 3.5 or later
      var types = aEvent.dataTransfer.mozTypesAt(0);
      if ("TreeStyleTabService" in window &&
          types[0] == TreeStyleTabService.kDRAG_TYPE_TABBAR) {
        return false;
      }
    } else {
      //
    }

    var SourceNode = aDragSession.sourceNode;
    // Firefox3.5のタブのドロップはデフォルト挙動に
    var tab = SourceNode;
    while (tab) {
      if (tab instanceof XULElement && tab.localName == 'tab' &&
          tab.ownerDocument.defaultView instanceof ChromeWindow &&
          this.DORPPING_TAB == "DETACH") {
        this.debug('tab will be detached ');
        if (exec)
          contentAreaDNDObserver.__preDnG_onDrop(aEvent, aXferData, aDragSession);

        return false;
      }
      if (tab instanceof XULElement && tab.localName == 'tab' &&
          tab.ownerDocument.defaultView instanceof ChromeWindow &&
          this.DORPPING_TAB != "DETACH") {
        this.debug('tab was dropped ');
        var uri = tab.linkedBrowser.currentURI;
        var spec = uri ? uri.spec : "about:blank";
        if (exec) {
          if (aEvent.ctrlKey)
            this.openURL(aEvent, aDragSession, spec, null,  null, "NTB", false);
          else
            gBrowser.reloadTab(tab);
        }
        return true;
      }
      tab = tab.parentNode;
    }


    var direction = this.directionChain;
    var urlFromData = DragNGo.url;
    var url = urlFromData;
    if (typeof urlFromData != 'undefined' && urlFromData.match(/(.*)\n/m)){
      url = urlFromData.match(/(.*)\n/m)[0];
    }

//from outside of browser
    //Get File Path and copy to input field.
    if(url && aEvent.target && aEvent.target.localName
        && aEvent.target.localName.match(/INPUT/i)
        && aEvent.target.type && aEvent.target.type.match(/file/i)){
      //this.debug('file path : '+url);
      if(!SourceNode ){
        if(exec){
          this.putFilePath(aEvent, aDragSession, url);
        }else
          this._setStatusMessage((this.locale=="en")?'Put file path':'ファイルのパスを記入', 0, true)
        return true;
      }else{
        DragNGo._setStatusMessage( '', 0);
        return false;
      }
    }

    /*Firefox seems to never delete Image temp-files produced by drag_and_drop.
     *So delete it. Bug#245861
     */
    if(exec && SourceNode && aDragSession.isDataFlavorSupported("application/x-moz-file")){
      var transData = this.getTransferData("application/x-moz-file", aDragSession);
      if(transData.dataObj.value){
        var tempFile = transData.dataObj.value.QueryInterface(Ci.nsIFile);
        if(tempFile.exists()) {
          setTimeout(function(){
            try{
              if(tempFile.exists()) {
                tempFile.remove(false);
              }
            }catch(e){
              ////DragNGo.debug("Fails to delete image ;" + e);
            }
          }, 1000);
        }
      }
    }

//from outside and sidebar
    var mes0 = '';
    var i= aEvent.shiftKey?1:0 + aEvent.ctrlKey?2:0;
    i = (i>2)?2:i;
    if(url && !SourceNode) {
      var WHERE = this.OUTSIDE[i];
      var mes0 = 'outside ';
      var mes1 = (this.locale=="en")?'outside ':'外部の';
    }else{
      if (SourceNode && !/tabbrowser/.test(SourceNode.nodeName) ) {
        var sourceWin = SourceNode.ownerDocument.defaultView.top;
      }else if (SourceNode) {
        var sourceWin = SourceNode.contentDocument.defaultView.top;
      }
      var targetWin = aEvent.target.ownerDocument.defaultView.top;

      if( sourceWin != targetWin){
        var WHERE = this.SIDEBAR[i];
        var mes0 = 'sidebar ';
        var mes1 = (this.locale=="en")?'sidebar ':'サイドバー等の';
      }
    }

    if(mes0 != ''){
      url = (this.dataRegExp.test(urlFromData))?RegExp.$1:null;
      //xpi file from outside of browser
      if (this.xpiFileRegExp.test(url) ){
        //this.debug('outside or sidebar xpi : '+url);
        var fname = RegExp.$1;
        if(exec){
          this.installXpi(aEvent, aDragSession, url, fname);
        }else
          this._setStatusMessage((this.locale=="en")?('install ' + mes1 + 'xpi file')
                                               :(mes1 + 'xpiファイルをインストール'), 0, true);
        return true;
      }
      //Text or html file from outside of browser
      if(!this.textRegExp.test(url) ){
        //文字列のドロップ
        //this.debug('outside or sidebar text : '+url);
        if(exec){
          this.openSearch(this.getEngine("Default"), url, WHERE);
        }else
          (this.locale=="en")
            ?this._setStatusMessage(mes1 + 'text '+ this.DISP[WHERE].en, 0, true)
            :this._setStatusMessage(mes1 + '文字列を '+ this.DISP[WHERE].ja, 0, true);
        return true;
      }
      //リンクやファイル実体のドロップ
      url = (this.dataRegExp.test(urlFromData))?RegExp.$1:null;
      var contentType = this.getContentType(this._getDroppedURL(aDragSession, 0));
      if (this.imageLinkRegExp.test(url) || /^image\//i.test(contentType)){
        var kind = (this.locale=="en")?'image ':'画像を';
      }else if(this.linkRegExp.test(url)) {
        var kind = (this.locale=="en")?'link ':'リンクを';
      }
      url = this._getDroppedURL_Fixup(url);
      if(url){
        //this.debug('outside or sidebar '+kind + ' : '+url + '\nnum' + aDragSession.numDropItems);
        if(exec){
          var arrURL=[];
          var self = this;
          var text = url;
          if(!SourceNode || this.imageLinkRegExp.test(url) || /^image\//i.test(contentType)){
            try{
              try{
                text = urlFromData.match(/(.*)\n(.*)/m)[2];
              }catch(e){}
              this.openURL(aEvent, aDragSession, url, text,  null, WHERE, false);
              var i1 = 1;
            }catch(e){
              gBrowser.dragDropSecurityCheck(aEvent, aDragSession, this._getDroppedURL(aDragSession, 0));
              return false;
              this.debug('キャッシュファイルを用いることはセキュリテイ上フェイルする(JavaScriptを有効にしておけばフェイルしないと思われる),従ってキャッシュを用いずに実urlを参照するものとする。')
              //セキュリテイチェック ここでフェイルになってもopenURLの方で再チェックしているのでOK
              var i1 = 0;
            }
          }else{
            try{
              text = urlFromData.match(/(.*)\n(.*)/m)[2];
            }catch(e){}
            this.openURL(aEvent, aDragSession, url, text, null, WHERE, false);
            var i1 = 1;
          }

          for(var i=i1; i<aDragSession.numDropItems; i++){
            url = this._getDroppedURL(aDragSession, i);
            arrURL.push(this._getDroppedURL_Fixup(url));
          }
          (function x(i){
            if(i < arrURL.length){
              if(arrURL[i]){
                self.openURL(aEvent, aDragSession, arrURL[i], arrURL[i], null, WHERE)
              }
              setTimeout(function(i){x(i)},0,++i);
            }
          })(0);
        }else
          (this.locale=="en")
            ?this._setStatusMessage(mes1 + kind + this.DISP[WHERE].en, 0, true)
            :this._setStatusMessage(mes1 + kind + this.DISP[WHERE].ja, 0, true);
        return true;
      }

      //外部からのドラッグだったがどれにも該当しなかった
      if(exec){
        //contentAreaDNDObserver.__preDnG_onDrop(aEvent, aXferData, aDragSession);
      }else
        this._setStatusMessage( (this.locale=="en")?'default':'ブラウザ既定', 0, true)
      return false;
    }

//same window
if(direction=="" || !direction) return true;

    // The case just after the drug, prevent drop.
    if (exec && DragNGo.startTime && new Date().getTime() - DragNGo.startTime < 100) {
      DragNGo.startTime = null;
      return false;
    }

//TEXT

    var word = this.selection.replace(/\s*\n\s*/m,' ');
    word = word.substring(0,1024);
    url = !!url&&(this.dataRegExp.test(url.replace(/\s*\n\s*/m,' ')))?RegExp.$1:'';

    if (this.SEARCH[direction] &&
        word != '' &&
        !this.textRegExp.test(word) &&
        aDragSession.numDropItems == 1
       )
    {
      //this.debug('same window text : '+url);
      if( this.sourcenode /* && !this.sourcenode.nodeName.match(/^tabbrowser$/i)*/
         && (this.isSelectedIn(this.sourcenode)
         || !this.isSelectedIn(this.sourcenode) && word === url ) ){

        // text string
        var ACTION = this.SEARCH[direction][aEvent.shiftKey?3:1];
        var WHERE = this.SEARCH[direction][aEvent.shiftKey?2:0];
        //ページ内検索.
        if(ACTION.match(/^Page$/i)){
          if(exec)
            this.findWords(word);
          else
            this._setStatusMessage((this.locale=="en")?'Find word':'ページ内検索', 0)
          return true;
        }
        //Concuery Modoki2 メニューポップアップ.
        if(ACTION.match(/^ConQuery$/i)){
          if(typeof cqrShowHotmenu !='undefined'){
            if(exec)
              cqrShowHotmenu(null, aEvent.screenX, aEvent.screenY);
            else
              this._setStatusMessage((this.locale=="en")?'ConQuery menu':'ConQueryメニュー', 0)
          }
          return true;
        }
        //Web検索
        var searchText = word
        if (WHERE.replace(/ /g,'') != ""
            && !ACTION.match(/^(ConQuery|Page|Domain)$/i)){
          var engine = this.getEngine(UI.ConvertToUnicode(ACTION));
          if(exec){
           this.openSearch(engine, word, WHERE);
          }else{
            if(!/E[1-8]/.test(WHERE) ){
              var msg = (this.locale=="en")
                        ?'Search with ' + ACTION + ', '
                        :ACTION + ' で検索, ';
            }else{
              var msg = "";
            }
            this._setStatusMessage(msg + this.DISP[WHERE][this.locale], 0)
          }
          return true;
        }
        //ドメイン内検索
        url ='http://www.google.com/search?q=site:';
        url = url + gBrowser.currentURI.spec.split('/')[2]+' '+encodeURIComponent(word);
        if (WHERE.replace(/ /g,'') != ""
            && ACTION.match(/^Domain$/i)){
          if(exec)
            this.openURL(aEvent, aDragSession, url,null,null, WHERE, true);
          else
            (this.locale=="en")
              ?this._setStatusMessage('Search in this domain, ' + this.DISP[WHERE].en, 0)
              :this._setStatusMessage('サイト内検索, ' + this.DISP[WHERE].ja, 0);
          return true;
        }
      }
    }

//Link
    url = (this.dataRegExp.test(urlFromData))?RegExp.$1:null;
    url = this._getDroppedURL_Fixup(url);
  //xpi Link
    if (url && this.XPI[direction] && this.xpiLinkRegExp.test(url) ){
      //this.debug('same window xpi link : '+url);
      var fname = RegExp.$1;
      var ACTION = this.XPI[direction][aEvent.shiftKey?1:0];
      if (this.XPI[direction] && ACTION.replace(/ /g,'') != ""){
        switch(ACTION.toUpperCase()){
          case "I": // Linked XPI:installation
            if(exec)
              this.installXpi(aEvent, aDragSession, url, fname);
            else
              this._setStatusMessage((this.locale=="en")?'install xpi Link'
                                                        :'xpiリンクをインストール', 0)
            return true;
          case "S": // Linked XPI:Save as
            try{
              gBrowser.dragDropSecurityCheck(aEvent, aDragSession, url); //セキュリテイチェック
            }catch(e){
              return true;
            }
            if(exec)
              this.saveURL( url, fname, null, true, false, null);
            else
              this._setStatusMessage((this.locale=="en")?'save xpi Link':'xpiリンクを保存', 0)
            return true;
        }
        if(/SF[0-8]/.test(ACTION) ){
          if(exec){
            this.openURL(aEvent, aDragSession, url, null, null, ACTION, true);
          }else{
            this._setStatusMessage(((this.locale=="en")?'':('xpiリンクを'))+ this.DISP[ACTION][this.locale], 0);
          }
          return true;
        }
        if(/E[1-8]/.test(ACTION) ){
          try{
            gBrowser.dragDropSecurityCheck(aEvent, aDragSession, url); //セキュリテイチェック
          }catch(e){
            return true;
          }
          if(exec){
              var j = ACTION.match(/\d/);
              this.launch(this.E[j].path,this.E[j].params, this.E[j].code,url)
          }else{
            var msg = (this.locale=="en")
                      ?'xpi Link with ' + this.DISP[ACTION].en
                      :'xpiリンクを ' + this.DISP[ACTION].ja;
            this._setStatusMessage(msg, 0);
          }
          return true;
        }
      }
      aEvent.preventDefault();
      this._setStatusMessage('',0);
      return true;
    }

//image link or link

    var DIR = null;
    url = (this.dataRegExp.test(urlFromData))?RegExp.$1:null;
    //var contentType = this.getContentType(url);
    var contentType = this.getContentType(this._getDroppedURL(aDragSession, 0));
    //this.debug('url : '+(url?url:'null') );
    if (this.imageLinkRegExp.test(url) || /^image\//i.test(contentType)){
      var kind = (this.locale=="en")?'image':'画像';
      var DIR = this.IMAGE;
    }else if(this.linkRegExp.test(url)
            || ( /^data:.+/.test(url) && this.LINK[direction] && /C|S|SF/.test(this.LINK[direction][aEvent.shiftKey?1:0])) ) {
      var kind = (this.locale=="en")?'link':'リンク';
      var DIR = this.LINK;
    }
    url = this._getDroppedURL_Fixup(url);
    if(url && !!DIR && DIR[direction]){
      //this.debug('same window '+kind + ' : '+url);
      var WHERE = DIR[direction][aEvent.shiftKey?1:0];
      if (DIR[direction] && WHERE.replace(/ /g,'') != ""){
        if(exec){
          var arrURL=[];
          var self = this;
          var text = url;
          if( (this.imageLinkRegExp.test(url) || /^image\//i.test(contentType)) ){
            try{
              try{
                text = urlFromData.match(/(.*)\n(.*)/m)[2];
              }catch(e){}
              this.openURL(aEvent, aDragSession, url, text, gBrowser.currentURI, WHERE, true);
              var i1 = 1;
            }catch(e){
              gBrowser.dragDropSecurityCheck(aEvent, aDragSession, this._getDroppedURL(aDragSession, 0));
              this.debug('キャッシュファイルを用いることはセキュリテイ上フェイルする(JavaScriptを有効にしておけばフェイルしないと思われる),従ってキャッシュを用いずに実urlを参照するものとする。')
              //セキュリテイチェック ここでフェイルになってもopenURLの方で再チェックしているのでOK
              var i1 = 0;
            }
          }else{
            try{
              text = urlFromData.match(/(.*)\n(.*)/m)[2];
            }catch(e){}
            this.openURL(aEvent, aDragSession, url, text, gBrowser.currentURI, WHERE, true);
            var i1 = 1;
          }
          for(var i=i1; i<aDragSession.numDropItems; i++){
            url = this._getDroppedURL(aDragSession, i);
            arrURL.push(this._getDroppedURL_Fixup(url));
          }
          (function x(i){
            if(i < arrURL.length){
              if(arrURL[i]){
                self.openURL(aEvent, aDragSession, arrURL[i], arrURL[i], gBrowser.currentURI, WHERE, true)
              }
              setTimeout(function(i){x(i)},0,++i);
            }
          })(0);
        }else{
          if(/E\d/.test(WHERE)){
            var msg = this._makeDisplay(kind, WHERE);
            this._setStatusMessage(msg, 0);
          }else{
            this._setStatusMessage(((this.locale=="en")?'':(kind + 'を'))+ this.DISP[WHERE][this.locale], 0);
          }
        }
        return true;
      }
      aEvent.preventDefault();
      this._setStatusMessage('',0);
      return true;
    }
    //ユーザー定義(同一ウインドウ内ドロップ)
    if (typeof urlFromData != 'undefined')
      url = urlFromData.replace(/^\s|\s$/mg,'');
    var word ='';
    if(!this.selection && this.linkRegExp.test(urlFromData) ){ //2009/02/14 Priority is given to selected text
      url = RegExp.$1;
      url = this._getDroppedURL_Fixup(url);
      if(/(.*)\n?(.*)?/m.test(urlFromData) )
        word = RegExp.$2?RegExp.$2:RegExp.$1;
    }else{
      url = '';
      word = this.selection;
    }
    ////this.debug('url : '  + url + '\nword : ' + word);
    if( DragNGo.userDefined(aEvent, aXferData, aDragSession, direction, url, word , exec) ){
      return true;
    }


  //どれにも該当しなかった
    if(exec){
      //contentAreaDNDObserver.__preDnG_onDrop(aEvent, aXferData, aDragSession);
    }else
      this._setStatusMessage( (this.locale=="en")?'default':'ブラウザ既定', 0);
    return false;
  },
  clearSession: function(){
    this.last_SourceNode = null;
    this.directionChain = '';
    this.last_direction = '';
    this.last_keyCode = 99;
  }
}

//既存メソッド等置き換え
contentAreaDNDObserver.__preDnG_onDrop = contentAreaDNDObserver.onDrop || null;
contentAreaDNDObserver.onDrop = function(aEvent, aXferData, aDragSession) {
  const Cc = Components.classes;
  const Ci = Components.interfaces;
  if (DragNGo.appVer > 3.5) {
      aXferData = aEvent.dataTransfer;
      var mDragService = Cc["@mozilla.org/widget/dragservice;1"]
                         .getService(Ci.nsIDragService);
      aDragSession = mDragService.getCurrentSession();
  }
  DragNGo.drop(aEvent, aXferData, aDragSession, true)
  DragNGo.clearSession();
};

contentAreaDNDObserver.onDragOver = function(aEvent, aFlavour, aDragSession) {
  const Cc = Components.classes;
  const Ci = Components.interfaces;

          /**/
          //仮のFix Bug 459334 - Drag and Drop issue の1番目(後で 取り除く)
          if(DragNGo.appVer > 3.0 &&
             (aEvent.target.hasAttribute('ondragover') ||
              aEvent.target.hasAttribute('ondorp')) ){
            return (DragNGo.canDrop = true);
          }
  const nsIDragService = Ci.nsIDragService;
  DragNGo.directionChain = DragNGo._getdirection(aEvent);
  var _keyCode =  aEvent.altKey?1:0+aEvent.shiftKey?2:0+aEvent.ctrlKey?4:0;
  var SourceNode = aDragSession.sourceNode;

  if(!SourceNode ||
     SourceNode != DragNGo.last_SourceNode ||
     DragNGo.directionChain != DragNGo.last_direction ||
     _keyCode !== DragNGo.last_keyCode ){
    try{
      if (DragNGo.appVer > 3.0) {
        var _supportedLinkDropTypes = ["text/x-moz-url", "text/uri-list", "text/plain", "application/x-moz-file"];
        var dt = aEvent.dataTransfer;
        var url;
        for (var i=0; i < _supportedLinkDropTypes.length; i++) {
          let dataType = _supportedLinkDropTypes[i];
          // uri-list: for now, support dropping of the first URL
          // only
          var isURLList = dataType == "text/uri-list";
          let urlData = isURLList ?
                        dt.mozGetDataAt("URL", 0) : dt.mozGetDataAt(dataType, 0);
          if (urlData) {
            url = transferUtils.retrieveURLFromData(urlData, isURLList ? "text/plain" : dataType);
            break;
          }
        }
        DragNGo.url = url;

      } else {

        var transData = DragNGo.getTransferData(aFlavour.contentType, aDragSession);
        var DragData = transData.dataObj.value.
              QueryInterface(Ci.nsISupportsString).
              data.substring(0, transData.len.value);
        DragNGo.url = DragData;
      }
    }catch(e){}
    DragNGo.canDrop = DragNGo.drop(aEvent, null, aDragSession, false);
  }

  if(DragNGo.canDrop == null) DragNGo.canDrop = true;
  DragNGo.last_SourceNode = SourceNode;
  DragNGo.last_direction = DragNGo.directionChain;
  DragNGo.last_keyCode = _keyCode;

  //input , textarea
  var node = aEvent.target;
  if(SourceNode && node && node.localName && DragNGo.isParentEditableNode(node) ){
    DragNGo.last_direction = '';
    if(node.type && !node.type.match(/text/i) ||
       node.localName.match(/select/i) ){
      DragNGo._setStatusMessage( '', 0);
      DragNGo.canDrop = false;
    }else {
      DragNGo._setStatusMessage( (this.locale=="en")?'input':'記入', 0);
      DragNGo.canDrop = true;
    }
  }

  if(aEvent.keyCode == 27){
    DragNGo.clearSession();
    DragNGo.canDrop = false;
  }

  if (DragNGo.canDrop){
    aDragSession.dragAction.action = nsIDragService.DRAGDROP_ACTION_COPY |
                                     nsIDragService.DRAGDROP_ACTION_MOVE |
                                     nsIDragService.DRAGDROP_ACTION_LINK;
  } else {
    aDragSession.dragAction = nsIDragService.DRAGDROP_ACTION_NONE;
  }

  return (aDragSession.canDrop = DragNGo.canDrop);
};

contentAreaDNDObserver.canDrop = function(aEvent, aDragSession){

  var retVal = DragNGo.canDrop;
  return retVal;
};

contentAreaDNDObserver.__preDnG_onDragExit = contentAreaDNDObserver.onDragExit || null;
contentAreaDNDObserver.onDragExit = function(aEvent, aDragSession) {
};

contentAreaDNDObserver.__preDnG_onDragStart = contentAreaDNDObserver.onDragStart || null;
contentAreaDNDObserver.onDragStart = function(aEvent, aXferData, aDragAction) {
  const Cc = Components.classes;
  const Ci = Components.interfaces;
  const nsIDragService = Ci.nsIDragService;

  DragNGo.startTime = new Date().getTime();

  if (!!aDragAction)
  aDragAction.action = nsIDragService.DRAGDROP_ACTION_COPY | nsIDragService.DRAGDROP_ACTION_MOVE | nsIDragService.DRAGDROP_ACTION_LINK;

  DragNGo.clearSession();
  DragNGo._lastX = aEvent.screenX;
  DragNGo._lastY = aEvent.screenY;
  DragNGo._startX = DragNGo._lastX;
  DragNGo._startY = DragNGo._lastY;
  DragNGo.sourcenode = aEvent.originalTarget;

  var target = aEvent.originalTarget;

  // Bug 491079 -  clicking on a scroll bar with all text selected starts a drag?
  if(/^(slider|thumb|scrollbarbutton)$/.test(target.localName)) {
    aEvent.preventDefault();
  }

  if ( !this.IMAGE_DROP_ONDESKTOP_SHORTCUT
     && (target instanceof HTMLImageElement && target.src) ){
    contentAreaDNDObserver.__preDnG_onDragStart(aEvent, aXferData, aDragAction);
    return;
  }
  contentAreaDNDObserver.__preDnG_onDragStart(aEvent, aXferData, aDragAction);
  return;
};

if (DragNGo.appVer > 3.5) {
  contentAreaDNDObserver.getSupportedFlavours = function ()
    {
      var flavourSet = new FlavourSet();
      flavourSet.appendFlavour("text/x-moz-url");
      flavourSet.appendFlavour("text/unicode");
      flavourSet.appendFlavour("application/x-moz-file", "nsIFile");
      return flavourSet;
    }
}

eval("nsDragAndDrop.checkCanDrop = " + nsDragAndDrop.checkCanDrop.toString().replace("this.mDragSession.sourceNode != aEvent.target;", "$& if (!(this.mDragSession.sourceNode instanceof XULElement)) {this.mDragSession.canDrop = true;}"));

DragNGo.init();
window.addEventListener("unload", function(){ DragNGo.uninit(); }, false);
