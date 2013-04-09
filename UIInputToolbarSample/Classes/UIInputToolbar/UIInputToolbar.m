/*
 *  UIInputToolbar.m
 *  
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#import "UIInputToolbar.h"

@implementation UIInputToolbar

@synthesize textView;
@synthesize inputButton;
@synthesize delegate;

-(void)inputButtonPressed
{
    if ([delegate respondsToSelector:@selector(inputButtonPressed:)]) 
    {
        [delegate inputButtonPressed:self.textView.text];
    }
    
    /* Remove the keyboard and clear the text */
    [self.textView resignFirstResponder];
    [self.textView clearText];
}

-(void)plusButtonPressed
{
    if ([delegate respondsToSelector:@selector(plusButtonPressed:)])
    {
        [delegate plusButtonPressed:nil];
    }
}

-(void)setupToolbar:(NSString *)buttonLabel
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.tintColor = [UIColor lightGrayColor];
    
    /* Create custom send button*/
    UIImage *buttonImage = [UIImage imageNamed:@"buttonbg.png"];
    buttonImage          = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
    UIImage *buttonDownImage = [UIImage imageNamed:@"buttonbgDown.png"];
    buttonImage          =     [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonDownImage.size.width/2)
                                                                topCapHeight:floorf(buttonDownImage.size.height/2)];
    
    UIButton *button               = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font         = medium14;
//    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button.titleEdgeInsets         = UIEdgeInsetsMake(0, 2, 0, 2);
    button.contentStretch          = CGRectMake(0.5, 0.5, 0, 0);
    button.contentMode             = UIViewContentModeScaleToFill;
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonDownImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonImage forState:UIControlStateDisabled];
    [button setTitle:buttonLabel forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5]
                 forState:UIControlStateDisabled];
    
    [button addTarget:self action:@selector(inputButtonPressed) forControlEvents:UIControlEventTouchDown];
    [button sizeToFit];
    
    /* Plus Button at the left side */
    
    UIButton *plusButton               = [UIButton buttonWithType:UIButtonTypeCustom];
    plusButton.frame                   = CGRectMake(0, 0, 27, 26);
    plusButton.titleEdgeInsets         = UIEdgeInsetsMake(0, 2, 0, 2);
    plusButton.contentStretch          = CGRectMake(0.5, 0.5, 0, 0);
    plusButton.contentMode             = UIViewContentModeScaleToFill;
    
    [plusButton setBackgroundImage:[UIImage imageNamed:@"buttonPlusNormal.png"] forState:UIControlStateNormal];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"buttonPlusDown.png"] forState:UIControlStateHighlighted];
    [plusButton addTarget:self action:@selector(plusButtonPressed) forControlEvents:UIControlEventTouchDown];
    [plusButton sizeToFit];
    
    self.addButton = [[[UIBarButtonItem alloc] initWithCustomView:plusButton] autorelease];
    self.addButton.customView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    /////////////////////////////////
    
    self.inputButton = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.inputButton.customView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    /* Disable button initially */
    self.inputButton.enabled = NO;
    

    /* Create UIExpandingTextView input */
    self.textView = [[[UIExpandingTextView alloc] initWithFrame:CGRectMake(36, 7, 215, 27)] autorelease];
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(6.0f, 0.0f, 10.0f, 0.0f);
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.textView.delegate = self;
    self.textView.maximumNumberOfLines = 7;
    self.textView.font = medium14;
    [self addSubview:self.textView];
    
    /* Right align the toolbar button */
    UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    NSArray *items = [NSArray arrayWithObjects:self.addButton, flexItem, self.inputButton, nil];
    [self setItems:items animated:NO];
}

-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setupToolbar:NSLocalizedString(@"Send", @"Send")];
    }
    return self;
}

-(id)init
{
    if ((self = [super init])) {
        [self setupToolbar:NSLocalizedString(@"Send", @"Send")];
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    /* Draw custon toolbar background */
    UIImage *backgroundImage = [UIImage imageNamed:@"toolbarbg.png"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:floorf(backgroundImage.size.width/2) topCapHeight:floorf(backgroundImage.size.height/2)];
    [backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    CGRect i = self.inputButton.customView.frame;
    i.origin.y = self.frame.size.height - i.size.height - 6;
    i.origin.x = self.textView.frame.size.width + self.addButton.customView.frame.size.width + 13;
    self.inputButton.customView.frame = i;
    
    CGRect f = self.addButton.customView.frame;
    f.origin.x = 5;
    f.origin.y = self.frame.size.height - f.size.height -6;
    self.addButton.customView.frame = f;
}

- (void)dealloc
{
    [textView release];
    [inputButton release];
    [super dealloc];
}


#pragma mark -
#pragma mark UIExpandingTextView delegate

- (void)expandingTextViewDidBeginEditing:(UIExpandingTextView *)expandingTextView
{
    if ([delegate respondsToSelector:@selector(inputDidBegingEditing)])
    {
        [delegate inputDidBegingEditing];
    }
}

- (void)expandingTextViewDidEndEditing:(UIExpandingTextView *)expandingTextView
{
    if ([delegate respondsToSelector:@selector(inputDidEndEditing)])
    {
        [delegate inputDidEndEditing];
    }
}

-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (textView.frame.size.height - height);
    CGRect r = self.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    self.frame = r;
}

-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
    /* Enable/Disable the button */
    if ([expandingTextView.text length] > 0)
    {
        self.inputButton.enabled = YES;
    }
    else
    {
        self.inputButton.enabled = NO;
    }
    
    if ([delegate respondsToSelector:@selector(inputDidChange)])
    {
        [delegate inputDidChange];
    }
}

-(void)setEnabled:(BOOL)enabled
{
    [self.inputButton setEnabled:enabled];
    [self.textView setEnabled:enabled];
    [self.addButton setEnabled:enabled];
}

@end
