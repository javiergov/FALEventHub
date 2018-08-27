//
//  SecondViewController.m
//  FALEventHub_Example
//
//  Created by Javier Cristóbal González Ovalle on 23-08-18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import "SecondViewController.h"
#import "FALEventHub-compat.h"
@import FALEventHub;

@interface SecondViewController ()

@end

static NSString *const message = @"Event Message";
static NSString *const infoKey = @"exampleValue";
static NSInteger const infoValue = 777;

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)simpleFunction:(NSDictionary<NSString *, id>*)infoDictionary {
    NSLog(@"•SecondVC: simple method from Event: %@", infoDictionary.description);
}

#pragma mark - IBAction

- (IBAction)exampleButtonAction:(UIButton *)sender {
    
    switch ([sender tag]) {
            
            case 1:
        {
            NSString *idString =
            [EventHub subscribeWithInstance:self
                                   forEvent:message
                                      async:NO
                                   thenCall:^(NSDictionary *messageInfo) {
                                       NSLog(@"•SecondVC: block direclty implemented in the subscribe method. %@", messageInfo.description);
                                   }];
            NSLog(@"•SecondVC: Subscribed to %@", idString);
        }
            break;
            
            case 2:
        {
            EventHubBlock swiftClosure = ^(NSDictionary *messageInfo) { [self simpleFunction: messageInfo]; };
            [EventHub subscribeWithInstance:self
                                   forEvent:message
                                      async:YES thenCall:swiftClosure];
        }
            break;
            
            case 3:
            [EventHub unsubscribeWithInstance:self fromEvent:message];
            break;
            
            case 4:
            [EventHub triggerWithEventMessage:message optionalInfo:nil];
            break;
            
            case 5:
        {
            NSNumber *infoNumber = [NSNumber numberWithInt:infoValue];
            NSDictionary *messageInfo = @{infoKey : infoNumber};
            [EventHub triggerWithEventMessage:message optionalInfo:messageInfo];
        }
            break;
            
        default:
            NSLog(@"•SecondVC: button not tagged");
            break;
    }
    
}

@end
