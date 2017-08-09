//
//  RegionsViewController.swift
//  Atlas
//
//  Created by Admin on 8/1/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class RegionsViewController: UITableViewController {
    
    private var regionNames:[String]!
    private var regionData:[String]!
    
    private let regions = [
        "Africa"    : "https://restcountries.eu/rest/v2/region/Africa?fields=name;nativeName;flag;alpha3Code",
        "Americas"  : "https://restcountries.eu/rest/v2/region/Americas?fields=name;nativeName;flag;alpha3Code",
        "Asia"      : "https://restcountries.eu/rest/v2/region/Asia?fields=name;nativeName;flag;alpha3Code",
        "Europe"    : "https://restcountries.eu/rest/v2/region/Europe?fields=name;nativeName;flag;alpha3Code",
        "Oceania"   : "https://restcountries.eu/rest/v2/region/Oceania?fields=name;nativeName;flag;alpha3Code",
        
        "EU (European Union)"                                       : "https://restcountries.eu/rest/v2/regionalbloc/eu?fields=name;nativeName;flag;alpha3Code",
        "EFTA (European Free Trade Association)"                    : "https://restcountries.eu/rest/v2/regionalbloc/EFTA?fields=name;nativeName;flag;alpha3Code",
        "CARICOM (Caribbean Community)"                             : "https://restcountries.eu/rest/v2/regionalbloc/CARICOM?fields=name;nativeName;flag;alpha3Code",
        "PA (Pacific Alliance)"                                     : "https://restcountries.eu/rest/v2/regionalbloc/PA?fields=name;nativeName;flag;alpha3Code",
        "AU (African Union)"                                        : "https://restcountries.eu/rest/v2/regionalbloc/AU?fields=name;nativeName;flag;alpha3Code",
        "USAN (Union of South American Nations)"                    : "https://restcountries.eu/rest/v2/regionalbloc/USAN?fields=name;nativeName;flag;alpha3Code",
        "EEU (Eurasian Economic Union)"                             : "https://restcountries.eu/rest/v2/regionalbloc/EEU?fields=name;nativeName;flag;alpha3Code",
        "AL (Arab League)"                                          : "https://restcountries.eu/rest/v2/regionalbloc/AL?fields=name;nativeName;flag;alpha3Code",
        "ASEAN (Association of Southeast Asian Nations)"            : "https://restcountries.eu/rest/v2/regionalbloc/ASEAN?fields=name;nativeName;flag;alpha3Code",
        "CAIS (Central American Integration System)"                : "https://restcountries.eu/rest/v2/regionalbloc/CAIS?fields=name;nativeName;flag;alpha3Code",
        "CEFTA (Central European Free Trade Agreement)"             : "https://restcountries.eu/rest/v2/regionalbloc/CEFTA?fields=name;nativeName;flag;alpha3Code",
        "NAFTA (North American Free Trade Agreement)"               : "https://restcountries.eu/rest/v2/regionalbloc/NAFTA?fields=name;nativeName;flag;alpha3Code",
        "SAARC (South Asian Association for Regional Cooperation)"  : "https://restcountries.eu/rest/v2/regionalbloc/SAARC?fields=name;nativeName;flag;alpha3Code"
    ]
    
    private static let regionCell = "RegionName"

    override func viewDidLoad() {
        super.viewDidLoad()
        regionNames = [String](regions.keys)
        regionData = [String](regions.values)
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
        return regionNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegionsViewController.regionCell, for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = regionNames[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        let listVC = segue.destination as! CountryListViewController
        let regionName = regionNames[indexPath.row]
        listVC.navigationItem.title = regionName
        listVC.regionLink = regionData[indexPath.row]
    }
 

}
