//
//  PokeCell.swift
//  PokeDexVersion1.0
//
//  Created by Rakesh Kusuma on 07/12/15.
//  Copyright © 2015 Attic Infomatics. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImage : UIImageView!
    @IBOutlet weak var pokemonLbl : UILabel!
    
    var pokemon : Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 10.0
    }
    
    func configureCell(pokemon:Pokemon) {
        self.pokemon = pokemon
        pokemonLbl.text = self.pokemon.name.capitalizedString
        pokemonImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
    
    
    
}
