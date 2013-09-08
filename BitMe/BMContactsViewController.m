//
//  BMContactsViewController.m
//  BitMe
//
//  Created by Josh Pearlstein on 9/8/13.
//
//

#import "BMContactsViewController.h"
#import "BMSendViewController.h"
@interface BMContactsViewController ()

@end

@implementation BMContactsViewController
@synthesize tableView,contacts;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com/users"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user = [prefs objectForKey:@"UID"];
    Firebase *users = [ref childByAppendingPath:user];
    Firebase *fuser = [users childByAppendingPath:@"contacts"];
    __block NSDictionary *dict = nil;
    [fuser observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        dict = snapshot.value;
        contacts = [[NSDictionary alloc]initWithDictionary:dict copyItems:YES];
    }];    
}
- (void)viewDidLoad
{
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com/users"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user = [prefs objectForKey:@"UID"];
    Firebase *users = [ref childByAppendingPath:user];
    Firebase *fuser = [users childByAppendingPath:@"contacts"];
    __block NSDictionary *dict = nil;
    [fuser observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        dict = snapshot.value;
        if(dict != nil){
        contacts = [[NSDictionary alloc]initWithDictionary:dict copyItems:YES];
        }
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
    }];
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(contacts != nil){
    return [[contacts allKeys] count];
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [contacts allKeys][indexPath.row];
    // Configure the cell...
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"select" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"select"]){
    NSString *key = [contacts allKeys][[self.tableView indexPathForSelectedRow].row];
    NSString *uid = [contacts valueForKey:key];
    [(BMSendViewController *)segue.destinationViewController setAddressField:uid];
    }
}
@end
