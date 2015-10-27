//
//  ViewController.m
//  Test
//
//  Created by Vishwa Deepak on 27/07/15.
//  Copyright (c) 2015 learningiphonesdk. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+AFNetworking.h"

static NSString * const BaseURLString = @"https://gist.githubusercontent.com/maclir/f715d78b49c3b4b3b77f/raw/8854ab2fe4cbe2a5919cea97d71b714ae5a4838d/items.json";

@interface ViewController ()
{
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    __weak IBOutlet UITableView *tableView;
}
@property(nonatomic, strong) NSArray *array_Response;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [activityIndicator startAnimating];
    
    NSString *string = [NSString stringWithFormat:@"%@", BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.array_Response = (NSArray *)responseObject;
        [tableView reloadData];
        [activityIndicator stopAnimating];
        NSLog(@"%@",[self.array_Response description]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [activityIndicator stopAnimating];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UItableView Delegate / Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.array_Response count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   __weak UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"saltSideCell"];
    
    UIImageView *imageCell = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *labelTitle = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *labelDesc = (UILabel *)[cell.contentView viewWithTag:102];
    
    imageCell.image = [UIImage imageNamed:@""];
    
    
    NSURL *url = [NSURL URLWithString:[[self.array_Response objectAtIndex:indexPath.row] objectForKey:@"image"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [imageCell setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        imageCell.image = image;
        [imageCell setNeedsLayout];
    } failure:nil];
    
    [labelTitle setText:[[self.array_Response objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [labelDesc setText:[[self.array_Response objectAtIndex:indexPath.row] objectForKey:@"description"]];
    
    return cell;
}

@end
