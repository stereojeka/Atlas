//
//  CountryInfoViewController.swift
//  Atlas
//
//  Created by Admin on 8/3/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import MapKit

class CountryInfoViewController: UIViewController {
    
    private var countryService: CountryService!
    
    var countryCode: String!
    var country: Country!
    var borderedCountries: [Country]!
    var favorite: Bool = false

    
    
    @IBOutlet weak var currenciesLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var flagView: UIWebView!
    @IBOutlet weak var locationMap: MKMapView!
    @IBOutlet weak var boardsTableView: UITableView!
    @IBOutlet weak var boardsWithLabel: UILabel!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    @IBAction func toggleFavorite(_ sender: UISwitch) {
        let favoritesList = FavoritesList.sharedFavoritesList
        if sender.isOn {
            favoritesList.addFavorite(newFavouriteCountry: country.alpha3Code)
        } else {
            favoritesList.removeFavorite(favoriteToDelete: country.alpha3Code)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryService = CountryService.sharedCountryService
        
        boardsTableView.register(CountryListCell.self, forCellReuseIdentifier: CountryInfoViewController.cellIdentifier)
        let xib = UINib(nibName: "CountryListCell", bundle: nil)
        boardsTableView.register(xib, forCellReuseIdentifier: CountryInfoViewController.cellIdentifier)
        boardsTableView.rowHeight = 140
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        countryService.getCountryByCode(self.countryCode) { [unowned self] result, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.country = result
            
            self.flagView.loadHTMLString("<img style=\"position:absolute;left:0;top:0;\" width=\"100%\" height=\"100%\" src=\" \(self.country.flag)\" alt=\"Flag\" >", baseURL: nil)
            
            for currency in self.country.currencies {
                self.currenciesLabel.text! += "\(currency) "
            }
            for language in self.country.languages {
                self.languagesLabel.text! += "\(language) "
            }
            if !self.country.latlng.isEmpty {
                let centerLocation = CLLocationCoordinate2DMake(self.country.latlng[0], self.country.latlng[1])
                let mapSpan = MKCoordinateSpanMake(1.2, 1.2)
                let mapRegion = MKCoordinateRegionMake(centerLocation, mapSpan)
                self.locationMap.setRegion(mapRegion, animated: true)
                self.locationMap.isHidden = false
            }
            if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        favoriteSwitch.isOn = favorite
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.country.borders != nil, !(self.country.borders?.isEmpty)! {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            countryService.getMultipleCountries(self.country.borders!) { [unowned self] result, errorMessage in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.borderedCountries = result
                self.boardsTableView.reloadData()
                if !self.borderedCountries.isEmpty {
                    self.boardsWithLabel.isHidden = false
                }
                if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = boardsTableView.indexPath(for: sender as! UITableViewCell)!
        let listVC = segue.destination as! CountryInfoViewController
        listVC.navigationItem.title = borderedCountries[indexPath.row].name
        listVC.countryCode = borderedCountries[indexPath.row].alpha3Code
        listVC.favorite = FavoritesList.sharedFavoritesList.favorites.contains(listVC.countryCode)
        listVC.borderedCountries = []
    }
 

}


extension CountryInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate static let cellIdentifier = "CountryCell"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return borderedCountries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CountryInfoViewController.cellIdentifier, for: indexPath) as! CountryListCell
        
        cell.flagView.loadHTMLString("<img style=\"position:absolute;left:0;top:0;\" width=\"100%\" height=\"100%\" src=\" \(borderedCountries[indexPath.row].flag)\" alt=\"Flag\" >", baseURL: nil)
        cell.nameLabel.text = borderedCountries[indexPath.row].name
        cell.nativeNameLabel.text = borderedCountries[indexPath.row].nativeName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowBoardCountry", sender: tableView.cellForRow(at: indexPath))
    }

}






