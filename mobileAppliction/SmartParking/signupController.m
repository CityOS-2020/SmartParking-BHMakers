//
//  signupController.m
//  SmartParking
//
//  Created by Academy387 on 13/03/15.
//  Copyright (c) 2015 Academy387. All rights reserved.
//

#import "signupController.h"
#import "CountryListDataSource.h"
#import "CountryCell.h"

static NSString *const BaseURLString = @"http://preview.hardver.ba/users/api/registration";

@interface signupController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>{
    UITextField *userName;
    UITextField *name;
    UITextField *lastName;
    UITextField *password;
    UITextField *rePassword;
    UITextField *email;
    UITextField *address;
    UIButton *country;
    UITableView *countriesTable;
    NSMutableData *getResponseData;
}

@property (strong, nonatomic) NSArray *dataRows;
@property (strong, nonatomic) IBOutlet UITableView *countriesTable;


@end

@implementation signupController
@synthesize countriesTable;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navBar.barTintColor = [self colorWithHexString:@"00A368"];
    
    self.navigationItem.title = @"Sign Up";
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    navBar.translucent = NO;
    [navBar pushNavigationItem:self.navigationItem animated:NO];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleDone target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];

    [self.view addSubview:navBar];
    
    
    self.view.backgroundColor = [self colorWithHexString:@"34495e"];
    [self.view setTintColor:[UIColor whiteColor]];
    [self createSignUpForm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)createSignUpForm{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    CGFloat y = 10;
    
    UIScrollView *menuView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight - 64)];
    userName = [[UITextField alloc]initWithFrame:CGRectMake(40, y, screenWidth - 80, 40)];
    userName.placeholder = @" User Name";
    userName.autocorrectionType = UITextAutocorrectionTypeNo;
    userName.returnKeyType = UIReturnKeyDone;
    userName.borderStyle = UITextBorderStyleNone;
    userName.backgroundColor = [UIColor whiteColor];
    userName.delegate = self;
    [menuView addSubview:userName];
    
    y += userName.frame.size.height + 10;

    name = [[UITextField alloc]initWithFrame:CGRectMake(40, y, screenWidth - 80, 40)];
    name.placeholder = @" Name";
    name.autocorrectionType = UITextAutocorrectionTypeNo;
    name.returnKeyType = UIReturnKeyDone;
    name.borderStyle = UITextBorderStyleNone;
    name.backgroundColor = [UIColor whiteColor];
    name.delegate = self;
    [menuView addSubview:name];
    
    y += name.frame.size.height + 10;
    
    lastName = [[UITextField alloc]initWithFrame:CGRectMake(40, y, screenWidth - 80, 40)];
    lastName.placeholder = @" Last Name";
    lastName.autocorrectionType = UITextAutocorrectionTypeNo;
    lastName.returnKeyType = UIReturnKeyDone;
    lastName.borderStyle = UITextBorderStyleNone;
    lastName.backgroundColor = [UIColor whiteColor];
    lastName.delegate = self;
    [menuView addSubview:lastName];
    
    y += lastName.frame.size.height + 10;
    
    password = [[UITextField alloc]initWithFrame:CGRectMake(40, y, screenWidth - 80, 40)];
    password.placeholder = @" Password";
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.returnKeyType = UIReturnKeyDone;
    password.borderStyle = UITextBorderStyleNone;
    password.backgroundColor = [UIColor whiteColor];
    password.delegate = self;
    password.secureTextEntry = YES;
    [menuView addSubview:password];
    
    y += password.frame.size.height + 10;
    
    rePassword = [[UITextField alloc]initWithFrame:CGRectMake(40, y, screenWidth - 80, 40)];
    rePassword.placeholder = @" Rewrite Password";
    rePassword.autocorrectionType = UITextAutocorrectionTypeNo;
    rePassword.returnKeyType = UIReturnKeyDone;
    rePassword.borderStyle = UITextBorderStyleNone;
    rePassword.backgroundColor = [UIColor whiteColor];
    rePassword.delegate = self;
    rePassword.secureTextEntry = YES;
    [menuView addSubview:rePassword];
    
    y += rePassword.frame.size.height + 10;
    
    email = [[UITextField alloc]initWithFrame:CGRectMake(40, y, screenWidth - 80, 40)];
    email.placeholder = @" Email";
    email.autocorrectionType = UITextAutocorrectionTypeNo;
    email.returnKeyType = UIReturnKeyDone;
    email.borderStyle = UITextBorderStyleNone;
    email.backgroundColor = [UIColor whiteColor];
    email.delegate = self;
    [menuView addSubview:email];
    
    y += email.frame.size.height + 10;
    
    address = [[UITextField alloc]initWithFrame:CGRectMake(40, y, screenWidth - 80, 40)];
    address.placeholder = @" Address";
    address.autocorrectionType = UITextAutocorrectionTypeNo;
    address.returnKeyType = UIReturnKeyDone;
    address.borderStyle = UITextBorderStyleNone;
    address.backgroundColor = [UIColor whiteColor];
    address.delegate = self;
    [menuView addSubview:address];
    
    y += address.frame.size.height + 10;
    
    country = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [country addTarget:self action:@selector(countrySelect) forControlEvents:UIControlEventTouchUpInside];
    [country setTitle:@" City" forState:UIControlStateNormal];
    [country setFrame:CGRectMake(40, y, screenWidth - 80, 40)];
    [country setBackgroundColor:[UIColor whiteColor]];
    country.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [country setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [menuView addSubview:country];
    
    y += country.frame.size.height + 10;
    
    UIButton *signUp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signUp addTarget:self action:@selector(signUpBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [signUp setTitle:@" Sign Up" forState:UIControlStateNormal];
    [signUp setFrame:CGRectMake(40, y, screenWidth - 80, 60)];
    [signUp setBackgroundColor:[self colorWithHexString:@"00A368"]];
    [signUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [menuView addSubview:signUp];
    
    y += signUp.frame.size.height + 10;

    countriesTable = [[UITableView alloc]initWithFrame:CGRectMake(0, screenHeight, screenWidth, screenHeight)];
    countriesTable.dataSource = self;
    countriesTable.delegate = self;
    menuView.contentSize = CGSizeMake(self.view.frame.size.width, y);
    menuView.scrollEnabled = YES;
    [self.view addSubview:menuView];
}
- (void)countrySelect{
    [self.view addSubview:countriesTable];
    countriesTable.delegate = self;
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    _dataRows = [dataSource countries];
    [countriesTable reloadData];
    
    [UIView animateWithDuration:.5 animations:^{
        countriesTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)signUpBtnAct{
    if ([userName.text isEqualToString:@""] || [name.text isEqualToString:@""] ||[lastName.text isEqualToString:@""] ||[password.text isEqualToString:@""] ||[rePassword.text isEqualToString:@""] ||[email.text isEqualToString:@""] ||[address.text isEqualToString:@""] ||[country.titleLabel.text isEqualToString:@" City"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SORRY!" message:@"Enter Missing Data" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }else if ((int)[userName.text length] < 5){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SORRY!" message:@"Minimum length of username is 5 characters" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }else if ((int)password.text.length < 5){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SORRY!" message:@"Minimum length of password is 5 characters" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];

    }else if (![password.text isEqualToString:rePassword.text]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SORRY!" message:@"Passwords Does Not Match" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];

    }else if ([self NSStringIsValidEmail:email.text] == NO){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SORRY!" message:@"Enter Valid Email" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        NSArray *dictionaryKeys = @[@"username",@"password",@"firstName",@"lastName",@"email",@"address",@"city"];
        NSArray *dictionaryValue = @[userName.text,password.text,name.text,lastName.text,email.text,address.text,country.titleLabel.text];
        NSDictionary *newUserData = [NSDictionary dictionaryWithObjects:dictionaryValue forKeys:dictionaryKeys];
        NSString *jsonFormat = [self formatUserDataForUpload:newUserData];
        
        NSURL *url = [NSURL URLWithString:BaseURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        NSString *bodydata=[NSString stringWithFormat:@"%@",jsonFormat];
        [request setHTTPMethod:@"POST"];
        NSData *req=[NSData dataWithBytes:[bodydata UTF8String] length:[bodydata length]];
        [request setHTTPBody:req];
        
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        

        if( connection )
        {
            getResponseData = [NSMutableData new];
        }


    }
    
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
    
- (NSString*)formatUserDataForUpload:(NSDictionary*) userData{
        
        NSError *error = nil;
        
        //Serialize the JSON data
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userData
                                                           options:0
                                                             error:&error];
        
        if ([jsonData length] > 0 && error == nil) {
            //Create a string from the JSON Data
            NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"JSON String = %@",jsonString);
            return jsonString;
        }
        else if ([jsonData length] == 0 && error == nil){
            NSLog(@"No data was returned after the serialization");
        }
        else if (error != nil){
            NSLog(@"An error happened = %@",error);
        }
        return nil;
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


#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    CountryCell *cell = (CountryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[CountryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [[_dataRows objectAtIndex:indexPath.row] valueForKey:kCountryName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    CountryCell *cell = (CountryCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[CountryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    NSString *cellText = cell.textLabel.text;
    [country setTitle:cellText forState:UIControlStateNormal];
    [country setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:.5 animations:^{
        countriesTable.frame = CGRectMake(0, self.view.frame.size.height , self.view.frame.size.width, self.view.frame.size.height);
    }completion:^(BOOL finished) {
        [countriesTable removeFromSuperview];
    }];
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
    NSString *test = [NSString stringWithFormat:@"%@",dict];
    
    
    if ([test rangeOfString:@"User with entered e-mail alraedy exists."].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SORRY!" message:@"User with entered e-mail alraedy exists." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        
    }else if ([test rangeOfString:@"Username is taken. Please choose another one."].location != NSNotFound){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SORRY!" message:@"Username is taken. Please choose another one." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SUCCESS!" message:@"Account Created" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        [self Back];
    }

}


@end
