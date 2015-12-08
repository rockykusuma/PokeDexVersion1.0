//
//  Pokemon.swift
//  PokeDexVersion1.0
//
//  Created by Rakesh Kusuma on 07/12/15.
//  Copyright © 2015 Attic Infomatics. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name : String!
    private var _pokedexId : Int!
    private var _description : String!
    private var _type : String!
    private var _defense : String!
    private var _height : String!
    private var _attack : String!
    private var _weight : String!
    private var _nextEvolutionTxt : String!
    private var _nextEvolutionId : String!
    private var _nextEvolutionLevel : String!
    private var _pokemonURL : String!
    

    
    var description : String {
        get{
            if _description == nil {
                _description = ""
            }
            return _description
        }
        set(newValue) {
            _description = newValue
        }
    }
    
    var type : String {
        get{
            if _type == nil {
                _type = ""
            }
            return _type
        }
        set(newValue) {
            _type = newValue
        }
    }
    
    var defense : String {
        get{
            if _defense == nil{
                _defense = ""
            }
            return _defense
        }
        set(newValue) {
            _defense = newValue
        }
    }
    
    var height : String {
        get{
            if _height == nil{
                _height = ""
            }
            return _height
        }
        set(newValue) {
            _height = newValue
        }
    }
    
    var attack : String {
        get{
            if _attack == nil {
                _attack = ""
            }
            return _attack
        }
        set(newValue) {
            _attack = newValue
        }
    }
    
    var weight : String {
        get{
            if _weight == nil {
                _weight = ""
            }
            return _weight
        }
        set(newValue) {
            _weight = newValue
        }
    }
    
    var nextEvolutionTxt : String {
        get{
            if _nextEvolutionTxt == nil {
                _nextEvolutionTxt = ""
            }
            return _nextEvolutionTxt
        }
        set(newValue) {
            _nextEvolutionTxt = newValue
        }
    }

    
    var nextEvolutionId : String {
        get{
            if _nextEvolutionId == nil {
                _nextEvolutionId = ""
            }
            return _nextEvolutionId
        }
        set(newValue) {
            _nextEvolutionId = newValue
        }
    }
 
    var nextEvolutionLevel: String {
        get{
            if _nextEvolutionLevel == nil {
                _nextEvolutionLevel = ""
            }
            return _nextEvolutionLevel
        }
        set(newValue) {
            _nextEvolutionLevel = newValue
        }
    }
    
    
    
    
    var name : String {
        get{
            return _name
        }
        set(newValue) {
            _name = newValue
        }
    }
    
    var pokedexId : Int{
        get{
            return _pokedexId
        }
        set(newValue) {
            _pokedexId = newValue
        }
    }
    
    
    
    init (name:String,pokedexId:Int) {
        self._name = name
        self._pokedexId = pokedexId
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    
    func downloadPokemonDetails(completed:DownloadComplete) {
        let url = NSURL(string: _pokemonURL)!
        Alamofire.request(.GET, url).responseJSON { (Response) -> Void in
            let result = Response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self.weight = weight
                }
                if let height = dict["height"] as? String {
                    self.height = height
                }
                if let attack = dict["attack"] as? Int {
                    self.attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self.defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String,String>] where types.count > 0{
                    
                    if let typeName = types[0]["name"] {
                        self.type = typeName
                    }
                    if types.count > 1{
                        for var x = 1; x<types.count; x++ {
                            if let typeName = types[x]["name"] {
                            self.type += "/\(typeName)"
                            }
                        }
                    }
                } else {
                    self.type = ""
                }
                if let descArray = dict["descriptions"] as? [Dictionary<String,AnyObject>] where descArray.count > 0 {
                    
                    if let tempUrl = descArray[0]["resource_uri"] {
                        let url = NSURL(string: "\(URL_BASE)\(tempUrl)")
                        // Using Alamofire for Description Tags
                        
                        Alamofire.request(.GET,url!).responseJSON { (Response) -> Void in
                        
                            let desResult = Response.result
                            if let descDict = desResult.value as? Dictionary<String,AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self.description = description
                                }
                            }
                            completed()
                        }  // Description Alamofire End Loop
                    }
                } else {
                    self.description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0{
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        // Cant Suport Mega Pokemon Right Now but api still has mega data.. so i am skipping
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self.nextEvolutionId = num
                                self.nextEvolutionTxt = to
                                
                                if let level = evolutions[0]["level"] as? Int {
                                    self.nextEvolutionLevel = "\(level)"
                                }
                            }
                        }else {
                            
                        }
                    }
                } else {

                }
                
            }
        } /// Main Pokemon Alamofire End Loop
        

        
        
        
        
        
    }
    
}