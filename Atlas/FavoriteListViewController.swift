//
//  FavoriteListViewController.swift
//  Atlas
//
//  Created by Admin on 8/8/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class FavoriteListViewController: UITableViewController {
    
    private var favoritesList: FavoritesList!
    private var countryService: CountryService!
    private static let cellIdentifier = "CountryCell"
    
    var favoriteCountries: [Country] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        countryService = CountryService.sharedCountryService
        
        favoritesList = FavoritesList.sharedFavoritesList
        
        tableView.register(CountryListCell.self, forCellReuseIdentifier: FavoriteListViewController.cellIdentifier)
        let xib = UINib(nibName: "CountryListCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: FavoriteListViewController.cellIdentifier)
        tableView.rowHeight = 120
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !favoritesList.favorites.isEmpty {
            navigationItem.rightBarButtonItem = editButtonItem
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            countryService.getMultipleCountries(favoritesList.favorites) { [unowned self] result, errorMessage in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let result = result {
                    self.favoriteCountries = result
                    self.tableView.reloadData()
                }
                if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
            }
        } else {
            favoriteCountries = []
            navigationItem.rightBarButtonItem = nil
            tableView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteCountries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteListViewController.cellIdentifier, for: indexPath) as! CountryListCell

        // Configure the cell...
        cell.flagView.loadHTMLString("<img style=\"position:absolute;left:0;top:0;\" align=\"middle\" width=\"100%\" height=\"100%\" src=\" \(favoriteCountries[indexPath.row].flag)\" alt=\"Flag\" >", baseURL: nil)
        cell.nameLabel.text = favoriteCountries[indexPath.row].name
        cell.nativeNameLabel.text = favoriteCountries[indexPath.row].nativeName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowFavoriteCountry", sender: tableView.cellForRow(at: indexPath))
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !favoriteCountries.isEmpty
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if favoriteCountries.isEmpty {
            return
        }
        if editingStyle == UITableViewCellEditingStyle.delete {
            let favorite = favoriteCountries[indexPath.row]
            FavoritesList.sharedFavoritesList.removeFavorite(favoriteToDelete: favorite.alpha3Code)
            favoriteCountries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if favoriteCountries.isEmpty {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        FavoritesList.sharedFavoritesList.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
        let item = favoriteCountries[sourceIndexPath.row]
        favoriteCountries.remove(at: sourceIndexPath.row)
        favoriteCountries.insert(item, at: destinationIndexPath.row)
        tableView.reloadData()
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        let listVC = segue.destination as! CountryInfoViewController
        listVC.navigationItem.title = favoriteCountries[indexPath.row].name
        listVC.countryCode = favoriteCountries[indexPath.row].alpha3Code
        listVC.favorite = favoritesList.favorites.contains(listVC.countryCode)
        listVC.borderedCountries = []
    }
    
}
