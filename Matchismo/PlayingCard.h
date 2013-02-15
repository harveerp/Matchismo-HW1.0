//
//  PlayingCard.h
//  Matchismo
//
//  Created by Eric on 11/02/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSUInteger rank;

- (NSInteger)matchRank:(NSArray *)otherCards;
- (NSInteger)matchSuit:(NSArray *)otherCards;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
