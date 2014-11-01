package com.Suman.display.blitting 
{
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.*;
	
	/**
	 * ...
	 * @author Suman Constantin
	 */
	public class  BlitManager
	{
		protected static var baseLayerBM:Bitmap;
		protected static var blitLayers:Vector.<BlitLayer>;
		protected static var targetParent:Sprite;
		public static var initialized:Boolean = false;
		public static var defaultPoint:Point = new Point(0,0);
		
		public static var BMDs:Object = new Object();
		
		protected static var _baseLayerBMD:BitmapData;
		public static function get baseLayerBMD():BitmapData{return _baseLayerBMD;}
		public static function set baseLayerBMD(_value:BitmapData):void {_baseLayerBMD = _value;}
		
		protected static var _autoUpdate:Boolean = false;
		public static function get autoUpdate():Boolean{return _autoUpdate;}
		public static function set autoUpdate(_value:Boolean):void 
		{
			if(_autoUpdate == _value) return;
			
			_autoUpdate = _value;
			
			if(_value)
				targetParent.addEventListener(Event.ENTER_FRAME, autoUpdateEnterFrame);
			else
				targetParent.removeEventListener(Event.ENTER_FRAME, autoUpdateEnterFrame);
		};
		
		public static var baseLayerBMDInit:BitmapData;
		
		public static function Init(_targetParent:*,_stageW,_stageH,_transparent:Boolean=true):void
		{
			if(initialized) return;
			
			initialized = true;
			targetParent = _targetParent;
			
			BMDs = new Object();
			
			baseLayerBMD = new BitmapData(_stageW, _stageH, _transparent, 0);
			baseLayerBM = new Bitmap(baseLayerBMD);
			targetParent.addChild(baseLayerBM);
			
			blitLayers = new Vector.<BlitLayer>();
		}
		
		private static function autoUpdateEnterFrame(e:Event):void
		{
			Update();
		}
		
		public static function Update():void
		{//trace("BlitManager.Update");
			_baseLayerBMD.lock();
			
			// Draw opaque baselayer
			if(baseLayerBMDInit != null)
				_baseLayerBMD.copyPixels(baseLayerBMDInit, baseLayerBMDInit.rect, baseLayerBMDInit.rect.topLeft);
			else
			{
				baseLayerBM.bitmapData.fillRect(baseLayerBM.bitmapData.rect, 0x00000000);
				//
				//_baseLayerBMD.fillRect(_baseLayerBMD.rect,0x00000000);
				//_baseLayerBMD.copyPixels(_baseLayerBMD,_baseLayerBMD.rect,defaultPoint,null,null,true);
			}
			
			// Draw all layers
			for each(var bLayer:BlitLayer in blitLayers)
				bLayer.Update();
			
			_baseLayerBMD.unlock();
        }
		
		public static function setBackgroundLayer(_img:*):void
		{
			// Set non-transparent background layer
			baseLayerBMDInit = new BitmapData(_img.width, _img.height, false, 0);
			baseLayerBMDInit.draw(_img);
		}
		
		public static function addLayer(_blitLayer:BlitLayer):void
		{
			// Check if layer with same name exists => do not add
			for each(var layer in blitLayers)
				if(layer.name == _blitLayer.name)
					return;
				
			blitLayers.push(_blitLayer);
		}
		
		public static function addImageTo(_blitImage:BlitImage, _blitLayerName:String):void
		{
			var layer:BlitLayer = getLayer(_blitLayerName);
			
			if(layer != null)
				getLayer(_blitLayerName).addChild(_blitImage);
		}
		
		public static function getLayer(_blitLayerName:String):BlitLayer
		{
			var len:int = blitLayers.length;
			for(var i:int = 0; i<len; i++)
			{
				if(blitLayers[i].name == _blitLayerName)
				{
					return blitLayers[i];
				}
			}
			
			return null;
		}
		
		public static function removeLayer(_blitLayer:BlitLayer):void
		{
			blitLayers.splice(blitLayers.indexOf(_blitLayer),1);
			_blitLayer.dispose();
		}
		
		public static function cleanUp():void
		{
			if(blitLayers)
				while(blitLayers.length > 0)
					removeLayer(blitLayers[0]);
			
			blitLayers = null;
			
			if(baseLayerBM.parent)
				baseLayerBM.parent.removeChild(baseLayerBM);
			baseLayerBM = null;
			
			baseLayerBMD = null;
			baseLayerBMDInit = null;
			
			BlitImage.cleanUp();
			
			initialized = false;
			
			autoUpdate = false;
			
			BMDs = null;
		}
	}
	
}