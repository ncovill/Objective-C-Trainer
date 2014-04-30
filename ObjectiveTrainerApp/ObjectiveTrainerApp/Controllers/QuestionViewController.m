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
    // Get user stats
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Record that user answered a question
    int mcQuestionsAnswered = [userDefaults integerForKey:@"MCQuestionsAnswered"];
    mcQuestionsAnswered++;
    [userDefaults setInteger:mcQuestionsAnswered forKey:@"MCQuestionsAnswered"];
    
    UIButton *selectedButton = (UIButton *)sender;
    
    if (selectedButton.tag == _currentQuestion.correctMCAnswerIndex) {
        // User got it right
        
        // TODO: display message for correct answer
        
        // Record that user answered correctly
        int mcQuestionsAnsweredCorrectly = [userDefaults integerForKey:@"MCQuestionsAnsweredCorrectly"];
        mcQuestionsAnsweredCorrectly++;
        [userDefaults setInteger:mcQuestionsAnsweredCorrectly forKey:@"MCQuestionsAnsweredCorrectly"];
    } else {
        // User got it wrong
    }
    
    [userDefaults synchronize];
    
    // Display next question
    [self randomizeQuestion];
}

- (void)imageQuestionAnswered
{
    // User got it right
    
    // Get user stats
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Record that user answered a question
    int imageQuestionsAnswered = [userDefaults integerForKey:@"ImageQuestionsAnswered"];
    imageQuestionsAnswered++;
    [userDefaults setInteger:imageQuestionsAnswered forKey:@"ImageQuestionsAnswered"];
    
    // Record that user answered correctly
    int imageQuestionsAnsweredCorrectly = [userDefaults integerForKey:@"ImageQuestionsAnsweredCorrectly"];
    imageQuestionsAnsweredCorrectly++;
    [userDefaults setInteger:imageQuestionsAnsweredCorrectly forKey:@"ImageQuestionsAnsweredCorrectly"];
    
    [userDefaults synchronize];
    
    // Display next question
    [self randomizeQuestion];
}

- (IBAction)blankSubmitted:(id)sender
{
    // Get user stats
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // TODO: display message for correct answer

    // Record that user answered a question
    int blankQuestionsAnswered = [userDefaults integerForKey:@"BlankQuestionsAnswered"];
    blankQuestionsAnswered++;
    [userDefaults setInteger:blankQuestionsAnswered forKey:@"BlankQuestionsAnswered"];

    NSString *answer = self.blankTextField.text;
    if ([answer isEqualToString:_currentQuestion.correctAnswerForBlank]) {
        // User got it right
        
        // TODO: display message for correct answer
        
        // Record that user answered correctly
        int blankQuestionsAnsweredCorrectly = [userDefaults integerForKey:@"BlankQuestionsAnsweredCorrectly"];
        blankQuestionsAnsweredCorrectly++;
        [userDefaults setInteger:blankQuestionsAnsweredCorrectly forKey:@"BlankQuestionsAnsweredCorrectly"];
    } else {
        // User got it wrong
    }
    
    [userDefaults synchronize];
    
    // Display next question
    [self randomizeQuestion];
}

- (void)scrollViewTapped
{
    [self.blankTextField resignFirstResponder];
}

@end
