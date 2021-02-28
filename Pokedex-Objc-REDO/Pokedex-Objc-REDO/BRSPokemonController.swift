//
//  BRSPokemonController.swift
//  Pokedex-Objc-REDO
//
//  Created by BrysonSaclausa on 2/28/21.
//

import UIKit

enum NetworkError: String, Error {
    case networkError
    case noData
    case decodeError
    
}
@objc(BRSPokemonController)
class BRSPokemonController: NSObject {
    
    //MARK: - Properties
    var pokemon: [BRSPokemon] = []
    @objc static let shared = BRSPokemonController()
    private let fetchPokemonURL = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=1000")!
    private let fetchPokemonDetails = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    @objc func fetchAllPokemon(completion: @escaping ([BRSPokemon]?, Error?) -> Void) {
        var request = URLRequest(url: fetchPokemonURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error)
                completion(nil, NetworkError.networkError)
                return
            }
            
            guard let data = data else {
                print("No data was fetched: \(NetworkError.noData)")
                completion(nil, error)
                return
            }
            
            var resultsDictionary : [String : Any?]
            
            do {
                resultsDictionary = try (JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] ?? [:])
            } catch {
                completion(nil, NetworkError.decodeError)
                print("Error decoding JSON: \(error)")
                return
            }
            
            guard let resultsArray = resultsDictionary["results"] as? [[String : String]] else { return }
            
            for pokemonResult in resultsArray {
                guard let pokemon = BRSPokemon(dictionary: pokemonResult) else { return }
                self.pokemon.append(pokemon)
                completion(self.pokemon, nil)
            }
        }.resume()
    }
    
    
}
