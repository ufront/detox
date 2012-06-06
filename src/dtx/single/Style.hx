/****
* Copyright 2012 Jason O'Neil. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE "AS IS" AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Jason O'Neil.
* 
****/

package dtx.single;

import js.w3c.level3.Core;
import js.w3c.css.CSSOM;

/* 
Functionality to implement:
	innerHeight
	innerWidth
	css() - 
	offset()
	offsetParent()
	scrollLeft - int
	scrollTop - int
	position(top, left)
	width()
	height() - 
	outerHeight()
	outerWidth()
*/

class Style
{
	public static function getComputedStyle(node:DOMNode)
	{
		var style:CSSStyleDeclaration = null;
		if (ElementManipulation.isElement(node))
		{
			//style = DOMCollection.window.getComputedStyle(cast node).width;
		}
		return style;
	}

	
	public static function css(node:DOMNode, property:String)
	{
		getComputedStyle(node).getPropertyValue("property");
	}

	public static function setCSS(node:DOMNode, property:String, value:String)
	{
		if (ElementManipulation.isElement(node))
		{
			var style:Dynamic = untyped node.style;
			Reflect.setField(style, property, value);
		}
	}

	/** Get the current computed width for the first element in the set of matched elements, including padding but not border. */
	public static function innerWidth(node:DOMNode):Int
	{
		var style = getComputedStyle(cast node);
		if (style != null)
		{
			
		}
		return 0;
	}
} 