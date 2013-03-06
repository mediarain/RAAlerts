//
//  ViewController.m
//  RAAlerts
//
//  Created by Joshua Buhler on 2/21/13.
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

#import "ViewController.h"
#import "RAAlertManager.h"

@interface ViewController ()
{

}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)onStandardSingle:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"A Standard UIAlertView"
                                                    message:@"A single instance of UIAlertView"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)onStandardMany:(id)sender
{
    for (int i = 1; i <= 10; i++)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"A Standard UIAlertView"
                                                        message:@"Part of a mess of alerts presented at once."
                                                       delegate:nil
                                              cancelButtonTitle:[NSString stringWithFormat:@"%d", i]
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)onCondensedSingle:(id)sender
{
    RAAlertManager *_alertManager = [RAAlertManager defaultManager];
    
    RAAlertView *alert = [[RAAlertView alloc] initWithTitle:@"RAAlertView A"
                                                    message:@"Message set in initWithTitle:"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert setCompletionBlock:^(NSInteger buttonIndex) {
        NSLog(@"alertCompleted - A");
    }];
    
    [_alertManager showAlert:alert];
}

- (IBAction)onCondensedSingle2:(id)sender
{
    RAAlertManager *_alertManager = [RAAlertManager defaultManager];
    
    RAAlertView *alert = [[RAAlertView alloc] initWithTitle:@"RAAlertView B"
                                                    message:@"Message set in initWithTitle"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Button 1", @"Button 2", nil];
    
    alert.combineMessage = @"Combined message provided by alert.combineMessage";
    
    [alert setCompletionBlock:^(NSInteger buttonIndex) {
        NSLog(@"alertCompleted - B - %d", buttonIndex);
    }];
    
    [_alertManager showAlert:alert];
}

- (IBAction)onCondensedMany:(id)sender
{
    RAAlertManager *_alertManager = [RAAlertManager defaultManager];
    
    for (int i = 1; i <= 1000; i++)
    {
        RAAlertView *alert = [[RAAlertView alloc] initWithTitle:@"Flood Prevented"
                                                        message:@"A single alert."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        alert.combineMessage = @"There were a ton of alerts of this type. Is that OK?";
        
        [alert setCompletionBlock:^(NSInteger buttonIndex) {
            NSLog(@"alertCompleted - selected button: %d", buttonIndex);
        }];
        
        [_alertManager showAlert:alert];
    }
}
@end