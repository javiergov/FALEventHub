//
//  SecondViewController.m
//  FALEventHub_Example
//
//  Created by Javier Cristóbal González Ovalle on 23-08-18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import "SecondViewController.h"
#import <FALEventHub/FALEventHub-Swift.h>
@import FALEventHub;

@interface SecondViewController ()

@end

static NSString *const message = @"Event Message";

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];

    typedef void (^EventHubBlock)(NSDictionary* dict);

    EventHubBlock swiftClosure = ^(NSDictionary *messageInfo){
        [self simpleFunction: messageInfo];
    };
    NSString *subsId = [EventHub subscribeWithInstance:self
                                                      forEvent:message
                                                         async:YES thenCall:swiftClosure];
    NSLog(@"EventHub subscribeWithInstance returns an NSString id: %@", subsId);
    
    //it can also be discarded.
    [EventHub subscribeWithInstance:self
                           forEvent:message
                              async:NO
                           thenCall:^(NSDictionary *messageInfo) {
                               NSLog(@"block direclty implemented in the subscribe method. %@", messageInfo.description);
                           }];
}

- (void)simpleFunction:(NSDictionary<NSString *, id>*)infoDictionary {
    NSLog(@"•SecondVC: simple function from Event: %@", infoDictionary.description);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
