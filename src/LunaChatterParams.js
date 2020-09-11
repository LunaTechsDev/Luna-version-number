/*:
@author LunaTechs - Kino
@plugindesc This plugin allows you to add sounds to your text in the message window
at character, word, sentence, and just message intervals. 
menu <LunaMsgSounds>.

@target MV MZ

@param audioBytes
@desc The audio files to use when playing sound
@type struct<SoundFile>[]


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