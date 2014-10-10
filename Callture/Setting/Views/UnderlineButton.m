//
//  UnderlineButton.m
//  Oye
//
//  Created by user on 26/10/12.
//
//

#import "UnderlineButton.h"

@implementation UnderlineButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 58.0/255.0, 110.0/255.0, 199.0/255.0, 1.0);
    
    // Draw them with a 1.0 stroke width.
    CGContextSetLineWidth(context, 2.0);
    
    // Draw a single line from left to right
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}

@end
