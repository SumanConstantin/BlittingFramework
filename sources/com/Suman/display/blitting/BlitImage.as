package com.Suman.display.blitting 
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.flash_proxy;

    public class BlitImage extends Object
    {
		
		private static var preDrawnRotationBMDs:Object = new Object();
		
		private var bmDataSrc:BitmapData;
		private var prevX:Number = 0;
		private var prevY:Number = 0;
		private var prevRot:Number = 0;
		private var displayObjects:Vector.<DisplayObject> = new Vector.<DisplayObject>;
		private var frameRect:Rectangle;	// Draw region, size of this image
		public var rotation:Number = 0;
		public var angleStep:int = 5;		// Used to create preDrawn images rotated at this step from 0 to 360 degrees 
		
        public var bmData:BitmapData;
		public var x:Number = 0;
		public var y:Number = 0;
		public var parent:BlitLayer;
		public var name:String = "";
		public var visible:Boolean = true;
		public var allowRotation:Boolean = false;
		
		private var _scaleX:Number = 0;
		public function get scaleX():Number
		{
			return _scaleX;
		}
		public function set scaleX(_value:Number):void
		{
			_scaleX = _value;
			
			var transformMatrix:Matrix = new Matrix();
			transformMatrix.scale(width*_scaleX,height);
			
			var tempBMD:BitmapData = bmDataSrc.clone();
			bmData.fillRect(frameRect, 0);
			bmData.draw(tempBMD, transformMatrix, null, null, null, true);
		}
		
		private var _scaleY:Number = 0;
		public function get scaleY():Number
		{
			return _scaleY;
		}
		public function set scaleY(_value:Number):void
		{
			_scaleY = _value;
			
			var transformMatrix:Matrix = new Matrix();
			transformMatrix.scale(width,height*_scaleY);
			
			var tempBMD:BitmapData = bmDataSrc.clone();
			bmData.fillRect(frameRect, 0);
			bmData.draw(tempBMD, transformMatrix, null, null, null, true);
		}
		
		public function get width():Number
		{
			return frameRect.width;
		}
		public function set width(_value:Number):void
		{
			frameRect.width = _value;
		}
		
		public function get height():Number
		{
			return frameRect.height;
		}
		public function set height(_value:Number):void
		{
			frameRect.height = _value;
		}
		
        public function BlitImage(_img:*, _name:String, _allowRotation:Boolean = false)
        {
			name = _name;
			allowRotation = _allowRotation;
			
			if(_img == null) return;
			
			this.addChild(_img);
			
			if(allowRotation)
				preDrawRotations(name);
		}
		
		public function addChild(_img:DisplayObject = null):void
		{
			if(_img == null) return;
			
			// If already in list, remove and then re-add (that is place on top of render list)
			if(displayObjects.indexOf(_img) != -1)
				displayObjects.splice(displayObjects.indexOf(_img), 1);
			
			displayObjects.push(_img);
			
			drawImages();
		}
		
		public function removeChild(_img:DisplayObject = null):void
		{
			if(_img == null) return;
			
			// If already in list, remove
			if(displayObjects.indexOf(_img) != -1)
				displayObjects.splice(displayObjects.indexOf(_img), 1);
			
			drawImages();
		}
		
		// Draw all displayObjects
		// Call this function once there has been added or removed an image
		// Do not call this function on every update
		private function drawImages():void
		{
			// Check if this bmd has already been drawn with rotations
			if(name != "" && preDrawnRotationBMDs[name])
			{
				bmData = preDrawnRotationBMDs[name];//.clone();
				frameRect = new Rectangle(0, 0, bmData.width/360*angleStep, bmData.height);
				return;
			}
			
			bmData = null;
			
			var len:int = displayObjects.length;
			for(var i:int = 0; i<len; i++)
			{
				var tempBMD:BitmapData = getBmdFromMc(displayObjects[i]);
				
				if(bmData == null)
				{
					bmData = tempBMD.clone();
				}
				else
				{
					var matrix:Matrix = new Matrix();
					matrix.translate(displayObjects[i].x,displayObjects[i].y);
					bmData.draw(tempBMD, matrix, null, null, null, true);
				}
			}
			
			bmDataSrc = bmData.clone();
			
			frameRect = new Rectangle(0, 0, bmData.width, bmData.height);
			
        }
		
        public function Update() : void
        {
			Render();
        }
		
        private function Render() : void
        {
			if(!visible) return;
			
			// Get frame corresponding to rotation
			if(allowRotation && prevRot != rotation)
			{
				prevRot = rotation;
				
				if(rotation != 0)
				{
					rotation = Math.round(rotation%360);
					
					if(rotation < 0)
					{
						rotation+=360;
					}
					
					if(rotation > 360-angleStep)
						rotation = 0;
					
					frameRect.x = frameRect.width * Math.round(rotation/angleStep);
					
				}
				else
					frameRect.x = 0;
			}
			
			BlitManager.baseLayerBMD.copyPixels(bmData, frameRect, new Point(x,y), null, null, true);
        }
		
		protected function getBmdFromMc(_mc:DisplayObject):BitmapData
		{
			var bmd:BitmapData = new BitmapData(_mc.width, _mc.height, true, 0);	// Full transparency (w,h,true,0)
			var matrix:Matrix = new Matrix();
			matrix.translate(_mc.x,_mc.y);
			bmd.draw(_mc, matrix, null, null, null, true);
			return bmd;
		}
		
		public function getBounds(_img:BlitImage = null):Rectangle
		{
			if(_img == null)
				return frameRect;
			else
				return _img.getBounds();
		}
		
		public function preDrawRotations(_name:String):void
		{
			// Check if this bmd has already been drawn
			if(preDrawnRotationBMDs[_name])
			{
				bmData = preDrawnRotationBMDs[_name];
				return;
			}
			
			var tempRect:Rectangle = new Rectangle(0,0,frameRect.width,frameRect.height);
			
			bmDataSrc = bmData.clone();
			bmData = new BitmapData(frameRect.width*360/angleStep,frameRect.height, true, 0);
			
			for(var i:int = 0; i<=360; i+=angleStep)
			{
				var angleRad:Number = Math.PI*2*(i/360);
				
				var transformMatrix:Matrix = new Matrix();
				transformMatrix.translate(-frameRect.width/2,-frameRect.height/2);
				transformMatrix.rotate(angleRad);
				transformMatrix.translate(frameRect.width/2,frameRect.height/2);
				
				var tempBMD:BitmapData = new BitmapData(frameRect.width, frameRect.height, true, 0);
				tempBMD.draw(bmDataSrc, transformMatrix, null, null, null, true);
				
				bmData.copyPixels(tempBMD, frameRect, new Point(frameRect.width * i/angleStep, 0));
			}
			
			preDrawnRotationBMDs[_name] = bmData.clone();
		}
		
		public function dispose():void
		{
			bmDataSrc = null;
			bmData = null;
			frameRect = null;
			displayObjects = null;
			
			bmDataSrc:BitmapData;
			displayObjects = null;
			
			bmData = null;
			
			if(parent)
			{
				var tempParent = parent;
				parent = null;
				tempParent.removeChild(this);
			}
		}
		
		public static function cleanUp():void
		{
			preDrawnRotationBMDs = null;
		}
    }
}
