//
//  ViewController.m
//  BigData_Lab_2
//
//  Created by Dayananda Saraswathi on 6/19/15.
//  Copyright (c) 2015 Dayanand. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "RecipeCellTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#define BASE_URL @"http://api.pearson.com:80/kitchen-manager/v1/recipes?"


@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) IBOutlet UITableView *recipeList;
@property (strong, nonatomic) NSArray * recipeArray;
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recipeList.dataSource = self;
    self.recipeList.delegate = self;
    self.recipeList.hidden = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickSearch:(id)sender {
    if ([self.searchText.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter atleast one ingredient name" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        return;
    }
    NSString *str = self.searchText.text;
    NSString *searchString = [NSString stringWithFormat:@"%@ingredients-all=%@",BASE_URL,str];
    NSString *urlString = [searchString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    _manager = [AFHTTPRequestOperationManager manager];
    [_manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        self.recipeArray = [responseObject objectForKey:@"results"];
        if ([self.recipeArray count]>0) {
            self.recipeList.hidden = NO;
            [self.recipeList reloadData];
        }else{
            self.recipeList.hidden = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                            message:@"No Recipes found"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (IBAction)onClickClear:(id)sender {
    self.recipeList.hidden = YES;
    self.recipeArray = nil;
    self.searchText.text = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.recipeArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecipeCellTableViewCell *cell = (RecipeCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"recipeCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[RecipeCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recipeCell"];
    }
    cell.recipeName.text = [[self.recipeArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    [cell.recipeImage setImageWithURL:[NSURL URLWithString:[[self.recipeArray objectAtIndex:indexPath.row] objectForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"defaultrecipe.jpg"]];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchText resignFirstResponder];
}



@end
