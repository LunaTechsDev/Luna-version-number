import rm.Globals;
import rm.managers.FontManager;
import rm.core.JsonEx;
import utils.Parse;

using Lambda;
using StringTools;
using core.NumberExtensions;

typedef Font = {
 var fontName: String;
 var fontFileName: String;
}

typedef FontParams = {
 fonts: Array<Font>
}

class LunaFonts {
 public static var FontParams: FontParams;

 public static function main() {
  var params = Globals.Plugins.filter((plugin) ->
   ~/<LunaFonts>/ig.match(plugin.description))[0].parameters;
  var parsedFonts: Array<Font> = untyped JsonEx.parse(params["fonts"])
   .map((fontJson) -> JsonEx.parse(fontJson));
  FontParams = {
   fonts: parsedFonts
  }

  FontParams.fonts.iter((font) -> {
   FontManager.load(font.fontName, font.fontFileName);
  });
  trace(FontManager.__states);
  trace(FontManager.__urls);
  trace(FontParams);
 }
}
