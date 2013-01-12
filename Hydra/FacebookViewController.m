//
//  FacebookViewController.m
//  Hydra
//
//  Created by Feliciaan De Palmenaer on 7/01/13.
//  Copyright (c) 2013 Zeus WPI. All rights reserved.
//

#import "FacebookViewController.h"
#import "FacebookLogin.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FBEventView.h"

@interface FacebookViewController ()
@end

@implementation FacebookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([FBSession activeSession].isOpen){
        // facebook is logged in
        [self loadLoggedInView];
    }
}

-(IBAction)loginButtonPressed:(id)sender
{
    [self.spinner startAnimating];
    FacebookLogin *delegate = [FacebookLogin sharedLogin];
    if([delegate openSessionWithAllowLoginUI:YES]){
        DLog(@"Facebook login worked");
        // yes => log in worked
        self.logInButton.hidden = YES;
        self.logOutButton.hidden = NO;
        [self loadLoggedInView];
    }else {
        DLog(@"Facebook login failed");
        // log in failed
    }
    [self.spinner stopAnimating];
}

-(IBAction)logoutButtonPressed:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    [self.logInButton setHidden:NO];
    [self.logOutButton setHidden:YES];
}

- (void)loadLoggedInView
{
    self.logInButton.hidden = YES;
    self.logOutButton.hidden = NO;

    FBEventView *eventView = [[FBEventView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 300)];
    [eventView configureWithEventID:@"171216039688617"];
    [self.view addSubview:eventView];
}
@end
