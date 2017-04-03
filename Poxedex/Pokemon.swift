//
//  Pokemon.swift
//  Poxedex
//
//  Created by Serge Ivanov on 24/03/2017.
//  Copyright © 2017 xserge. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _details: String!
    private var _type: String!
    private var _defense: Int!
    private var _height: Int!
    private var _weight: Int!
    private var _attack: Int!
    private var _nextEvoName: String!
    private var _nextEvoImgName: String!
    private var _pokemonURL: String!
    
    public var name: String {
        return _name
    }
    
    public var pokedexId: Int {
        return _pokedexId
    }
    
    public var weight: Int {
        if _weight == nil {
            return 0
        }
        return _weight
    }
    
    public var height: Int {
        if _height == nil {
            return 0
        }
        return _height
    }
    
    public var attack: Int {
        if _attack == nil {
            return 0
        }
        return _attack
    }
    
    public var defense: Int {
        if _defense == nil {
            return 0
        }
        return _defense
    }
    
    public var type: String {
        if _type == nil {
            return ""
        }
        return _type
    }
    
    public var details: String {
        if _details == nil {
            return ""
        }
        return _details
    }
    
    public var nextEvoName: String {
        if _nextEvoName == nil {
            return ""
        }
        return _nextEvoName
    }
    
    public var nextEvoImgName: String {
        if _nextEvoImgName == nil {
            return ""
        }
        return _nextEvoImgName
    }
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
        
        self._pokemonURL = "\(BASE_URL)\(POKEMON_URL)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        Alamofire.request(self._pokemonURL!).responseJSON { (response) in
            let result = response.result
            if let value = result.value as? Dictionary<String, AnyObject> {
                if let attack = value["attack"] as? Int {
                    self._attack = attack
                }
                if let defense = value["defense"] as? Int {
                    self._defense = defense
                }
                if let height = value["height"] as? String {
                    self._height = Int(height)
                }
                if let weight = value["weight"] as? String {
                    self._weight = Int(weight)
                }
                if let types = value["types"] as? [Dictionary<String, AnyObject>] {
                    var typeNames = [String]()
                    for type in types {
                        if let name = type["name"] as? String {
                            typeNames.append(name.capitalized)
                        }
                    }
                    self._type = typeNames.joined(separator: "/")
                }
                
                if let descArr = value["descriptions"] as? [Dictionary<String, String>], descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let url = "\(BASE_URL)\(url)"
                        Alamofire.request(url).responseJSON { (response) in
                            if let value = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = value["description"] as? String {
                                    let description = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._details = description
                                }
                            }
                            completed()
                        }
                    }
                }
                
                if let evoArr = value["evolutions"] as? [Dictionary<String, AnyObject>], evoArr.count > 0 {
                    let lvl = evoArr[0]["level"] as? Int
                    if let name = evoArr[0]["to"] as? String {
                        if name.range(of: "mega") == nil, let lvl = lvl {
                            self._nextEvoName = "\(name) LVL\(lvl)"
                            
                            if let url = evoArr[0]["resource_uri"] as? String {
                                let id = url.replacingOccurrences(of: POKEMON_URL, with: "").replacingOccurrences(of: "/", with: "")
                                self._nextEvoImgName = id
                            }
                        }
                    }
                    
                    
                    
                }
            }
            completed()
        }
    }
}
