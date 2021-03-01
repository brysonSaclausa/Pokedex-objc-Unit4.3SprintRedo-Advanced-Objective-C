//
//  BRSPokedexTableViewController.m
//  Pokedex-Objc-REDO
//
//  Created by BrysonSaclausa on 2/28/21.
//

#import "BRSPokedexTableViewController.h"
#import "BRSPokemon.h"

#import "Pokedex_Objc_REDO-Swift.h"




@interface BRSPokedexTableViewController ()

@property (nonatomic, nonnull) NSArray<BRSPokemon *> *pokemon;


@end

@implementation BRSPokedexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BRSPokemonController.shared fetchAllPokemonWithCompletion:^(NSArray<BRSPokemon *> * _Nullable pokemon, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        }
        
        if (pokemon){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pokemon = pokemon;
                [self.tableView reloadData];
            });
        }
    }];//
}

#pragma mark - Table view data source



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pokemon.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pokemonCell" forIndexPath:indexPath];
    
    BRSPokemon *pokemon = self.pokemon[indexPath.row];
    
    cell.textLabel.text = pokemon.name;
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detailSegue"]) {
        BRSPokemonDetailViewController *detailVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailVC.pokemon = self.pokemon[indexPath.row];
        
    }

}



@end
