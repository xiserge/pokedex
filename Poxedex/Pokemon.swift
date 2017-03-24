//
//  Pokemon.swift
//  Poxedex
//
//  Created by Serge Ivanov on 24/03/2017.
//  Copyright © 2017 xserge. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    
    public var name: String {
        return _name
    }
    
    public var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
    }
}
