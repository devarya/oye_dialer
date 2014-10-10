//
//  CopyLabel.m
//  Callture
//
//  Created by Manish on 28/03/12.
//  Copyright (c) 2011 __Aryavrat Infotech Pvt. Ltd.__. All rights reserved.
//

#import "CopyLabel.h"

@implementation CopyLabel
@synthesize delegate;
#pragma mark Initialization

- (void) attachTapHandler
{
    [self setUserInteractionEnabled:YES];
    pasteboard = [UIPasteboard generalPasteboard];
    UIGestureRecognizer *touchy = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:touchy];
}

- (id) initWithFrame: (CGRect) frame
{
    [super initWithFrame:frame];
    [self attachTapHandler];
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self attachTapHandler];
}

#pragma mark Clipboard


- (void) handleTap: (UIGestureRecognizer*) recognizer
{
    [self becomeFirstResponder];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

- (void)copy:(id)sender {
	// NSLog(@"text copied %@",self.text);
    pasteboard.string = self.text;
    // NSLog(@"%@",pasteboard.string);
}

- (void)paste:(id)sender {
	// NSLog(@"text pasted");
    [self setText:pasteboard.string];
    [delegate pasteData:pasteboard.string];
}



- (BOOL) canBecomeFirstResponder
{
    return YES;
}

@end