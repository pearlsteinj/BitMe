//
//  BMLogViewController.m
//  BitMe
//
//  Created by Josh Pearlstein on 9/8/13.
//
//

#import "BMLogViewController.h"

@interface BMLogViewController ()

@end

@implementation BMLogViewController
@synthesize entries,tableView,top_bar;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    UIColor* secondaryColor = [UIColor colorWithRed:22.0/255 green:160.0/255 blue:133.0/255 alpha:1.0f];
    top_bar.tintColor = secondaryColor;
    
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com/log"];
    __block NSDictionary *dict = nil;
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        dict = snapshot.value;
        entries = [[NSDictionary alloc]initWithDictionary:dict copyItems:YES];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
    }];
    [super viewDidLoad];

}
-(void)viewWillAppear:(BOOL)animated{
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com/log"];
    
    __block NSDictionary *dict = nil;
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        dict = snapshot.value;
        entries = [[NSDictionary alloc]initWithDictionary:dict copyItems:YES];
    }];
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
    NSLog(@"%x",[[entries allKeys]count]);
    return [[entries allKeys]count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = entries[[entries allKeys][indexPath.row]];
    NSLog(@"%x",[[dict allKeys]count]);
    if (cell == nil) {
        // Create the cell and add the labels
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *from = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 120.0f, 44.0f)];
        from.tag = 1; // We use the tag to set it later
    
        UILabel *to = [[UILabel alloc] init];
        to.tag = 2; // We use the tag to set it later
        
        UILabel *amount = [[UILabel alloc]init];
        amount.tag = 3;
        
        UILabel *message = [[UILabel alloc]init];
        message.tag = 4;
    
        [cell.contentView addSubview:from];
        [cell.contentView addSubview:to];
        [cell.contentView addSubview:amount];
        [cell.contentView addSubview:message];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *from = (UILabel *)[cell viewWithTag:1];
    from.text = dict[@"sender"];
    UILabel *to = (UILabel *)[cell viewWithTag:2];
    to.text = dict[@"reciever"];
    UILabel *amount = (UILabel *)[cell viewWithTag:3];
    amount.text = dict[@"amount"];
    UILabel *message = (UILabel *)[cell viewWithTag:4];
    message.text = dict[@"message"];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
