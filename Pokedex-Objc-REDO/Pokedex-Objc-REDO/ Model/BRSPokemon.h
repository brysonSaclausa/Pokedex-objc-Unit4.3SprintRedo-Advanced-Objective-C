//
//  BRSPokemon.h
//  Pokedex-Objc-REDO
//
//  Created by BrysonSaclausa on 2/27/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRSPokemon : NSObject

@property (nonatomic, copy, readonly, nonnull) NSString *name;
@property ( nonatomic, nonnull) NSNumber *identifier;
@property (nonatomic, nullable) UIImage *sprite;
@property (nonatomic, nonnull, copy)NSArray* abilities;

- (instancetype)initWithName:(NSString *)aName;

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;


@end

NS_ASSUME_NONNULL_END
