//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Eric on 12/02/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCardDeck.h"

@interface CardMatchingGame : NSObject

typedef enum NSInteger {
    TwoCardsMatchGameMode  = 2,
    ThreeCardsMatchGameMode = 3,
} GameMode;

@property (nonatomic) GameMode selectedGameMode;
@property (nonatomic, readonly) int score;
@property (readonly, strong, nonatomic) NSMutableArray *flipHistory;

- (GameMode)selectedGameMode;
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)flipCardAtIndex:(NSUInteger)index;

@end
