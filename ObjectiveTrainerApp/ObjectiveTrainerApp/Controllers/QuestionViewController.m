//
//  QuestionViewController.m
//  ObjectiveTrainerApp
//
//  Created by Nathan Covill on 4/29/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "QuestionViewController.h"
#import "SWRevealViewController.h"

@interface QuestionViewController ()
{
    Question *_currentQuestion;
    UIView *_tappablePortionImageQuestion;
    UITapGestureRecognizer *_tapRecognizer;
    UITapGestureRecognizer *_scrollViewTapRecognizer;
}

@end

@implementation QuestionViewController

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
    
    // Add tap gesture recognizer to scroll view
    _scrollViewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped)];
    [self.questionScrollView addGestureRecognizer:_scrollViewTapRecognizer];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Hide everything
    [self hideAllQuestionElements];
    
    // Create Quiz Model
    self.model = [[QuestionModel alloc] init];
    
    // Check difficulty level and retrieve questions for desire level
    self.questions = [self.model getQuestions:self.questionDifficulty];
    
    // Display a random question
    [self randomizeQuestion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideAllQuestionElements
{
    self.questionText.hidden = TRUE;
    self.questionMCAnswer1.hidden = TRUE;
    self.questionMCAnswer2.hidden = TRUE;
    self.questionMCAnswer3.hidden = TRUE;
    self.submitAnswerForBlank.hidden = TRUE;
    self.blankTextField.hidden = TRUE;
    self.instructionLabelForBlank.hidden = TRUE;
    self.questionImageView.hidden = TRUE;
    
    // Remove the tappable uiview for image questions
    if (_tappablePortionImageQuestion.superview)
        [_tappablePortionImageQuestion removeFromSuperview];
}

#pragma mark Question Methods

- (void)displayCurrentQuestion
{
    switch (_currentQuestion.questionType) {
        case QuestionTypeMC:
            [self displayMCQuestion];
            break;
            
        case QuestionTypeBlank:
            [self displayBlankQuestion];
            break;
            
        case QuestionTypeImage:
            [self displayImageQuestion];
            break;
            
        default:
            break;
    }
}

- (void)displayMCQuestion
{
    // Hide all elements
    [self hideAllQuestionElements];
    
    // Set question elements
    self.questionText.text = _currentQuestion.questionText;
    [self.questionMCAnswer1 setTitle:_currentQuestion.questionAnswer1 forState:UIControlStateNormal];
    [self.questionMCAnswer2 setTitle:_currentQuestion.questionAnswer2 forState:UIControlStateNormal];
    [self.questionMCAnswer3 setTitle:_currentQuestion.questionAnswer3 forState:UIControlStateNormal];
    
    // Adjust scroll view
    self.questionScrollView.contentSize = CGSizeMake(self.questionScrollView.frame.size.width, self.skipButton.frame.origin.y + self.skipButton.frame.size.height + 30);
    
    // Reveal question elements
    self.questionText.hidden = NO;
    self.questionMCAnswer1.hidden = NO;
    self.questionMCAnswer2.hidden = NO;
    self.questionMCAnswer3.hidden = NO;
}

- (void)displayImageQuestion
{
    // Hide all elements
    [self hideAllQuestionElements];
    
    // Set question elements
    
    
    // TODO: Set image
    self.questionImageView.backgroundColor = [UIColor greenColor];
    
    // Create tappable part
    int tappable_x = self.questionImageView.frame.origin.x + _currentQuestion.offset_x - 10;
    int tappable_y = self.questionImageView.frame.origin.y + _currentQuestion.offset_y - 10;
    _tappablePortionImageQuestion = [[UIView alloc] initWithFrame:CGRectMake(tappable_x, tappable_y, 20, 20)];
    _tappablePortionImageQuestion.backgroundColor = [UIColor redColor];
    
    // Create and attach gesture recognizer
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageQuestionAnswered)];
    [_tappablePortionImageQuestion addGestureRecognizer:_tapRecognizer];
    
    // Add tappable part to view
    [self.questionScrollView addSubview:_tappablePortionImageQuestion];
    
    self.questionImageView.hidden = NO;
}

- (void)displayBlankQuestion
{
    // Hide all elements
    [self hideAllQuestionElements];
    
    // Set question elements
    self.questionText.text = _currentQuestion.questionText;
    [self.questionMCAnswer1 setTitle:_currentQuestion.questionAnswer1 forState:UIControlStateNormal];
    [self.questionMCAnswer2 setTitle:_currentQuestion.questionAnswer2 forState:UIControlStateNormal];
    [self.questionMCAnswer3 setTitle:_currentQuestion.questionAnswer3 forState:UIControlStateNormal];
    
    // Adjust scroll view
    self.questionScrollView.contentSize = CGSizeMake(self.questionScrollView.frame.size.width, self.skipButton.frame.origin.y + self.skipButton.frame.size.height + 30);
    
    // Reveal question elements
    self.questionText.hidden = NO;
    self.submitAnswerForBlank.hidden = NO;
    self.blankTextField.hidden = NO;
    self.instructionLabelForBlank.hidden = NO;
}

- (void)randomizeQuestion
{
    // Randomize a question
    int randomQuestionIndex = arc4random() % self.questions.count;
    _currentQuestion = self.questions[randomQuestionIndex];
    
    // Display the question
    [self displayCurrentQuestion];
}

#pragma mark Question Answer Handlers
- (IBAction)skipButtonClicked:(id)sender
{
    // Randomize and display another question
    [self randomizeQuestion];
}

- (IBAction)questionMCAnswer:(id)sender
{
    UIButton *selectedButton = (UIButton *)sender;
    BOOL isCorrect = NO;
    
    if (selectedButton.tag == _currentQuestion.correctMCAnswerIndex) {
        // User got it right
        isCorrect = YES;
        
        // TODO: display message for correct answer
    } else {
        // User got it wrong
    }
    
    // Save the question data
    [self saveQuestionData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:isCorrect];
    
    // Display next question
    [self randomizeQuestion];
}

- (void)imageQuestionAnswered
{
    // User got it right
    
    // Save the question data
    [self saveQuestionData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:YES];
    
    // Display next question
    [self randomizeQuestion];
}

- (IBAction)blankSubmitted:(id)sender
{
    NSString *answer = self.blankTextField.text;
    BOOL isCorrect = NO;

    if ([answer isEqualToString:_currentQuestion.correctAnswerForBlank]) {
        // User got it right
        isCorrect = YES;
        
        // TODO: display message for correct answer
    } else {
        // User got it wrong
    }
    
    // Save the question data
    [self saveQuestionData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:isCorrect];
    
    // Display next question
    [self randomizeQuestion];
}

- (void)saveQuestionData:(QuizQuestionType)type withDifficulty:(QuizQuestionDifficulty)difficulty isCorrect:(BOOL)correct
{
    // Get user stats
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *keyToSaveType = @"";
    
    switch (type) {
        case QuestionTypeMC:
            keyToSaveType = @"MC";
            break;

        case QuestionTypeBlank:
            keyToSaveType = @"Blank";
            break;
            
        case QuestionTypeImage:
            keyToSaveType = @"Image";
            break;
            
        default:
            break;
    }
    
    // Record that user answered a question
    int questionsAnsweredByType = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionsAnswered", keyToSaveType]];
    questionsAnsweredByType++;
    [userDefaults setInteger:questionsAnsweredByType forKey:[NSString stringWithFormat:@"%@QuestionsAnswered", keyToSaveType]];
    
    if (correct) {
        // Record that user answered correctly
        int questionsAnsweredCorrectlyType = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionsAnsweredCorrectly", keyToSaveType]];
        questionsAnsweredCorrectlyType++;
        [userDefaults setInteger:questionsAnsweredCorrectlyType forKey:[NSString stringWithFormat:@"%@QuestionsAnsweredCorrectly", keyToSaveType]];
    }
    
    NSString *keyToSaveDifficulty = @"";
    switch (difficulty) {
        case QuestionDifficultyEasy:
            keyToSaveDifficulty = @"Easy";
            break;
            
        case QuestionDifficultyMedium:
            keyToSaveDifficulty = @"Medium";
            break;
            
        case QuestionDifficultyHard:
            keyToSaveDifficulty = @"Hard";
            break;
            
        default:
            break;
    }
    
    int questionAnsweredDifficulty = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionsAnswered", keyToSaveDifficulty]];
    questionAnsweredDifficulty++;
    [userDefaults setInteger:questionAnsweredDifficulty forKey:[NSString stringWithFormat:@"%@QuestionsAnswered", keyToSaveDifficulty]];
    
    if (correct) {
        int questionAnsweredCorrectlyDifficulty = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionsAnsweredCorrectly", keyToSaveDifficulty]];
        questionAnsweredCorrectlyDifficulty++;
        [userDefaults setInteger:questionAnsweredCorrectlyDifficulty forKey:[NSString stringWithFormat:@"%@QuestionsAnsweredCorrectly", keyToSaveDifficulty]];
    }
    
    [userDefaults synchronize];
}

- (void)scrollViewTapped
{
    [self.blankTextField resignFirstResponder];
}

@end
