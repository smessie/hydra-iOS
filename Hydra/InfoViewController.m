//
//  InfoViewController.m
//  Hydra
//
//  Created by Yasser Deceukelier on 19/07/12.
//  Copyright (c) 2012 Zeus WPI. All rights reserved.
//

#import "InfoViewController.h"
#import "WebViewController.h"

@implementation InfoViewController

#pragma mark - Initializing + loading

- (id)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info-content" ofType:@"plist"];
        content = [[NSArray alloc] initWithContentsOfFile:path];
        [self setTitle:@"Info"];
    }
    return self;
}

- initWithContent:(NSArray *)newContent
{
    self = [super init];
    if (self) {
        content = newContent;
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    [[self tableView] setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [[self tableView] setBounces:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
    cell.contentView.backgroundColor = [UIColor whiteColor];
	cell.textLabel.backgroundColor = cell.contentView.backgroundColor;
	
	NSDictionary *item = [content objectAtIndex:indexPath.row];
	NSString *text = [item objectForKey:@"title"];;

	UIImage *icon = [UIImage imageNamed:[item objectForKey:@"image"]];
	if(icon) {
		cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
		cell.imageView.image = icon;
		cell.indentationLevel = 1;
		text = [@" " stringByAppendingString:text];
	}
	cell.textLabel.text = text;
	
	CGRect frame = cell.imageView.frame;
	frame.size.width = 200;
	cell.imageView.frame = frame;
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *item = [content objectAtIndex:indexPath.row];
	
    // Choose a different action depending on what data is available
    if([item objectForKey:@"subcontent"]){
		NSArray *subContent = [item objectForKey:@"subcontent"];
		InfoViewController *c = [[InfoViewController alloc] initWithContent:subContent];
        [c setTitle:[item objectForKey:@"title"]];
		[[self navigationController] pushViewController:c animated:YES];
	}
    else if([item objectForKey:@"url"]) {
        NSURL *url = [NSURL URLWithString:[item objectForKey:@"url"]];
        [[UIApplication sharedApplication] openURL:url];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
    else {
        DLog(@"Unknown action in %@", item);
    }
}

@end
