
#import "include/m_gui.h"
#import "util_darwin.h"

@implementation iElement
- (void) setPositionLeft: (POSITION)leftIn
		Top: (POSITION)topIn
		Right: (POSITION)rightIn
		Bottom: (POSITION)bottomIn
	{
		NSLog(@"FIXME base SetPosition called");
		self->left = leftIn;
		self->top = topIn;
		self->right = rightIn;
		self->bottom = bottomIn;

		if (self->parent)
		{
			NSRect rc = ComputePosition(
					[self->parent->view frame],
					self->left,
					self->top,
					self->right,
					self->bottom);


			[self->view setFrameOrigin: rc.origin];
			[self->view setFrameSize: rc.size];

			[self resizeChildren: rc.size];
		}
	}

- (void) resizeChildren: (NSSize) size
	{
		NSLog(@"FIXME base resizeChildren");
	}

- (void) show
	{
		NSLog(@"FIXME base Show called");
	}
@end

void SetPosition(Element element,
	POSITION left,
	POSITION top,
	POSITION right,
	POSITION bottom)
{
	[(iElement *)element
		setPositionLeft:left
		Top:top
		Right:right
		Bottom:bottom ];
}

void Show(Element element)
{
	[(iElement *)element show];
}

