
#import "include/m_gui.h"

@implementation iMenu

- (id) init
	{
		MenuItem appMenu;

		self = [super init];
		if (!self)
			return self;

		self->menu = [[NSMenu alloc] init];
		[self->menu setAutoenablesItems: NO];


		appMenu = CreateTextMenuItem("Application");
		[self addMenuItem: (iMenuItem *)appMenu];
		self->_applicationMenu = (iMenuItem *)appMenu;

		return self;
	}

- (id) initForSubmenu
	{
		self = [super init];
		if (!self)
			return self;
		self->menu = NULL;
		return self;
	}

- (void) addMenuItem: (iMenuItem *)it
	{
		[ self->menu addItem: [it getNSItem]];
	}

- (void) addMenuSeparator
	{
		[ self->menu addItem: [NSMenuItem separatorItem]];
	}

- (NSMenu *) getNSMenu
	{
		return self->menu;
	}
@end

@implementation iMenuItem
- (id) initWithText: (NSString *) txt
	{
		self = [super initForSubmenu];
		if (!self)
			return self;

		//action: @selector(onSelect:);
		self->item = [[NSMenuItem alloc] initWithTitle: txt
			action: @selector(onSelect:)
			keyEquivalent: @""];
		[self->item setTarget: self];
		self->text = txt;
		[txt retain];
		[self->item setEnabled: YES]; //FIXME have an enable menu somewhere

		return self;
	}

- (NSMenuItem *) getNSItem
	{
		return self->item;
	}

- (void) addMenuItem: (iMenuItem *)it
	{
		if (self->menu == NULL)
		{
			self->menu = [[NSMenu alloc] initWithTitle: self->text];
			[self->menu setAutoenablesItems: NO];
			[self->item setSubmenu: self->menu];
		}
		[ self->menu addItem: [it getNSItem]];
	}


- (void) handleSelect: (void (*)(void *)) fn withContext: (void *) ctx
	{
		self->handle_select = fn;
		self->handle_select_ctx = ctx;
	}

- (void) onSelect: (id)sender
	{
		if (self->handle_select)
			self->handle_select(self->handle_select_ctx);
	}

- (void) setShortcut: (NSString *)str
	{
		[self->item setKeyEquivalent: str];
	}

@end

Menu CreateMenu(void)
{
	return (Menu)[[iMenu alloc] init];
}

MenuItem CreateTextMenuItem(const char *txt)
{
	NSString *str = [NSString stringWithCString:txt encoding:NSUTF8StringEncoding];
	return (MenuItem)[[iMenuItem alloc] initWithText: str];
}

MenuItem CreateImgTextMenuItem(Image img, const char *txt)
{
	return NULL;
}

void SetMenuShortcut(MenuItem item, const char *key)
{
	NSString *str = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
	[(iMenuItem *)item setShortcut: str];
}

Menu MenuItemToMenu(MenuItem mi)
{
	return (Menu)mi;
}

void AddMenuItem(Menu  menu, MenuItem item)
{
	[ (iMenu *)menu addMenuItem: (iMenuItem *)item];
}

void AddMenuSeparator(Menu  menu)
{
	[ (iMenu *)menu addMenuSeparator];
}

void HandleMenuSelect(MenuItem item, void (*fn)(void *), void *ctx)
{
	[(iMenuItem *)item handleSelect: fn withContext: ctx];
}

MenuItem GetApplicationMenu(Menu menu)
{
	return (MenuItem)[(iMenu *)menu applicationMenu];
}

