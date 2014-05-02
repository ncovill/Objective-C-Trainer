//
//  ResultView.h
//  ObjectiveTrainerApp
//
//  Created by Nathan Covill on 5/2/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@protocol ResultViewProtocol <NSObject>

- (void)resultViewDismissed;

@end

@interface ResultView : UIView

@property (nonatomic, weak) id<ResultViewProtocol> delegate;

@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UILabel *userAnswerLabel;
@property (nonatomic, strong) UILabel *correctAnswerLabel;
@property (nonatomic, strong) UIImageView *correctAnswerImageView;
@property (nonatomic,strong) UIButton *continueButton;

- (void)showResultsTextQuestion:(BOOL)wasCorrect forUserAnswer:(NSString *)userAnswer forQuestion:(Question *)question;
- (void)showResultsBlankQuestion:(BOOL)wasCorrect forUserAnswer:(NSString *)userAnswer forQuestion:(Question *)question;
- (void)showResultsImageQuestion:(BOOL)wasCorrect forQuestion:(Question *)question;

@end
