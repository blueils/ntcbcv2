//
//  BCContactsViewController.m
//  NTCBC
//
//  Created by Michael Lan on 2014-06-25.
//  Copyright (c) 2014 Meeto Technologies Inc. All rights reserved.
//

#import "BCContactsViewController.h"
#import "CLLightHighlightButton.h"


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
    
    CLLightHighlightButton *addButton = [[CLLightHighlightButton alloc] initWithFrame:CGRectZero];
    [addButton setImage:[[UIImage imageNamed:@"add_contact_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addContactTapped:) forControlEvents:UIControlEventTouchUpInside];
    [addButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"My Contacts", @"Contacts page title");
    
    _emptyStateScreen = [[BCEmptyStateView alloc] initWithFrame:self.view.bounds
                                                         iconFile:nil
                                                          message:NSLocalizedString(@"You do not have any saved contact", @"empty state title")
                                                              tip:NSLocalizedString(@"You can add people to your contacts for easier follow-up.", @"empty state message")];
    _emptyStateScreen.hidden = YES;
    [self.view addSubview:_emptyStateScreen];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    [self loadSavedContacts];
}

#pragma mark - 
- (void) addContactTapped: (id)sender {
    //TO DO: Add new contact
    ABNewPersonViewController *viewController = [[ABNewPersonViewController alloc] init];
    viewController.newPersonViewDelegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc]
                                                       initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)loadSavedContacts {
    //TO DO
    [self contactLoaded];
}

- (void)contactLoaded {
    if (_savedContacts != nil && [_savedContacts count] > 0) {
        [_tableView reloadData];
        _tableView.hidden = NO;
        _emptyStateScreen.hidden = YES;
    } else {
        _emptyStateScreen.hidden = NO;
        _tableView.hidden = YES;
    }
}

#pragma mark - ABNewPersonViewCopntrollerDelegate

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
    //TO DO: display the person in the list
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_savedContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"contactCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //TO DO
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TO DO: should pop up a contact detail view of a specific contact
}

@end
