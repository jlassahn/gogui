

#import "include/m_gui.h"
#import "util_darwin.h"


@implementation iFileDialog

- (id) initAsOpen
{
	self = [super init];
	if (!self)
		return self;

	nspanel = [[NSOpenPanel alloc] init];
	// FIXME so we want to set file type limits?
	//NSArray *filetypes = @[ @"json", @"msch"];
	//[nspanel  setAllowedFileTypes: filetypes];
	//[nspanel setAllowsOtherFileTypes: YES];
	return self;
}

- (id) initAsSave
{
	self = [super init];
	if (!self)
		return self;

	nspanel = [[NSSavePanel alloc] init];
	return self;
}

- (BOOL) run
{
	return [nspanel runModal] == NSModalResponseOK;
}

- (void) setFile: (NSString *)filename
{
	// FIXME implement
}

- (NSString *) file
{
	return [[nspanel URL] path];
}

@end

FileDialog CreateOpenFileDialog(void)
{
	return (FileDialog)[[iFileDialog alloc] initAsOpen];
}

FileDialog CreateSaveFileDialog(void)
{
	return (FileDialog)[[iFileDialog alloc] initAsSave];
}

bool RunDialog(FileDialog dlg)
{
	return [(iFileDialog *)dlg run];
}

void DestroyFileDialog(FileDialog dlg)
{
	//FIXME implement
}

void SetFileDialogFile(FileDialog dlg, const char *filename)
{
	//FIXME implement
}

const char *GetFileDialogFile(FileDialog dlg)
{
	return [[(iFileDialog *)dlg file] UTF8String];
}

