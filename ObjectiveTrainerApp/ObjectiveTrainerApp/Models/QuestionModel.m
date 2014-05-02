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
        
        // Load questions from JSON file and parse out arrays
        [self loadQuestions];
    }
    
    return self;
}

- (NSMutableArray *)getQuestions:(QuizQuestionDifficulty)difficulty
{
    switch (difficulty) {
        case QuestionDifficultyEasy:
            return self.easyQuestions;
            break;
            
        case QuestionDifficultyMedium:
            return self.mediumQuestions;
            break;
            
        case QuestionDifficultyHard:
            return self.hardQuestions;
            break;
            
        default:
            return [[NSMutableArray alloc] init];
            break;
    }
}

-(void)loadQuestions
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"objctrainer" ofType:@"json"];
    NSError *error;
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    // Parse out easy questions
    NSArray *easyJsonArray = jsonDictionary[@"easy"];
    self.easyQuestions = [self parseJsonArrayQuestions:easyJsonArray forDifficulty:QuestionDifficultyEasy];
    
    // Parse out medium questions
    NSArray *mediumJsonArray = jsonDictionary[@"medium"];
    self.mediumQuestions = [self parseJsonArrayQuestions:mediumJsonArray forDifficulty:QuestionDifficultyMedium];

    // Parse out hard questions
    NSArray *hardJsonArray = jsonDictionary[@"hard"];
    self.hardQuestions = [self parseJsonArrayQuestions:hardJsonArray forDifficulty:QuestionDifficultyHard];

}

- (NSMutableArray *)parseJsonArrayQuestions:(NSArray *)jsonArray forDifficulty:(QuizQuestionDifficulty)difficulty
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < jsonArray.count; i++) {
        NSDictionary *jsonObject = jsonArray[i];
        
        Question *newQuestion = [[Question alloc] init];
        newQuestion.questionDifficulty = difficulty;
        
        if ([jsonObject[@"type"] isEqualToString:@"mc"]) {
            // Parse out multiple choice type question
            newQuestion.questionType = QuestionTypeMC;
            newQuestion.questionText = jsonObject[@"question"];
            newQuestion.questionAnswer1 = jsonObject[@"answer0"];
            newQuestion.questionAnswer2 = jsonObject[@"answer1"];
            newQuestion.questionAnswer3 = jsonObject[@"answer2"];
            newQuestion.correctMCAnswerIndex = [jsonObject[@"correctAnswer"] intValue];
        }
        else if ([jsonObject[@"type"] isEqualToString:@"image"]) {
            // Parse out image type questions
            newQuestion.questionType = QuestionTypeImage;
            newQuestion.questionImageName = jsonObject[@"imageName"];
            newQuestion.offset_x = [jsonObject[@"x_coord"] intValue];
            newQuestion.offset_y = [jsonObject[@"y_coord"] intValue];
            newQuestion.answerImageName = jsonObject[@"answerImage"];
        }
        else if ([jsonObject[@"type"] isEqualToString:@"blank"]) {
            // Parse out fill in the blank type question
            newQuestion.questionType = QuestionTypeBlank;
            newQuestion.questionText = jsonObject[@"questionCode"];
            newQuestion.correctAnswerForBlank = jsonObject[@"answerBlank"];
        }
        
        // Add newly created question to temp array
        [tempArray addObject:newQuestion];
    }
    
    return tempArray;
}

@end
