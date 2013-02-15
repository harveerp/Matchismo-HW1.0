//
//  PlayingCard.m
//  Matchismo
//
//  Created by Eric on 11/02/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PlayingCard.h"

@interface PlayingCard ()

@end


@implementation PlayingCard

@synthesize suit = _suit;

#pragma mark - Instance methods
//Playing cards are caracterized by their rank and suit
- (NSString *)contents
{
    NSArray  *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (NSString *)description
{
    return self.contents;
}

- (NSString *)suit
{
    return (_suit) ? _suit: @"?";
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

//Matches actual card to other card(s) by rank and suit
//Match points : rank =4, suit = 1, both = 4 + 1 = 5
- (NSInteger)match:(NSArray *)otherCards
{
    NSInteger rankScore = [self matchRank:otherCards];
    NSInteger suitScore = [self matchSuit:otherCards];
    return rankScore + suitScore;
}

//Matches actual card to other card(s) by rank only
- (NSInteger)matchRank:(NSArray *)otherCards
{
    NSInteger rankScore = 4;
    for (PlayingCard *otherCard in otherCards) {
        if (!([otherCard isKindOfClass:[PlayingCard class]]) ||
            !(otherCard.rank == self.rank)) {
            rankScore = 0;
            break;
        }
    }
    return rankScore;
}

//Matches actual card to other card(s) by suit only
- (NSInteger)matchSuit:(NSArray *)otherCards;
{
    NSInteger suitScore = 1;
    for (PlayingCard *otherCard in otherCards) {
        if (!([otherCard isKindOfClass:[PlayingCard class]]) ||
            ![otherCard.suit isEqualToString:self.suit]) {
            suitScore = 0;
            break;
        }
    }
    return suitScore;
}

#pragma mark - Class methods
+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSArray *)validSuits
{
    return @[@"♥", @"♦", @"♠", @"♣"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}

@end
