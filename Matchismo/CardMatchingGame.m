//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Eric on 12/02/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (strong, nonatomic) NSMutableArray *cards;
//An Array of NSStrings describing the successive game flip results
@property (strong, nonatomic) NSMutableArray *flipHistory;
//Obviuosly, an Array for keeping track of playable face up cards 
//@property (strong, nonatomic) NSMutableArray *playableFaceUpCards;
@property (strong, nonatomic) NSString *playableFaceUpCardsList;
@property (nonatomic) int score;

@end

@implementation CardMatchingGame

//Game coefficients
#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4
#define GAME_MODE_BONUS (self.selectedGameMode - 1)

//Game messages
#define FLIP_DOWN_MESSAGE [NSString stringWithFormat:@"Flipped %@ down", flippedCard.contents]
#define FLIP_UP_MESSAGE [NSString stringWithFormat:@"Flipped up %@: -1 point for flip", [self playableFaceUpCardsList]]
#define MATCH_MESSAGE [NSString stringWithFormat:@"%@: %d points for MATCH!", [self playableFaceUpCardsList], (matchScore * MATCH_BONUS * GAME_MODE_BONUS)]
#define MISMATCH_MESSAGE [NSString stringWithFormat:@"%@: -%d points for MISMATCH!", [self playableFaceUpCardsList], (MISMATCH_PENALTY * GAME_MODE_BONUS)]

#pragma mark - Instance methods
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) self = nil;
            else self.cards[i] = card;
        }
    }
    return self;
}

- (void)selectedGameMode:(GameMode)gameMode
{
    _selectedGameMode = (gameMode <= TwoCardsMatchGameMode) ? TwoCardsMatchGameMode : gameMode;
}

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSArray *)playableFaceUpCards
{
    NSMutableArray *playableFaceUpCards = [[NSMutableArray alloc] init];
    for (Card *otherCard in self.cards) {
        if (!otherCard.isUnplayable && otherCard.isFaceUp)
            [playableFaceUpCards addObject:otherCard];
    }
    return [playableFaceUpCards copy];
}

//Helper function returning a properly formatted, readable, list of active face-up cards
- (NSString *)playableFaceUpCardsList
{
    NSString *fullDescription = nil;
    NSArray *playableFaceUpCards = [self playableFaceUpCards];    
    for (NSInteger index = 0; index < [playableFaceUpCards count]; index++) {
        NSString *description = [playableFaceUpCards[index] contents];
        if (!fullDescription)
            fullDescription = description;
        else {
            NSString *separator = (index < ([self.playableFaceUpCards count] - 1)) ? @", " : @" & ";
            fullDescription = [NSString stringWithFormat:@"%@%@%@", fullDescription, separator, description];
        }
    }
    return fullDescription;
}

- (NSMutableArray *)flipHistory
{
    if (!_flipHistory) _flipHistory = [[NSMutableArray alloc] init];
    return _flipHistory;
}

- (NSString *)description
{
    return [self.flipHistory lastObject];
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

//Flips a card, checks for other matching card(s) and updates score
- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *flippedCard = [self cardAtIndex:index];
    if (!flippedCard.isUnplayable) {
        flippedCard.faceUp = !flippedCard.isFaceUp;
        self.score -= FLIP_COST;
        if (flippedCard.isFaceUp) {
            NSArray *playableFaceUpCards = [self playableFaceUpCards];
            if ([playableFaceUpCards count] < self.selectedGameMode) {
                [self.flipHistory addObject:FLIP_UP_MESSAGE];
            } else {
                //Note: playableFaceUpCards contains the flippedCard, which will be checked for matching...
                NSInteger matchScore = [flippedCard match:playableFaceUpCards];
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS * GAME_MODE_BONUS;
                    [self.flipHistory addObject:MATCH_MESSAGE];
                    //Sets all (matching) playableFaceUpCards as unplayable
                    for (Card *allCards in playableFaceUpCards)
                        allCards.unplayable = YES;
                } else {
                    self.score -= MISMATCH_PENALTY * GAME_MODE_BONUS;
                    [self.flipHistory addObject:MISMATCH_MESSAGE];
                    //Flips down all playableFaceUpCards, but the last flippedCard
                    for (Card *otherCards in playableFaceUpCards)
                        if (![otherCards isEqual:flippedCard]) otherCards.faceUp = NO;
                }
            }
        } else {
            [self.flipHistory addObject:FLIP_DOWN_MESSAGE];
        }
    }
}

@end