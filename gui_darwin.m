
#import <stdlib.h>
#import "Cocoa/Cocoa.h"
#import "include/m_gui.h"

static void *appOpenFileContext;
static bool (*appOpenFileCallback)(void *ctx, const char *txt);

@interface GUIApplication : NSApplication
{ }
-(void) sendEvent: (NSEvent *) event;
@end

@interface GUIDelegate : NSObject <NSApplicationDelegate>
{ }
- (BOOL) application: (NSApplication *)sender openFile: (NSString *)filename;
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

-(void) noop: (id)unused
{
}

@end

@implementation GUIDelegate
- (BOOL) application: (NSApplication *)sender openFile: (NSString *)filename
{
	if (appOpenFileCallback)
		return appOpenFileCallback(appOpenFileContext, [filename UTF8String]);
	else
		return NO;
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
	GUIDelegate *del;

	// create a NO-OP thread so Cocoa knows it's running multithreaded
	[NSThread detachNewThreadSelector: @selector(noop) toTarget: NSApp withObject: NULL];

	del = [[GUIDelegate alloc] init];
	[GUIApplication sharedApplication];
	[NSApp setDelegate: del];
	[NSWindow setAllowsAutomaticWindowTabbing: NO];
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

void HandleAppOpenFile(bool (*fn)(void *, const char *), void *ctx)
{
	appOpenFileCallback = fn;
	appOpenFileContext = ctx;
}


