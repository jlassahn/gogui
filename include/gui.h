
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

// Join Styles
#define JOIN_ROUND 1
#define JOIN_MITER 2
#define JOIN_BEVEL 3

// Font Styles
#define FONT_NORMAL 0
#define FONT_BOLD   1
#define FONT_ITALIC 2
#define FONT_BOLD_ITALIC 3
// It's valid to assume FONT_BOLD_ITALIC == FONT_BOLD + FONT_ITALIC

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


Element BoxToElement(Box b);

Element ScrollBoxToElement(ScrollBox b);
Box ScrollBoxToBox(ScrollBox b);

Element WindowToElement(Window w);
Box WindowToBox(Window w);

Element ButtonToElement(Button b);

Menu MenuItemToMenu(MenuItem m);


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
void HandleResize(Box box, void (*fn)(void *), void *ctx);
void HandleMouseMove(Box box, void (*fn)(void *, int, int), void *ctx);
void HandleMouseDown(Box box, void (*fn)(void *, int), void *ctx);
void HandleMouseUp(Box box, void (*fn)(void *, int), void *ctx);
void HandleMouseEnter(Box box, void (*fn)(void *), void *ctx);
void HandleMouseLeave(Box box, void (*fn)(void *), void *ctx);
void HandleKeyDown(Box box, void (*fn)(void *, int), void *ctx);
void HandleKeyUp(Box box, void (*fn)(void *, int), void *ctx);
void HandleRedraw(Box box, void (*fn)(void *, Graphics), void *ctx);
void ForceRedraw(Box box);

Window CreateWindow(void);
void SetTitle(Window window, const char *txt);
void SetMenu(Window window, Menu menu);
void HandleClose(Window window, void (*fn)(void *), void *ctx);

Menu CreateMenu(void);
void AddMenuItem(Menu  menu, MenuItem item);
int GetMenuItemCount(Menu menu);
MenuItem GetMenuItem(Menu menu, int n);
void SetMainMenu(Menu menu); //FIXME remove

MenuItem CreateTextMenuItem(const char *txt);
MenuItem CreateImgTextMenuItem(Image img, const char *txt);
void HandleMenuSelect(MenuItem item, void (*fn)(void *), void *ctx);

ScrollBox CreateScrollBox(void);
void SetContentSize(ScrollBox box, int width, int height);

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
void DestroyFileDialog(FileDialog dlg);
bool RunDialog(FileDialog dlg); //FIXME subclass
void SetFileDialogFile(FileDialog dlg, const char *filename);
const char *GetFileDialogFile(FileDialog dlg);

void Init(void);
void Exit(void);
void StopEventLoop(int ret);
int RunEventLoop(void);

// FIXME MacOS specific stuff...
void HandleAppOpenFile(bool (*fn)(void *, const char *), void *ctx);

