
#import "util_darwin.h"


NSRect ComputePosition(NSRect bounds,
		POSITION left,
		POSITION top,
		POSITION right,
		POSITION bottom)
{
	NSRect rc;

	rc.origin.x = bounds.origin.x
		+ (bounds.size.width*left.percent + 50)/100
		+ left.offset;

	rc.origin.y = bounds.origin.y
		+ (bounds.size.height*(100 - bottom.percent) + 50)/100
		- bottom.offset;

	rc.size.width = (bounds.size.width
		*(right.percent - left.percent) + 50)/100
		+ right.offset - left.offset;

	rc.size.height = (bounds.size.height
		*(bottom.percent - top.percent) + 50)/100
		+ bottom.offset - top.offset;

	return rc;
}

