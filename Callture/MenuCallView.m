/**
 *  Siphon SIP-VoIP for iPhone and iPod Touch
 *  Copyright (C) 2008-2010 Samuel <samuelv0304@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#import "MenuCallView.h"


@implementation MenuCallView

@synthesize delegate;

- (void)preloadButtons
{
  int i;
  CGRect rect = {0.0f, 0.0f, 0.0f, 0.0f};
  NSString *bg, *bgSel;
  UIImage *image, *selectedImage;
  
  for (i = 0; i < 6; ++i)
  {
    bg    = [NSString stringWithFormat:@"sixsqbutton_%d.png", i+1];
    bgSel = [NSString stringWithFormat:@"sixsqbuttonsel_%d.png", i+1];
    image = [UIImage imageNamed:bg];
    selectedImage = [UIImage imageNamed:bgSel];
    
    rect.size = [image size];
    PushButton *button = [[PushButton alloc] initWithFrame:rect];
    
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    
    // in case the parent view draws with a custom color or gradient, use a transparent color
    //button.backgroundColor = [UIColor clearColor];
    
    [button setTag:i];
    [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect content = CGRectMake(11.0, 11.0, 72.0, 75.0);
    if (i == 0 || i == 3)
      content.origin.x += 5.;
    if (i < 3)
      content.origin.y += 2.;
    [button setContentRect: content];
    
    _buttons[i] = button;
    [self addSubview:_buttons[i]];
    
    if (i == 2)
    {
      //rect.origin.y += rect.size.height - 1.0f;
      rect.origin.y += rect.size.height - 9.0f;
      rect.origin.x = 0.0f;
    }
    else
      rect.origin.x += rect.size.width;
  }
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
    {
        // Initialization code
      // TODO display text maybe I need to derivate UIButton
      [self preloadButtons];
    }
    return self;
}

- (void)clicked:(UIButton *)button
{
  if ([delegate respondsToSelector:@selector(menuButtonClicked:)])
  {
    [delegate menuButtonClicked:[button tag]];
  }
}

- (void)dealloc 
{
  int i;
  for (i = 0; i < 6; ++i)
    [_buttons[i] release];
    [super dealloc];
}

- (PushButton *)buttonAtPosition:(NSInteger)pos
{
  if (pos < 0 || pos > 5)
    return nil;
  return _buttons[pos];
}

- (void)setTitle:(NSString *)title image:(UIImage *)image forPosition:(NSInteger)pos
{
  if (pos < 0 || pos > 5)
    return;
  if (image)
  {
    [_buttons[pos] setImage:image forState:UIControlStateNormal];
    [_buttons[pos] setImage:image forState:UIControlStateSelected];
  }
  if (title)
  {
#ifdef __IPHONE_3_0
    _buttons[pos].titleLabel.font = [UIFont systemFontOfSize:[UIFont buttonFontSize] - 5.];
#else
    [_buttons[pos] setFont:[UIFont systemFontOfSize:[UIFont buttonFontSize] - 5.]];
#endif
    [_buttons[pos] setTitle:title forState:UIControlStateNormal];
    //[_buttons[pos] setTitle:title];
  }
}

-(void)showKeyPad:(BOOL)flag
{
    //[_buttons[1].imageView setHidden:!flag];
    [_buttons[1] setUserInteractionEnabled:flag];
    //[_buttons[1].titleLabel setHidden:!flag];
    if (flag) {
        _buttons[1].imageView.alpha = 1.0;
        _buttons[1].titleLabel.alpha = 1.0;
    }else
    {
        _buttons[1].imageView.alpha = 0.2;
        _buttons[1].titleLabel.alpha = 0.2;
    }
    
}

-(void)enableMenuItems:(BOOL)flag isCalling:(BOOL)isCalling
{
    //[_buttons[1].imageView setHidden:!flag];
    for (int i=0; i<6; i++) {
        if (!flag && isCalling && i==2) {
            [_buttons[1] setUserInteractionEnabled:!flag];
            //[_buttons[1].titleLabel setHidden:!flag];
            _buttons[i].imageView.alpha = 1.0;
            _buttons[i].titleLabel.alpha = 1.0;
            
        }else
        {
            [_buttons[1] setUserInteractionEnabled:flag];
            //[_buttons[1].titleLabel setHidden:!flag];
            if (flag) {
                _buttons[i].imageView.alpha = 1.0;
                _buttons[i].titleLabel.alpha = 1.0;
            }else
            {
                _buttons[i].imageView.alpha = 0.2;
                _buttons[i].titleLabel.alpha = 0.2;
            }
        }
    }
}

@end
