import rm.core.Input;
import rm.core.TouchInput;
import utils.Comment;
import core.Types.JsFn;
import rm.scenes.Scene_Title;
import rm.windows.Window_Base;
import utils.Fn;
import rm.core.Rectangle;
import rm.Globals;

using core.NumberExtensions;

typedef PSParams = {
 var titleText: String;
 var fontSize: Int;
 var enableFade: Bool;
 var fadeSpeed: Int;
 var windowWidth: Int;
 var windowHeight: Int;
 var xPosition: Int;
 var yPosition: Int;
};

class LunaPressStart {
 public static var PressStartParams: PSParams = null;

 public static function main() {
  var params = Globals.Plugins.filter((plugin) -> {
   return ~/<LunaPressStart>/ig.match(plugin.description);
  })[0].parameters;

  PressStartParams = {
   titleText: params["Start Text"],
   fontSize: Fn.parseIntJs(params['Font Size']),
   enableFade: ~/T/ig.match(params["Fade Enable"]),
   fadeSpeed: Fn.parseIntJs(params["Fade Speed"]),
   windowWidth: Fn.parseIntJs(params["Window Width"]),
   windowHeight: Fn.parseIntJs(params["Window Height"]),
   xPosition: Fn.parseIntJs(params["Window X Position"]),
   yPosition: Fn.parseIntJs(params["Window Y Position"])
  };

  Comment.title("Scene_Title");
  var _SceneTitleCreate: JsFn = Fn.getPrProp(Scene_Title, "create");
  Fn.setPrProp(Scene_Title, "create", () -> {
   var STitle: Dynamic = Fn.self;
   _SceneTitleCreate.call(STitle);
   STitle.createStartWindow();
  });

  Fn.setPrProp(Scene_Title, "createStartWindow", () -> {
   var STitle: Dynamic = Fn.self;
   var PSParams = LunaPressStart.PressStartParams;
   STitle._windowStart = new LTWindowStart(PSParams.xPosition,
    PSParams.yPosition, PSParams.windowWidth, PSParams.windowHeight);
   STitle.addWindow(STitle._windowStart);
  });

  var _SceneTitleIsBusy: JsFn = Fn.getPrProp(Scene_Title, "isBusy");
  Fn.setPrProp(Scene_Title, "isBusy", () -> {
   var STitle: Dynamic = Fn.self;
   return STitle._windowStart.isOpen() || _SceneTitleIsBusy.call(STitle);
  });

  var _SceneTitleUpdate: JsFn = Fn.getPrProp(Scene_Title, "update");
  Fn.setPrProp(Scene_Title, "update", () -> {
   var STitle: Dynamic = Fn.self;
   _SceneTitleUpdate.call(STitle);
   STitle.processStart();
  });

  Fn.setPrProp(Scene_Title, "processStart", () -> {
   var STitle: Dynamic = Fn.self;
   if (STitle._windowStart.isOpen()
    && (TouchInput.isPressed() || Input.isTriggered("ok"))) {
    STitle._windowStart.close();
    STitle._windowStart.deactivate();
   }
  });
 }
}

@:keep
class LTWindowStart extends Window_Base {
 private var _visible: Bool;

 public function new(x: Int, y: Int, width: Int, height: Int) {
  #if compileMV
  super(x, y, width, height);
  #else
  var rect = new Rectangle(x, y, width, height);
  super(rect);
  #end
 }

 #if compileMV
 public override function initialize(?x: Int, ?y: Int, ?width: Int,
   ?height: Int) {
  super.initialize(x, y, width, height);
 #else
 public override function initialize(rect: Rectangle) {
  super.initialize(rect);
 #end

  this.setBackgroundType(2);
 }
  public override function update() {
   super.update();
   if (LunaPressStart.PressStartParams.enableFade) {
    this.processFade();
    this.refresh();
   }
  }

  public function drawStartText() {
   var PSParams = LunaPressStart.PressStartParams;
   this.contents.fontSize = PSParams.fontSize;
   var xpos = (this.contentsWidth() / 2)
    - (this.textWidth(PSParams.titleText) / 2);
   this.drawText(PSParams.titleText, 0, 0, this.contentsWidth(), 'center');
   this.resetFontSettings();
  }

  public function processFade() {
   switch (this._visible) {
    case true:
     this.fadeOut();
    case false:
     this.fadeIn();
   }
  }

  public function refresh() {
   if (this.contents != null) {
    this.contents.clear();
    this.drawStartText();
   }
  }

  public function fadeOut() {
   this.contentsOpacity -= LunaPressStart.PressStartParams.fadeSpeed;
   this.contentsOpacity = this.contentsOpacity.clampf(0, 255);
   if (this.contentsOpacity == 0) {
    this._visible = false;
   }
  }

  public function fadeIn() {
   this.contentsOpacity += LunaPressStart.PressStartParams.fadeSpeed;
   this.contentsOpacity = this.contentsOpacity.clampf(0, 255);
   if (this.contentsOpacity == 255) {
    this._visible = true;
   }
  }
}
