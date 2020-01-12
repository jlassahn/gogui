
#import <stdlib.h>
#import "Cocoa/Cocoa.h"
#import "include/m_gui.h"

@interface GUIApplication : NSApplication
{ }
-(void) sendEvent: (NSEvent *) event;
@end

static int eventReturn;


@implementation GUIApplication
-(void) sendEvent: (NSEvent *) event;
{
	if ([event type] == NSEventTypeApplicationDefined)
	{
		[self stop:self];
		return;
	}

	[super sendEvent:event];
}
@end

POSITION Pos(int pct, int off)
{
	POSITION ret;
	ret.percent = pct;
	ret.offset = off;
	return ret;
}

void Init(void)
{
	[GUIApplication sharedApplication];
}

void Exit(void)
{
}

void StopEventLoop(int ret)
{
	eventReturn = ret;
	NSPoint p = {0, 0};

	NSEvent *e = [NSEvent
		otherEventWithType: NSEventTypeApplicationDefined
		location: p
		modifierFlags: 0
		timestamp: 0
		windowNumber: 0
		context: nil
		subtype: 1
		data1: 0
		data2: 0 ];

	[NSApp postEvent: e atStart: NO];
}

int RunEventLoop(void)
{
	[NSApp run];
	return eventReturn;
}
