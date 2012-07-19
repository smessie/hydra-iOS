//
//  InfoViewController.m
//  Hydra
//
//  Created by Yasser Deceukelier on 19/07/12.
//  Copyright (c) 2012 Zeus WPI. All rights reserved.
//

#import "InfoViewController.h"
#import "WebViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

#pragma mark - 
#pragma mark Properties

@synthesize content = _content;

- (void)setContent:(NSArray *)content {
	
	if(_content != content) {
		_content = content;
		[self.tableView reloadData];
	}
}

#pragma mark Initializing + loading

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Info";
	}
    return self;
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
    return [self.content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
	NSDictionary *item = [self.content objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"title"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *item = [self.content objectAtIndex:indexPath.row];
	NSLog(@"%@", item);
	
	if([item objectForKey:@"link"]) { //key zit in dict
		WebViewController *c = [[WebViewController alloc] init];
		[[c webView] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[item objectForKey:@"link"]]]];
		[[self navigationController] pushViewController:c animated:YES];
	} else if([item objectForKey:@"subcontent"]){
		NSArray *subContent = [item objectForKey:@"subcontent"];
		InfoViewController *subVC = [[InfoViewController alloc] initWithStyle:UITableViewStylePlain];
		subVC.content = subContent;
		[[self navigationController] pushViewController:subVC animated:YES];
	}
}

@end