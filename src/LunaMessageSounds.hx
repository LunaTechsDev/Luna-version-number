import rm.types.RM.TextState;
import rm.abstracts.managers.AudioMgr;
import rm.types.RPG.AudioFile;
import rm.managers.AudioManager;
import rm.windows.Window_Message;
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

  Comment.title("AudioManager");

  Fn.setField(AudioManager, "playTalkSe", (se: AudioFile) -> {
   if (se.name != null) {
    untyped Fn.self._seBuffers = Fn.self._seBuffers.filter((audio) -> {
     return audio.isPlaying();
    });
    untyped var buffer = Fn.self.createBuffer("se/", se.name);
    untyped Fn.self.updateSeParameters(buffer, se);
    buffer.play(false);
    untyped Fn.self._seBuffers.push(buffer);
   }
  });

  Comment.title("Window_Message");
  Fn.renameClass(Window_Message, LTWinMsgUpdate);
 }
}

@:keep
@:native("LTWinMsg")
class LTWinMsgUpdate extends Window_Message {
 #if compileMV
 public function new(x: Int, y: Int, width: Int, height: Int) {
  super(x, y, width, height);
 }
 #else
 public function new(rect: Rectangle) {
  super(rect);
 }
 #end

 #if compileMV
 public override function initialize() {
  super.initialize();
 }
 #else
 public override function initialize(rect: Rectangle) {
  super.initialize(rect);
 }
 #end

 #if compileMV
 public override function processNormalCharacter(textState: TextState) {
  super.processNormalCharacter(textState);
 #else
 public override function processCharacter(textState: TextState) {
  super.processCharacter(textState);
 #end

  var se = {
   name: "Cat",
   volume: 25,
   pitch: 100,
   pan: 0
  };
  untyped AudioManager.playTalkSe(se);
  trace("Playing SE");
 }
}
