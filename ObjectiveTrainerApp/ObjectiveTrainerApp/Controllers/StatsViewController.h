//
//  StatsViewController.h
//  ObjectiveTrainerApp
//
//  Created by Nathan Covill on 4/29/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *totalQuestionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *easyQuestionsStats;
@property (weak, nonatomic) IBOutlet UILabel *mediumQuestionsStats;
@property (weak, nonatomic) IBOutlet UILabel *hardQuestionsStats;

@end
