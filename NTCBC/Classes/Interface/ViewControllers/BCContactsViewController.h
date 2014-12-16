//
//  BCContactsViewController.h
//  NTCBC
//
//  Created by Michael Lan on 2014-06-25.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCEmptyStateView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface BCContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ABNewPersonViewControllerDelegate> {
    BCEmptyStateView *_emptyStateScreen;
    
    UITableView *_tableView;
    NSArray *_savedContacts;
}

@end
