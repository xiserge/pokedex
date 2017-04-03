//
//  PokeCell.swift
//  Poxedex
//
//  Created by Serge Ivanov on 27/03/2017.
//  Copyright © 2017 xserge. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    private var _pokemon: Pokemon!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon) {
        self._pokemon = pokemon
        
        label.text = _pokemon.name.capitalized
        image.image = UIImage(named: "\(_pokemon.pokedexId)") 
    }
}
