package com.Suman.display.blitting 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Suman Constantin
	 */
	public class  BlitManager
	{
		protected static var baseLayerBM:Bitmap;
		protected static var blitLayers:Vector.<BlitLayer>;
		
		protected static var _baseLayerBMD:BitmapData;
		public static function get baseLayerBMD():BitmapData
		{
			return _baseLayerBMD;
		}
		public static function set baseLayerBMD(_value:BitmapData):void
		{
			_baseLayerBMD = _value;
		}
		
		public static var baseLayerBMDInit:BitmapData;
		
		public static function Init(_targetParent:*,_stageW,_stageH):void
		{
			baseLayerBMD = new BitmapData(_stageW, _stageH, false, 0);
			
			baseLayerBM = new Bitmap(baseLayerBMD);
			_targetParent.addChild(baseLayerBM);
			
			blitLayers = new Vector.<BlitLayer>();
		}
		
		public static function Update():void
		{
			baseLayerBMD.lock();
			
			// Draw opaque baselayer
			if(baseLayerBMD != null)
				baseLayerBMD.copyPixels(baseLayerBMDInit, baseLayerBMDInit.rect, baseLayerBMDInit.rect.topLeft);
			
			// Draw all layers
			for each(var bLayer:BlitLayer in blitLayers)
				bLayer.Update();
			
			baseLayerBMD.unlock();
        }
		
		public static function setBackgroundLayer(_img:*):void
		{
			// Set non-transparent background layer
			BlitManager.baseLayerBMDInit = new BitmapData(_img.width, _img.height, false, 0);
			BlitManager.baseLayerBMDInit.draw(_img);
		}
		
		public static function addLayer(_blitLayer:BlitLayer):void
		{
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
			while(blitLayers.length > 0)
				removeLayer(blitLayers[0]);
			blitLayers = null;
			
			if(baseLayerBM.parent)
				baseLayerBM.parent.removeChild(baseLayerBM);
			baseLayerBM = null;
			
			baseLayerBMD = null;
			baseLayerBMDInit = null;
			
			BlitImage.cleanUp();
		}
	}
	
}