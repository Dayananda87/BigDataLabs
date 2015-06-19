//
//  RecipeCellTableViewCell.h
//  BigData_Lab_2
//
//  Created by Dayananda Saraswathi on 6/19/15.
//  Copyright (c) 2015 Dayanand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;

@end
