import rm.core.JsonEx;
import haxe.crypto.BaseCode;
import rm.sprites.Sprite_Character;
import rm.core.TouchInput;
import rm.objects.Game_Event;
import rm.scenes.Scene_Map;
import rm.windows.Window_Base;
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
import utils.Parse;

using LunaChatter.ChatterExtensions;
using Lambda;
using StringTools;
using core.NumberExtensions;

/**
 * Chatter Template for creating custom chatter windows.
 */
typedef ChatterTemplate = {
 var id: Int;
}

typedef TemplateString = {
 > ChatterTemplate,
 var text: String;
}

typedef JSTemplate = {
 > ChatterTemplate,
 var code: String;
}

typedef CHParams = {
 var fadeInTime: Int;
 var fadeOutTime: Int;
 var eventWindowRange: Int;
 var anchorPosition: AnchorPos;
 var backgroundType: Int;
 var eventBackgroundType: Int;
 var templateStrings: Array<TemplateString>;
 var templateJSStrings: Array<JSTemplate>;
};

enum abstract ChatterEvents(String) from String to String {
 public var SHOW = "show";
 public var PUSH = "push";
 public var HIDE = "hide";
 public var CLOSE = "close";
 public var OPEN = "open";
 public var QUEUE = "queue";
 public var PAINT = "paint";
 public var DEQUEUE = "dequeue";
 public var PLAYERINRANGE = "playerInRange";
 public var PLAYEROUTOFRANGE = "playerOutOfRange";
 public var ONHOVER = "onHover";
 public var ONHOVEROUT = "onHoverOut";
}

enum abstract ChatterType(String) from String to String {
 public var TEXT = "text";
 public var ACTOR = "actor";
 public var FACE = "face";
 public var PIC = "picture";
 public var MAP = "map";
}

enum abstract AnchorPos(String) from String to String {
 public var TOPRIGHT = "topRight";
 public var BOTTOMRIGHT = "bottomRight";
 public var TOPLEFT = "topLeft";
 public var BOTTOMLEFT = "bottomLeft";
}

class LunaChatter {
 public static var ChatterEmitter = Amaryllis.createEventEmitter();
 public static var CHParams: CHParams;
 public static var params = Globals.Plugins.filter((plugin) ->
  ~/<LunaChatter>/ig.match(plugin.description))[0].parameters;
 public static var chatterQueue: Array<ChatterWindow> = [];
 public static var chatterWindows: Array<ChatterWindow> = [];

 public static function main() {
  Comment.title("Parameter Setup");
  CHParams = {
   fadeInTime: Fn.parseIntJs(params["fadeInTime"]),
   fadeOutTime: Fn.parseIntJs(params["fadeOutTime"]),
   eventWindowRange: Fn.parseIntJs(params["eventWindowRange"]),
   anchorPosition: params["anchorPosition"].trim(),
   backgroundType: Fn.parseIntJs(params["backgroundType"]),
   eventBackgroundType: Fn.parseIntJs(params["eventBackgroundType"]),
   templateStrings: JsonEx.parse(params["templateStrings"]),
   templateJSStrings: JsonEx.parse(params["templateJSStrings"])
  }

  CHParams.templateJSStrings = cast CHParams.templateJSStrings.map((ts) ->
   JsonEx.parse(cast ts));
  CHParams.templateStrings = cast CHParams.templateStrings.map((ts) ->
   JsonEx.parse(cast ts));
  trace(CHParams);

  Comment.title("Event Hooks");
  setupEvents();

  Comment.title("Scene_Map");

  var _SceneMapStart: JsFn = cast Fn.proto(Scene_Map).startR;
  Fn.proto(Scene_Map).startD = () -> {
   _SceneMapStart.call(Fn.self);
  };

  var _SceneMapCreateWindows: JsFn = cast Fn.proto(Scene_Map).createAllWindowsR;
  Fn.proto(Scene_Map).createAllWindowsD = () -> {
   _SceneMapCreateWindows.call(Fn.self);
   createAllEventWindows(Fn.self); // TODO: Replace with event emitter
  };
 }

 public static function setupEvents() {
  ChatterEmitter.on(ChatterEvents.QUEUE, (win: ChatterWindow) -> {
   queueChatterWindow(win);
  });
  ChatterEmitter.on(ChatterEvents.DEQUEUE, () -> {
   dequeueChatterWindow();
  });

  Comment.title("Window_Base");
  var _WindowBaseEscapeCharacter: JsFn = Fn.proto(Window_Base)
   .processEscapeCharacterR;
  Fn.proto(Window_Base)
   .processEscapeCharacterD = (code: String, textState: TextState) -> {
    var winBase: Window_Base = Fn.self;
    switch (code) {
     case "LCT":
      processTemplateString(winBase,
       cast winBase.obtainEscapeParam(textState), textState);
     case "LCJS":
      processJSTemplateString(winBase,
       cast winBase.obtainEscapeParam(textState), textState);
     case _:
      _WindowBaseEscapeCharacter.call(Fn.self, code, textState);
    }
   };

  //    var _WinBaseEscapeParam :JsFn = Fn.proto(Window_Base).obtainEscapeParamR;
  //    Fn.proto(Window_Base).obtainEscapeParamD = (textState) -> {
  //      final stringReg = ~/^\[.*?\]/ig;
  //      if(stringReg.match(textState.text)) {
  //        return
  //      } else {
  //        return
  //      }
  //    };
 }

 public static function processTemplateString(win: Window_Base,
   templateIndex: Int, textState: TextState) {
  var templateStr: TemplateString = LunaChatter.CHParams.templateStrings.find((ts) ->
   ts.id == templateIndex);
  var text = templateStr.text;
  #if compileMV
  win.drawTextEx(text, textState.x, textState.y);
  #else
  win.drawTextEx(text, textState.x, textState.y, win.contentsWidth());
  #end
 }

 public static function processJSTemplateString(win: Window_Base,
   templateIndex: Int, textState: TextState) {
  var templateJsStr: JSTemplate = LunaChatter.CHParams.templateJSStrings.find((ts: Dynamic) ->
   ts.id == templateIndex);
  var code = templateJsStr.code;
  var text = js.Syntax.code("new Function({0})()", code);
  trace(templateJsStr);
  #if compileMV
  win.drawTextEx(text, textState.x, textState.x);
  #else
  win.drawTextEx(text, textState.x, textState.y, win.contentsWidth());
  #end
 }

 public static function createAllEventWindows(scene: Scene_Map) {
  // Scan Events With Notetags to show event information
  var mapEvents = Globals.GameMap.events();
  // Add NoteTag Check Later -- + Add Events
  mapEvents.iter((event) -> {
   var chatterEventWindow = new ChatterEventWindow(0, 0, 100, 100);
   chatterEventWindow.setEvent(event);

   scene.__spriteset.__characterSprites.iter((charSprite) -> {
    if (charSprite.x == event.screenX() && charSprite.y == event.screenY()) {
     chatterEventWindow.setEventSprite(charSprite);
     charSprite.addChild(chatterEventWindow);
     charSprite.bitmap.addLoadListener((_) -> {
      positionEventWindow(chatterEventWindow);
     });
     chatterEventWindow.close();
    }
   });

   chatterEventWindow.setupEvents(cast setupGameEvtEvents);
   chatterEventWindow.open();
  });
 }

 public static function setupGameEvtEvents(currentWindow: ChatterEventWindow) {
  currentWindow.on(ChatterEvents.PLAYERINRANGE, (win: ChatterEventWindow) -> {
   if (win.playerInRange == false) {
    openChatterWindow(win);
    win.playerInRange = true;
   }
  });

  currentWindow.on(ChatterEvents.PLAYEROUTOFRANGE,
   (win: ChatterEventWindow) -> {
    if (win.playerInRange == true) {
     closeChatterWindow(win);
     win.playerInRange = false;
    }
   });

  currentWindow.on(ChatterEvents.ONHOVER, (win: ChatterEventWindow) -> {
   if (win.hovered == false && win.playerInRange == false) {
    openChatterWindow(win);
    win.hovered = true;
   }
  });

  currentWindow.on(ChatterEvents.ONHOVEROUT, (win: ChatterEventWindow) -> {
   if (win.hovered == true) {
    closeChatterWindow(win);
    win.hovered = false;
   }
  });

  currentWindow.on(ChatterEvents.PAINT, (win: ChatterEventWindow) -> {
   win.drawText(win.event.event().name, 0, 0, win.contentsWidth(), "center");
  });
 }

 public static function showChatterEventWindow() {
  // Update Position On Within Range
 }

 public static function queueChatterWindow(win: ChatterWindow) {
  // Perform Show Transition
  chatterQueue.enqueue(win);
 }

 public static function dequeueChatterWindow(): ChatterWindow {
  // Perform Transition
  return chatterQueue.dequeue();
 }

 public static function showChatterWindow(win: ChatterWindow) {
  win.show();
 }

 public static function hideChatterWindow(win: ChatterWindow) {
  win.hide();
 }

 public static function openChatterWindow(win: ChatterWindow) {
  win.open();
 }

 public static function positionEventWindow(win: ChatterEventWindow) {
  var offset = win.eventSprite.offsetByEventSprite();
  win.x -= win.width / 2;
  win.y -= (win.height + (offset.y));
 }

 public static function closeChatterWindow(win: ChatterWindow) {
  win.close();
 }
}

class ChatterExtensions {
 public static function enqueue<T>(arr: Array<T>, element: T) {
  arr.push(element);
 }

 public static function dequeue<T>(arr: Array<T>): T {
  return arr.shift();
 }

 public static function offsetAboveEvent(evt: Game_Event) {
  var eventScreenXCenter = evt.screenX() - 24;
  var eventScreenYAbove = evt.screenY() - 64;
  return {x: eventScreenXCenter, y: eventScreenYAbove};
 }

 public static function offsetByEventSprite(charSprite: Sprite_Character) {
  charSprite.updateFrame();
  return {x: charSprite.__frame.width / 2, y: charSprite.__frame.height};
 }
}

class ChatterWindow extends Window_Base {
 public function new(x: Int, y: Int, width: Int, height: Int) {
  #if compileMV
  super(x, y, width, height);
  #else
  var rect = new Rectangle(x, y, width, height);
  super(rect);
  #end
  this.setBGType();
 }

 public function setBGType() {
  this.setBackgroundType(LunaChatter.CHParams.backgroundType);
 }

 public function setupEvents(fn: (win: ChatterWindow) -> Void) {
  fn(this);
 }

 public function paint() {
  if (this.contents != null) {
   this.contents.clear();
   this.emit(ChatterEvents.PAINT, this);
  }
 }

 public override function show() {
  this.emit(ChatterEvents.SHOW, this);
  super.show();
 }

 public override function hide() {
  this.emit(ChatterEvents.HIDE, this);
  super.hide();
 }

 public override function open() {
  this.emit(ChatterEvents.OPEN, this);
  super.open();
 }

 public override function close() {
  this.emit(ChatterEvents.CLOSE, this);
  super.close();
 }
}

class ChatterEventWindow extends ChatterWindow {
 public var event: Game_Event;
 public var eventSprite: Sprite_Character;
 public var hovered: Bool;
 public var playerInRange: Bool;

 public function new(x: Int, y: Int, width: Int, height: Int) {
  super(x, y, width, height);
  this.hovered = false;
  this.playerInRange = false;
 }

 public override function setBGType() {
  this.setBackgroundType(LunaChatter.CHParams.eventBackgroundType);
 }

 public function setEvent(evt: Game_Event) {
  this.event = evt;
 }

 public function setEventSprite(evt: Sprite_Character) {
  this.eventSprite = evt;
 }

 public override function update() {
  super.update();
  this.scanForPlayer();
  this.scanForHover();
  this.paint();
 }

 public function scanForPlayer() {
  var eventX = this.event.screenX();
  var eventY = this.event.screenY();
  var playerX = Globals.GamePlayer.screenX();
  var playerY = Globals.GamePlayer.screenY();

  var inRange = Math.sqrt(Math.pow(playerX - eventX, 2)
   + Math.pow(playerY - eventY, 2)) < LunaChatter.CHParams.eventWindowRange;

  if (inRange) {
   this.emit(ChatterEvents.PLAYERINRANGE, this);
  } else {
   this.emit(ChatterEvents.PLAYEROUTOFRANGE, this);
  }
 }

 public function scanForHover() {
  var eventScreenX = this.event.screenX();
  var eventScreenY = this.event.screenY();
  var inputPosition = {x: TouchInput.x, y: TouchInput.y};

  if (inputPosition.x.withinRange(eventScreenX, eventScreenX + 48)
   && inputPosition.y.withinRange(eventScreenY - 48, eventScreenY)) {
   this.emit(ChatterEvents.ONHOVER, this);
  } else {
   this.emit(ChatterEvents.ONHOVEROUT, this);
  }
 }

 // Logic For Handling Drawing Different Types in the window
}
