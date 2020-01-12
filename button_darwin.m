
#import "include/m_gui.h"

//FIXME looks like sizing is not handling the border of the button properly

@implementation iButton
- (id) initWithText: (NSString *) txt
	{
		self = [super init];
		if (!self)
			return self;

		//FIXME do we need both a button and a view member?
		self->button = [NSButton
			buttonWithTitle: txt
			target: self
			action: @selector(onClick:)];

		self->view = button;
		self->image = NULL;

		//FIXME set hidden property?

		return self;
	}

- (id) initWithImage: (iImage *)img
	{
		self = [super init];
		if (!self)
			return self;

		self->image = img;

		NSImage *nsimage = [image getNSImage];

		//FIXME do we need both a button and a view member?
		self->button = [NSButton
			buttonWithImage: nsimage
			target: self
			action: @selector(onClick:)];
		[self->button setBezelStyle: NSBezelStyleShadowlessSquare];
		[self->button setBordered: YES];

		self->view = button;

		//FIXME set hidden property?

		return self;
	}

- (id) initWithImage: (iImage *)img text: (NSString *)txt
	{
		self = [super init];
		if (!self)
			return self;

		self->image = img;

		NSImage *nsimage = [image getNSImage];

		//FIXME do we need both a button and a view member?
		self->button = [NSButton
			buttonWithTitle: txt
			image: nsimage
			target: self
			action: @selector(onClick:)];
		//[self->button setBezelStyle: NSBezelStyleShadowlessSquare];
		//[self->button setBordered: YES];

		self->view = button;

		//FIXME set hidden property?

		return self;
	}

- (void) handleClick: (void (*)(void *)) fn withContext: (void *) ctx
	{
		self->handle_click = fn;
		self->handle_click_ctx = ctx;
	}

- (void) onClick: (id)sender
	{
		if (self->handle_click)
			self->handle_click(self->handle_click_ctx);
	}

- (int) bestWidth
	{
		return [self->button intrinsicContentSize].width;
	}

- (int) bestHeight
	{
		//FIXME add 4 points as a hack because this is returning too small
		//      not sure what the root cause is...
		return [self->button intrinsicContentSize].height + 4;
	}

@end

Button CreateTextButton(const char *txt)
{
	NSString *str = [NSString stringWithCString:txt encoding:NSUTF8StringEncoding];

	return (Button)[[iButton alloc] initWithText: str];
}

Button CreateImageButton(Image img)
{
	return (Button)[[iButton alloc] initWithImage: (iImage *)img];
}

Button CreateImgTextButton(Image img, const char *txt)
{
	NSString *str = [NSString stringWithCString:txt encoding:NSUTF8StringEncoding];
	return (Button)[[iButton alloc] initWithImage: (iImage *)img text: str];
}


Element ButtonToElement(Button b)
{
	return (Element)b;
}

void HandleClick(Button button, void (*fn)(void *), void *ctx)
{
	[(iButton *)button handleClick: fn withContext: ctx];
}

int GetBestWidth(Button button)
{
	return [(iButton *)button bestWidth];
}

int GetBestHeight(Button button)
{
	return [(iButton *)button bestHeight];
}

