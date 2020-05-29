
#import "include/m_gui.h"

// FIXME control doesn't fit in it's bounding box right

@implementation iTextInput
- (id) init
	{
		self = [super init];
		if (!self)
			return self;

		self->textField = [NSTextField textFieldWithString: @""];

		self->view = textField;
		[textField setEditable: YES];
		[textField setTarget: self];
		[textField setAction: @selector(onChange:)];


		//FIXME set hidden property?

		return self;
	}

- (void) handleChange: (void (*)(void *, const char *txt)) fn withContext: (void *) ctx
	{
		self->handle_change = fn;
		self->handle_change_ctx = ctx;
	}

- (void) onChange: (id)sender
	{
		NSLog(@"onChange, text = %@", [textField stringValue]);
		if (self->handle_change)
		{
			const char * txt = [[textField stringValue] UTF8String];
			self->handle_change(self->handle_change_ctx, txt);
		}
	}

- (int) bestHeight
	{
		//FIXME add 4 points as a hack because this is returning too small
		//      not sure what the root cause is...
		return [textField intrinsicContentSize].height + 4;
	}

- (NSString *) getValue
	{
		return [textField stringValue];
	}

- (void) setValue: (NSString *)val
	{
		[textField setStringValue: val];
	}

@end

Element TextInputToElement(TextInput t)
{
	return (Element)t;
}

TextInput CreateTextLineInput(void)
{
	return (TextInput)[[iTextInput alloc] init];
}

void SetTextData(TextInput t, const char *txt)
{
	NSString *str = [NSString stringWithCString:txt encoding:NSUTF8StringEncoding];
	[(iTextInput *)t setValue: str];
}

void HandleChange(TextInput t, void (*fn)(void *, const char *), void *ctx)
{
	[(iTextInput *)t handleChange: fn withContext: ctx];
}

int GetBestTextHeight(TextInput t)
{
	return [(iTextInput *)t bestHeight];
}

const char *GetTextData(TextInput t)
{
	return [[(iTextInput *)t getValue] UTF8String];
}

