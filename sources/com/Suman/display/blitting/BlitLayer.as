package com.Suman.display.blitting 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	/**
	 * This is a virtual layer, a manager for blitImages.
	 * This is not a visual elevement of any kind.
	 * ...
	 * @author Suman Constantin
	 */
	public class BlitLayer
	{
        public var blitImages:Vector.<BlitImage>;
		public var name:String = "";
		
		public function BlitLayer(_name:String):void
		{
			name = _name;
			
			blitImages = new Vector.<BlitImage>();
		}
		
		public function Update():void
		{
			// Draw images
            var index:int = 0;
            while (index < blitImages.length)
			{
                blitImages[index].Update();
                index++;
            }
		}
		
		public function addChild(_blitImage:BlitImage):void
		{
			_blitImage.parent = this;
			
			// If already in list, remove and then re-add (that is place on top of render list)
			if(blitImages.indexOf(_blitImage) != -1)
				blitImages.splice(blitImages.indexOf(_blitImage), 1);
			
			blitImages.push(_blitImage);
		}
		
		public function removeChild(_blitImage:BlitImage):void
		{
			if(_blitImage != null && blitImages.indexOf(_blitImage) != -1)
			{
				_blitImage.parent = null;
				blitImages.splice(blitImages.indexOf(_blitImage),1);
			}
		}
		
		public function dispose():void
		{
			while(blitImages.length > 0)
				this.removeChild(blitImages[0]);
			
			blitImages = null;
		}
	}
	
}