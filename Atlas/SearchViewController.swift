//
//  SearchViewController.swift
//  Atlas
//
//  Created by Admin on 8/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var countryService: CountryService!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate static let cellIdentifier = "SearchResultCell"

    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    
    var searchResults: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryService = CountryService.sharedCountryService
        
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchViewController.cellIdentifier)
        let xib = UINib(nibName: "SearchResultCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: SearchViewController.cellIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        let listVC = segue.destination as! CountryInfoViewController
        listVC.navigationItem.title = searchResults[indexPath.row].name
        listVC.countryCode = searchResults[indexPath.row].alpha3Code
        listVC.favorite = FavoritesList.sharedFavoritesList.favorites.contains(listVC.countryCode)
        listVC.borderedCountries = []
    }
    

}

// MARK: - UITableView
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.cellIdentifier, for: indexPath) as! SearchResultCell
        cell.flagView.loadHTMLString("<img style=\"position:absolute;left:0;top:0;\" width=\"100%\" height=\"100%\" src=\" \(searchResults[indexPath.row].flag)\" alt=\"Flag\" >", baseURL: nil)
        cell.nameLabel.text = searchResults[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowCountryFromResult", sender: tableView.cellForRow(at: indexPath))
    }
    
}





