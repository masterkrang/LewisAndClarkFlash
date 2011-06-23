package com.kurt.util
{
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class TextFormatFactory
	{
		public static function getTweetTextFormat():TextFormat {
			//trace("turn fonts back on");
			
			//var font:Font = new StagStencilBold();
			var tf:TextFormat = new TextFormat();
			//tf.font = font.fontName;
			tf.size = 14;
			tf.color = 0xFFFFFF;
			tf.align = TextFormatAlign.LEFT;
			return tf;
		}
		
		public static function getListItemFormat():TextFormat {
			//var font:Font = new StagStencilBold();
			var tf:TextFormat = new TextFormat();
			//tf.font = font.fontName;
			tf.size = 14;
			tf.color = 0x000000;
			tf.align = TextFormatAlign.LEFT;
			return tf;
		}
		
		/*
		public static function getNavigationTitleFormat():TextFormat {
			trace("turn fonts back on");
			
			var font:Font = new StagStencilBold();
			var tf:TextFormat = new TextFormat();
			tf.font = font.fontName;
			tf.size = 14;
			tf.color = 0xAAACAE;
			tf.align = TextFormatAlign.CENTER; //TextFormatAlign.LEFT;
			return tf;
		}
		
		public static function getLoadingFormat():TextFormat {
			trace("turn fonts back on");
			
			var font:Font = new StagStencilBold();
			var tf:TextFormat = new TextFormat();
			tf.font = font.fontName;
			tf.size = 14;
			tf.color = 0xAAACAE;
			tf.align = TextFormatAlign.LEFT;
			return tf;
		}
		
		public static function getSubtitleFormat():TextFormat {
			trace("turn fonts back on");
			
			var font:Font = new StagStencilBold();
			var tf:TextFormat = new TextFormat();
			tf.font = font.fontName;
			tf.size = 33;
			tf.color = 0xAAACAE;
			tf.align = TextFormatAlign.LEFT;
			return tf;
		}
		
		public static function getBackButtonFormat():TextFormat {
			trace("turn fonts back on");
			
			var font:Font = new StagStencilBold();
			var tf:TextFormat = new TextFormat();
			tf.font = font.fontName;
			tf.size = 14;
			tf.color = 0x000000;
			tf.align = TextFormatAlign.LEFT;
			return tf;
		}
		*/
		
		public static function setTextParams(tf:TextField, 
											 _embedFonts:Boolean = true, 
											 _wordWrap:Boolean = true, 
											 _multiLine:Boolean = true, 
											 _antiAliasType:String = AntiAliasType.ADVANCED,
											 _autoSize:String = TextFieldAutoSize.LEFT):void {
			
			/*
			tf.embedFonts = _embedFonts;
			*/
			tf.wordWrap = _wordWrap;
			tf.multiline = _multiLine;
			
			tf.antiAliasType = _antiAliasType;
			tf.autoSize = _autoSize;
			
		}
	}
}