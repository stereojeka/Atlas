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
    private(set) var favorites: [String]
    
    init() {
        let defaults = UserDefaults.standard
        let storedFavorites = defaults.object(forKey: "favorites") as? [String]
        favorites = storedFavorites != nil ? storedFavorites! : []
    }
    
    func addFavorite(newFavouriteCountry: String){
        if !favorites.contains(newFavouriteCountry) {
            favorites.append(newFavouriteCountry)
            saveFavorites()
        }
        
    }
    
    func removeFavorite(favoriteToDelete: String) {
        if let index = favorites.index(of: favoriteToDelete) {
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
        let defaults = UserDefaults.standard
        defaults.set(favorites, forKey: "favourites")
        defaults.synchronize()
    }
}
