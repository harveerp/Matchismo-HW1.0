//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Eric on 11/02/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

#define GAME_MODE_MESSAGE [NSString stringWithFormat:@"GAME MODE: %d-cards matching game", self.game.selectedGameMode]

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) int flipCount;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeController;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

- (IBAction)dealButton;
- (IBAction)browseHistory;
@end

@implementation CardGameViewController

- (void)viewDidLoad
{
    self.historySlider.enabled = NO;
    self.historySlider.value = 0;
    self.historySlider.maximumValue = 0;
    self.gameModeController.enabled = YES;
    [self updateUI];
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    UIImage *cardBackImage = [UIImage imageNamed:@"cardBack_red_54x64.png"];
    UIImage *blank = [[UIImage alloc] init];
    for (UIButton *cardButton in cardButtons) {
        [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        [cardButton setImage:blank forState:UIControlStateSelected];
        [cardButton setImage:blank forState:UIControlStateSelected|UIControlStateDisabled];
    }
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)dealButton {
    self.game = nil;
    self.flipCount = 0;
    self.historySlider.value = 0;
    self.historySlider.maximumValue = 0;
    self.historySlider.enabled = NO;
    self.gameModeController.enabled = YES;
    [self updateUI];
}

- (IBAction)browseHistory
{
    self.flipResultLabel.alpha = (self.historySlider.value == self.historySlider.maximumValue) ? 1.0 : 0.3;
    NSInteger historyIndex = (NSInteger)self.historySlider.value;
    self.historySlider.value = historyIndex;
    if (historyIndex)
        self.flipResultLabel.text = [NSString stringWithFormat: @"%d. %@",historyIndex, [self.game.flipHistory objectAtIndex:historyIndex - 1]];
    else
        self.flipResultLabel.text = GAME_MODE_MESSAGE;
}

- (IBAction)flipCard:(UIButton *)sender
{
    self.game.selectedGameMode = 2 + self.gameModeController.selectedSegmentIndex;
    self.gameModeController.enabled = NO;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    self.historySlider.maximumValue = [self.game.flipHistory count];
    self.historySlider.value = self.historySlider.maximumValue;
    self.flipResultLabel.alpha = 1.0;
    self.historySlider.enabled = YES;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipResultLabel.text = self.game.description;
}

@end