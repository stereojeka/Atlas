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
    let controller = CountryTableViewController()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    

    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryService = CountryService.sharedCountryService
        
        tableView.register(CountryListCell.self, forCellReuseIdentifier: CountryTableViewController.cellId)
        let xib = UINib(nibName: "CountryListCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: CountryTableViewController.cellId)
        tableView.dataSource = controller
        tableView.rowHeight = 140
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
        listVC.navigationItem.title = controller.items[indexPath.row].name
        listVC.countryCode = controller.items[indexPath.row].alpha3Code
        listVC.favorite = FavoritesList.sharedFavoritesList.favorites.contains(listVC.countryCode)
        listVC.controller.items = []
    }
    

}

// MARK: - UITableView
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowCountryFromResult", sender: tableView.cellForRow(at: indexPath))
    }
    
}



