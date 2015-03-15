//
//  ViewController.m
//  SmartParking
//
//  Created by Academy387 on 13/03/15.
//  Copyright (c) 2015 Academy387. All rights reserved.
//

#import "ViewController.h"
#import "mapView.h"
#import "signupController.h"
#import "DataClass.h"

static NSString *const BaseURLString = @"http://preview.hardver.ba/users/api/token";

@interface ViewController ()<UITextFieldDelegate, NSURLConnectionDelegate>{
    UITextField *userName;
    UITextField *password;
    NSMutableData *getResponseData;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = [self colorWithHexString:@"34495e"];
    [self createMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)createMenu {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    userName = [[UITextField alloc]initWithFrame:CGRectMake(40, screenHeight / 4, screenWidth - 80, 40)];
    userName.placeholder = @"Username";
    userName.autocorrectionType = UITextAutocorrectionTypeNo;
    userName.returnKeyType = UIReturnKeyDone;
    userName.borderStyle = UITextBorderStyleRoundedRect;
    userName.delegate = self;
    [self.view addSubview:userName];
    
    password = [[UITextField alloc]initWithFrame:CGRectMake(40, (screenHeight / 4) + 50, screenWidth - 80, 40)];
    password.placeholder = @"Password";
    password.secureTextEntry = YES;
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.returnKeyType = UIReturnKeyDone;
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.delegate = self;
    [self.view addSubview:password];
    
    UIButton *logIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logIn addTarget:self action:@selector(logInBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [logIn setTitle:@"Log In" forState:UIControlStateNormal];
    [logIn setFrame:CGRectMake(40, (screenHeight / 4) + 110, screenWidth - 80, (screenHeight / 8) - 20)];
    [logIn setBackgroundColor:[self colorWithHexString:@"0088BF"]];
    [logIn setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
    [self.view addSubview:logIn];
    
    UIButton *signUp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signUp addTarget:self action:@selector(signUpBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [signUp setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signUp setFrame:CGRectMake(40, ((screenHeight / 4) + 110) + logIn.frame.size.height + 10, screenWidth - 80, (screenHeight / 8) - 20)];
    [signUp setBackgroundColor:[self colorWithHexString:@"00A368"]];
    [signUp setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
    [self.view addSubview:signUp];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
 
    [textField resignFirstResponder];
    return YES;
}

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


- (void)logInBtnAct{
    if ([password.text isEqualToString:@""] || [userName.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SORRY!" message:@"Enter Missing Data" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        NSURL *url = [NSURL URLWithString:BaseURLString];
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
        NSString * grant_type = [NSString stringWithFormat:@"grant_type=password&username=%@&password=%@",userName.text,password.text];

    
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
        NSString *bodydata=[NSString stringWithFormat:@"%@",grant_type];
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

- (void)signUpBtnAct{
    signupController *sController = [[signupController alloc]init];
    [self presentViewController:sController animated:YES completion:nil];
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
    if ([dict objectForKey:@"access_token"]) {
        DataClass *dataClass = [DataClass getInstance];
        dataClass.token = [dict objectForKey:@"access_token"];
        mapView *mapview = [[mapView alloc] init];
        [self presentViewController:mapview animated:YES completion:nil];

    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SORRY!" message:@"The user name or password is incorrect." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];

    }

}


@end
