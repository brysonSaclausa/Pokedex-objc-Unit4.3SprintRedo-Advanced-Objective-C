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
    
    //MARK: - Network Calls
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
    
    func getPokemonDetails(for pokemon: BRSPokemon) {
        var request = URLRequest(url: fetchPokemonDetails.appendingPathComponent(pokemon.name.lowercased()))
        request.httpMethod = "GET"
        print(request)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            guard let data = data else { return }
            var topLevelDictionary : [String:Any]?
            
            do {
                topLevelDictionary  = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            } catch let err as NSError {
                print(err)
                return
            }
            
            guard let topLevelDict = topLevelDictionary else { return }
            
            // Get ID
            guard let id = topLevelDict["id"] as? NSNumber else { return }
            pokemon.identifier = id
            
            // Get Sprite
            let spritesDictionary = topLevelDict["sprites"] as! [String:Any]
            let imageURLString = spritesDictionary["front_default"] as? String
            if let imageURL = URL(string: imageURLString!) {
                guard let data = try? Data(contentsOf: imageURL) else { return }
                pokemon.sprite = UIImage(data: data)!
            }
            // Get Abilities
            let abilitiesArray = topLevelDict["abilities"] as! [[String:Any]]
            for item in abilitiesArray {
                let ability = item["ability"] as! [String:String]
                let abi = ability["name"]!
                pokemon.abilities.append(abi)
            }
        }.resume()
        
        
    }
    
    
}
