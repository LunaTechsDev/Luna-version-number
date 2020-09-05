import utils.Comment;
import core.Types.JsFn;
import utils.Fn;
import rm.core.Rectangle;
import rm.Globals;

class LunaMessageSounds {
 public static function main() {
  var params = Globals.Plugins.filter((plugin) -> {
   return ~/<LunaMsgSounds>/ig.match(plugin.description);
  })[0].parameters;

  Comment.title("Window_Message");
 }
}
