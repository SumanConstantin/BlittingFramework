package
{
	import com.Suman.display.blitting.BlitImage;
	import com.Suman.display.blitting.BlitLayer;
	import com.Suman.display.blitting.BlitMC;
	import com.Suman.display.blitting.BlitManager;
	
	import flash.display.*;
	import flash.events.Event;
	
	[SWF(backgroundColor='#000044',frameRate='24')]
	
	public class BlittingFramework extends Sprite
	{
		[Embed(source='smiley_back.jpg')]
		public const BackgroundAsset:Class;
		
		[Embed(source='smiley.png')]
		public const CharAsset:Class;
		
		[Embed (source = "explodeGem.swf", symbol = "ExplodeGem2")]
		public static var ExplodeGem2:Class;
		
		protected var numberOfCharsMax:int = 1000;
		protected var chars:Vector.<Object> = new Vector.<Object>();
		
		protected const STATE_ADDING:String = "state_adding";
		protected const STATE_REMOVING:String = "state_removing";
		protected var state:String = STATE_ADDING;
		
			
		public function BlittingFramework()
		{
			// Init the BlitManager
			BlitManager.Init(this, stage.stageWidth, stage.stageHeight);
			
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function Init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Get sprite of background
			BlitManager.setBackgroundLayer(new BackgroundAsset());
			// Create a blit layer for chars
			BlitManager.addLayer(new BlitLayer("charLayer"));
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		//}
		
		//protected function onEnterFrame(e:Event):void
		//{
			/*
			// Add/remove chars
			if(state == STATE_ADDING)
			{
				for(var i:int = 0; i<10; i++)
				{
					var char:Object = new Object();
					char.img = new BlitImage(new CharAsset(), "charName1", true);
					char.x = Math.random()*(stage.stageWidth-char.img.width);
					char.y = Math.random()*(stage.stageHeight-char.img.height);
					char.stepX = Math.random() > .5 ? Math.random()*3 : -Math.random()*3;
					char.stepY = Math.random() > .5 ? Math.random()*3 : -Math.random()*3;
					char.stepRot = Math.random() > .5 ? 5+Math.random()*5 : -5+Math.random()*5;
					char.width = char.img.width;
					char.height = char.img.height;
					
					BlitManager.getLayer("charLayer").addChild(char.img);
					
					chars.push(char);
				}
				
				if(chars.length == numberOfCharsMax)
					state = STATE_REMOVING;
			}
			else
			if(state == STATE_REMOVING)
			{
				if(chars.length > 0)
				{
					for(var i:int = 0; i<10; i++)
					{
						if(chars.length > 0)
						{
							chars[0].img.dispose();
							chars.splice(0,1);
						}
					}
				}
				
				if(chars.length == 0)
					state = STATE_ADDING;
			}
						
			
			// Update chars
			var len:int = chars.length;
			for each (var char:Object in chars)
			{
				char.img.x = char.x += char.stepX;
				char.img.y = char.y += char.stepY;
				char.img.rotation += char.stepRot;
				
				if(char.x < 0 || char.x > stage.stageWidth - char.width)
					char.stepX = -char.stepX;
				
				if(char.y < 0 || char.y > stage.stageHeight - char.height)
					char.stepY = -char.stepY;
			}
			*/
			
			
			var char:Object = new Object();
			char.bitmapDisplayObject = new BlitMC(new ExplodeGem2());
			char.bitmapDisplayObject.x = 50;//Math.random()*(stage.stageWidth-char.bitmapDisplayObject.width);
			char.bitmapDisplayObject.y = 100;// Math.random()*(stage.stageHeight-char.bitmapDisplayObject.height);
			chars.push(char);
			BlitManager.getLayer("charLayer").addChild(char.bitmapDisplayObject);
			
			char = new Object();
			char.bitmapDisplayObject = new BlitMC(new ExplodeGem2());
			char.bitmapDisplayObject.x = 70;//Math.random()*(stage.stageWidth-char.bitmapDisplayObject.width);
			char.bitmapDisplayObject.y = 100;//Math.random()*(stage.stageHeight-char.bitmapDisplayObject.height);
			chars.push(char);
			BlitManager.getLayer("charLayer").addChild(char.bitmapDisplayObject);
		}
		
		protected function onEnterFrame(e:Event):void	
		{
			BlitManager.Update();
		}
		
		public function dispose():void
		{
			while(chars.length > 0)
			{
				if(chars[0].img)
					chars[0].img.dispose();
				if(chars[0].mc)
					chars[0].mc.dispose();
				
				chars.splice(0,1);
			}
			
			BlitManager.cleanUp();
		}
		
	}
}