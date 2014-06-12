//
//  BCWorshipScheduleTableViewController.m
//  ntcbcv1
//
//  Created by Chung-Ching Lan on 12-03-31.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import "BCWorshipScheduleTableViewController.h"
@interface BCWorshipScheduleTableViewController () {
    UIBarButtonItem * _moreButton;
}
@end

@implementation BCWorshipScheduleTableViewController
@synthesize isNextWeek = _isNextWeek;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _sections = [[NSArray alloc] initWithObjects:
                     @"Praise & Worship", 
                     @"Scripture Reading", 
                     @"Pastoral Prayer", 
                     @"Message", 
                     @"Song & Giving", 
                     @"Benediction", 
                     @"Announcements",
                     @"Pastors",
                     @"Service Teams", nil];
        _data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                 @"Praise Team", @"Praise & Worship", 
                 @"Dr Stanley Porter", @"Scripture Reading", 
                 @"Dr Stanley Porter", @"Pastoral Prayer", 
                 @"Dr Stanley Porter", @"Message", 
                 @"Praise Team", @"Song & Giving", 
                 @"Rev Nathan Hui", @"Benediction", 
                 @"Deacon Norm Seto", @"Announcements", nil];
        
        _serviceTeams = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"Richard Kwan", @"Praise Leader",
                         @"Kelvin Chen", @"Power Point",
                         @"Andrew Hui/Eugene Cheng", @"Audio Video",
                         @"Crystal Lai", @"Scripture Reader", 
                         @"Steve Yung/Lynn Yung", @"Gr. Fl. Greeters",
                         @"Michael Lan/Jordana Lan", @"Gr. Fl. Ushers",
                         @"Chih Chou", @"Mezzanine Usher",
                         @"Gloria Yu", @"Welcome Table",
                         @"Lisa/Linda", @"Snacks",nil];
        
        _pastors = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"Rev Nathan Hui", @"Sr. Pastor",
                    @"Rev Dr. Ted Tham", @"English Ministry",
                    @"Pastor Patrick Lau", @"Cantonese Ministry",
                    @"Rev Tai Ping Li", @"Consulting Pastor", 
                    @"Pastor Danny Wong", @"Music Ministry", 
                    @"Pastor Kwan Chan", @"Youth Ministry", 
                    @"Pastor Cathy Chan", @"Mandarin Ministry",
                    @"Mr. James Ho", @"Administrator",
                    @"Mrs. Nora Chow", @"Custodian", 
                    @"Mr. Ricky Wong", @"Custodian", nil];
        
        self.isNextWeek = NO;
        //UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(nextWeekSchedule)];
        
        _moreButton = [[UIBarButtonItem alloc] initWithTitle:@"Next Week" style:UIBarButtonItemStyleBordered target:self action:@selector(nextWeekSchedule)];
        self.navigationItem.rightBarButtonItem = _moreButton;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setIsNextWeek:(BOOL)isNextWeek {
    _isNextWeek = isNextWeek;
    if (isNextWeek == NO) {
        self.navigationItem.title = @"This Week"; 
    }
    else {
        self.navigationItem.title = @"Next Week";
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)nextWeekSchedule {
    BCWorshipScheduleTableViewController *nextWeekController = [[BCWorshipScheduleTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    nextWeekController.isNextWeek = YES;
    [self.navigationController pushViewController:nextWeekController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [_sections objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[_sections objectAtIndex:section] isEqualToString:@"Pastors"]) {
        return [_pastors count];
    }
    else if([[_sections objectAtIndex:section] isEqualToString:@"Service Teams"]) {
        return [_serviceTeams count];
    }
    else 
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if ([indexPath section] < 7) {
        cell.textLabel.text = [_data objectForKey:[_sections objectAtIndex:[indexPath section]]];
        cell.detailTextLabel.text = @"";
        if ([[_sections objectAtIndex:[indexPath section]] isEqualToString:@"Scripture Reading"]) {
            //scripture reading
            cell.detailTextLabel.text = @"Luke 11:1-13";
        }
        
        if ([[_sections objectAtIndex:[indexPath section]] isEqualToString:@"Message"]) {
            //message
            cell.detailTextLabel.text = @"Lead Us Not Into Temptation";
        }
    }
    else if ([indexPath section] == 7) {
        NSArray *keyArray = [_pastors allKeys];
        cell.textLabel.text = [_pastors objectForKey:[keyArray objectAtIndex:[indexPath row]]];
        cell.detailTextLabel.text = [keyArray objectAtIndex:[indexPath row]];
    }
    else if ([indexPath section] == 8) {
        NSArray *keyArray = [_serviceTeams allKeys];
        cell.textLabel.text = [_serviceTeams objectForKey:[keyArray objectAtIndex:[indexPath row]]];
        cell.detailTextLabel.text = [keyArray objectAtIndex:[indexPath row]];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
