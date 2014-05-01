//
//  StatsViewController.m
//  ObjectiveTrainerApp
//
//  Created by Nathan Covill on 4/29/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "StatsViewController.h"
#import "SWRevealViewController.h"

@interface StatsViewController ()

@end

@implementation StatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Add pan gesture recognizer for revealing menu
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Load and display stats
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Easy stats
    int easyQuestionsAnswered = [userDefaults integerForKey:@"EasyQuestionsAnswered"];
    int easyQuestionsCorrect = [userDefaults integerForKey:@"EasyQuestionsAnsweredCorrectly"];
    self.easyQuestionsStats.text = [NSString stringWithFormat:@"Easy Questions: %i / %i", easyQuestionsAnswered, easyQuestionsCorrect];
    
    // Medium stats
    int mediumQuestionsAnswered = [userDefaults integerForKey:@"MediumQuestionsAnswered"];
    int mediumQuestionsCorrect = [userDefaults integerForKey:@"MediumQuestionsAnsweredCorrectly"];
    self.mediumQuestionsStats.text = [NSString stringWithFormat:@"Medium Questions: %i / %i", mediumQuestionsAnswered, mediumQuestionsCorrect];

    // Hard stats
    int hardQuestionsAnswered = [userDefaults integerForKey:@"HardQuestionsAnswered"];
    int hardQuestionsCorrect = [userDefaults integerForKey:@"HardQuestionsAnsweredCorrectly"];
    self.hardQuestionsStats.text = [NSString stringWithFormat:@"Hard Questions: %i / %i", hardQuestionsAnswered, hardQuestionsCorrect];
    
    // Total
    self.totalQuestionsLabel.text = [NSString stringWithFormat:@"Total Questions Answered: %i", easyQuestionsAnswered + mediumQuestionsAnswered + hardQuestionsAnswered];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
