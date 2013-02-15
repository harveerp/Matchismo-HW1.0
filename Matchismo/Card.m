//
//  Card.m
//  Matchismo
//
//  Created by Eric on 11/02/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Card.h"

@interface Card ()

@end


@implementation Card

//Match function for generic cards
//Matches for card contents equality
- (int)match:(NSArray *)otherCards
{
    int match = 1;
    for (Card *card in otherCards) {
        if (![card.contents isEqualToString:self.contents]) match = 0;
    }
    return match;
}

- (NSString *)description
{
    return self.contents;
}

@end
