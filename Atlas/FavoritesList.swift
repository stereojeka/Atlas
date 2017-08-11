//
//  FavoritesList.swift
//  Atlas
//
//  Created by Admin on 8/8/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

final class FavoritesList {
    
    static let sharedFavoritesList = FavoritesList()
    private(set) var favorites: [Country]
    
    init() {
        
        if let unarchivedObject = UserDefaults.standard.object(forKey: "favorites") as? Data,
            let favs = NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [Country] {
            favorites = favs
        } else {
            favorites = []
        }
        
    }
    
    func addFavorite(newFavouriteCountry: Country){
        if !favorites.contains(where: { (_ country: Country) -> Bool in
            newFavouriteCountry.alpha3Code == country.alpha3Code
        }) {
            favorites.append(newFavouriteCountry)
            saveFavorites()
        }
    }
    
    func removeFavorite(favoriteToDelete: Country) {
        if let index = favorites.index(where: { (_ country: Country) -> Bool in
            favoriteToDelete.alpha3Code == country.alpha3Code
        }) {
            favorites.remove(at: index)
            saveFavorites()
        }
    }
    
    func moveItem(fromIndex from: Int, toIndex to: Int) {
        let item = favorites[from]
        favorites.remove(at: from)
        favorites.insert(item, at: to)
        saveFavorites()
    }
    
    private func saveFavorites() {

        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: favorites as NSArray) as NSData
        UserDefaults.standard.set(archivedObject, forKey: "favorites")
        UserDefaults.standard.synchronize()

    }
}
