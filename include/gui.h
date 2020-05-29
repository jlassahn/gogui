
#include <stdint.h>
#include <stdbool.h>

typedef struct _POSITION
{
	int16_t percent;
	int16_t offset;
} POSITION;

POSITION Pos(int pct, int off);


typedef struct _COLOR
{
	uint8_t r;
	uint8_t g;
	uint8_t b;
	uint8_t a;
} COLOR;

// Line Join Styles
#define JOIN_ROUND 1
#define JOIN_MITER 2
#define JOIN_BEVEL 3

// Font Styles
#define FONT_NORMAL 0
#define FONT_BOLD   1
#define FONT_ITALIC 2
#define FONT_BOLD_ITALIC 3
// It's valid to assume FONT_BOLD_ITALIC == FONT_BOLD + FONT_ITALIC

// Window Styles
#define WINDOW_TITLED   0x0001
#define WINDOW_CLOSABLE 0x0002
#define WINDOW_SIZABLE  0x0004
#define WINDOW_TOPMOST  0x0010

#define WINDOW_NORMAL   0x0007

typedef struct iElement *Element;
typedef struct iBox *Box;
typedef struct iScrollBox *ScrollBox;
typedef struct iWindow *Window;
typedef struct iButton *Button;
typedef struct iMenu *Menu;
typedef struct iMenuItem *MenuItem;
typedef struct iImage *Image;
typedef struct iGraphics *Graphics;
typedef struct iFont *Font;

typedef struct iFileDialog *FileDialog;
typedef struct iTextInput *TextInput;


Element BoxToElement(Box b);

Element ScrollBoxToElement(ScrollBox b);
Box ScrollBoxToBox(ScrollBox b);

Element WindowToElement(Window w);
Box WindowToBox(Window w);

Element ButtonToElement(Button b);

Menu MenuItemToMenu(MenuItem m);

Element TextInputToElement(TextInput t);


void SetPosition(Element element,
	POSITION left,
	POSITION top,
	POSITION right,
	POSITION bottom);
void Show(Element element);
void Hide(Element element);
void Destroy(Element element);
Element GetParent(Element element);

Box CreateBox(void);
void AddChild(Box box, Element child);
void RemoveChild(Box box, int n);
int GetChildCount(Box box);
Element GetChild(Box box, int n);
void HandleResize(Box box, void (*fn)(void *ctx), void *ctx);
void HandleMouseMove(Box box, void (*fn)(void *ctx, int x, int y), void *ctx);
void HandleMouseDown(Box box, void (*fn)(void *ctx, int x, int y, int btn), void *ctx);
void HandleMouseUp(Box box, void (*fn)(void *ctx, int x, int y, int bn), void *ctx);
void HandleMouseEnter(Box box, void (*fn)(void *ctx), void *ctx);
void HandleMouseLeave(Box box, void (*fn)(void *ctx), void *ctx);
void HandleKeyDown(Box box, void (*fn)(void *ctx, int ch, int flags), void *ctx);
void HandleKeyUp(Box box, void (*fn)(void *ctx, int ch, int flags), void *ctx);
void HandleRedraw(Box box, void (*fn)(void *ctx, Graphics gfx), void *ctx);
void ForceRedraw(Box box);

Window CreateWindow(int mode);
void SetTitle(Window window, const char *txt);
void SetMenu(Window window, Menu menu);
void HandleClose(Window window, void (*fn)(void *), void *ctx);

Menu CreateMenu(void);
void AddMenuItem(Menu  menu, MenuItem item);
void AddMenuSeparator(Menu  menu);
int GetMenuItemCount(Menu menu);
MenuItem GetMenuItem(Menu menu, int n);

// returns MacOS app menu, Windows returns NULL
MenuItem GetApplicationMenu(Menu menu);

MenuItem CreateTextMenuItem(const char *txt);
MenuItem CreateImgTextMenuItem(Image img, const char *txt);
void HandleMenuSelect(MenuItem item, void (*fn)(void *), void *ctx);
void SetMenuShortcut(MenuItem item, const char *key);

ScrollBox CreateScrollBox(void);
void SetContentSize(ScrollBox box, int width, int height);
void SetBackgroundColor(ScrollBox box, COLOR color);
int GetVisibleWidth(ScrollBox box);
int GetVisibleHeight(ScrollBox box);
int GetVisibleLeft(ScrollBox box);
int GetVisibleTop(ScrollBox box);
void SetVisibleLeftTop(ScrollBox box, int left, int top);

Button CreateTextButton(const char *txt);
Button CreateImageButton(Image img);
Button CreateImgTextButton(Image img, const char *txt);
void SetText(Button button, const char *txt);
void SetImage(Button button, Image img);

void HandleClick(Button button, void (*fn)(void *), void *ctx);
int GetBestWidth(Button button);
int GetBestHeight(Button button);

int GetCanvasWidth(Graphics gfx);
int GetCanvasHeight(Graphics gfx);
void SetStrokeColor(Graphics gfx, COLOR color);
void SetFillColor(Graphics gfx, COLOR color);
void SetLineWidth(Graphics gfx, double width);
void SetLineJoin(Graphics gfx, int join_style);
void StartPath(Graphics gfx, double x, double y);
void LineTo(Graphics gfx, double x, double y);
void CurveTo(Graphics gfx,
		double c1x, double c1y,
		double c2x, double c2y,
		double x, double y);
void ClosePath(Graphics gfx);
void StrokePath(Graphics gfx);
void FillCanvas(Graphics gfx);
void FillPath(Graphics gfx);
void SetFont(Graphics gfx, Font font, double size);
void SetDefaultFont(Graphics gfx); //selects a font used for normal UI text
void DrawText(Graphics gfx, double x, double y, double angle, const char *txt);
double MeasureText(Graphics gfx, const char *txt);
void DrawImage(Graphics gfx,
		double x, double y,
		double width, double height,
		Image img);


Image CreateImage(int width, int height);
Image CreateImageFromFile(const char *filename);
void DestroyImage(Image img);
uint8_t *GetImageBuffer(Image img);
int GetImageBufferSize(Image img);
Graphics BeginDrawToImage(Image img);
void EndDrawToImage(Image img, Graphics gfx);


Font CreateFont(const char *family, int style);
void DestroyFont(Font font);

FileDialog CreateOpenFileDialog(void);
FileDialog CreateSaveFileDialog(void);
void DestroyFileDialog(FileDialog dlg);
bool RunDialog(FileDialog dlg); //FIXME subclass
void SetFileDialogFile(FileDialog dlg, const char *filename);
const char *GetFileDialogFile(FileDialog dlg);

TextInput CreateTextLineInput(void);
void SetTextData(TextInput t, const char *txt);
void HandleChange(TextInput t, void (*fn)(void *, const char *), void *ctx);
int GetBestTextHeight(TextInput t);
const char *GetTextData(TextInput t);

void Init(void);
void Exit(void);
void StopEventLoop(int ret);
int RunEventLoop(void);

// FIXME MacOS specific stuff...
void HandleAppOpenFile(bool (*fn)(void *, const char *), void *ctx);

