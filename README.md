as3-blitting-framework
======================

AS3 Blitting Framework

Usage:

1.	// Init the BlitManager

	BlitManager.Init(target_display_object, target_width, target_height);
	
2.	// Set background

	BlitManager.setBackgroundLayer(new BackgroundAsset());
	
	// This layer is blitted non-opaque (non-transparent), which is CPU-cheap
	
	// In case you don't need/want a non-opaque background layer, skip this step.
	
	// In case you need an opaque background layer, follow the steps below.
	
3.	// Create blit layer(s)

	BlitManager.addLayer(new BlitLayer(layer_name));
	
	// A layer organizes the images.
	// Images of the first added layer will appear under the images of the second added layer, and so on.

4.	// Create a BlitImage

	var blitImg:BlitImage = new BlitImage(IBitmapDrawable_asset, image_name, allow_rotation);
	
	// IBitmapDrawable_asset may be a sprite, movieclip, bitmap.
	
	// The cached bitmapData is linked to the image_name.
	
	// In case of multiple objects with the same image_name, the cached bitmapData will be used instead of drawing a new one.
	
	// Allow_rotation - caches rotated bitmapData and allows this image to be rotated.
	
	
5.	// Add blitImg to a blit layer

	BlitManager.getLayer(layer_name).addChild(blitImg);
	
	// The first added image will appear under the second, and so on.
	
6.	// Update the blit framework on each frame

	BlitManager.Update();

//-----------

// ToDo:

// - cache bmd of non-rotating images

// - set/unset allowRotation

// - scaling

// - movieclips

// - use starling assets as source