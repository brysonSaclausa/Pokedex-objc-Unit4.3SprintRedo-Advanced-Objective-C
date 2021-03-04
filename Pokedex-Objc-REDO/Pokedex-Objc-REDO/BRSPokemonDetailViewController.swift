//
//  BRSPokemonDetailViewController.swift
//  Pokedex-Objc-REDO
//
//  Created by BrysonSaclausa on 2/28/21.
//

import UIKit

class BRSPokemonDetailViewController: UIViewController {
    
    
    //MARK: - Properties
    @objc var pokemon: BRSPokemon?
       var spriteObserver: NSKeyValueObservation?
       var idObserver: NSKeyValueObservation?
       var abilitiesObserver: NSKeyValueObservation?
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var abilityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
           addObserver()
        if let pokemon = pokemon {
            BRSPokemonController.shared.getPokemonDetails(for: pokemon)
        }
    }
    
    private func updateViews() {
        if let pokemon = pokemon {
            nameLabel.text = pokemon.name
            imageView.image = pokemon.sprite
            idLabel.text = "ID: \(pokemon.identifier)"
            let abilities = pokemon.abilities as? [String]
            abilityLabel.text = "Abilities: \(String (describing: abilities!.joined(separator: ", ").capitalized))"
        }
    }
    
       private func addObserver() {
           let pokemonChangeHandler: ((Any, Any) -> Void) = { [weak self] _, _ in
               guard let self = self else { return }
               DispatchQueue.main.async {
                   self.updateViews()
               }
           }
   
           spriteObserver = observe(\.pokemon?.sprite, changeHandler: pokemonChangeHandler)
           idObserver = observe(\.pokemon?.identifier, changeHandler: pokemonChangeHandler)
           abilitiesObserver = observe(\.pokemon?.abilities, changeHandler: pokemonChangeHandler)
       }
}
