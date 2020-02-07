
#import "include/m_gui.h"
#import "util_darwin.h"

struct iGraphics
{
	int width;
	int height;
	NSBezierPath *path;
	NSDictionary *fontAttributes;
};

struct iFont
{
	NSFont *nsfont;
};

static struct iGraphics shared_context;

Graphics gfxStartRender(int width, int height)
{
	shared_context.width = width;
	shared_context.height = height;
	shared_context.path = [NSBezierPath bezierPath];
	shared_context.fontAttributes = [[NSMutableDictionary alloc] init];

	COLOR white = {255, 255, 255, 255};
	COLOR black = {0, 0, 0, 255};

	SetStrokeColor(&shared_context, black);
	SetFillColor(&shared_context, white);
	SetLineWidth(&shared_context, 1.0);
	SetLineJoin(&shared_context, JOIN_ROUND);
	SetDefaultFont(&shared_context);

	return &shared_context;
}

void gfxEndRender(Graphics gfx)
{
	[shared_context.fontAttributes release];
	shared_context.fontAttributes = NULL;
}

int GetCanvasWidth(Graphics gfx)
{
	return gfx->width;
}

int GetCanvasHeight(Graphics gfx)
{
	return gfx->height;
}

void FillCanvas(Graphics gfx) {
	NSRect bounds;
	bounds.origin.x = 0;
	bounds.origin.y = 0;
	bounds.size.width = gfx->width;
	bounds.size.height = gfx->height;
	NSRectFill(bounds);
}

void SetStrokeColor(Graphics gfx, COLOR color) {
		NSColor *col = [NSColor
			colorWithCalibratedRed: color.r/255.0
			green: color.g/255.0
			blue: color.b/255.0
			alpha: color.a/255.0];

		[col setStroke];
		[gfx->fontAttributes setValue: col forKey: NSForegroundColorAttributeName];
}

void SetFillColor(Graphics gfx, COLOR color) {
		NSColor *col = [NSColor
			colorWithCalibratedRed: color.r/255.0
			green: color.g/255.0
			blue: color.b/255.0
			alpha: color.a/255.0];

		[col setFill];
}

void SetLineWidth(Graphics gfx, double width) {
	[gfx->path setLineWidth: width];
}

void SetLineJoin(Graphics gfx, int join_style) {
	switch(join_style)
	{
		case JOIN_MITER:
			[gfx->path setLineJoinStyle: NSLineJoinStyleMiter];
			[gfx->path setLineCapStyle: NSLineCapStyleSquare];
			break;
		case JOIN_BEVEL:
			[gfx->path setLineJoinStyle: NSLineJoinStyleBevel];
			[gfx->path setLineCapStyle: NSLineCapStyleSquare];
			break;
		case JOIN_ROUND:
		default:
			[gfx->path setLineJoinStyle: NSLineJoinStyleRound];
			[gfx->path setLineCapStyle: NSLineCapStyleRound];
	}
}

void StartPath(Graphics gfx, double x, double y) {
	NSPoint pt;
	pt.x = x;
	pt.y = gfx->height-y;
	[gfx->path removeAllPoints];
	[gfx->path moveToPoint: pt];
}

void LineTo(Graphics gfx, double x, double y) {
	NSPoint pt;
	pt.x = x;
	pt.y = gfx->height-y;
	[gfx->path lineToPoint: pt];
}

void CurveTo(Graphics gfx,
		double c1x, double c1y,
		double c2x, double c2y,
		double x, double y) {

	NSPoint c1;
	c1.x = c1x;
	c1.y = gfx->height-c1y;

	NSPoint c2;
	c2.x = c2x;
	c2.y = gfx->height-c2y;

	NSPoint pt;
	pt.x = x;
	pt.y = gfx->height-y;

	[gfx->path curveToPoint: pt controlPoint1: c1 controlPoint2: c2];
}

void ClosePath(Graphics gfx) {
	[gfx->path closePath];
}

void StrokePath(Graphics gfx) {
	[gfx->path stroke];
}

void FillPath(Graphics gfx) {
	[gfx->path fill];
}

void SetFont(Graphics gfx, Font font, double size) {
	NSFont *fnt = [NSFont fontWithName: [font->nsfont fontName] size: size];
	[gfx->fontAttributes setValue: fnt forKey: NSFontAttributeName];
}

void SetDefaultFont(Graphics gfx) {
	NSFont *font = [NSFont systemFontOfSize: 0];
	[gfx->fontAttributes setValue: font forKey: NSFontAttributeName];
}

double MeasureText(Graphics gfx, const char *txt)
{
	NSString *str = [NSString stringWithCString:txt encoding:NSUTF8StringEncoding];
	return [str sizeWithAttributes: gfx->fontAttributes].width;
}

void DrawText(Graphics gfx, double x, double y, double angle, const char *txt) {

	NSString *str = [NSString stringWithCString:txt encoding:NSUTF8StringEncoding];

	NSAffineTransform *xform = [NSAffineTransform transform];
	[xform translateXBy: x yBy: gfx->height-y];
	[xform rotateByDegrees: -angle];

	[xform concat];

	double baseline = [ gfx->fontAttributes[NSFontAttributeName] descender];

	NSPoint pt;
	pt.x = 0;
	pt.y = baseline;
	[str drawAtPoint: pt withAttributes: gfx->fontAttributes];

	[xform invert];
	[xform concat];
}

void DrawImage(Graphics gfx,
		double x, double y,
		double width, double height,
		Image img) {}


Font CreateFont(const char *family, int style)
{
	NSString *str = [NSString stringWithCString:family encoding:NSUTF8StringEncoding];
	NSFont *fnt = [NSFont fontWithName: str size: 12];
	if (!fnt)
		return NULL;

	struct iFont *ret = malloc(sizeof(struct iFont));
	ret->nsfont = fnt;
	return ret;
}

void DestroyFont(Font font)
{
	free(font);
}

