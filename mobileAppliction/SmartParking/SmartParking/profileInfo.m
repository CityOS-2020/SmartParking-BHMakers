//
//  profileInfo.m
//  SmartParking
//
//  Created by Academy387 on 14/03/15.
//  Copyright (c) 2015 Academy387. All rights reserved.
//

#import "profileInfo.h"
#import "DataClass.h"

static NSString *const BaseURLString = @"http://preview.hardver.ba/Users/api/account";

@interface profileInfo ()<UITableViewDataSource, UITableViewDelegate>{
    UILabel *userName;
    UILabel *name;
    UILabel *lastName;
    UILabel *country;
    UILabel *email;
    UILabel *address;
    UILabel *balance;

    NSMutableData *getResponseData;
    DataClass *dataClass;
    UITableView *table;

}
@property (nonatomic, strong) NSArray *tableData;
@property (strong, nonatomic) IBOutlet UITableView *table;

@end

@implementation profileInfo
@synthesize tableData, table;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dataClass = [DataClass getInstance];
    
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navBar.barTintColor = [self colorWithHexString:@"0088BF"];
    
    self.navigationItem.title = @"Profile";
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    navBar.translucent = NO;
    [navBar pushNavigationItem:self.navigationItem animated:NO];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleDone target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:navBar];
    
    
    self.view.backgroundColor = [self colorWithHexString:@"2c3e50"];
    [self.view setTintColor:[UIColor whiteColor]];
    NSString *authStr = [NSString stringWithFormat:@"Bearer %@",dataClass.token];

    NSURL *url = [NSURL URLWithString:BaseURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:authStr forHTTPHeaderField:@"Authorization"];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(connection)
    {
        getResponseData = [NSMutableData new];
    }
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height -  350, self.view.frame.size.width, 350)];
    table.dataSource = self;
    table.delegate = self;
    table.scrollEnabled = NO;
    table.rowHeight = 50;
    table.center = self.view.center;
    [self.view addSubview:table];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createLabels{


}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)Back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HTTP POST

-(void) connection:(NSURLConnection*) connetion didReceiveData:(NSData *)data
{
    [getResponseData appendData:data];
}

-(void) connection:(NSURLConnection*)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", [error localizedDescription]);
}

-(void) connectionDidFinishLoading:(NSURLConnection*) connection
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:getResponseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"return: %@", dict);
    
    tableData = [[NSArray alloc]initWithObjects:[dict objectForKey:@"username"], [[dict objectForKey:@"firstName"] capitalizedString],[[dict objectForKey:@"lastName"] capitalizedString], [dict objectForKey:@"email"], [dict objectForKey:@"address"], [dict objectForKey:@"city"], [[dict objectForKey:@"balance"] stringValue], nil];
    [table reloadData];
    }

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [self colorWithHexString:@"2c3e50"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [self colorWithHexString:@"0088BF"];
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    switch (indexPath.row) {
            
        case 0:
            cell.detailTextLabel.text = @"Username";
            break;
        case 1:
            cell.detailTextLabel.text = @"First Name";
            break;
        case 2:
            cell.detailTextLabel.text = @"Last Name";
            break;
        case 3:
            cell.detailTextLabel.text = @"Email";
            break;
        case 4:
            cell.detailTextLabel.text = @"Address";
            break;
        case 5:
            cell.detailTextLabel.text = @"City";
            break;
        case 6:
            cell.detailTextLabel.text = @"Balance";
            break;
        default:
            break;
    }
    return cell;
}


@end
