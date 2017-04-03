//
//  ViewController.swift
//  Poxedex
//
//  Created by Serge Ivanov on 24/03/2017.
//  Copyright © 2017 xserge. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    var pokemons: [Pokemon] = []
    var filteredPokemons: [Pokemon] = []
    var inSearchMode = false
    var shouldBeginSearch = true
    
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchbar.delegate = self
        searchbar.returnKeyType = .done
        
        parsePokemonCSV()
        
        initMusicPlayer()
    }
    
    func initMusicPlayer() {
        do {
            if let path = Bundle.main.path(forResource: "music", ofType: "mp3") {
                musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
                musicPlayer.prepareToPlay()
                musicPlayer.numberOfLoops = -1
                musicPlayer.play()
            }
        }
        catch let err as NSError {
            print("\(err)")
        }
    }
    
    func parsePokemonCSV() {
        if let path = Bundle.main.path(forResource: "pokemon", ofType: "csv") {
            do {
                let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                for row in rows {
                    if let name = row["identifier"], let strid = row["id"], let id = Int(strid) {
                        let pokemon = Pokemon(name: name, pokedexId: id)
                        pokemons.append(pokemon)
                    }
                }
            }
            catch {
                let error = error as NSError
                print("\(error)")
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let pokemons = inSearchMode ? filteredPokemons : self.pokemons
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            let pokemons = inSearchMode ? filteredPokemons : self.pokemons
            let pokemon = pokemons[indexPath.row]
            cell.configureCell(pokemon: pokemon)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemons = inSearchMode ? filteredPokemons : self.pokemons
        let pokemon = pokemons[indexPath.row]
        performSegue(withIdentifier: "PokeDetailsVC", sender: pokemon)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokeDetailsVC", let destination = segue.destination as? PokeDetailsVC, let pokemon = sender as? Pokemon {
            destination.pokemon = pokemon
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentWidth = collectionView.bounds.width - 20
        let width = min(105, contentWidth / 3)
        return CGSize(width: width, height: width)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let shouldBegin = shouldBeginSearch
        shouldBeginSearch = true
        return shouldBegin
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            inSearchMode = true
            let lower = searchText.lowercased()
            filteredPokemons = pokemons.filter({pokemon in
                return pokemon.name.lowercased().contains(lower)
            })
            collectionView.reloadData()
        }
        else {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
            
            if !searchBar.isFirstResponder {
                shouldBeginSearch = false
            }
        }
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if !musicPlayer.isPlaying {
            musicPlayer.play()
            sender.alpha = 1
        }
        else {
            musicPlayer.pause()
            sender.alpha = 0.2
        }
    }
}

