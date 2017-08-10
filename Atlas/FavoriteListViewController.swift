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
    let controller = CountryTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        countryService = CountryService.sharedCountryService
        favoritesList = FavoritesList.sharedFavoritesList
        
        tableView.register(CountryListCell.self, forCellReuseIdentifier: CountryTableViewController.cellId)
        let xib = UINib(nibName: "CountryListCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: CountryTableViewController.cellId)
        tableView.rowHeight = 110
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !favoritesList.favorites.isEmpty {
            navigationItem.rightBarButtonItem = editButtonItem
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            countryService.getMultipleCountries(favoritesList.favorites) { [unowned self] result, errorMessage in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let result = result {
                    self.controller.items = result
                    self.tableView.dataSource = self.controller
                    self.tableView.reloadData()
                }
                if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
            }
        } else {
            controller.items = []
            navigationItem.rightBarButtonItem = nil
            tableView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowFavoriteCountry", sender: tableView.cellForRow(at: indexPath))
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        let listVC = segue.destination as! CountryInfoViewController
        listVC.navigationItem.title = controller.items[indexPath.row].name
        listVC.countryCode = controller.items[indexPath.row].alpha3Code
        listVC.favorite = favoritesList.favorites.contains(listVC.countryCode)
        listVC.controller.items = []
    }
    
}

extension CountryTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !self.items.isEmpty
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if self.items.isEmpty {
            return
        }
        if editingStyle == UITableViewCellEditingStyle.delete {
            let favorite = self.items[indexPath.row]
            FavoritesList.sharedFavoritesList.removeFavorite(favoriteToDelete: favorite.alpha3Code)
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        FavoritesList.sharedFavoritesList.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
        let item = self.items[sourceIndexPath.row]
        self.items.remove(at: sourceIndexPath.row)
        self.items.insert(item, at: destinationIndexPath.row)
        tableView.reloadData()
    }

    
}
