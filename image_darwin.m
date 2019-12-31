
#import "include/m_gui.h"

@implementation iImage

- (id) initWithWidth: (int)w height: (int)h
	{
		self = [super init];
		if (!self)
			return self;

		self->width = w;
		self->height = h;

		NSSize size;
		size.width = w;
		size.height = h;
		self->img = [[NSImage alloc] initWithSize: size];
		self->rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes: NULL
				pixelsWide: w
				pixelsHigh: h
				bitsPerSample: 8
				samplesPerPixel: 4
				hasAlpha: YES
				isPlanar: NO
				colorSpaceName: NSCalibratedRGBColorSpace
				bytesPerRow: 4*w
				bitsPerPixel: 32];

		[self->img addRepresentation: self->rep];
		uint8_t *buf = [self->rep bitmapData];
		memset(buf, 0, w*h*4);

		return self;
		
	}

- (NSImage *) getNSImage
	{
		return self->img;
	}

- (uint8_t *) buffer
	{
		return [self->rep bitmapData];
	}

- (int) bufferSize
	{
		return self->width*self->height*4;
	}


		/* FIXME notes on images
			Draw into a bitmap by
				Create an NSImage
				Create a NSBitmapImageRep and add it to the NSImage
				Use NSGraphicsContext::graphicsContextWithBitmapImageRep
			Other methods load image files into an NSImage, but they
			don't guarantee that the representation is compatible with
			the drawing procedure above.
		 */

- (Graphics) beginDraw
	{
		NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: self->rep];
		[NSGraphicsContext saveGraphicsState];
		[NSGraphicsContext setCurrentContext: ctx];

		return gfxStartRender(self->width, self->height);
	}

- (void) endDraw: (Graphics) gfx
	{
		gfxEndRender(gfx);
		[NSGraphicsContext restoreGraphicsState];
	}
@end

Image CreateImage(int width, int height)
{
	return (Image)[[iImage alloc] initWithWidth: width height:height];
}


void DestroyImage(Image img)
{
	//FIXME
}

uint8_t *GetImageBuffer(Image img)
{
	return [(iImage *)img buffer];
}

int GetImageBufferSize(Image img)
{
	return [(iImage *)img bufferSize];
}


Graphics BeginDrawToImage(Image img)
{
	return [(iImage *)img beginDraw];
}

void EndDrawToImage(Image img, Graphics gfx)
{
	[(iImage *)img endDraw: gfx];
}

