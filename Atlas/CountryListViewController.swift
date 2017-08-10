//
//  CountryListViewController.swift
//  Atlas
//
//  Created by Admin on 8/1/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CountryListViewController: UITableViewController {

    var regionLink: String!
    let controller = CountryTableViewController()
    
    private var countryService: CountryService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryService = CountryService.sharedCountryService
        
        tableView.register(CountryListCell.self, forCellReuseIdentifier: CountryTableViewController.cellId)
        let xib = UINib(nibName: "CountryListCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: CountryTableViewController.cellId)
        tableView.rowHeight = 140
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        countryService.getCountriesByRegion(regionLink) { [unowned self] results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if results != nil {
                self.controller.items = results!
                self.tableView.dataSource = self.controller
                self.tableView.reloadData()
            }
            if !errorMessage.isEmpty { print("Search error: " + errorMessage); UIApplication.shared.isNetworkActivityIndicatorVisible = false }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowCountryInfo", sender: tableView.cellForRow(at: indexPath))
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        let listVC = segue.destination as! CountryInfoViewController
        listVC.navigationItem.title = controller.items[indexPath.row].name
        listVC.countryCode = controller.items[indexPath.row].alpha3Code
        listVC.favorite = FavoritesList.sharedFavoritesList.favorites.contains(listVC.countryCode)
        listVC.controller.items = []
    }

}



















