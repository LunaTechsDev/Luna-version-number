import utils.Parse;
import core.Amaryllis;
import pixi.interaction.EventEmitter;
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

typedef SoundState = {
 var id: String;
 var soundMode: SoundMode;
};

typedef SoundFile = {
 > AudioFile,
 var id: String;
}

enum abstract SoundMode(String) from String to String {
 public var LETTER = "letter";
 public var WORD = "word";
 public var SENTENCE = "sentence";
 public var TEXT = "text";
}

enum abstract MessageEvents(String) from String to String {
 public var UPDATEMODE = "updateMode";
}

class LunaMessageSounds {
 public static var currentSoundState: SoundState = {
  id: "0",
  soundMode: "letter"
 };
 public static var messageEmitter: EventEmitter = Amaryllis.createEventEmitter();
 public static var audioBytes: Array<SoundFile> = [];

 public static function main() {
  var params = Globals.Plugins.filter((plugin) -> {
   return ~/<LunaMsgSounds>/ig.match(plugin.description);
  })[0].parameters;

  audioBytes = Parse.parseParameters(params["audioBytes"]);
  trace("Preloaded audio files", audioBytes);

  Comment.title("AudioManager");

  Fn.setField(AudioManager, "playTalkSe", (se: AudioFile) -> {
   // Add SE Get from Code Sound State Parameters
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

  setupEvents();
 }

 public static function updateSoundState(state: SoundState) {
  currentSoundState = state;
 }

 public static function setupEvents() {
  messageEmitter.on(MessageEvents.UPDATEMODE, (state: SoundState) -> {
   updateSoundState(state);
  });
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
  public function processSound(code: String, soundId: String) {
   LunaMessageSounds.messageEmitter.emit(MessageEvents.UPDATEMODE, {
    id: soundId,
    mode: code
   });
  }

  // Update textState for processEscapeCharacter to be not a string
  public override function processEscapeCharacter(code, textState: String) {
   switch (code) {
    // Process Sound at letter
    case "LL":
     this.processSound(SoundMode.LETTER, this.obtainEscapeParam(textState));
    // Process Sound at Word
    case "LW":
     this.processSound(SoundMode.WORD, this.obtainEscapeParam(textState));
    case "LS":
     this.processSound(SoundMode.SENTENCE, this.obtainEscapeParam(textState));
    case "LT:":
     this.processSound(SoundMode.TEXT, this.obtainEscapeParam(textState));
    case _:
     super.processEscapeCharacter(code, textState);
   }
  }
}
