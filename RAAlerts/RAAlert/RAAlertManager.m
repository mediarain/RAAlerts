//
//  RAAlertManager.m
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

#import "RAAlertManager.h"
#import "RAAlertView+Private.h"

@interface RAAlertManager ()
{
    NSMutableArray  *_alertQueue;
    
    NSMutableDictionary *_alertDict;
    NSMutableDictionary *_timerDict;
}

@end

@implementation RAAlertManager

@synthesize combineWindow = _combineWindow;

+ (RAAlertManager *)defaultManager {
    static RAAlertManager * _defaultManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[RAAlertManager alloc] init];
    });
    
    return _defaultManager;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        _alertQueue = [[NSMutableArray alloc] init];
        _alertDict = [[NSMutableDictionary alloc] init];
        _timerDict = [[NSMutableDictionary alloc] init];
        
        _combineWindow = 1.0f;
    }
    return self;
}

- (void) showAlert:(RAAlertView *)alert
{
    // do we have a queue for this type of alert yet?
    if ([_alertDict objectForKey:alert.title] == nil)
    {
        NSMutableArray *alertList = [NSMutableArray new];
        [_alertDict setObject:alertList forKey:alert.title];
    }
    
    NSMutableArray *alertQueue = (NSMutableArray *)[_alertDict objectForKey:alert.title];
    [alertQueue addObject:alert];
    
    NSTimer *alertTimer = [_timerDict objectForKey:alert.title];
    
    if (alertTimer == nil && _combineWindow > 0)
    {
        alertTimer = [NSTimer scheduledTimerWithTimeInterval:_combineWindow
                                                       target:self
                                                     selector:@selector(onAlertTimer:)
                                                     userInfo:nil
                                                      repeats:NO];

        [_timerDict setObject:alertTimer forKey:alert.title];
        return;
    }
    
    if (alertTimer == nil && [alertQueue count] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
        });
    }
}

- (void) onAlertTimer:(NSTimer *)t
{
    [t invalidate];
    
    NSMutableArray *alertQueue = nil;
    NSString *alertTitle = nil;
    NSString *alertMsg = nil;
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    
    // find the key for the timer that just fired
    for (NSString *key in _alertDict)
    {
        NSTimer *cTimer = [_timerDict objectForKey:key];
        if (cTimer != t)
            continue;
        
        // found the right one, so grab the right set of alerts
        alertQueue = [_alertDict objectForKey:key];
        
        alertTitle = key;
        
        // grab the condensed version of the alerts for this queue
        RAAlertView *fAlert = (RAAlertView *)[alertQueue objectAtIndex:0];
        alertMsg = fAlert.combineMessage ?: fAlert.message;
        
        for (int i = 0; i < fAlert.numberOfButtons; i++)
        {
            [buttons addObject:[fAlert buttonTitleAtIndex:i]];
        }        
        
        // got what we needed, so bail out
        break;
    }
    
    [_timerDict removeObjectForKey:alertTitle];
    t = nil;    
    
    if ([alertQueue count] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            RAAlertView *alert = (RAAlertView *)[alertQueue objectAtIndex:0];
            [alert show];
            
            [alertQueue removeAllObjects];
            [_alertDict removeObjectForKey:alert];
        });
        
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Pop the condensed version of these alerts        
        RAAlertView *alert = [[RAAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:[buttons objectAtIndex:0]
                                              otherButtonTitles:nil];
        
        // Now copy over the buttons from the first alert. We need to manually
        // set the cancel button above though, so that the alert will display
        // properly. If we just add all of the buttons using the loop below, they'll
        // be added, and maintain the proper indexes, but the cancel button won't
        // be placed in the regular cancel location as it would be by using the
        // init method above. We'll start at the first button after the cancel.
        for (int i = 1; i < [buttons count]; i++)
        {
            [alert addButtonWithTitle:[buttons objectAtIndex:i]];
        }
        
        [alert showWithCompletion:^(NSInteger buttonIndex) {
            [self onAlertDismissed:buttonIndex alertKey:alertTitle];
        }];
    });
}

- (void) onAlertDismissed:(NSInteger)buttonIndex alertKey:(NSString *)key
{
    NSMutableArray *alertQueue = [_alertDict objectForKey:key];
    for (RAAlertView *cAlert in alertQueue)
    {
        [cAlert performCompletionBlock:buttonIndex];
    }
    
    [alertQueue removeAllObjects];
    [_alertDict removeObjectForKey:key];
}

@end
