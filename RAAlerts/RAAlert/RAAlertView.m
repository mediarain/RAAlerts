//
//  RAAlertView.m
//  MediaLibrary
//
//  Created by Colin Pratt on 1/6/12.
//  Copyright (c) 2013 Rain.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "RAAlertView.h"
#import "RAAlertView+Private.h"

@implementation RAAlertView

@synthesize textField;
@synthesize shouldShowTextField;
@synthesize combineMessage = _condensedMessage;

- (void) layoutSubviews
{

}

- (void) setShouldShowTextField:(BOOL)shouldShow
{
    shouldShowTextField = shouldShow;
    if (shouldShowTextField)
    {
        [self textField];
    }
}

- (UITextField *) textField
{
    if (!textField)
    {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 45, 245, 27)];
        [textField setBorderStyle:UITextBorderStyleLine];
        [textField setTextAlignment:UITextAlignmentLeft];
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField becomeFirstResponder];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:textField];
    }
    return  textField;
}

- (void) setCompletionBlock:(AlertCompletion)cBlock
{
    self.delegate = self;
    completionBlock = [cBlock copy];
}

- (void) showWithCompletion:(AlertCompletion)aBlock
{
    [self setCompletionBlock:aBlock];
    
    [self show];
}

- (void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (textField != nil)
        [textField resignFirstResponder];
    
    [self performCompletionBlock:buttonIndex];
    
    completionBlock = nil;
}

- (void) dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animate
{
    if (buttonIndex != 0 && shouldShowTextField && [textField.text length] <= 0)
        return;
    
    [super dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void) performCompletionBlock:(NSInteger)buttonIndex
{
    if (completionBlock)
    {
        completionBlock(buttonIndex);
    }
}

@end