//
//  EditListTableViewCell.swift
//  contact
//
//  Created by Pinkesh Gjr on 05/02/20.
//  Copyright © 2020 Pinkesh Gjr. All rights reserved.
//

import UIKit

class EditListTableViewCell: UITableViewCell {

    //MARK:- Property
    @IBOutlet weak var labelKey: UILabel!
    @IBOutlet weak var textFieldValue: UITextField!
    
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Functions
    func configureCell(key: String, value: String) {
        labelKey.text = key
        textFieldValue.text = value
    }
}
