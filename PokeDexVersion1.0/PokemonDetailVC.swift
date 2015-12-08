//
//  PokemonDetailVC.swift
//  PokeDexVersion1.0
//
//  Created by Rakesh Kusuma on 07/12/15.
//  Copyright © 2015 Attic Infomatics. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typelabel: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedeskIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var evolutionLbl: UILabel!
    @IBOutlet weak var nextEvoImage: UIImageView!
    
    var pokemon : Pokemon!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pokemon.name.capitalizedString
        let image = UIImage(named: "\(pokemon.pokedexId)")
        mainImage.image = image
        currentEvoImage.image = image
        pokemon.downloadPokemonDetails { () -> () in
            // This will be called After Downloaded Resource has been finished
            self.updateUI()
        }
        
        self.mainImage.layer.cornerRadius = self.mainImage.frame.size.width/2
        self.mainImage.clipsToBounds = true
        //self.currentEvoImage.layer.cornerRadius = self.currentEvoImage.frame.size.width/2
        self.currentEvoImage.layer.cornerRadius = 20.0
        self.currentEvoImage.clipsToBounds = true
        //self.nextEvoImage.layer.cornerRadius = self.nextEvoImage.frame.size.width/2
        self.nextEvoImage.layer.cornerRadius = 20.0
        self.nextEvoImage.clipsToBounds = true
        
    }
    
    func updateUI(){
        descriptionLbl.text = pokemon.description
        typelabel.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        attackLbl.text = pokemon.attack
        pokedeskIdLbl.text = "\(pokemon.pokedexId)"
        
        if pokemon.nextEvolutionId == "" {
            evolutionLbl.text = "No Evolutions"
            nextEvoImage.hidden = true
        } else {
            nextEvoImage.hidden = false
            nextEvoImage.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            if pokemon.nextEvolutionLevel != "" {
                str += " - LVL \(pokemon.nextEvolutionLevel)"
            }
            evolutionLbl.text = str
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
