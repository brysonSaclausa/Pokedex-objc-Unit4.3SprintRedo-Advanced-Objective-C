//
//  BRSPokemon.m
//  Pokedex-Objc-REDO
//
//  Created by BrysonSaclausa on 2/27/21.
//

#import "BRSPokemon.h"

@implementation BRSPokemon

- (instancetype)initWithName:(NSString *)aName
{
    if (self = [super init]) {
        _name = aName.copy;
    }
    return self;
}

@end
