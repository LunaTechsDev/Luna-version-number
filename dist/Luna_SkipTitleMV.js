//=============================================================================
// Luna_SkipTitleMV.js
//=============================================================================
//=============================================================================
// Build Date: 2020-08-29 18:43:53
//=============================================================================
//=============================================================================
// Made with LunaTea -- Haxe
//=============================================================================


// Generated by Haxe 4.1.3
/*:
@author LunaTechs - Kino
@plugindesc Skips the title screen for testing during the development
process <LunaSkipTitle>.
@target MV MZ

MIT License
Copyright (c) 2020 LunaTechsDev
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE
*/
(function ($hx_exports, $global) { "use strict"
class LunaSkipTitle {
	static main() {
		let oldsceneTitleStart = Scene_Title.prototype["start"] 
		Scene_Title.prototype["start"] = function() {
			oldsceneTitleStart.call(this)
			SceneManager.goto(Scene_Map)
		}
	}
}
class haxe_iterators_ArrayIterator {
	constructor(array) {
		this.current = 0
		this.array = array
	}
	hasNext() {
		return this.current < this.array.length;
	}
	next() {
		return this.array[this.current++];
	}
}
class utils_Fn {
	static proto(obj) {
		return obj.prototype;
	}
}
LunaSkipTitle.main()
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, {})
