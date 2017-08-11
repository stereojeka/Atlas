//
//  Country.swift
//  Atlas
//
//  Created by Admin on 8/1/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

class Country: NSObject, NSCoding {
    
    let name: String
    let nativeName: String
    let alpha3Code: String
    let flag: URL
    let latlng: [Double]
    let currencies: [String]
    let languages: [String]
    let borders: [String]?
    
    
    init(name: String, nativeName: String, flag: String, latlng: [Double],
         currencies: [String], languages: [String], borders: [String], alpha3Code: String) {
        self.name = name
        self.nativeName = nativeName
        self.flag = URL(string: flag)!
        self.latlng = latlng
        self.currencies = currencies
        self.languages = languages
        self.borders = borders
        self.alpha3Code = alpha3Code
    }
    
    init(name: String, nativeName: String, flag: String, alpha3Code: String) {
        self.name = name
        self.nativeName = nativeName
        self.flag = URL(string: flag)!
        self.alpha3Code = alpha3Code
        self.latlng = []
        self.currencies = []
        self.languages = []
        self.borders = []
    }
    
    //MARK: - NSCoding -
    required init(coder aDecoder: NSCoder) {
        name        =   aDecoder.decodeObject(forKey: "name") as! String
        nativeName  =   aDecoder.decodeObject(forKey: "nativeName") as! String
        flag        =   aDecoder.decodeObject(forKey: "flag") as! URL
        latlng      =   aDecoder.decodeObject(forKey: "latlng") as! [Double]
        currencies  =   aDecoder.decodeObject(forKey: "currencies") as! [String]
        languages   =   aDecoder.decodeObject(forKey: "languages") as! [String]
        borders     =   aDecoder.decodeObject(forKey: "borders") as! [String]?
        alpha3Code  =   aDecoder.decodeObject(forKey: "alpha3Code") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name,         forKey: "name")
        aCoder.encode(nativeName,   forKey: "nativeName")
        aCoder.encode(flag,         forKey: "flag")
        aCoder.encode(latlng,       forKey: "latlng")
        aCoder.encode(currencies,   forKey: "currencies")
        aCoder.encode(languages,    forKey: "languages")
        aCoder.encode(borders,      forKey: "borders")
        aCoder.encode(alpha3Code,   forKey: "alpha3Code")
    }
    
}

