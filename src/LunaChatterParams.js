/*:
@author LunaTechs - Kino
@plugindesc This plugin allows you to create notifications and event labels within RPGMakerMV/MZ <LunaChatter>.

@target MV MZ

@param audioBytes
@desc The audio files to use when playing sound
@type struct<SoundFile>[]

@param fadeInTime
@text Fade In Time
@desc The time in frames to fade in the chatter window as it enters the screen.
@default 120

@param fadeOutTime
@text Fade Out Time
@desc The time in frames to fade out the chatter window as it leaves the screen.
@default 120

@param eventWindowRange
@text Event Window Range
@desc The radius in pixels in which the player will see the chatter window.
@default 120

@param anchorPosition
@text Anchor Position
@desc The anchor position of the chatter notification windows on the screen.
@default right

@param backgroundType
@text Background Type
@desc The background type of the chatter windows.
@default 0

@param eventBackgroundType
@text Event Background Type
@desc The background type of the event chatter windows. 
@default 2

@param templateStrings
@text Template Strings
@desc The template strings that you can draw within the
text window.
@type struct<Template>[]

@param templateJSStrings
@text Template JavaScript Strings
@desc The template JavaScripts you can embed within
the chatter window.
@type struct<JSTemplate>[]


@help
This plugin allows you to have a press start button before the title screen information.

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

/*~struct~Template:
*
* @param id
* @text Identifier
* @desc The identifier used for this text template.
* @default 1
*
* @param text
* @text Text
* @type note
* @desc The text for the string template; has text code support.
* @default \N[1]: Hello Tim
*
*/

/*~struct~JSTemplate:
* @param id
* @text Identifier
* @desc The identifier used for the JS template.
* @default 1
*
* @param code
* @text Code
* @type note
* @desc The code for the code template.
* @default `${$gameActors.actor(1).name}`;
*/

/*~struct~SoundFile:
* @param id
* @text Identifier
* @desc The identifier used in the text window
* @type text
*
* @param name
* @text Name
* @desc The name of the audio SE file
* @type file
*
* @param pitch
* @text Pitch
* @desc The pitch of the audio file
* @type number
* @default 100
*
* @param volume
* @text Volume
* @desc The volume of the audio file
* @type number
* @default 50
*
* @param pan
* @text Pan
* @desc The pan of the audio file
* @type number
* @default 100
*
*/