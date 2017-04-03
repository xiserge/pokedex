//
//  PokeDetailsVC.swift
//  Poxedex
//
//  Created by Serge Ivanov on 27/03/2017.
//  Copyright © 2017 xserge. All rights reserved.
//

import UIKit

class PokeDetailsVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var nextEvoNameLbl: UILabel!
    @IBOutlet weak var nextEvoImgView: UIStackView!
    @IBOutlet weak var nextEvoNameView: UIView!
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name
        pokedexIdLbl.text = "\(pokemon.pokedexId)"
        thumbImg.image = UIImage(named: "\(pokemon.pokedexId)")
        currentEvoImg.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokemon.downloadPokemonDetails {
            self.updateUI();
        }
    }
    
    func updateUI() {
        typeLbl.text = pokemon.type
        baseAttackLbl.text = "\(pokemon.attack)"
        defenseLbl.text = "\(pokemon.defense)"
        heightLbl.text = "\(pokemon.height)"
        weightLbl.text = "\(pokemon.weight)"
        detailsLbl.text = "\(pokemon.details)"
        baseAttackLbl.text = "\(pokemon.attack)"
        if pokemon.nextEvoName != "" {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvoImgName)
            nextEvoNameLbl.text = "Следующий этап эволюции: \(pokemon.nextEvoName)"
        } else {
            nextEvoNameLbl.text = "Без эволюции"
            nextEvoImg.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
