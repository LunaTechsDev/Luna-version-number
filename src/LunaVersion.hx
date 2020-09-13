import rm.scenes.Scene_Title;
import utils.Comment;
import core.Types.JsFn;
import utils.Fn;
import rm.Globals;
import rm.managers.FontManager;
import rm.core.JsonEx;
import utils.Parse;

using Lambda;
using StringTools;
using core.NumberExtensions;

typedef VersionParams = {
 var x: Int;
 var y: Int;
 var width: Int;
 var height: Int;
 var fontSize: Int;
 var fontFace: String;
 var versionText: String;
}

class LunaVersion {
 public static var VParams: VersionParams;

 public static function main() {
  Comment.title("Parameters");
  var params = Globals.Plugins.filter((plugin) ->
   ~/<LunaVersion>/ig.match(plugin.description))[0].parameters;
  VParams = {
   x: Fn.parseIntJs(params["x"]),
   y: Fn.parseIntJs(params["y"]),
   width: Fn.parseIntJs(params["width"]),
   height: Fn.parseIntJs(params["height"]),
   fontSize: Fn.parseIntJs(params["fontSize"]),
   fontFace: untyped params["fontFace"].trim(),
   versionText: untyped params["versionText"].trim()
  };

  Comment.title("Scene_Title");

  var _SceneTitleCreate: JsFn = Fn.proto(Scene_Title).createR;
  Fn.proto(Scene_Title).createD = () -> {
   _SceneTitleCreate.call(Fn.self);
   createVersionWindow(Fn.self);
  };
 }

 public static function createVersionWindow(scene: Scene_Title) {
  scene.addWindow(new WindowVersion(VParams.x, VParams.y, VParams.width,
   VParams.height));
 }
}
