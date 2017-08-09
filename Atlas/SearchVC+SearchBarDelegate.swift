//
//  SearchVC+SearchBarDelegate.swift
//  Atlas
//
//  Created by Admin on 8/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

extension SearchViewController: UISearchBarDelegate {
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        countryService.getSearchResults(searchTerm: searchText) { [unowned self] results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let results = results {
                self.searchResults = results
                self.tableView.reloadData()
            } else {
                self.searchResults = []
                self.tableView.reloadData()
                let alert = UIAlertController(title: "Search Results",
                                              message: "No matches found",
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay :(", style: .default,
                                           handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
}
