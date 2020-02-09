
#import "include/m_gui.h"

@implementation iMenu

- (void) makeMain
	{
		[NSApp setMainMenu: self->menu];
	}

- (id) init
	{
		self = [super init];
		if (!self)
			return self;

		self->menu = [[NSMenu alloc] init];
		[self->menu setAutoenablesItems: NO];
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
		printf("adding menu item: %p to %p\n", [it getNSItem], self->menu);
		[ self->menu addItem: [it getNSItem]];
		printf("number of items: %d\n", (int)[self->menu numberOfItems]);
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
			printf("adding first submenu to %p\n", self);
			self->menu = [[NSMenu alloc] initWithTitle: self->text];
			[self->menu setAutoenablesItems: NO];
			[self->item setSubmenu: self->menu];
		}
		printf("adding item to %p\n", self);
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

void SetMainMenu(Menu m)
{
	[ (iMenu *)m makeMain];
}

Menu MenuItemToMenu(MenuItem mi)
{
	return (Menu)mi;
}

void AddMenuItem(Menu  menu, MenuItem item)
{
	[ (iMenu *)menu addMenuItem: (iMenuItem *)item];
}

void HandleMenuSelect(MenuItem item, void (*fn)(void *), void *ctx)
{
	[(iMenuItem *)item handleSelect: fn withContext: ctx];
}

