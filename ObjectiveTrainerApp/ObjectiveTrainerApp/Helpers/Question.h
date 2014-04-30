//
//  Question.h
//  ObjectiveTrainerApp
//
//  Created by Nathan Covill on 4/30/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (strong, nonatomic) NSString *questionText;
@property (nonatomic) QuizQuestionType questionType;
@property (nonatomic) QuizQuestionDifficulty questionDifficulty;

// Properties for MC
@property (strong, nonatomic) NSString *questionAnswer1;
@property (strong, nonatomic) NSString *questionAnswer2;
@property (strong, nonatomic) NSString *questionAnswer3;
@property (nonatomic) int correctMCAnswerIndex;

// Properties for fill in the blank
@property (strong, nonatomic) NSString *correctAnswerForBlank;

// Properties for find within image
@property (nonatomic) int offset_x;
@property (nonatomic) int offset_y;
@property (strong, nonatomic) NSString *questionImageName;

@end
