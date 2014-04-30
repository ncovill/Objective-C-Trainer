//
//  QuestionModel.m
//  ObjectiveTrainerApp
//
//  Created by Nathan Covill on 4/29/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "QuestionModel.h"
#import "Question.h"

@implementation QuestionModel

- (id)init
{
    self = [super init];
    
    if (self) {
        // Initialize questions in here
        self.easyQuestions = [[NSMutableArray alloc] init];
        self.mediumQuestions = [[NSMutableArray alloc] init];
        self.hardQuestions = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSMutableArray *)getQuestions:(QuizQuestionDifficulty)difficulty
{
    // Create some easy questions
    Question *newQuestion = [[Question alloc] init];
    newQuestion.questionDifficulty = QuestionDifficultyEasy;
    newQuestion.questionType = QuestionTypeMC;
    newQuestion.questionText = @"This is a test question";
    newQuestion.questionAnswer1 = @"Answer 1";
    newQuestion.questionAnswer2 = @"Answer 2";
    newQuestion.questionAnswer3 = @"Answer 3";
    newQuestion.correctMCAnswerIndex = 1;
    [self.easyQuestions addObject:newQuestion];
    
    newQuestion = [[Question alloc] init];
    newQuestion.questionDifficulty = QuestionDifficultyEasy;
    newQuestion.questionType = QuestionTypeBlank;
    newQuestion.questionText = @"This is a _____ question";
    newQuestion.correctAnswerForBlank = @"test";
    [self.easyQuestions addObject:newQuestion];
    
    newQuestion = [[Question alloc] init];
    newQuestion.questionDifficulty = QuestionDifficultyEasy;
    newQuestion.questionType = QuestionTypeImage;
    newQuestion.questionImageName = @"TestQuestionImage";
    newQuestion.offset_x = 50;
    newQuestion.offset_y = 50;
    [self.easyQuestions addObject:newQuestion];
    
    return self.easyQuestions;
}

@end
