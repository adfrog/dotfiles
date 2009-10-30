/*
 * @name            linkpad.js
 * @description     like LinkPad of Netscape.
 * @description-ja  ネットスケープのLinkPadのようなもの。
 * @author          wocota <wocota@gmail.com>
 * @version         0.01
 *
 * LICENSE
 *   Public Domain http://creativecommons.org/licenses/publicdomain/
 *
 * USAGE
 *   :linkpad [site]
 *     LinkPadに登録されているサイトを表示。選択して開く。開くと勝手にLinkPadから消える。
 *   :addlinkpad
 *     LinkPadに登録。
 * 
 */

liberator.plugins.exLinkPad = (function(){
  var linkpad = storage.newMap("linkpad", true);
  var links = [];
  // view links list and open link
  commands.addUserCommand(['linkpad'],' linkpad ',
                          function (args){
                            let arg     = args.literalArg;
                            let num = arg.match(/^\d+/);
                            if(num > 0){
                              liberator.plugins.exLinkPad.open(links[--num][1], liberator.NEW_TAB);
                            } else {
                              liberator.echoerr("Error!:not set");
                            }
                          },{
                            completer: function(context) liberator.plugins.exLinkPad.list(context),
                            argCount: "?",
                            bang: true,
                            count: true,
                            literal: 0
                          }
  );
  // add link of current tab
  commands.addUserCommand(['addlinkpad'],' addlinkpad ',
                          function (){
                            liberator.plugins.exLinkPad.add(buffer.URL, buffer.title);
                          }
  );
  
  return {
    add: function add(url, name)
    {
      linkpad.set(url, name);
      liberator.echomsg("Added Link Pad '" + name + "': " + url, 1);
    },
    //del: function del(url)
    //{
    //	linkpad.remove(url);
    //	liberator.echomsg("Delited Link Pad : " + url, 1);
    //},
    open: function open(url, where)
    {
      if (url) {
        liberator.open(url, where);
        linkpad.remove(url);
      } else {
        liberator.echoerr("Error!:not set");
      }
    },
    list: function list(context){
      //filter = context.filter.toLowerCase();
      context.title = ["Link Pad", "URL"];
      let i = 1;
      links = [];
      for(let [url,] in linkpad){
        let title = i++ + ':' + linkpad.get(url);
        //if(title.indexOf(filter) == 0)
        links.push([title, url]);
      }
      return [0, links];
    }
  };
})();
