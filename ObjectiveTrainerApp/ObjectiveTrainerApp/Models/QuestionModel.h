//
//  QuestionModel.h
//  ObjectiveTrainerApp
//
//  Created by Nathan Covill on 4/29/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

@property (strong, nonatomic) NSMutableArray *easyQuestions;
@property (strong, nonatomic) NSMutableArray *mediumQuestions;
@property (strong, nonatomic) NSMutableArray *hardQuestions;

- (NSMutableArray *)getQuestions:(QuizQuestionDifficulty)difficulty;

@end
