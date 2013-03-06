//
//  RAAlertView.h
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


#import <UIKit/UIKit.h>

typedef void (^AlertCompletion)(NSInteger);


//  An UIAlertView subclass to add a completion block
//  Alloc and init like a regular block then call [NAMEOFALERT showWithCompletion:]
//  A local enum may be useful for buttonIndex.
@interface RAAlertView : UIAlertView <UIAlertViewDelegate>
{
    AlertCompletion completionBlock;
}

//  Allows use of a text field for displaying an alert that collects user input.
@property (nonatomic, assign) BOOL shouldShowTextField;
@property (nonatomic, strong) UITextField *textField;

//  Used in conjunction with an RAAlertManager. If an alternate message is
//  desired when an alert is combined with others, this message will be used.
@property (nonatomic, strong) NSString *combineMessage;


//  Display the alert immediately. The supplied block with be called when the
//  alert is dismissed. Alerts presented using this method will not be watched
//  or combined by an RAAlertManager.
- (void) showWithCompletion:(AlertCompletion)aBlock;

// If an alert is to be managed by RAAlertManager, sets the block to be called
// when the alert is dismissed.
- (void) setCompletionBlock:(AlertCompletion)cBlock;

@end
