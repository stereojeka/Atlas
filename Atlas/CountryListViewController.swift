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
    var countries: [Country] = []
    
    private var countryService: CountryService!
    
    private static let cellIdentifier = "CountryCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryService = CountryService.sharedCountryService
        
        tableView.register(CountryListCell.self, forCellReuseIdentifier: CountryListViewController.cellIdentifier)
        let xib = UINib(nibName: "CountryListCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: CountryListViewController.cellIdentifier)
        tableView.rowHeight = 120
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        countryService.getCountriesByRegion(regionLink) { [unowned self] results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if results != nil {
                self.countries = results!
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return countries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CountryListViewController.cellIdentifier, for: indexPath) as! CountryListCell
        
        //let request: NSURLRequest = NSURLRequest(url: countries[indexPath.row].flag)
        // Configure the cell...
        //cell.flagView.loadRequest(request as URLRequest)
        cell.flagView.loadHTMLString("<img style=\"position:absolute;left:0;top:0;\" width=\"100%\" height=\"100%\" src=\" \(countries[indexPath.row].flag)\" alt=\"Flag\" >", baseURL: nil)
        cell.nameLabel.text = countries[indexPath.row].name
        cell.nativeNameLabel.text = countries[indexPath.row].nativeName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowCountryInfo", sender: tableView.cellForRow(at: indexPath))
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        let listVC = segue.destination as! CountryInfoViewController
        listVC.navigationItem.title = countries[indexPath.row].name
        listVC.countryCode = countries[indexPath.row].alpha3Code
        listVC.favorite = FavoritesList.sharedFavoritesList.favorites.contains(listVC.countryCode)
        listVC.borderedCountries = []
    }

}
