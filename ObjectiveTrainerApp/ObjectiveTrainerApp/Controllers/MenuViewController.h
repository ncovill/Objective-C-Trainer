//
//  MenuViewController.h
//  ObjectiveTrainerApp
//
//  Created by Nathan Covill on 4/29/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuModel.h"
#import "MenuItem.h"

@interface MenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MenuModel *model;
@property (strong, nonatomic) NSArray *menuItems;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
