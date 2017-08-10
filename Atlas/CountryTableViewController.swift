//
//  TableViewController.swift
//  Atlas
//
//  Created by Admin on 8/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

class CountryTableViewController: NSObject, UITableViewDataSource {
    static let cellId = "CellId"
    var items: [Country] = []


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewController.cellId, for: indexPath) as! CountryListCell
        
        cell.flagView.loadHTMLString("<img style=\"position:absolute;left:0;top:0;\" width=\"100%\" height=\"100%\" src=\" \(items[indexPath.row].flag)\" alt=\"Flag\" >", baseURL: nil)
        cell.nameLabel.text = items[indexPath.row].name
        cell.nativeNameLabel.text = items[indexPath.row].nativeName
        
        return cell
    }

}
