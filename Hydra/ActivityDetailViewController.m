//
//  ActivityDetailViewController.m
//  Hydra
//
//  Created by Pieter De Baets on 11/10/12.
//  Copyright (c) 2012 Zeus WPI. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "AssociationActivity.h"
#import <EventKit/EventKit.h>

@interface ActivityDetailViewController ()

@property (nonatomic, strong) AssociationActivity *activity;

@end

@implementation ActivityDetailViewController

- (id)initWithActivity:(AssociationActivity *)activity
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.activity = activity;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Detail";
    
    /*UIButton *addToCalendar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addToCalendar setTitle:@"Add to Calendar" forState:UIControlStateNormal];
    addToCalendar.frame = CGRectMake(0, 0, 280, 40);
    [addToCalendar addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 100)];
    [footerView addSubview:addToCalendar];
    self.tableView.tableFooterView = footerView;*/    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 4 : 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    //return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"ActivityDetailTitleCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellIdentifier];
                cell.textLabel.adjustsFontSizeToFitWidth = YES;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0f];
                cell.textLabel.textAlignment = UITextAlignmentCenter;
            }
            cell.textLabel.text = self.activity.title;
            return cell;
        }
        else {
            static NSString *CellIdentifier = @"ActivityDetailCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                              reuseIdentifier:CellIdentifier];
                cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            }

            static NSDateFormatter *dateStartFormatter = nil;
            static NSDateFormatter *dateEndFormatter = nil;
            if (!dateStartFormatter || !dateEndFormatter) {
                dateStartFormatter = [[NSDateFormatter alloc] init];
                [dateStartFormatter setDateFormat:@"EEE d MMMM H:mm"];
                dateEndFormatter = [[NSDateFormatter alloc] init];
                [dateEndFormatter setDateFormat:@"H:mm"];
            }

            switch (indexPath.row) {
                case 1:
                    cell.textLabel.text = @"Vereniging";
                    cell.detailTextLabel.text = self.activity.associationId;
                    break;
                case 2:
                    cell.textLabel.text = @"Datum";
                    if (self.activity.end) {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                                     [dateStartFormatter stringFromDate:self.activity.start],
                                                     [dateEndFormatter stringFromDate:self.activity.end]];
                    }
                    else {
                        cell.detailTextLabel.text = [dateStartFormatter stringFromDate:self.activity.start];
                    }
                    break;
                case 3:
                    cell.textLabel.text = @"Locatie";
                    cell.detailTextLabel.text = self.activity.location;
                    break;
            }
            
            return cell;
        }
    }
    else {
        static NSString *CellIdentifier = @"ActivityDetailButtonCell";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"Toevoegen aan agenda";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        return cell;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 1 ? indexPath : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];

    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = self.activity.title;
    event.location  = self.activity.location;
    event.startDate = self.activity.start;
    event.endDate   = self.activity.end;

    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err;
    [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
