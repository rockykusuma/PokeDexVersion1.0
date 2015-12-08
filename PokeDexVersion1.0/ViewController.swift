//
//  ViewController.swift
//  PokeDexVersion1.0
//
//  Created by Rakesh Kusuma on 07/12/15.
//  Copyright © 2015 Attic Infomatics. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var backgroundImage : UIImageView!
    @IBOutlet weak var volumeBtn: UIButton!
    var musicPlayer : AVAudioPlayer!
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = backgroundImage.bounds
//        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
//        backgroundImage.addSubview(blurEffectView)
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        
        parsePokemonCSV()
        initAudio()
        
    }

    @IBAction func musicBtnPressed(sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "volume"){
            volumeBtn.setImage(UIImage(named: "mediumVolume"), forState: .Normal)
            musicPlayer.volume = 0.25
        }else if sender.currentImage == UIImage(named: "mediumVolume"){
            volumeBtn.setImage(UIImage(named: "lowVolume"), forState: .Normal)
            musicPlayer.volume = 0.1
        }else if sender.currentImage == UIImage(named: "lowVolume"){
            volumeBtn.setImage(UIImage(named: "mute"), forState: .Normal)
            musicPlayer.pause()
        }else if sender.currentImage == UIImage(named: "mute"){
            volumeBtn.setImage(UIImage(named: "volume"), forState: .Normal)
            musicPlayer.volume = 0.5
            musicPlayer.play()
        }

    }
    
    func initAudio(){
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.volume = 0.5
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
        
    }
    func parsePokemonCSV(){
        
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filteredPokemon.count
        }
        return pokemon.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell{
            let poke : Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            cell.configureCell(poke)
            return cell
        }
        else {
            return UICollectionViewCell()
        }

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            collectionView.reloadData()
        } else {
            inSearchMode = true
            let searchText = searchBar.text!
            //filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) !=nil})
            
            filteredPokemon = pokemon.filter {$0.name.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil }
            collectionView.reloadData()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var poke : Pokemon!
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
            
        } else {
            poke = pokemon[indexPath.row]
        }
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    

}

