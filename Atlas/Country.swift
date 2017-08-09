//
//  Country.swift
//  Atlas
//
//  Created by Admin on 8/1/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation.NSURL

class Country {
    
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
    
}

