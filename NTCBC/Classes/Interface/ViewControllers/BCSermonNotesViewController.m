//
//  BCSermonNotesViewController.m
//  NTCBC
//
//  Created by Michael Lan on 2014-06-25.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "BCSermonNotesViewController.h"

@interface BCSermonNotesViewController ()

@end

@implementation BCSermonNotesViewController

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
    self.navigationItem.title = NSLocalizedString(@"Sermon Notes", @"Notes page title");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
