//
//  BCContactsViewController.m
//  NTCBC
//
//  Created by Michael Lan on 2014-06-25.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "BCContactsViewController.h"

@interface BCContactsViewController ()

@end

@implementation BCContactsViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"My Contacts", @"Contacts page title");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
