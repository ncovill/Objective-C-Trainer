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
    
    ResultView *_resultView;
    UIView *_dimmedBackground;
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
    
    // Add background behind status bar
    UIView *statusBarBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarBg.backgroundColor = [UIColor colorWithRed:11/255.0 green:187/255.0 blue:115/255.0 alpha:1.0];
    
    [self.view addSubview:statusBarBg];
    
    // Set button styles
    UIColor *buttonBorderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    [self.questionMCAnswer1.layer setBorderWidth:1];
    [self.questionMCAnswer2.layer setBorderWidth:1];
    [self.questionMCAnswer3.layer setBorderWidth:1];
    [self.questionMCAnswer1.layer setBorderColor:buttonBorderColor.CGColor];
    [self.questionMCAnswer2.layer setBorderColor:buttonBorderColor.CGColor];
    [self.questionMCAnswer3.layer setBorderColor:buttonBorderColor.CGColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Call super implementation
    [super viewDidAppear:animated];
    
    // Create a result view
    _resultView = [[ResultView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height)];
    _resultView.delegate = self;
    
    // Create dimmed bg
    _dimmedBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _dimmedBackground.backgroundColor = [UIColor blackColor];
    _dimmedBackground.alpha = 0.3;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideAllQuestionElements
{
    self.questionText.hidden = YES;
    self.questionMCAnswer1.hidden = YES;
    self.questionMCAnswer2.hidden = YES;
    self.questionMCAnswer3.hidden = YES;
    self.submitAnswerForBlank.hidden = YES;
    self.blankTextField.hidden = YES;
    self.questionImageView.hidden = YES;
    
    // Remove the tappable uiview for image questions
    if (_tappablePortionImageQuestion.superview)
        [_tappablePortionImageQuestion removeFromSuperview];
}
- (IBAction)menuButtonClicked:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
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
    
    
    // TODO: Set image and resize image view
    UIImage *tempImage = [UIImage imageNamed:_currentQuestion.questionImageName];
    self.questionImageView.image = tempImage;
    
    CGRect imageViewFrame = self.questionImageView.frame;
    imageViewFrame.size.height = tempImage.size.height;
    imageViewFrame.size.width = tempImage.size.width;
    self.questionImageView.frame = imageViewFrame;
    
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
    
    // Adjust scroll view
    self.questionScrollView.contentSize = CGSizeMake(self.questionScrollView.frame.size.width, self.skipButton.frame.origin.y + self.skipButton.frame.size.height + 30);
    
    // Reveal question elements
    self.questionText.hidden = NO;
    self.submitAnswerForBlank.hidden = NO;
    self.blankTextField.hidden = NO;
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
    NSString *userAnswer;
    
    switch (selectedButton.tag) {
        case 1:
            userAnswer = _currentQuestion.questionAnswer1;
            break;

        case 2:
            userAnswer = _currentQuestion.questionAnswer2;
            break;
            
        case 3:
            userAnswer = _currentQuestion.questionAnswer3;
            break;
            
        default:
            break;
    }
    
    if (selectedButton.tag == _currentQuestion.correctMCAnswerIndex) {
        // User got it right
        isCorrect = YES;
    } else {
        // User got it wrong
    }
    
    // Display message for correct answer
    [_resultView showResultsTextQuestion:isCorrect forUserAnswer:userAnswer forQuestion:_currentQuestion];
    [self.view addSubview:_dimmedBackground];
    [self.view addSubview:_resultView];
    
    // Save the question data
    [self saveQuestionData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:isCorrect];
    
    // Display next question
    [self randomizeQuestion];
}

- (void)imageQuestionAnswered
{
    // User got it right
    
    // Display message for correct answer
    [_resultView showResultsImageQuestion:YES forQuestion:_currentQuestion];
    [self.view addSubview:_dimmedBackground];
    [self.view addSubview:_resultView];

    // Save the question data
    [self saveQuestionData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:YES];
    
    // Display next question
    [self randomizeQuestion];
}

- (IBAction)blankSubmitted:(id)sender
{
    // Retract keyboard
    [self.blankTextField resignFirstResponder];
    
    // Get answer
    NSString *answer = self.blankTextField.text;
    BOOL isCorrect = NO;

    // Check if answer is right
    if ([answer isEqualToString:_currentQuestion.correctAnswerForBlank]) {
        // User got it right
        isCorrect = YES;
    } else {
        // User got it wrong
    }
    
    // Clear the text field
    self.blankTextField.text = @"";
    
    // Display message for correct answer
    [_resultView showResultsBlankQuestion:isCorrect forUserAnswer:answer forQuestion:_currentQuestion];
    [self.view addSubview:_dimmedBackground];
    [self.view addSubview:_resultView];
    
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

#pragma mark Result View Delegate Methods
-(void)resultViewDismissed
{
    [_dimmedBackground removeFromSuperview];
    [_resultView removeFromSuperview];
}

@end
