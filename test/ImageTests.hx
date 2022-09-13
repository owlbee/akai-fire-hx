package test;

import akaifirehx.fire.display.Canvas.Image;

class ImageTests {
	static function main() {
		test_writeImage();
	}

	static var image:Image;

	/** tests writing an Image to disk **/
	static function test_writeImage() {
		image = new Image(64, 64);
		image.setPixel(0, 0, true);
		image.setPixel(8, 8, true);
		image.setPixel(16, 16, true);
		image.write("test-image.png");
	}
}
