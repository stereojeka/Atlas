//
//  CountryListCell.swift
//  Atlas
//
//  Created by Admin on 8/3/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CountryListCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nativeNameLabel: UILabel!
    @IBOutlet var flagView: UIWebView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.flagView.stopLoading()
    }

}
