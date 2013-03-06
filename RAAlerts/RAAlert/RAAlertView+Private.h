//
//  RAAlertView+Private.h
//  RAAlerts
//
//  Created by Joshua Buhler on 3/6/13.
//  Copyright (c) 2013 Rain. All rights reserved.
//

#import "RAAlertView.h"

@interface RAAlertView (Private)

//  Calls the block specified by setCompletionBlock: Used by RAAlertManager
//  when the alert is to be dismissed.
//
//  Implemented in RAAlertView.m
- (void) performCompletionBlock:(NSInteger)buttonIndex;

@end
