package com.kurt.util
{
	import com.greensock.TweenMax;

	public class LayoutFactory
	{
		public static function resizeMe(mc:Object, maxW:Number, maxH:Number=0, constrainProportions:Boolean=true):void{
			maxH = maxH == 0 ? maxW : maxH;
			
			mc.width = maxW;
			mc.height = maxH;
			if (constrainProportions) {
				/*
				if(mc.scaleX < mc.scaleY) {
					TweenMax.to(mc, .5, {scaleY:mc.scaleX});
				} else {
					TweenMax.to(mc, .5, {scaleX:mc.scaleY});
				}
				*/
				mc.scaleX < mc.scaleY ? mc.scaleY = mc.scaleX : mc.scaleX = mc.scaleY;
			}
		}
		
		//returns the proper percentage one should resize an object mc in order to fit in a box and maintain proportions
		// mostly use a fake sprite drawn at the objects size so you don't have to modify the graphic visually
		public static function getResizeFactor(mc:Object, maxW:Number, maxH:Number=0, constrainProportions:Boolean=true):Number {
			maxH = maxH == 0 ? maxW : maxH;
			
			mc.width = maxW;
			mc.height = maxH;
			if (constrainProportions) {
				/*
				if(mc.scaleX < mc.scaleY) {
				TweenMax.to(mc, .5, {scaleY:mc.scaleX});
				} else {
				TweenMax.to(mc, .5, {scaleX:mc.scaleY});
				}
				*/
				mc.scaleX < mc.scaleY ? mc.scaleY = mc.scaleX : mc.scaleX = mc.scaleY;
			}
			//trace("mc.width " + 
			//return the final scale
			return mc.scaleX; //scaleY and scaleX should always be equal
		}
		
		
	}
}